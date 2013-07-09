module euclid;
import std.stdio;
import std.math, std.conv;

void main()
{
  /* long a,b;
   readf(" %s %s",&a,&b);
   writeln("gcd(",a,", ",b,") = ",gcd(a,b));
   writeln("lcm(",a,", ",b,") = ",lcm(a,b)); */
   writeln(0.5," = ", ChainFraction!int(0.5));
   writeln(1.5," = ", ChainFraction!int(1.5e17));
   writeln(1.6," = ", ChainFraction!int(1.6));
   writeln(0.3," = ", ChainFraction!int(0.3));
   writeln(0.33," = ", ChainFraction!long(0.33));
   writeln(0.3333333333333333333333," = ", ChainFraction!int(0.33333333333333333333333));
   //writeln(SQRT2," = ", ChainFraction!byte(SQRT2));
   //writeln(SQRT1_2," = ", ChainFraction!int(SQRT1_2));
   //writeln(PI," = ", ChainFraction!long(PI));
}

T gcd(T)(T a, T b)
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
{
   return a*(b/gcd(a,b));
}

struct ChainFraction(T)
{
    this(real number)
    {
	writefln("\n\nnumber = %.20g\nnumber = %.20a",number,number);
	int expn;
	auto mantissa = frexp(number, expn);
	ulong mnt = cast(ulong) ldexp(mantissa,64);
	writefln("mnt = %.20a", mantissa);
	writefln("mnt =    %x",mnt);
	writeln("exp = ", expn);
	mnt>>=1;
	writefln("mnt =    %x",mnt);
	ulong base = 1UL << 63;
	writefln("bas =    %x",base);
	ulong gcdValue = gcd(base,mnt);
	ulong Q = base / gcdValue;
	ulong P = mnt  / gcdValue;
	writefln("P =    %x",P);
	writefln("Q =    %x",Q);
	T   pPre = 1,
	    pCur = 0,
	    qPre = 0,
	    qCur = 1;
	ulong a=1;
	ulong b;
	
	
	do
	{
	    
	    ulong aPre=a;
	    a = Q / P;
	    b = Q % P;
	    Q = P;
	    P = b;
	    writefln("a = %d,\tb = %d", a, b);
	    //*
	    writeln("pPre ", pPre);
	    writeln("pCur ", pCur);
	    writeln("qPre ", qPre);
	    writeln("qCur ", qCur);//*/
	    if(a/aPre>1000 || qCur>=(T.max-qPre)/a) break;
	    auto temp = pCur;
	    pCur = cast(T) (a * pCur + pPre);
	    pPre = temp;
	    
	    temp = qCur;
	    qCur = cast(T) (a * qCur + qPre);
	    qPre = temp;
	    
	    
	  //  writeln("x ",x);
	}
	while(b);
	/*
	writeln("pPre ", pPre);
	    writeln("pCur ", pCur);
	    writeln("qPre ", qPre);
	    writeln("qCur ", qCur);//*/
	numerator_ = pCur;
	denominanator_ = qCur;    
    }
    
    string toString()
    {
	return to!string(integral_) ~ " : " ~ to!string(numerator_) ~ " / " ~ to!string(denominanator_);
    }
    private:
	T integral_=0,
	    numerator_=0,
	    denominanator_=1;
}

