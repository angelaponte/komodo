#include <sodium.h>

char* to_hex( char hex[], const uint8_t bin[], size_t length )
{
	int i;
	uint8_t *p0 = (uint8_t *)bin;
	char *p1 = hex;

	for( i = 0; i < length; i++ ) {
		snprintf( p1, 3, "%02x", *p0 );
		p0 += 1;
		p1 += 2;
	}

	return hex;
}

int main(void)
{
  char userpass[64] = "";
  char passphrase[32] = "2781D87578639B49630F503B3128C2AC";
  char hex[64] = "";

  crypto_scalarmult_base(userpass, passphrase);

  printf("%s\r\n", to_hex(hex, userpass, 32));
}
