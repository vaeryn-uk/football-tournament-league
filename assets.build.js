const esbuild = require('esbuild');
const sassPlugin = require('esbuild-plugin-sass')

esbuild.build({
    entryPoints: ['assets/js/app.js'],
    bundle: true,
    outfile: 'assets/built/app.js',
    plugins: [sassPlugin()],
}).catch((e) => console.error(e.message))

esbuild.build({
    entryPoints: ['assets/js/index.js'],
    bundle: true,
    outfile: 'assets/built/index.js',
    plugins: [sassPlugin()],
}).catch((e) => console.error(e.message))