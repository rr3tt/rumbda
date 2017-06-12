const exec = require('child_process').exec;
const queue = require('queue');

var processRecord = function(record, context) {
  const child = exec('./ruby_wrapper ' + "'" +  JSON.stringify(record) + "' '" + JSON.stringify(context) + "'", (result) => {
    context.done(result);
  });

  child.stdout.on('data', function (data) {
    data.split("\n").forEach(function(x) {
      console.log(x);
    });
  });
  child.stderr.on('data', function (data) {
    data.split("\n").forEach(function(x) {
      console.log(x);
    });
  });
};

exports.handler = function(event, context) {
  var context = context;
  var records = event['Records']

  var q = queue();
  records.forEach(function(record) {
    q.push(function(cb) {
      processRecord(record, context);
      cb();
    });
  });

  q.on('success', function(result, job) {
    console.log('job finished processing:', job.toString().replace(/\n/g, ''));
  });

  q.start(function(err) {
    console.log('all done!');
  });
};
