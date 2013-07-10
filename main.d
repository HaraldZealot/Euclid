module euclid;
import std.stdio;
import std.math, std.conv, std.traits;

void main()
{
  /* long a,b;
   readf(" %s %s",&a,&b);
   writeln("gcd(",a,", ",b,") = ",gcd(a,b));
   writeln("lcm(",a,", ",b,") = ",lcm(a,b)); */
   writeln(0.5," = ", ChainFraction!int(0.5));
   writeln(1.5e3," = ", ChainFraction!long(1.5e3));
   writeln(1.6," = ", ChainFraction!int(1.6));
   //writeln(0.3," = ", ChainFraction!int(0.3));
   writeln(0.335," = ", ChainFraction!long(0.335));
   //writeln(0.5+real.epsilon," = ",ChainFraction!long(0.5+real.epsilon));
   //writeln(real.epsilon," = ",ChainFraction!long(real.epsilon));
   writeln(0x9.123456789abcd24P-4," = ",ChainFraction!long(0x9.123456789abcd24P-4));
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
	writeln("\n\n\n");
	auto immutable antieps = cast(ulong)1.0/(number.epsilon*2);
	//writefln("\n\nnumber = %.20g\nnumber = %.20a",number,number);
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
	//{auto temp=P%Q;P=Q;Q=temp;}
	P%=Q;
	
	writefln("P =    %x",P);
	writefln("Q =    %x",Q);
	Unsigned!T  pPre = 1,
		    pCur = 0,
		    qPre = 0,
		    qCur = 1;
	ulong a=1;
	ulong b;
	
	//real sum = 0.0, sumSq = 0.0;
	int n=1;
	do
	{
	    a = Q / P;
	    b = Q % P;
	    Q = P;
	    P = b;
	    //writefln("a[%02d] =    %d,\tb = %d",n, a, b);
	    //writefln("num = %d",cast(long)(pPre*qCur-pCur*qPre));
	   // writefln("treshold = %.0f",(antieps/qCur)/qCur);
	    //sum+=a;
	    //sumSq+=a*a;
	    //writefln("<a>  = %g,\ts(a) = %g",sum/n,sqrt((sumSq-sum^^2/n)/(n-1)));
	    /*
	    writeln("pPre ", pPre);
	    writeln("pCur ", pCur);
	    writeln("qPre ", qPre);
	    writeln("qCur ", qCur);//*/
	    if(a>=(antieps/qCur)/qCur || a>=(Unsigned!T.max-qPre)/qCur) break;
	    auto temp = pCur;
	    pCur = cast(T) (a * pCur + pPre);
	    pPre = temp;
	    
	    temp = qCur;
	    qCur = cast(T) (a * qCur + qPre);
	    qPre = temp;
	    
	    ++n;
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
	writefln("number = %.20a",mantissa);
	writefln("result = %.20a",cast(real)pCur/cast(real)qCur);
    }
    
    string toString()
    {
	return to!string(integral_) ~ " : " ~ to!string(numerator_) ~ " / " ~ to!string(denominanator_);
    }
    private:
	T 		integral_=0;
	Unsigned!T	numerator_=0,
			denominanator_=1;
}

