import { StyleSheet } from 'react-native';

import ParallaxScrollView from '@/components/ParallaxScrollView';
import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';
import { IconSymbol } from '@/components/ui/IconSymbol';

export default function SearchScreen() {
  return (
    <ParallaxScrollView
      headerBackgroundColor={{ light: '#E0F0FF', dark: '#102030' }}
      headerImage={
        <IconSymbol
          size={240}
          color="#4B9EFF"
          name="magnifyingglass"
          style={styles.headerImage}
        />
      }>
      <ThemedView style={styles.titleContainer}>
        <ThemedText type="title">Search</ThemedText>
      </ThemedView>
      <ThemedText>
        This is the search tab. Add your search UI or functionality here.
      </ThemedText>
    </ParallaxScrollView>
  );
}

const styles = StyleSheet.create({
  headerImage: {
    bottom: -60,
    left: -20,
    position: 'absolute',
  },
  titleContainer: {
    flexDirection: 'row',
    gap: 8,
  },
});