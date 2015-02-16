function drawLine(p1_x, p1_y, p2_x, p2_y) {
    // FILL IN CANVAS ID
    var c = document.getElementById("myCanvas");
    // 2d line
    context = c.getContext("2d");
    // starting point
    context.moveTo(p1_x, p1_y);
    // ending point
    context.lineTo(p2_x, p2_y);
    // set line color
    context.strokeStyle = '#A4A4A4';
    // set line width
    context.lineWidth = 4;
    // line up
    context.stroke();
}