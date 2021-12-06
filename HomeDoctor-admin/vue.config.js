module.exports = {
  // devServer: {
  //   proxy: 'http://45.76.186.233:8000'
  // }
  publicPath: process.env.NODE_ENV === 'production'
    ? '/'
    : '/'
}
