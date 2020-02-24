var http = require('http');

var app = http.createServer(function(req, res) {
        console.log('createServer');
});

var io = require('socket.io').listen(app);
io.set('origins', '*:*');
app.listen(3000);

io.on('connection', function(socket) {
    io.emit('Server 2 Client Message', 'Welcome!' );

    socket.on('Client 2 Server Message', function(message)      {
        console.log(message);
        io.emit('Server 2 Client Message', message.toUpperCase() );     //upcase it
    });

});
