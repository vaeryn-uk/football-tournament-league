const esbuild = require('esbuild');
const sassPlugin = require('esbuild-plugin-sass')

esbuild.build({
    entryPoints: ['assets/app.js'],
    bundle: true,
    outfile: 'assets/built/app.js',
    plugins: [sassPlugin()],
}).catch((e) => console.error(e.message))