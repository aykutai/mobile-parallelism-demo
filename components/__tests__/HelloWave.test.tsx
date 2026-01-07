import React from 'react';
import { render } from '@testing-library/react-native';

import { HelloWave } from '@/components/HelloWave';

jest.mock('react-native-reanimated', () =>
  require('react-native-reanimated/mock'),
);

describe('HelloWave', () => {
  it('renders the waving hand emoji', () => {
    const { getByText } = render(<HelloWave />);

    expect(getByText('👋')).toBeTruthy();
  });
});