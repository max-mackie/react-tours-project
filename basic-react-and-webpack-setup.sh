# Create folders
mkdir config src public 
mkdir src/components

# Stub files
touch \
    .gitignore \
    .babelrc \
    src/index.js \
    src/App.js \
    src/components/Greeting.js\
    config/webpack.config.js \
    config/webpack.config.dev.js \
    config/webpack.config.production.js \
    public/index.html 


# Populate files
tee -a .gitignore <<DOC
node_modules
.coverage
.DS_Store
DOC

tee -a public/index.html <<DOC
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Intro to React and Webpack Setup Script</title>
    </head>
    <body>
        <div id="root"></div>
    </body>
</html>
DOC
 
tee -a .babelrc <<DOC
{
  "presets": [
      "@babel/preset-env",
      "@babel/preset-react"
  ],
  "plugins": [
      "@babel/plugin-transform-runtime"
  ]
}
DOC

tee -a src/index.js << DOC
import React from "react";
import ReactDOM from "react-dom";

import App from "./App";

ReactDOM.render(<App />, document.getElementById("root"));
DOC

tee -a src/App.js << DOC
// App.js
import React, { Component } from "react";
import { Greeting } from "./components/Greeting";

function App() {
  return (
    <>
      <Greeting />
    </>
  );
}

export default App;
DOC

tee -a src/components/Greeting.js << DOC
import React from "react";

const Greeting = () => {
  let phrase = "Hello";

  return <h2 id="greeting">We just called to say to say {phrase}!</h2>;
};

export { Greeting };
DOC

tee -a config/webpack.config.dev.js << DOC
const config = require('./webpack.config.js');

config.devServer = {
  historyApiFallback: true, //serve a previous page on a 404 error
  port: 8080, // use this port for the server
  liveReload: true, // refresh the browser when changes are saved
  open: true, // open the project in the browser when the server starts
};

config.devtool = 'inline-source-map'; // a tool to find errors in the compiled code, but show them against the source code for easier debugging

module.exports = config;
DOC

tee -a config/webpack.config.js << DOC
const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')

const ROOT_DIRECTORY = path.join(__dirname, '../'); // the root of your project
const PUBLIC_DIRECTORY = path.join(ROOT_DIRECTORY, 'public'); // the root of the frontend, i.e. html file

const config = {
  entry: [path.resolve(ROOT_DIRECTORY, 'src/index.js')], // the main JavaScript file of the project
  output: {
    // instructions for compiling the code
    path: path.resolve(ROOT_DIRECTORY, 'build'), // the file where the compiled code should go
    filename: 'bundle.js', // the file name of the compiled code
    publicPath: '/', // specifies the base path for all the assets within your application.
  },
  mode: 'development', // tells webpack to use its built-in optimizations according to the mode
  resolve: {
    // instructions on how to resolve modules
    modules: [path.resolve('node_modules'), 'node_modules'], // tells webpack where to look for node_modules
  },
  performance: {
    // notifies you if assets and entry points exceed a specific file limit
    hints: false,
  },
  plugins: [
    // plugins we are using to help with compiling
    new HtmlWebpackPlugin({
      // used to add the JavaScript code to the HTML
      template: path.join(PUBLIC_DIRECTORY, 'index.html'),
    }),
  ],
  module: {
    // helpers we want webpack to use
    rules: [
      {
        test: /\.(js|jsx)$/,
        resolve: {
          extensions: [".js", ".jsx"]
        },
        exclude: /nodeModules/,
        use: {
          loader: 'babel-loader'
        }
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader'],
      }, // transpile css files
      {
        test: /\.(png|svg|jpg|gif|pdf)$/,
        use: ['file-loader'],
      }, // transpile image files
    ],
  },
};

module.exports = config;
DOC

tee -a config/webpack.config.production.js << DOC
const config = require('./webpack.config.js');

config.mode = 'production';
module.exports = config;
DOC

# Create npm package & install dependencies
npm init -y

npm i -D \
    webpack webpack-cli webpack-dev-server html-webpack-plugin \
    babel-loader style-loader css-loader file-loader \
    @babel/core @babel/preset-env \
    @babel/plugin-transform-runtime \
    @babel/preset-react

npm i \
    react \
    react-dom

# Add npm scripts
npx npm-add-script \
  -k "dev" \
  -v "webpack serve --mode development --config config/webpack.config.dev.js" \
  --force

npx npm-add-script \
  -k "build" \
  -v "webpack --config config/webpack.config.production.js" \
  --force

# Initialise git repository
git init