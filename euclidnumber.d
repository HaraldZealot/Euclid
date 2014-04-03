//module euclidnumber.d;

private
{
	import std.traits;
	import std.conv;

}

alias deuclid = Euclidnumber!ulong;
alias seuclid = Euclidnumber!uint;

struct Euclidnumber(T)
	if(is(T == ulong) || is(T == uint))
{
public:

	/** Default copy procedure */
	/** Default assign operator */
	
	/** Aliases for frequent type */
	alias IntegralPartType = Signed!(Halfbytes!T) ;
	alias FractionsPartType = Quarterbytes!T ;
	
	/** Not a number represents as 0:0/0 */
	static @property Euclidnumber!T nan() pure nothrow @safe
	{
		return Euclidnumber!T(0, nanRepresentation);
	}
	
	/** Positive infinity represents as +1:0/0 */
	static @property Euclidnumber!T infinity() pure nothrow @safe
	{
		return Euclidnumber!T(0, posInfRepresentation);
	}
	
	/** Negative infinity represents as -1:0/0 */
	static @property Euclidnumber!T negInfinity() pure nothrow @safe
	{
		return Euclidnumber!T(0, negInfRepresentation);
	}
	
	/** Zero represents as 0:0/1 */
	static @property Euclidnumber!T zero() pure nothrow @safe
	{
		return Euclidnumber!T(0, zeroRepresentation);
	}
	
	/** Maximum represents as max:max-1/max */
	static @property Euclidnumber!T max() pure nothrow @safe
	{
		return Euclidnumber!T(0, maxRepresentation);
	}
	
	/** Minimum represents as min:max-1/max */
	static @property Euclidnumber!T min() pure nothrow @safe
	{
		return Euclidnumber!T(0, minRepresentation);
	}
	
	private this(bool, T representation) pure nothrow @safe
	{
		this.representation = representation;
	}
	
	this(long integral) pure nothrow @safe
	{
		if(integral > IntegralPartType.max)
			representation = posInfRepresentation;
		else if(integral < -IntegralPartType.max)
			representation = negInfRepresentation;
		else 
		{
			representation = cast(T)(cast(IntegralPartType)integral) << integralShift | zeroRepresentation;
		}		
	}
	
	string toString() const
	{
		if(representation == nanRepresentation)
			return "nan";
		else if(representation == posInfRepresentation)
			return "+inf";
		else if(representation == negInfRepresentation)
			return "-inf";
		else if(representation == negZeroRepresentation)
			return "0";
		
		string result;
		T positiveRepresentation = representation;
		if(representation & signMask)
		{
			result ~= "-";
			positiveRepresentation = negateIntegralPart(positiveRepresentation);
		}
		result ~= to!string(cast(Signed!T)(positiveRepresentation & integralMask) >> integralShift); // N.B! arithmetical integralShift
		if(positiveRepresentation & numeratorMask)
		{
			result ~= ":";
			result ~= to!string((positiveRepresentation & numeratorMask) >>> numeratorShift) ~ "/"; // N.B! logical shift
			result ~= to!string(positiveRepresentation & denominatorMask);
		}
		
		return result;
	}
	
private:
	T representation;

	invariant()
	{
		assert(
			representation == nanRepresentation ||
			representation == posInfRepresentation ||
			representation == negInfRepresentation ||
			((representation & numeratorMask) >>> numeratorShift) < (representation & denominatorMask)
		);
	}
	
	enum bitsInByte = 8;
	enum bitsInDenominator = FractionsPartType.sizeof * bitsInByte;
	enum bitsInNumerator = FractionsPartType.sizeof * bitsInByte;
	enum bitsInFraction = bitsInDenominator + bitsInNumerator;
	enum bitsInIntegral = IntegralPartType.sizeof * bitsInByte;
	
	enum integralShift = bitsInFraction;
	enum numeratorShift = bitsInDenominator;
	enum signShift = T.sizeof * bitsInByte - 1;
	
	enum integralMask = cast(T)((~(cast(Unsigned!IntegralPartType)0))) << integralShift;
	enum numeratorMask = cast(T)((~(cast(FractionsPartType)0))) << numeratorShift;
	enum denominatorMask = cast(T)(~(cast(FractionsPartType)0));
	enum signMask = (cast(T)1) << signShift;
	
	enum nanRepresentation = cast(T)0;
	enum posInfRepresentation = cast(T)(cast(IntegralPartType)+1) << integralShift | cast(T)(cast(FractionsPartType)1) << numeratorShift;
	enum negInfRepresentation = cast(T)(cast(IntegralPartType)-1) << integralShift | cast(T)(cast(FractionsPartType)1) << numeratorShift;
	enum zeroRepresentation = cast(T)(cast(FractionsPartType)1);
	enum negZeroRepresentation = signMask | zeroRepresentation;
	enum maxRepresentation = cast(T)(IntegralPartType.max) << integralShift | cast(T)(FractionsPartType.max-1) << numeratorShift | cast(T)(FractionsPartType.max);
	enum minRepresentation = cast(T)(-IntegralPartType.max) << integralShift | cast(T)(FractionsPartType.max-1) << numeratorShift | cast(T)(FractionsPartType.max);

	static T negateIntegralPart(T representation)pure nothrow @safe
	{
		if((representation & integralMask) == signMask)
			return representation ^ signMask;
		else
			return -(representation & integralMask) | (representation & ~integralMask);
	}
}

