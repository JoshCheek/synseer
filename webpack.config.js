var path = require('path');

module.exports = {
  resolve: {
    root: [__dirname + '/js']
  },

  entry: {
    javascript: path.resolve(__dirname, 'js/application.es6')
  },

  output: {
    path:     path.resolve(__dirname, 'public/js'),
    filename: 'bundle.js'
  },

  module: {
    loaders: [
      {
        test:    /\.es6$/,
        exclude: /node_modules/,
        loader:  'babel',
        query:   {
          presets: ['es2015', 'stage-1', 'react']
        }
      }
    ]
  }
};
