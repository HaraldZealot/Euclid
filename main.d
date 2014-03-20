module euclid;
import std.stdio;
import std.math, std.conv, std.traits;

void main()
{
  /* long a,b;
   readf(" %s %s",&a,&b);
   writeln("gcd(",a,", ",b,") = ",gcd(a,b));
   writeln("lcm(",a,", ",b,") = ",lcm(a,b)); */
   writeln(0.0," = ", ChainFraction!int(0.0));
   writeln(real.infinity," = ", ChainFraction!int(real.infinity));
   writeln(-real.infinity," = ", ChainFraction!int(-real.infinity));
   writeln(real.nan," = ", ChainFraction!int(real.nan));
   writeln(0.5," = ", ChainFraction!int(0.5));
   writeln(1.5e19," = ", ChainFraction!long(1.5e19));
   writeln(-1.6," = ", ChainFraction!int(-1.6));
   writeln(1.6," = ", ChainFraction!int(1.6));
   //writeln(0.3," = ", ChainFraction!int(0.3));
   writeln(0.335," = ", ChainFraction!long(0.335));
   //writeln(0.5+real.epsilon," = ",ChainFraction!long(0.5+real.epsilon));
   //writeln(real.epsilon," = ",ChainFraction!long(real.epsilon));
   writeln(-0x9.123456789abcd24P-4," = ",ChainFraction!long(-0x9.123456789abcd24P-4));
   writeln(0x9.123456789abcd26P-4," = ",ChainFraction!long(0x9.123456789abcd26P-4));
   writeln(0x9.123456789abcd28P-4," = ",ChainFraction!long(0x9.123456789abcd28P-4));
   //writeln(0x1.23456789abcdef5p-4," = ",ChainFraction!long(0x1.23456789abcdef5p-4));
   //writeln(0x1.23456789abcdef5p-4," = ",ChainFraction!long(0x1.23456789abcdef5p-4));
   writeln(0x0.547ae147ae147ae1p0," = ", ChainFraction!long(0x0.547ae147ae147ae1p0));
   //writeln(0.3333333333333333333333," = ", ChainFraction!int(0.33333333333333333333333));
   writeln(SQRT2," = ", ChainFraction!byte(SQRT2));
   //writeln(SQRT1_2," = ", ChainFraction!int(SQRT1_2));
   //writeln(PI," = ", ChainFraction!long(PI));
}

T gcd(T)(T a, T b)
  if(isIntegral!T)
{
   if(!b)return a;
   while(a%b)
   {
      auto c=a%b;
      a=b;
      b=c;
   }
   return b;
}

T lcm(T)(T a, T b)
  if(isIntegral!T)
{
   return a*(b/gcd(a,b));
}

struct ChainFraction(T)
{
    this(real number)
    {
	
	writeln("\n\n\n");
	//writefln("num = %.20a",number);
	if(isNaN(number))
	{
	    denominanator_ = 0;
	    return;
	}
	byte sign = cast(byte)signbit(number);
	scope(exit)if(sign) denominanator_=-denominanator_;
	if(sign)number=copysign(number,1.0);
	//writefln("num = %.20a",number);
	if(number>Unsigned!T.max)
	{
	    numerator_ = sign?cast(Unsigned!T)-1:1;
	    denominanator_ = 0;
	    return;
	}
	auto immutable antieps = cast(ulong)1.0/(number.epsilon*2);
	writeln("antieps = ",antieps);
	int expn;
	auto mantissa = frexp(number, expn);
	ulong mnt = cast(ulong) ldexp(mantissa,64);
	writefln("mnt = %.20a", mantissa);
	writefln("mnt =    %x",mnt);
	writeln("exp = ", expn);
	mnt>>=1;
	writefln("mnt =    %x",mnt);
	ulong base = 1UL << 63;
	if(expn>0)
	    base>>=expn;
	
	writefln("bas =    %x",base);
	ulong gcdValue = gcd(base,mnt);
	ulong Q = base / gcdValue;
	ulong P = mnt  / gcdValue;
	integral_=cast(T)(P/Q<T.max?P/Q:T.max);
	P%=Q;
	
	writefln("P =    %x",P);
	writefln("Q =    %x",Q);
	Unsigned!T  pPre = 1,
		    pCur = 0,
		    qPre = 0,
		    qCur = 1;
	ulong a=1;
	ulong b;
	if(P){
	do
	{
	    a = Q / P;
	    b = Q % P;
	    Q = P;
	    P = b;
	    /*
	    writeln("pPre ", pPre);
	    writeln("pCur ", pCur);
	    writeln("qPre ", qPre);
	    writeln("qCur ", qCur);//*/
	    if(a>=(antieps/qCur)/qCur || a>=(T.max-qPre)/qCur) break;
	    auto temp = pCur;
	    pCur = cast(T) (a * pCur + pPre);
	    pPre = temp;
	    
	    temp = qCur;
	    qCur = cast(T) (a * qCur + qPre);
	    qPre = temp;
	}
	while(b);
	numerator_ = pCur;
	denominanator_ = qCur; 
	}
	else{
	    numerator_ = cast(Unsigned!T)P;
	    denominanator_ = cast(Unsigned!T)Q;//cast(Unsigned!T)1;??
	}
	/*
	writeln("pPre ", pPre);
	    writeln("pCur ", pCur);
	    writeln("qPre ", qPre);
	    writeln("qCur ", qCur);//*/
	
	writefln("number = %.20a",number);
	writefln("result = %.20a",sgn(denominanator_)*(cast(real)integral_+cast(real)numerator_/cast(real)abs(denominanator_)));
    }
    
    string toString()
    {
	if(!denominanator_)
	    if(numerator_)
		return numerator_>1?"-inf":"inf";
	    else
		return "nan";
	return (denominanator_<0?"-":"") ~ to!string(integral_) ~ " : " ~ to!string(numerator_) ~ " / " ~ to!string(abs(denominanator_));
    }
    private:
	Unsigned!T 	integral_=0;
	Unsigned!T	numerator_=0;
	T		denominanator_=1;
}

