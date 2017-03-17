######################################################
#
# gulpfile.coffee
#
# This file is actually not necessary right now.
# - `gulp build` just runs 'webpack'
# - `gulp dev` just runs 'webpack-dev-server'
#
######################################################

gulp = require 'gulp'
gutil = require 'gulp-util'
webpack = require 'webpack'
WebpackDevServer = require 'webpack-dev-server'
webpackConfig = require './webpack.config'
ip = require 'ip'
open = require 'gulp-open'
path = require 'path'
url = require('url')
http = require('http')
CleanWebpackPlugin  = require('clean-webpack-plugin')




######################################################
#
# BUILD
#
######################################################
gulp.task 'build', (cb)->

  startDate = Date.now()

  webpackConfig.plugins.push(new webpack.optimize.UglifyJsPlugin())
  webpackConfig.plugins.push(new webpack.optimize.OccurenceOrderPlugin())
  webpackConfig.plugins.push(new webpack.optimize.DedupePlugin())

  clean = new CleanWebpackPlugin(['dist'], {
    root: __dirname + '/'
    verbose: true
  })
  webpackConfig.plugins.push clean

  webpack(webpackConfig, (err, stats)->
    throw new gutil.PluginError("webpack:build", err) if err
    gutil.log "[build]", stats.toString({colors: true})
    gulp.src("./.htaccess").pipe(gulp.dest(__dirname + '/dist'))

    endDate = Date.now()
    time = (endDate - startDate) / 1000

    console.log "TOOK #{time}s"
  )




######################################################
#
# DEV
#
######################################################
gulp.task 'dev', ()->


  # DASHBOARD
  Dashboard = require('webpack-dashboard')
  DashboardPlugin = require('webpack-dashboard/plugin')
  dashboard = new Dashboard()
  webpackConfig.plugins.push(new DashboardPlugin(dashboard.setData))

  host = ip.address()
  # host = "localhost"



  webpackConfig.entry.app.push 'webpack/hot/dev-server'

  webpackConfig.devServer =
    port: 8080
    # contentBase: __dirname + '/dist'

  webpackConfig.entry.hot = [
    "webpack/hot/dev-server"
    "webpack-dev-server/client?http://#{host}:#{webpackConfig.devServer.port}/"
  ]


  webpackConfig.plugins.push(new webpack.HotModuleReplacementPlugin())

  webpackConfig.devtool = "source-map"

  webpackConfig.entry.app.unshift("webpack-dev-server/client?http://#{host}:#{webpackConfig.devServer.port}/")

  server = new WebpackDevServer(webpack(webpackConfig), {
    hot: true
    historyApiFallback: true
    quiet: true
    stats:
      colors: true
    # proxy:
    #   '/api/*':
    #     target: 'http://jordan.akqatest.cn'
    #   '/courtzero/api/*':
    #     target: 'http://jordan.akqatest.cn'
  })


  server.listen webpackConfig.devServer.port, host, (err)->
    throw new gutil.PluginError("webpack-dev-server", err) if err
    gutil.log("[dev]", "http://#{host}:#{webpackConfig.devServer.port}/webpack-dev-server/index.html")
    gulp.src('').pipe open({uri: "http://#{host}:#{webpackConfig.devServer.port}"})




