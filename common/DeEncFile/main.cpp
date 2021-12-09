
#include <string>
#include <time.h>
#include <stdlib.h>

using namespace std;

const std::string ENCRYPT_ZIP_EXT = ".zip";
static unsigned char magic[] = { 'C', 'Y', 'N', 'K' };

static bool encryptMem(unsigned char *data, int datasize, string key)
{
	if (!data || datasize < 5) {
		return false;
	}

	unsigned char *pmem = (unsigned char *)data;

	for (int i = 0; i < sizeof (magic); i++) {
		pmem[i] = magic[i];
	}

	pmem += sizeof (magic);
	datasize -= sizeof (magic);

	// get the header 
	srand((unsigned int)time(NULL));

	unsigned char seed = rand() % 256;
	printf("seed = %d \n", seed);
	pmem[0] = seed;

	// ptr to the body 
	pmem++;
	datasize--;

	// decrypt body 
	for (int i = 0; i < datasize; i++) {
		pmem[i] += seed;
	}

	return true;
}

static bool decryptMem(unsigned char *data, int datasize, const char * key)
{
	if (!data || datasize < 5) {
		return false;
	}

	unsigned char *pmem = (unsigned char *)data;

	// get the magic 
	if (false
		|| pmem[0] != magic[0]
		|| pmem[1] != magic[1]
		|| pmem[2] != magic[2]
		|| pmem[3] != magic[3]
		)
	{
		printf("Format Error!\n");
		return false;
	}

	pmem += sizeof (magic);
	datasize -= sizeof (magic);

	// get the header 
	unsigned char seed = pmem[0];

	// ptr to the body 
	pmem++;
	datasize--;

	// decrypt body 
	for (int i = 0; i < datasize; i++) {
		pmem[i] -= seed;
	}

	return true;
}


#define  USE_MEM 1

int main(int argc, char* argv[])
{
	if (argc < 4) {
		fprintf(stderr, "Usage : %s enc/dec filepath key \n", argv[0]);
		return (-1);
	}
	if (0 == strcmp(argv[1], "enc")) {

		FILE *fp = fopen(argv[2], "rb+");

		if (fp) {

			fseek(fp, 0, SEEK_END);
			int filesize = ftell(fp);
			fseek(fp, 0, SEEK_SET);

			int fileoff = sizeof (magic)+1;
			int totalSize = filesize + fileoff;

			unsigned char *pbuffer = new unsigned char[totalSize];		// plus header 
			fread((void *)(pbuffer + fileoff), filesize, 1, fp);					// read to body 

			// encrypt mem
			encryptMem(pbuffer, totalSize, "");

			// close old file 
			fclose(fp);

			// open write file 
			fp = fopen(argv[2], "wb+");

			if (fp){
				fwrite((void*)(pbuffer), totalSize, 1, fp);
				fclose(fp);
			}

			printf("Encrypt File OK\n");

			delete pbuffer;
			pbuffer = nullptr;

		}
	}
	else {

		FILE *fp = fopen(argv[2], "rb");
		if (fp) {
			fseek(fp, 0, SEEK_END);
			int filesize = ftell(fp);
			fseek(fp, 0, SEEK_SET);

			int fileoff = sizeof (magic)+1;

			unsigned char *pbuffer = new unsigned char[filesize];
			fread((void *)(pbuffer), filesize, 1, fp);
			decryptMem(pbuffer, filesize, "");

			string destbin = argv[2] + ENCRYPT_ZIP_EXT;
			FILE *tofp = fopen(destbin.c_str(), "wb");
			if (tofp) {

				fwrite((void*)(pbuffer + fileoff), filesize - fileoff, 1, tofp);
				fclose(tofp);

			}

			delete pbuffer;
			pbuffer = nullptr;

			fclose(fp);
		}
	}


	return (0);
}

