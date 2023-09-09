//	Data transformations
DLogPrice 	= diff(LogPrice,1);
DLogQuantity= diff(LogQuantity,1);
Price 		= exp(LogPrice);
Quantity 	= exp(LogQuantity);
LogPrice_ 	= lag(LogPrice,1);
LogQuantity_= lag(LogQuantity,1);

//	Holiday dummy
Dbox 		= dummy(18,1,18,1);		// boxing day
DMLK 		= dummy(34,1,34,1);  	// Martin Luther King Day
Deaster 	= dummy(95,1,95,1); 	// Wednesday before Easter Sunday
Dhol 		= Dbox + DMLK + Deaster;

//	Weather dummies
StormyMixed = Stormy + Mixed;
RStormy = Stormy - 	mean(Stormy);
RMixed  = Mixed  - 	mean(Mixed);
