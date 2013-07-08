module euclid;
import std.stdio;

void main()
{
   long a,b;
   readf(" %s %s",&a,&b);
   writeln("gcd(",a,", ",b,") = ",gcd(a,b));
   writeln("lcm(",a,", ",b,") = ",lcm(a,b));
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
