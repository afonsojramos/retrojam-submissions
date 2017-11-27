var pico8_gpio = Array(128);

// Connection

var connection = new WebSocket('ws://127.0.0.1:8080');
connection.onopen = function() 
{
	console.log('Connected to server');
};

connection.onerror = function(error) 
{
	console.log('Connection error ' + error);
};

connection.onmessage = function(event) 
{
	var data = event.data;
	console.log('Server message ' + data + ' received');

	processInput(data);
};

// Output

var OUTPUT_INDEX = 0;
var OUTPUT_FREQUENCY = 1000 / 60;

var outputMessage = '';

setInterval(function()
{
	var control = pico8_gpio[OUTPUT_INDEX];
	if (control)
	{
		for (var i = OUTPUT_INDEX + 1; i < 64; i ++)
		{
			if (!pico8_gpio[i])
			{
				processOutput();
				break;
			}

			outputMessage += String.fromCharCode(pico8_gpio[i]);
		}

		if (control == 2)
			processOutput();

		pico8_gpio[0] = 0;
	}
}, OUTPUT_FREQUENCY);

function processOutput()
{
	connection.send(outputMessage);

	outputMessage = '';
}

// Input

var INPUT_INDEX = 64;
var INPUT_FREQUENCY = 1000 / 60;

var inputQueue = [];
var inputMessage = null;

function processInput(message)
{
	inputQueue.push(message);
}

setInterval(function()
{
	var control = pico8_gpio[INPUT_INDEX];
	if (control == 1) return;

	if (inputMessage == null && inputQueue.length > 0)
		inputMessage = inputQueue.shift();

	if (inputMessage != null)
	{
		pico8_gpio[INPUT_INDEX] = 1;
		for (var i = 1; i < 64; i ++)
			pico8_gpio[INPUT_INDEX + i] = 0;

		var chunk = inputMessage.substr(0, 63);
		for (var i = 0; i < chunk.length; i ++)
			pico8_gpio[INPUT_INDEX + 1 + i] = chunk.charCodeAt(i);

		inputMessage = inputMessage.substr(63);
		if (inputMessage.length == 0)			
		{
			inputMessage = null;
			if (chunk.length == 63)
				pico8_gpio[INPUT_INDEX] = 2;
		}
	}
}, INPUT_FREQUENCY);













