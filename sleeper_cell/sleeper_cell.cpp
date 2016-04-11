#include <bits/stdc++.h>
using namespace std;

// CTF-BR{riot_in_public_square_vgzdLIEjd}
const string flag = "FYM-OI}olte_zi_wdqedd_djrzuj_shgmEDFqo{";

vector<int> primos;
bool ehprimo[1024];

void crivo()
{
	for(int i=2; i<1024; i++) ehprimo[i] = i%2;
	for(int i=3; i<1024; i+=2)
		if(ehprimo[i])
		{
			primos.push_back(i);
			for(int j=i*i; j<1024; j+=i)
				ehprimo[j] = 0;
		}
}

inline bool islet(char c)
{
	return (c>='a' and c<='z') or (c>='A' and c<='Z');
}

inline bool ism(char c)
{
	return (c>='a' and c<='z');
}

inline bool isM(char c)
{
	return islet(c) and not ism(c);
}

string cod(string s)
{
	for(int i=0; s[i]; i++)
	{
		int a = int(s[i])+primos[i];
		int prox = int(ism(s[i]) ? 'z' : isM(s[i]) ? 'Z' : s[i]);
		while(a>prox) a-=26;
		s[i] = s[i]=='{' ? '}' : s[i]=='}' ? '{' : islet(s[i]) ? char(a) : s[i];
	}
	return s;
}

int main() {
	string s;
	crivo();
	while(cin>>s)
		cout << (cod(s)==flag ? "OK" : s) << endl;
	return 0;
}
