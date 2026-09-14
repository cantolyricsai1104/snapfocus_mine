/**
 * Tactile Haptic feedback service
 * Bridges Expo Haptics API with Web Vibration API and UI feedback triggers
 */

export const Haptics = {
  impactAsync: async (style: 'light' | 'medium' | 'heavy' = 'medium') => {
    if (typeof window !== 'undefined' && 'vibrate' in navigator) {
      try {
        switch (style) {
          case 'light':
            navigator.vibrate(15);
            break;
          case 'medium':
            navigator.vibrate(35);
            break;
          case 'heavy':
            navigator.vibrate([50, 20, 40]);
            break;
        }
      } catch {
        // silent fail on restricted contexts
      }
    }
    // Dispatch visual tactile pulse event for desktop preview tactile feel
    if (typeof window !== 'undefined') {
      window.dispatchEvent(new CustomEvent('tactile-pulse', { detail: { style } }));
    }
  },

  notificationAsync: async (type: 'success' | 'warning' | 'error' = 'warning') => {
    if (typeof window !== 'undefined' && 'vibrate' in navigator) {
      try {
        switch (type) {
          case 'success':
            navigator.vibrate([30, 40, 60]);
            break;
          case 'warning':
            navigator.vibrate([100, 60, 100, 60, 150]);
            break;
          case 'error':
            navigator.vibrate([150, 80, 150, 80, 200]);
            break;
        }
      } catch {
        // ignore
      }
    }
    if (typeof window !== 'undefined') {
      window.dispatchEvent(new CustomEvent('tactile-pulse', { detail: { style: type } }));
    }
  },

  selectionAsync: async () => {
    if (typeof window !== 'undefined' && 'vibrate' in navigator) {
      try {
        navigator.vibrate(10);
      } catch {
        // ignore
      }
    }
  },

  alarmPattern: () => {
    if (typeof window !== 'undefined' && 'vibrate' in navigator) {
      try {
        // Urgent alternating vibration pulses
        navigator.vibrate([180, 80, 180, 80, 250, 100]);
      } catch {
        // ignore
      }
    }
  }
};
