updepall() { npm install --save $(node -p "Object.keys(require('./package.json').dependencies).map(e => e + '@latest').join(' ')") }
updevdepall() { npm install --save-dev $(node -p "Object.keys(require('./package.json').devDependencies).map(e => e + '@latest').join(' ')") }
