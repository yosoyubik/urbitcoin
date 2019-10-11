var gulp = require('gulp');

// Read pier folder
var urbitrc = require('./.urbitrc');

gulp.task('urbit-copy', function () {
  let ret = gulp.src('src/**/*');

  urbitrc.URBIT_PIERS.forEach(function(pier) {
    ret = ret.pipe(gulp.dest(pier));
  });

  return ret;
});

gulp.task('watch', function() {
  gulp.watch('src/**/*', gulp.parallel('urbit-copy'));
});
