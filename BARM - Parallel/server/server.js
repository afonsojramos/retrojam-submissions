'use strict';

const ws = require('ws');
const server = new ws.Server({port: 8080});
 
server.on('connection', (connection) => 
{
	console.log('Client connected');
	connection.send('test');
	connection.on('message', (data) =>
	{
		console.log('Client message ' + data + ' received');
		broadcast(data);
  	}); 
  	connection.on('close', (data) =>
	{
		console.log('Client disconnected');
  	}); 
});

function broadcast(data)
{
	server.clients.forEach((client) =>
	{
    	client.send(data);
  	});
}

console.log('Listening for connections');