unittest
{
	// Testing toString and std.conv.to with Euclidnumber
	// Testing predefined value and integral constructor
	assert("nan" == to!string(deuclid.nan));
	assert("nan" == to!dstring(seuclid.nan));
	assert("-inf" == to!wstring(deuclid.negInfinity));
	assert("+inf" == to!string(seuclid.infinity));
	assert("0" == to!string(seuclid.zero));
	assert("0" == to!string(deuclid.zero));
	assert("32767:254/255" == to!string(seuclid.max));
	assert("-32767:254/255" == to!string(seuclid.min));
	assert("2147483647:65534/65535" == to!string(deuclid.max));
	assert("-2147483647:65534/65535" == to!string(deuclid.min));
	assert("0" == to!string(seuclid(0)));
	assert("1" == to!string(deuclid(1)));
	assert("-1" == to!string(deuclid(-1)));
	assert("-345" == to!string(deuclid(-345)));
	assert("19873" == to!string(deuclid(19873)));
	assert("+inf" == to!string(seuclid(48347)));
	assert("48347" == to!string(deuclid(48347)));
	assert("-inf" == to!string(seuclid(-48347)));
	assert("-48347" == to!string(deuclid(-48347)));
	assert("32767" == to!string(seuclid(32767)));
	assert("+inf" == to!string(seuclid(32768)));
	assert("-32767" == to!string(seuclid(-32767)));
	assert("-inf" == to!string(seuclid(-32768)));
	assert("2147483647" == to!string(deuclid(2147483647)));
	assert("+inf" == to!string(deuclid(2147483648)));
	assert("-2147483647" == to!string(deuclid(-2147483647)));
	assert("-inf" == to!string(deuclid(-2147483648)));
}
/*
unittest
{
	import std.stdio;
	writefln("deuclid.integralMask    = %016X", deuclid.integralMask);
	writefln("deuclid.numeratorMask   = %016X", deuclid.numeratorMask);
	writefln("deuclid.denominatorMask = %016X", deuclid.denominatorMask);
	writefln("seuclid.integralMask    = %08X", seuclid.integralMask);
	writefln("seuclid.numeratorMask   = %08X", seuclid.numeratorMask);
	writefln("seuclid.denominatorMask = %08X", seuclid.denominatorMask);
	writeln();
	writefln("deuclid.nanRep = %016X,\t%s", deuclid.nan.representation, deuclid.nan);
	writefln("deuclid.posInf = %016X,\t%s", deuclid.infinity.representation, deuclid.infinity);
	writefln("deuclid.negInf = %016X,\t%s", deuclid.negInfinity.representation, deuclid.negInfinity);
	writefln("deuclid.zero   = %016X,\t%s", deuclid.zero.representation, deuclid.zero);
	writefln("deuclid.max    = %016X,\t%s", deuclid.max.representation, deuclid.max);
	writefln("deuclid.min    = %016X,\t%s", deuclid.min.representation, deuclid.min);
	writefln("seuclid.nanRep = %08X,\t%s", seuclid.nanRepresentation, seuclid.nan);
	writefln("seuclid.posInf = %08X,\t%s", seuclid.posInfRepresentation, seuclid.infinity);
	writefln("seuclid.negInf = %08X,\t%s", seuclid.negInfRepresentation, seuclid.negInfinity);
	writefln("seuclid.zero   = %08X,\t%s", seuclid.zeroRepresentation, seuclid.zero);
	writefln("seuclid.max    = %08X,\t%s", seuclid.maxRepresentation, seuclid.max);
	writefln("seuclid.min    = %08X,\t%s", seuclid.minRepresentation, seuclid.min);
}//*/

