updepall() { for dep in $(node -e "console.log(Object.keys(require('./package.json').dependencies).join('\n'))"); do npm install --save $dep@latest; done }
updevdepall() { for dep in $(node -e "console.log(Object.keys(require('./package.json').devDependencies).join('\n'))"); do npm install --save-dev $dep@latest; done }
