const execFile = require('child_process').execFile;

exports.handler = function(event, context) {
  const chunkSize = 5;

  var records = event.Records;
  var context = context;

  console.log("Received " + records.length + " records.")

  var chunkOffset = 0;
  var chunks = []

  while (chunkOffset < records.length) {
    chunks.push(records.slice(chunkOffset, chunkOffset + chunkSize));
    chunkOffset += chunkSize;
  }

  chunks.forEach(function(chunk, index) {
      const child = execFile('./ruby_wrapper', [JSON.stringify(chunk), JSON.stringify(context)], {}, (error, stdout, stderr) => {
      if (error) {
        console.error(`exec error: ${error}`);
        return;
      }
      stdout.trim().split("\n").forEach(function(x) {
        log = x.trim();
        if (log !== "") {
          console.log(log);
        }
      });
      stderr.trim().split("\n").forEach(function(x) {
        log = x.trim();
        if (log !== "") {
          console.log(log);
        }
      });
    });
  });
};