private void aproximateByEuclid(out ulong integral, ref ulong numerator, ref ulong denominator, ulong[] ) //pure nothrow @safe
{
	import std.stdio;
	typeof(numerator) previousNumerator = 1, currentNumerator = 0;
	typeof(denominator) previousDenominator = 0, currentDenominator = 1;
	integral = numerator / denominator;
	auto decomposedNumerator = numerator % denominator;
	auto decomposedDenominator = denominator;
	typeof(integral) quotient = 0;
	auto remainder = decomposedNumerator;

	writeln("pnum = ", previousNumerator, " cnum = ", currentNumerator);
	writeln("pden = ", previousDenominator, " cden = ", currentDenominator);
	writeln("dnum = ", decomposedNumerator, " dden = ", decomposedDenominator);
	writeln("quot = ", quotient, " remd = ", remainder);
	writeln();

	while(remainder)
	{
		quotient = decomposedDenominator / decomposedNumerator;
		remainder = decomposedDenominator % decomposedNumerator;
		decomposedDenominator = decomposedNumerator;
		decomposedNumerator = remainder;

		auto temp = quotient * currentNumerator + previousNumerator;
		previousNumerator = currentNumerator;
		currentNumerator = temp;

		temp = quotient * currentDenominator + previousDenominator;
		previousDenominator = currentDenominator;
		currentDenominator = temp;

		writeln("pnum = ", previousNumerator, " cnum = ", currentNumerator);
		writeln("pden = ", previousDenominator, " cden = ", currentDenominator);
		writeln("dnum = ", decomposedNumerator, " dden = ", decomposedDenominator);
		writeln("quot = ", quotient, " remd = ", remainder);
		writeln();
	}

	numerator = currentNumerator;
	denominator = currentDenominator;
}

unittest
{
	import std.stdio;
	ulong a, b=34,c=21;

	aproximateByEuclid(a, b, c, null);
	writeln(a,":",b,"/",c);
}

template Halfbytes(T)
	if(isIntegral!T && T.sizeof >= 2)
{
	static if(is(T == ulong))
		alias Halfbytes = uint ;
	else static if(is(T == uint))
		alias Halfbytes = ushort;
	else static if(is(T == ushort))
		alias Halfbytes = ubyte;
	else static if(is(T == long))
		alias Halfbytes = int;
	else static if(is(T == int))
		alias Halfbytes = short;
	else static if(is(T == short))
		alias Halfbytes = byte;
}

unittest
{
	assert(is(Halfbytes!ulong == uint));
	assert(is(Halfbytes!uint == ushort));
	assert(is(Halfbytes!ushort == ubyte));
	assert(is(Halfbytes!long == int));
	assert(is(Halfbytes!int == short));
	assert(is(Halfbytes!short == byte));
}

template Quarterbytes(T)
	if(isIntegral!T && T.sizeof >= 4)
{
	static if(is(T == ulong))
		alias Quarterbytes = ushort;
	else static if(is(T == uint))
		alias Quarterbytes = ubyte;
	else static if(is(T == long))
		alias Quarterbytes = short;
	else static if(is(T == int))
		alias Quarterbytes = byte;
}

unittest
{
	assert(is(Quarterbytes!ulong == ushort));
	assert(is(Quarterbytes!uint == ubyte));
	assert(is(Quarterbytes!long == short));
	assert(is(Quarterbytes!int == byte));
}
