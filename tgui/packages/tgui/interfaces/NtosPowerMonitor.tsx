import { NtosWindow } from 'tgui/layouts';

import { PowerMonitorContent } from './PowerMonitor/PowerMonitorContent';

export const NtosPowerMonitor = () => {
  return (
    <NtosWindow width={550} height={700}>
      <NtosWindow.Content scrollable>
        <PowerMonitorContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
