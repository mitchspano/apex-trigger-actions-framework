QuickText qt = new QuickText();
qt.Name = 'My Quick Text';
qt.Message = 'My Message';
insert qt;
System.debug(qt.Id);
System.debug(
	JSON.serializePretty(
		[SELECT Id, Name, Message, Channel, Category FROM QuickText]
	)
);
Integer x = 0 / 0;
