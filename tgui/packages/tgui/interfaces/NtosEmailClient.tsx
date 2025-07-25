import { useBackend } from 'tgui/backend';
import { NtosWindow } from 'tgui/layouts';
import {
  AnimatedNumber,
  Box,
  Button,
  Input,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  PC_device_theme: string;
  accounts: account[] | null;
  addressbook: BooleanLike;
  cur_attachment_filename: string | null;
  cur_attachment_size: number | null;
  cur_body: string | null;
  cur_hasattachment: BooleanLike;
  cur_source: string | null;
  cur_timestamp: string | null;
  cur_title: string | null;
  cur_uid: number | null;
  current_account: account | null;
  down_filename: string | null;
  down_progress: number | null;
  down_size: number | null;
  down_speed: number | null;
  downloading: BooleanLike;
  error: string | null;
  folder: string | null;
  label_deleted: string | null;
  label_inbox: string | null;
  label_spam: string | null;
  messagecount: number | null;
  messages: message[] | null;
  msg_attachment_filename: string | null;
  msg_attachment_size: number | null;
  msg_body: string | null;
  msg_hasattachment: BooleanLike;
  msg_recipient: string | null;
  msg_title: string | null;
  new_message: BooleanLike;
  stored_login: string | null;
  stored_password: string | null;
};

type message = {
  title: string;
  body: string;
  source: string;
  timestamp: string;
  uid: number;
};

type account = { login: string };

export const NtosEmailClient = (props) => {
  const { data } = useBackend<Data>();

  const { PC_device_theme, error, downloading, current_account } = data;

  let content = <NtosEmailClientLogin />;

  if (error) {
    content = <NtosEmailClientError error={error} />;
  } else if (downloading) {
    content = <NtosEmailClientDownloading />;
  } else if (current_account) {
    content = <NtosEmailClientContent />;
  }

  return (
    <NtosWindow resizable theme={PC_device_theme}>
      <NtosWindow.Content scrollable>{content}</NtosWindow.Content>
    </NtosWindow>
  );
};

