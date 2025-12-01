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
    url: 'https://assets.mixkit.co/active_storage/sfx/2390/2390-preview.mp3'
  },
  {
    id: '2',
    name: 'Thunder',
    icon: '⛈️',
    url: 'https://assets.mixkit.co/active_storage/sfx/2398/2398-preview.mp3'
  },
  {
    id: '3',
    name: 'River',
    icon: '🏞️',
    url: 'https://assets.mixkit.co/active_storage/sfx/2393/2393-preview.mp3'
  },
  {
    id: '4',
    name: 'Waterfall',
    icon: '💧',
    url: 'https://assets.mixkit.co/active_storage/sfx/2394/2394-preview.mp3'
  },
  {
    id: '5',
    name: 'Ocean Waves',
    icon: '🌊',
    url: 'https://assets.mixkit.co/active_storage/sfx/2395/2395-preview.mp3'
  },
  {
    id: '6',
    name: 'Wind',
    icon: '💨',
    url: 'https://assets.mixkit.co/active_storage/sfx/2392/2392-preview.mp3'
  },
  {
    id: '7',
    name: 'Birds',
    icon: '🐦',
    url: 'https://assets.mixkit.co/active_storage/sfx/2462/2462-preview.mp3'
  },
  {
    id: '8',
    name: 'Forest',
    icon: '🌲',
    url: 'https://assets.mixkit.co/active_storage/sfx/2396/2396-preview.mp3'
  },

  // Fire Sounds
  {
    id: '9',
    name: 'Fireplace',
    icon: '🔥',
    url: 'https://assets.mixkit.co/active_storage/sfx/2417/2417-preview.mp3'
  },
  {
    id: '10',
    name: 'Campfire',
    icon: '🏕️',
    url: 'https://assets.mixkit.co/active_storage/sfx/2418/2418-preview.mp3'
  },

  // Night Sounds
  {
    id: '11',
    name: 'Crickets',
    icon: '🦗',
    url: 'https://assets.mixkit.co/active_storage/sfx/2463/2463-preview.mp3'
  },
  {
    id: '12',
    name: 'Night Forest',
    icon: '🌙',
    url: 'https://assets.mixkit.co/active_storage/sfx/2464/2464-preview.mp3'
  },

  // Meditation & Relaxation
  {
    id: '13',
    name: 'Meditation',
    icon: '🧘',
    url: 'https://assets.mixkit.co/active_storage/sfx/2465/2465-preview.mp3'
  },
  {
    id: '14',
    name: 'Zen Music',
    icon: '☯️',
    url: 'https://assets.mixkit.co/active_storage/sfx/2466/2466-preview.mp3'
  },
  {
    id: '15',
    name: 'White Noise',
    icon: '📻',
    url: 'https://assets.mixkit.co/active_storage/sfx/2467/2467-preview.mp3'
  },
  {
    id: '16',
    name: 'Pink Noise',
    icon: '🎵',
    url: 'https://assets.mixkit.co/active_storage/sfx/2468/2468-preview.mp3'
  },

  // Other Relaxing Sounds
  {
    id: '17',
    name: 'Cat Purring',
    icon: '😺',
    url: 'https://assets.mixkit.co/active_storage/sfx/2469/2469-preview.mp3'
  },
  {
    id: '18',
    name: 'Clock Ticking',
    icon: '⏰',
    url: 'https://assets.mixkit.co/active_storage/sfx/2470/2470-preview.mp3'
  },
  {
    id: '19',
    name: 'Coffee Shop',
    icon: '☕',
    url: 'https://assets.mixkit.co/active_storage/sfx/2471/2471-preview.mp3'
  },
  {
    id: '20',
    name: 'Library',
    icon: '📚',
    url: 'https://assets.mixkit.co/active_storage/sfx/2472/2472-preview.mp3'
  }
];

export enum PlayerState {
  PLAYING,
  PAUSED,
  STOPPED
}