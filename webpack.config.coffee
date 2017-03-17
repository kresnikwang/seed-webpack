webpack             = require 'webpack'
HtmlWebpackPlugin   = require 'html-webpack-plugin'
autoprefixer        = require 'autoprefixer'
path                = require 'path'



module.exports =

  # ENTRY POINT
  entry: {
    app: ['./src/index.coffee']
    vendor: ['./src/vendor.coffee']
  }


  # OUTPUT
  output:
    path: __dirname + '/dist'
    filename: 'js/[name].[hash].js'
    # publicPath: "/"

  resolve:
    alias:
      src: path.resolve('./src')

  # LOADERS (Kind of like tasks in other build tools)
  module:
    loaders: [
      {
        test: /.htaccess/
        loaders: ["file?name=[name].[ext]"]
      }
      {
        test: /pixi.min.js/
        loaders: ['script']
      }
      {
        test: /\.coffee/
        loaders: ['babel', 'coffee']
        exclude: /node_modules/
      }
      {
        test: /\ga.js$/
        loaders: ["file?name=js/[name].[ext]"]
      }
      {
        test: /\.json$/
        loaders: ['json']
      }
      {
        test: /\.jade/
        loaders: ['jade']
      }
      {
        test: /\.sass/
        loaders: ['style', 'css', 'postcss', 'sass?indentedSyntax']
      }
      {
        test: /\.(mp4|webm)$/
        loaders: ["file?name=assets/video-[hash].[ext]"]
      }
      {
        test: /\.(wav|mp3)$/
        loaders: ["file?name=assets/audio-[hash].[ext]"]
      }
      {
        test: /\.(jpg|jpeg|png|svg|gif|ico)$/
        loaders: ["url-loader?limit=1&name=assets/img-[hash].[ext]"]
      }
      {
        test: /\.(ttf|otf)$/
        loaders: ["url-loader?limit=1&name=assets/font-[hash].[ext]"]
      }
      {
        test: /\.(fs|vs)/
        loaders: ["raw-loader"]
      }
      {
        test: /\.model.js|dae|obj$/
        loaders: ['file-loader?name=assets/model-[hash].[ext]']
        # loaders: ['file-loader?name=assets/[name].[ext]']
      }
    ]

    postLoaders: [
      {
        include: path.resolve(__dirname, 'node_modules/pixi.js')
        loader: 'transform?brfs'
      }
    ]


  # POSTPROCESS CSS
  sassLoader:
    includePaths: [path.resolve('./src')]

  postcss: ()->
    [autoprefixer]


  # PLUGINS
  plugins: [
    new HtmlWebpackPlugin({
      template: './src/index.jade'
      # hash: true
    })

    new webpack.optimize.CommonsChunkPlugin(
      "vendor", "js/vendor.[hash].js"
    )
  ]






