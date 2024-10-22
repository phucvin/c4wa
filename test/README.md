cd ..

gradle build

cd etc

npm install

cd ..

npm install -g @irongeek/wabt

etc/run-tests all

etc/run-tests 1-smoke

etc/run-tests test/c/1-smoke.c

cat ~/temp/1-smoke.wat

etc/run-wasm tests/wasm/1-smoke.wasm