const NtosEmailClientDownloading = (props) => {
  const { data } = useBackend<Data>();

  const { down_filename, down_progress, down_size, down_speed } = data;

  return (
    <Section title="Downloading...">
      <LabeledList>
        <LabeledList.Item label="File">
          {down_filename} ({down_size} GQ)
        </LabeledList.Item>
        <LabeledList.Item label="Speed">
          <AnimatedNumber value={down_speed!} /> GQ/s
        </LabeledList.Item>
        <LabeledList.Item label="Progress">
          <ProgressBar
            color="good"
            value={down_progress!}
            maxValue={down_size!}
          >
            {down_progress +
              '/' +
              down_size +
              ' (' +
              toFixed((down_progress! / down_size!) * 100, 1) +
              '%)'}
          </ProgressBar>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const NtosEmailClientContent = (props) => {
  const { act, data } = useBackend<Data>();

  const { current_account, addressbook, new_message, cur_title, accounts } =
    data;

  let content = <NtosEmailClientInbox />;

  if (addressbook) {
    content = <NtosEmailClientAddressBook accounts={accounts!} />;
  } else if (new_message) {
    content = <NtosEmailClientNewMessage />;
  } else if (cur_title) {
    content = <NtosEmailClientViewMessage />;
  }

  return (
    <Section
      title={`Logged in as: ${current_account}`}
      buttons={
        <Stack>
          <Stack.Item>
            <Button
              icon="plus"
              tooltip="New Message"
              tooltipPosition="left"
              onClick={() => act('new_message')}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="cogs"
              tooltip="Change Password"
              tooltipPosition="left"
              onClick={() => act('changepassword')}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="sign-out-alt"
              tooltip="Log Out"
              tooltipPosition="left"
              onClick={() => act('logout')}
            />
          </Stack.Item>
        </Stack>
      }
    >
      {content}
    </Section>
  );
};

const NtosEmailClientInbox = (props) => {
  const { act, data } = useBackend<Data>();

  const { folder, messagecount, messages } = data;

  return (
    <Section noTopPadding>
      <Tabs>
        <Tabs.Tab
          selected={folder === 'Inbox'}
          onClick={() => act('set_folder', { set_folder: 'Inbox' })}
        >
          Inbox
        </Tabs.Tab>
        <Tabs.Tab
          selected={folder === 'Spam'}
          onClick={() => act('set_folder', { set_folder: 'Spam' })}
        >
          Spam
        </Tabs.Tab>
        <Tabs.Tab
          selected={folder === 'Deleted'}
          onClick={() => act('set_folder', { set_folder: 'Deleted' })}
        >
          Deleted
        </Tabs.Tab>
      </Tabs>
      {(messagecount && (
        <Section>
          <Table>
            <Table.Row header>
              <Table.Cell>Source</Table.Cell>
              <Table.Cell>Title</Table.Cell>
              <Table.Cell>Received At</Table.Cell>
              <Table.Cell>Actions</Table.Cell>
            </Table.Row>
            {messages!.map((msg) => (
              <Table.Row key={msg.timestamp + msg.title}>
                <Table.Cell>{msg.source}</Table.Cell>
                <Table.Cell>{msg.title}</Table.Cell>
                <Table.Cell>{msg.timestamp}</Table.Cell>
                <Table.Cell>
                  <Button
                    icon="eye"
                    onClick={() => act('view', { view: msg.uid })}
                    tooltip="View"
                  />
                  <Button
                    icon="share"
                    onClick={() => act('reply', { reply: msg.uid })}
                    tooltip="Reply"
                  />
                  <Button
                    color="bad"
                    icon="trash"
                    onClick={() => act('delete', { delete: msg.uid })}
                    tooltip="Delete"
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      )) || <Box color="bad">No emails found in {folder}.</Box>}
    </Section>
  );
};

export const NtosEmailClientViewMessage = (props: {
  administrator?: BooleanLike;
}) => {
  const { act, data } = useBackend<Data>();

  // This is used to let NtosEmailAdministration use the same code for spying on emails
  // Administrators don't have access to attachments or the message UID, so we need to avoid
  // using those data attributes, as well as a slightly different act() model.
  const { administrator } = props;

  const {
    cur_title,
    cur_source,
    cur_timestamp,
    cur_body,
    cur_hasattachment,
    cur_attachment_filename,
    cur_attachment_size,
    cur_uid,
  } = data;

  return (
    <Section
      title={cur_title}
      buttons={
        administrator ? (
          <Button icon="times" onClick={() => act('back')} />
        ) : (
          <Stack>
            <Stack.Item>
              <Button
                icon="share"
                tooltip="Reply"
                tooltipPosition="left"
                onClick={() => act('reply', { reply: cur_uid })}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                color="bad"
                icon="trash"
                tooltip="Delete"
                tooltipPosition="left"
                onClick={() => act('delete', { delete: cur_uid })}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="save"
                tooltip="Save To Disk"
                tooltipPosition="left"
                onClick={() => act('save', { save: cur_uid })}
              />
            </Stack.Item>
            {(cur_hasattachment && (
              <Button
                icon="paperclip"
                tooltip="Save Attachment"
                tooltipPosition="left"
                onClick={() => act('downloadattachment')}
              />
            )) ||
              null}
            <Stack.Item>
              <Button
                icon="times"
                tooltip="Close"
                tooltipPosition="left"
                onClick={() => act('cancel', { cancel: cur_uid })}
              />
            </Stack.Item>
          </Stack>
        )
      }
    >
      <LabeledList>
        <LabeledList.Item label="From">{cur_source}</LabeledList.Item>
        <LabeledList.Item label="At">{cur_timestamp}</LabeledList.Item>
        {(cur_hasattachment && !administrator && (
          <LabeledList.Item label="Attachment" color="average">
            {cur_attachment_filename} ({cur_attachment_size}GQ)
          </LabeledList.Item>
        )) ||
          ''}
        <LabeledList.Item label="Message" verticalAlign="top">
          <Section>
            {/** biome-ignore lint/security/noDangerouslySetInnerHtml: is only ever passed data that has passed through pencode2html
             * It should be safe enough to support pencode in this way. */}
            <div dangerouslySetInnerHTML={{ __html: cur_body! }} />
          </Section>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const NtosEmailClientAddressBook = (props: { accounts: account[] }) => {
  const { act } = useBackend<Data>();

  const { accounts } = props;

  return (
    <Section
      title="Address Book"
      buttons={
        <Button
          color="bad"
          icon="times"
          onClick={() => act('set_recipient', { set_recipient: null })}
        />
      }
    >
      {accounts.map((acc) => (
        <Button
          key={acc.login}
          fluid
          onClick={() => act('set_recipient', { set_recipient: acc.login })}
        >
          {acc.login}
        </Button>
      ))}
    </Section>
  );
};

const NtosEmailClientNewMessage = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    msg_title = '',
    msg_recipient = '',
    msg_body,
    msg_hasattachment,
    msg_attachment_filename,
    msg_attachment_size,
  } = data;

  return (
    <Section
      title="New Message"
      buttons={
        <Stack>
          <Stack.Item>
            <Button icon="share" onClick={() => act('send')}>
              Send Message
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button color="bad" icon="times" onClick={() => act('cancel')} />
          </Stack.Item>
        </Stack>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Title">
          <Input
            fluid
            value={msg_title!}
            onChange={(val: string) => act('edit_title', { val: val })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Recipient" verticalAlign="top">
          <Stack>
            <Stack.Item grow>
              <Input
                fluid
                value={msg_recipient!}
                onChange={(val: string) => act('edit_recipient', { val: val })}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="address-book"
                onClick={() => act('addressbook')}
                tooltip="Find Receipients"
                tooltipPosition="left"
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item
          label="Attachments"
          buttons={
            (msg_hasattachment && (
              <Button
                color="bad"
                icon="times"
                onClick={() => act('remove_attachment')}
              >
                Remove Attachment
              </Button>
            )) || (
              <Button icon="plus" onClick={() => act('addattachment')}>
                Add Attachment
              </Button>
            )
          }
        >
          {(msg_hasattachment && (
            <Box inline>
              {msg_attachment_filename} ({msg_attachment_size}GQ)
            </Box>
          )) ||
            null}
        </LabeledList.Item>
        <LabeledList.Item label="Message" verticalAlign="top">
          <Stack>
            <Stack.Item grow>
              <Section width="99%" inline>
                {/** biome-ignore lint/security/noDangerouslySetInnerHtml: is only ever passed data that has passed through pencode2html
                 * It should be safe enough to support pencode in this way. */}
                <div dangerouslySetInnerHTML={{ __html: msg_body! }} />
              </Section>
            </Stack.Item>
            <Stack.Item>
              <Button
                verticalAlign="top"
                onClick={() => act('edit_body')}
                icon="pen"
                tooltip="Edit Message"
                tooltipPosition="left"
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const NtosEmailClientError = (props: { error: string }) => {
  const { act } = useBackend();
  const { error } = props;
  return (
    <Section
      title="Notification"
      buttons={
        <Button icon="arrow-left" onClick={() => act('reset')}>
          Return
        </Button>
      }
    >
      <Box color="bad">{error}</Box>
    </Section>
  );
};

const NtosEmailClientLogin = (props) => {
  const { act, data } = useBackend<Data>();

  const { stored_login = '', stored_password = '' } = data;

  return (
    <Section title="Please Log In">
      <LabeledList>
        <LabeledList.Item label="Email address">
          <Input
            fluid
            value={stored_login!}
            onChange={(val: string) => act('edit_login', { val: val })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Password">
          <Input
            fluid
            value={stored_password!}
            onChange={(val: string) => act('edit_password', { val: val })}
          />
        </LabeledList.Item>
      </LabeledList>
      <Button icon="sign-in-alt" onClick={() => act('login')}>
        Log In
      </Button>
    </Section>
  );
};
