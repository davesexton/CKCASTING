(function() {

  $(function() {
    if ($('.products').length > 0) {
      $('#player')[0].controls = false;
      $('#player').bind('ended', function() {
        return $('.play_button').text('Play').data('playing', 'n');
      });
      return $('.play_button').click(function() {
        var data, file, player;
        $('.play_button').not(this).text('Play').data('playing', 'n');
        data = $(this).data();
        player = $('#player')[0];
        if (data.playing === 'y') {
          player.pause();
          return $(this).text('Play').data('playing', 'n');
        } else {
          if (player.canPlayType("audio/ogg")) {
            file = data.ogg;
          } else {
            file = data.mp3;
          }
          $(this).text('Stop').data('playing', 'y');
          if (player.src.indexOf(file) > -1) {
            return player.play();
          } else {
            player.src = file;
            player.autoplay = true;
            return player.load();
          }
        }
      });
    }
  });

}).call(this);
