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
   writeln(1.5," = ", ChainFraction!int(1.5));
   writeln(1.6," = ", ChainFraction!int(1.6));
   writeln(0.3," = ", ChainFraction!int(0.3));
   writeln(0.333," = ", ChainFraction!int(0.333));
   writeln(0.3333333333333333333333," = ", ChainFraction!int(0.33333333333333333333333));
   writeln(SQRT2," = ", ChainFraction!byte(SQRT2));
   writeln(SQRT1_2," = ", ChainFraction!int(SQRT1_2));
   writeln(PI," = ", ChainFraction!long(PI));
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
	auto x = floor(number);
	integral_=cast(T) x;
	x = number - x;
	T pPre = 1,
	    pCur = integral_,
	    qPre = 0,
	    qCur = 1,
	    count = 0;
	while(abs(x)>float.epsilon && qCur<T.max/3)
	{
	    
	    x = 1.0/x;
	    T a = cast(T) floor(x);
	    /*writeln("a ", a);
	    writeln("pPre ", pPre);
	    writeln("pCur ", pCur);
	    writeln("qPre ", qPre);
	    writeln("qCur ", qCur);*/
	    auto temp = pCur;
	    pCur = cast(T) (a * pCur + pPre);
	    pPre = temp;
	    
	    temp = qCur;
	    qCur = cast(T) (a * qCur + qPre);
	    qPre = temp;
	    x-=a;
	    
	    ++count;
	}
	/*writeln("pPre ", pPre);
	    writeln("pCur ", pCur);
	    writeln("qPre ", qPre);
	    writeln("qCur ", qCur);*/
	numerator_ = cast(T) (pCur - integral_ * qCur);
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

