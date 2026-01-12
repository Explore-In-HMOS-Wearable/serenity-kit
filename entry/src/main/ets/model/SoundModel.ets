export interface Sound {
  id: string;
  name: string;
  icon: string;
  url: string;
}

export const SOUNDS: Sound[] = [
  // Nature Sounds
  {
    id: '1',
    name: 'Rain',
    icon: '🌧️',
    url: ''
  },
  {
    id: '2',
    name: 'Thunder',
    icon: '⛈️',
    url: ''
  },
  {
    id: '3',
    name: 'River',
    icon: '🏞️',
    url: ''
  },
  {
    id: '4',
    name: 'Waterfall',
    icon: '💧',
    url: ''
  },
  {
    id: '5',
    name: 'Ocean Waves',
    icon: '🌊',
    url: ''
  },
  {
    id: '6',
    name: 'Wind',
    icon: '💨',
    url: ''
  },
  {
    id: '7',
    name: 'Birds',
    icon: '🐦',
    url: ''
  },
  {
    id: '8',
    name: 'Forest',
    icon: '🌲',
    url: ''
  },

  // Fire Sounds
  {
    id: '9',
    name: 'Fireplace',
    icon: '🔥',
    url: ''
  },
  {
    id: '10',
    name: 'Campfire',
    icon: '🏕️',
    url: ''
  },

  // Night Sounds
  {
    id: '11',
    name: 'Crickets',
    icon: '🦗',
    url: ''
  },
  {
    id: '12',
    name: 'Night Forest',
    icon: '🌙',
    url: ''
  },

  // Meditation & Relaxation
  {
    id: '13',
    name: 'Meditation',
    icon: '🧘',
    url: ''
  },
  {
    id: '14',
    name: 'Zen Music',
    icon: '☯️',
    url: ''
  },
  {
    id: '15',
    name: 'White Noise',
    icon: '📻',
    url: ''
  },
  {
    id: '16',
    name: 'Pink Noise',
    icon: '🎵',
    url: ''
  },

  // Other Relaxing Sounds
  {
    id: '17',
    name: 'Cat Purring',
    icon: '😺',
    url: ''
  },
  {
    id: '18',
    name: 'Clock Ticking',
    icon: '⏰',
    url: ''
  },
  {
    id: '19',
    name: 'Coffee Shop',
    icon: '☕',
    url: ''
  },
  {
    id: '20',
    name: 'Library',
    icon: '📚',
    url: ''
  }
];

export enum PlayerState {
  PLAYING,
  PAUSED,
  STOPPED
}