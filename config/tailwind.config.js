const defaultTheme = require('tailwindcss/defaultTheme')
const colors = require('tailwindcss/colors')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
    colors: {
      'light-gray': 'var(--light-gray)',
      'gray': 'var(--gray)',
      'dark-gray': 'var(--dark-gray)',
      'white': 'var(--white)',
      'black': 'var(--black)',
      'dark-red': 'var(--dark-red)',
      'red': 'var(--red)',
      'blue': 'var(--blue)'
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
