import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';
import { toTitleCase } from 'tgui-core/string';

type Data = {
  active: BooleanLike;
  SM_area: string;
  SM_integrity: number;
  SM_power: number;
  SM_ambienttemp: number;
  SM_ambientpressure: number;
  SM_EPR: number;
  SM_gas_O2: number;
  SM_gas_CO2: number;
  SM_gas_N2: number;
  SM_gas_PH: number;
  SM_gas_N2O: number;
  supermatters: { area_name: string; integrity: number; uid: number }[];
};

// As of 2020-08-06 this isn't actually ever used, but it needs to exist because that's what tgui_modules expect
export const SupermatterMonitor = (props) => (
  <Window width={600} height={400}>
    <Window.Content scrollable>
      <SupermatterMonitorContent />
    </Window.Content>
  </Window>
);

export const SupermatterMonitorContent = (props) => {
  const { data } = useBackend<Data>();

  const { active } = data;

  if (active) {
    return <SupermatterMonitorActive />;
  } else {
    return <SupermatterMonitorList />;
  }
};

const SupermatterMonitorList = (props) => {
  const { act, data } = useBackend<Data>();

  const { supermatters } = data;

  return (
    <Section
      title="Supermatters Detected"
      buttons={
        <Button icon="sync" onClick={() => act('refresh')}>
          Refresh
        </Button>
      }
    >
      <Stack wrap="wrap">
        {supermatters.map((sm, i) => (
          <Stack.Item basis="49%" grow={i % 2} key={i}>
            <Section title={`${sm.area_name} (#${sm.uid})`}>
              <LabeledList>
                <LabeledList.Item label="Integrity">
                  {sm.integrity} %
                </LabeledList.Item>
                <LabeledList.Item label="Options">
                  <Button
                    icon="eye"
                    onClick={() => act('set', { set: sm.uid })}
                  >
                    View Details
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

const SupermatterMonitorActive = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    SM_area,
    SM_integrity,
    SM_power,
    SM_ambienttemp,
    SM_ambientpressure,
    SM_EPR,
    SM_gas_O2,
    SM_gas_CO2,
    SM_gas_N2,
    SM_gas_PH,
    SM_gas_N2O,
  } = data;

  return (
    <Section
      title={toTitleCase(SM_area)}
      buttons={
        <Button icon="arrow-left" onClick={() => act('clear')}>
          Return to Menu
        </Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Core Integrity">
          <ProgressBar
            value={SM_integrity}
            minValue={0}
            maxValue={100}
            ranges={{
              good: [100, 100],
              average: [50, 100],
              bad: [-Infinity, 50],
            }}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Relative EER">
          <Box
            color={
              (SM_power > 300 && 'bad') ||
              (SM_power > 150 && 'average') ||
              'good'
            }
          >
            <AnimatedNumber
              format={(val) => `${toFixed(val, 2)} MeV/cm³`}
              value={SM_power}
            />
          </Box>
        </LabeledList.Item>
        <LabeledList.Item label="Temperature">
          <Box
            color={
              (SM_ambienttemp > 5000 && 'bad') ||
              (SM_ambienttemp > 4000 && 'average') ||
              'good'
            }
          >
            <AnimatedNumber
              format={(val) => `${toFixed(val, 2)} K`}
              value={SM_ambienttemp}
            />
          </Box>
        </LabeledList.Item>
        <LabeledList.Item label="Pressure">
          <Box
            color={
              (SM_ambientpressure > 10000 && 'bad') ||
              (SM_ambientpressure > 5000 && 'average') ||
              'good'
            }
          >
            <AnimatedNumber
              format={(val) => `${toFixed(val, 2)} kPa`}
              value={SM_ambientpressure}
            />
          </Box>
        </LabeledList.Item>
        <LabeledList.Item label="Chamber EPR">
          <Box
            color={(SM_EPR > 4 && 'bad') || (SM_EPR > 1 && 'average') || 'good'}
          >
            <AnimatedNumber format={(val) => toFixed(val, 2)} value={SM_EPR} />
          </Box>
        </LabeledList.Item>
        <LabeledList.Item label="Gas Composition">
          <LabeledList>
            <LabeledList.Item label="O²">
              <AnimatedNumber value={SM_gas_O2} />%
            </LabeledList.Item>
            <LabeledList.Item label="CO²">
              <AnimatedNumber value={SM_gas_CO2} />%
            </LabeledList.Item>
            <LabeledList.Item label="N²">
              <AnimatedNumber value={SM_gas_N2} />%
            </LabeledList.Item>
            <LabeledList.Item label="PH">
              <AnimatedNumber value={SM_gas_PH} />%
            </LabeledList.Item>
            <LabeledList.Item label="N²O">
              <AnimatedNumber value={SM_gas_N2O} />%
            </LabeledList.Item>
          </LabeledList>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
