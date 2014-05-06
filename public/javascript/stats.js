$(document).ready(function(){
    $(".statstable").tablesorter({
        headers: { 1: { sorter: false}},
        widgets: ['numbering', 'zebra']
    });

    $(".points-stats-toggle").on('click', function(e) {
        e.preventDefault();

        var $toggle = $(e.target),
            data_to_show = 'data-stat-points';

        if ($toggle.attr('data-showing') == 'points') {
            $toggle.attr('data-showing', 'stats').html('Show Points');
            data_to_show = 'data-stat-raw';
        } else {
            $toggle.attr('data-showing', 'points').html('Show Stats');
        }

        $(".statstable td[data-stat-raw]").each(function(index, el) {
            var $el = $(el);
            $el.html($el.attr(data_to_show));
        });
    });
});