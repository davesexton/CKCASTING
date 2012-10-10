var _gaq = _gaq || [];

$(document).ready(function() {
  var web_property_id = $('html').attr('data-web-property-id');
  console.log(web_property_id);
  if ((typeof web_property_id) != 'undefined') {
    _gaq.push(['_setAccount', web_property_id]);
    _gaq.push(['_trackPageview']);

    (function() {
      var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();
  }
});
