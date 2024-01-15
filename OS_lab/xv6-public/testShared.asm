
_testShared:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#define allowedAddr HEAPLIMIT + 3*PGSIZE

int basicSharedTest();	// Create segment, write, read and destroy test
int forkTest();		// Two forks, parent write, child-1 write, child-2 write, parent read (parent attach)

int main(int argc, char *argv[]) {
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 04             	sub    $0x4,%esp
	/*
		Basic shared memory test,
		create region - write - read - remove region
	*/
    if(basicSharedTest() < 0) {
  15:	e8 46 00 00 00       	call   60 <basicSharedTest>
  1a:	85 c0                	test   %eax,%eax
  1c:	78 0e                	js     2c <main+0x2c>
		printf(1, "failed\n");
	}
	if(forkTest() < 0) {
  1e:	e8 3d 01 00 00       	call   160 <forkTest>
  23:	85 c0                	test   %eax,%eax
  25:	78 18                	js     3f <main+0x3f>
		printf(1, "failed\n");
	}

    exit();
  27:	e8 17 05 00 00       	call   543 <exit>
		printf(1, "failed\n");
  2c:	52                   	push   %edx
  2d:	52                   	push   %edx
  2e:	68 1e 0b 00 00       	push   $0xb1e
  33:	6a 01                	push   $0x1
  35:	e8 d6 06 00 00       	call   710 <printf>
  3a:	83 c4 10             	add    $0x10,%esp
  3d:	eb df                	jmp    1e <main+0x1e>
		printf(1, "failed\n");
  3f:	50                   	push   %eax
  40:	50                   	push   %eax
  41:	68 1e 0b 00 00       	push   $0xb1e
  46:	6a 01                	push   $0x1
  48:	e8 c3 06 00 00       	call   710 <printf>
  4d:	83 c4 10             	add    $0x10,%esp
  50:	eb d5                	jmp    27 <main+0x27>
  52:	66 90                	xchg   %ax,%ax
  54:	66 90                	xchg   %ax,%ax
  56:	66 90                	xchg   %ax,%ax
  58:	66 90                	xchg   %ax,%ax
  5a:	66 90                	xchg   %ax,%ax
  5c:	66 90                	xchg   %ax,%ax
  5e:	66 90                	xchg   %ax,%ax

00000060 <basicSharedTest>:
}

// basic shared test
int basicSharedTest() {
  60:	f3 0f 1e fb          	endbr32 
  64:	55                   	push   %ebp
  65:	89 e5                	mov    %esp,%ebp
  67:	57                   	push   %edi
  68:	56                   	push   %esi
  69:	53                   	push   %ebx
  6a:	83 ec 14             	sub    $0x14,%esp
	printf(1, "* (Basic) Create segment, write, read and destroy test : ");
  6d:	68 78 0a 00 00       	push   $0xa78
  72:	6a 01                	push   $0x1
  74:	e8 97 06 00 00       	call   710 <printf>
	char *string = "Test String";
	// get region
	int shmid = shmget(KEY1, 2565, 06 | IPC_CREAT);
  79:	83 c4 0c             	add    $0xc,%esp
  7c:	68 06 02 00 00       	push   $0x206
  81:	68 05 0a 00 00       	push   $0xa05
  86:	68 d0 07 00 00       	push   $0x7d0
  8b:	e8 a3 05 00 00       	call   633 <shmget>
	if(shmid < 0) {
  90:	83 c4 10             	add    $0x10,%esp
  93:	85 c0                	test   %eax,%eax
  95:	78 78                	js     10f <basicSharedTest+0xaf>
		return -1;
	}
	// attach to shmid's region
	char *ptr = (char *)shmat(shmid, (void *)0, 0);
  97:	83 ec 04             	sub    $0x4,%esp
  9a:	89 c6                	mov    %eax,%esi
  9c:	6a 00                	push   $0x0
  9e:	6a 00                	push   $0x0
  a0:	50                   	push   %eax
  a1:	e8 95 05 00 00       	call   63b <shmat>
	if((int)ptr < 0) {
  a6:	83 c4 10             	add    $0x10,%esp
  a9:	85 c0                	test   %eax,%eax
  ab:	78 62                	js     10f <basicSharedTest+0xaf>
  ad:	bb fc 0a 00 00       	mov    $0xafc,%ebx
  b2:	89 c2                	mov    %eax,%edx
		return -1;
	}
	// write into region
	for(int i = 0; string[i] != 0; i++) {
  b4:	b9 54 00 00 00       	mov    $0x54,%ecx
  b9:	89 df                	mov    %ebx,%edi
  bb:	29 c7                	sub    %eax,%edi
  bd:	8d 76 00             	lea    0x0(%esi),%esi
		ptr[i] = string[i];
  c0:	88 0a                	mov    %cl,(%edx)
	for(int i = 0; string[i] != 0; i++) {
  c2:	83 c2 01             	add    $0x1,%edx
  c5:	0f b6 0c 17          	movzbl (%edi,%edx,1),%ecx
  c9:	84 c9                	test   %cl,%cl
  cb:	75 f3                	jne    c0 <basicSharedTest+0x60>
	}
	// detach
	int dt = shmdt(ptr);
  cd:	83 ec 0c             	sub    $0xc,%esp
  d0:	50                   	push   %eax
  d1:	e8 6d 05 00 00       	call   643 <shmdt>
	if(dt < 0) {
  d6:	83 c4 10             	add    $0x10,%esp
  d9:	85 c0                	test   %eax,%eax
  db:	78 32                	js     10f <basicSharedTest+0xaf>
		return -1;
	}

	// re-attach for verification
	ptr = (char *)shmat(shmid, (void *)0, 0);
  dd:	83 ec 04             	sub    $0x4,%esp
  e0:	6a 00                	push   $0x0
  e2:	6a 00                	push   $0x0
  e4:	56                   	push   %esi
  e5:	e8 51 05 00 00       	call   63b <shmat>
	if((int)ptr < 0) {
  ea:	83 c4 10             	add    $0x10,%esp
  ed:	85 c0                	test   %eax,%eax
  ef:	78 1e                	js     10f <basicSharedTest+0xaf>
  f1:	89 c2                	mov    %eax,%edx
		return -1;
	}

	// read, written data
	for(int i = 0; string[i] != 0; i++) {
  f3:	b9 54 00 00 00       	mov    $0x54,%ecx
  f8:	29 c3                	sub    %eax,%ebx
  fa:	eb 0f                	jmp    10b <basicSharedTest+0xab>
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 100:	83 c2 01             	add    $0x1,%edx
 103:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 107:	84 c9                	test   %cl,%cl
 109:	74 15                	je     120 <basicSharedTest+0xc0>
		if(ptr[i] != string[i]) {
 10b:	38 0a                	cmp    %cl,(%edx)
 10d:	74 f1                	je     100 <basicSharedTest+0xa0>
	if(ctl < 0) {
		return -1;
	}
	printf(1, "Pass\n");
	return 0;
}
 10f:	8d 65 f4             	lea    -0xc(%ebp),%esp
		return -1;
 112:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 117:	5b                   	pop    %ebx
 118:	5e                   	pop    %esi
 119:	5f                   	pop    %edi
 11a:	5d                   	pop    %ebp
 11b:	c3                   	ret    
 11c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	dt = shmdt(ptr);
 120:	83 ec 0c             	sub    $0xc,%esp
 123:	50                   	push   %eax
 124:	e8 1a 05 00 00       	call   643 <shmdt>
	if(dt < 0) {
 129:	83 c4 10             	add    $0x10,%esp
 12c:	85 c0                	test   %eax,%eax
 12e:	78 df                	js     10f <basicSharedTest+0xaf>
	int ctl = shmctl(shmid, IPC_RMID, (void *)0);
 130:	83 ec 04             	sub    $0x4,%esp
 133:	6a 00                	push   $0x0
 135:	6a 00                	push   $0x0
 137:	56                   	push   %esi
 138:	e8 0e 05 00 00       	call   64b <shmctl>
	if(ctl < 0) {
 13d:	83 c4 10             	add    $0x10,%esp
 140:	85 c0                	test   %eax,%eax
 142:	78 cb                	js     10f <basicSharedTest+0xaf>
	printf(1, "Pass\n");
 144:	83 ec 08             	sub    $0x8,%esp
 147:	68 08 0b 00 00       	push   $0xb08
 14c:	6a 01                	push   $0x1
 14e:	e8 bd 05 00 00       	call   710 <printf>
	return 0;
 153:	83 c4 10             	add    $0x10,%esp
}
 156:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
 159:	31 c0                	xor    %eax,%eax
}
 15b:	5b                   	pop    %ebx
 15c:	5e                   	pop    %esi
 15d:	5f                   	pop    %edi
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    

00000160 <forkTest>:


// 2 fork test
int forkTest() {
 160:	f3 0f 1e fb          	endbr32 
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	57                   	push   %edi
 168:	56                   	push   %esi
 169:	53                   	push   %ebx
 16a:	83 ec 14             	sub    $0x14,%esp
	printf(1, "* 2 Forks (Parent attach; parent-child 1-child 2 write; parent read) : ");
 16d:	68 b4 0a 00 00       	push   $0xab4
 172:	6a 01                	push   $0x1
 174:	e8 97 05 00 00       	call   710 <printf>
	// test string
	char *string = "AAAAABBBBBCCCCC";
	// create
	int shmid = shmget(KEY1, 2565, 06 | IPC_CREAT);
 179:	83 c4 0c             	add    $0xc,%esp
 17c:	68 06 02 00 00       	push   $0x206
 181:	68 05 0a 00 00       	push   $0xa05
 186:	68 d0 07 00 00       	push   $0x7d0
 18b:	e8 a3 04 00 00       	call   633 <shmget>
	if(shmid < 0) {
 190:	83 c4 10             	add    $0x10,%esp
 193:	85 c0                	test   %eax,%eax
 195:	0f 88 ac 00 00 00    	js     247 <forkTest+0xe7>
		return -1;
	}
	// attach
	char *ptr = (char *)shmat(shmid, (void *)0, 0);
 19b:	83 ec 04             	sub    $0x4,%esp
 19e:	89 c3                	mov    %eax,%ebx
 1a0:	6a 00                	push   $0x0
 1a2:	6a 00                	push   $0x0
 1a4:	50                   	push   %eax
 1a5:	e8 91 04 00 00       	call   63b <shmat>
	if((int)ptr < 0) {
 1aa:	83 c4 10             	add    $0x10,%esp
	char *ptr = (char *)shmat(shmid, (void *)0, 0);
 1ad:	89 c6                	mov    %eax,%esi
	if((int)ptr < 0) {
 1af:	85 c0                	test   %eax,%eax
 1b1:	0f 88 90 00 00 00    	js     247 <forkTest+0xe7>
		return -1;
	}
	// parent-write
	for(int i = 0; i < 5; i++) {
 1b7:	31 c0                	xor    %eax,%eax
		ptr[i] = string[i];
 1b9:	ba 41 00 00 00       	mov    $0x41,%edx
 1be:	88 14 30             	mov    %dl,(%eax,%esi,1)
	for(int i = 0; i < 5; i++) {
 1c1:	83 c0 01             	add    $0x1,%eax
 1c4:	83 f8 05             	cmp    $0x5,%eax
 1c7:	74 13                	je     1dc <forkTest+0x7c>
 1c9:	0f b6 90 0e 0b 00 00 	movzbl 0xb0e(%eax),%edx
 1d0:	83 c0 01             	add    $0x1,%eax
		ptr[i] = string[i];
 1d3:	88 54 30 ff          	mov    %dl,-0x1(%eax,%esi,1)
	for(int i = 0; i < 5; i++) {
 1d7:	83 f8 05             	cmp    $0x5,%eax
 1da:	75 ed                	jne    1c9 <forkTest+0x69>
	}
	int pid = fork();
 1dc:	e8 5a 03 00 00       	call   53b <fork>
 1e1:	89 c7                	mov    %eax,%edi
	if(pid < 0) {
 1e3:	85 c0                	test   %eax,%eax
 1e5:	78 60                	js     247 <forkTest+0xe7>
		return -1;
	} else if(pid == 0) {
 1e7:	75 37                	jne    220 <forkTest+0xc0>
		int pid1 = fork();
 1e9:	e8 4d 03 00 00       	call   53b <fork>
		if(pid1 < 0) {
 1ee:	85 c0                	test   %eax,%eax
 1f0:	78 55                	js     247 <forkTest+0xe7>
			return -1;
		} else if(pid1 == 0) {
 1f2:	0f 85 b0 00 00 00    	jne    2a8 <forkTest+0x148>
 1f8:	b9 0e 0b 00 00       	mov    $0xb0e,%ecx
 1fd:	8d 46 05             	lea    0x5(%esi),%eax
 200:	8d 5e 0a             	lea    0xa(%esi),%ebx
			// child 2-write
			for(int i = 5; i < 10; i++) {
				ptr[i] = string[i];
 203:	29 f1                	sub    %esi,%ecx
 205:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
 209:	83 c0 01             	add    $0x1,%eax
 20c:	88 50 ff             	mov    %dl,-0x1(%eax)
			for(int i = 5; i < 10; i++) {
 20f:	39 d8                	cmp    %ebx,%eax
 211:	75 f2                	jne    205 <forkTest+0xa5>
		}
		printf(1, "Pass\n");
		return 0;
	}
	return 0;
 213:	8d 65 f4             	lea    -0xc(%ebp),%esp
 216:	89 f8                	mov    %edi,%eax
 218:	5b                   	pop    %ebx
 219:	5e                   	pop    %esi
 21a:	5f                   	pop    %edi
 21b:	5d                   	pop    %ebp
 21c:	c3                   	ret    
 21d:	8d 76 00             	lea    0x0(%esi),%esi
		wait();
 220:	e8 26 03 00 00       	call   54b <wait>
		for(int i = 0; string[i] != 0; i++) {
 225:	b9 0e 0b 00 00       	mov    $0xb0e,%ecx
		wait();
 22a:	89 f0                	mov    %esi,%eax
		for(int i = 0; string[i] != 0; i++) {
 22c:	ba 41 00 00 00       	mov    $0x41,%edx
 231:	29 f1                	sub    %esi,%ecx
 233:	eb 0e                	jmp    243 <forkTest+0xe3>
 235:	8d 76 00             	lea    0x0(%esi),%esi
 238:	83 c0 01             	add    $0x1,%eax
 23b:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
 23f:	84 d2                	test   %dl,%dl
 241:	74 1d                	je     260 <forkTest+0x100>
			if(ptr[i] != string[i]) {
 243:	38 10                	cmp    %dl,(%eax)
 245:	74 f1                	je     238 <forkTest+0xd8>
 247:	8d 65 f4             	lea    -0xc(%ebp),%esp
		return -1;
 24a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 24f:	5b                   	pop    %ebx
 250:	89 f8                	mov    %edi,%eax
 252:	5e                   	pop    %esi
 253:	5f                   	pop    %edi
 254:	5d                   	pop    %ebp
 255:	c3                   	ret    
 256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25d:	8d 76 00             	lea    0x0(%esi),%esi
		int dt = shmdt(ptr);
 260:	83 ec 0c             	sub    $0xc,%esp
 263:	56                   	push   %esi
 264:	e8 da 03 00 00       	call   643 <shmdt>
		if(dt < 0) {
 269:	83 c4 10             	add    $0x10,%esp
 26c:	85 c0                	test   %eax,%eax
 26e:	78 d7                	js     247 <forkTest+0xe7>
		int ctl = shmctl(shmid, IPC_RMID, (void *)0);
 270:	83 ec 04             	sub    $0x4,%esp
 273:	6a 00                	push   $0x0
 275:	6a 00                	push   $0x0
 277:	53                   	push   %ebx
 278:	e8 ce 03 00 00       	call   64b <shmctl>
		if(ctl < 0) {
 27d:	83 c4 10             	add    $0x10,%esp
 280:	85 c0                	test   %eax,%eax
 282:	78 c3                	js     247 <forkTest+0xe7>
		printf(1, "Pass\n");
 284:	83 ec 08             	sub    $0x8,%esp
		return 0;
 287:	31 ff                	xor    %edi,%edi
		printf(1, "Pass\n");
 289:	68 08 0b 00 00       	push   $0xb08
 28e:	6a 01                	push   $0x1
 290:	e8 7b 04 00 00       	call   710 <printf>
		return 0;
 295:	83 c4 10             	add    $0x10,%esp
 298:	8d 65 f4             	lea    -0xc(%ebp),%esp
 29b:	89 f8                	mov    %edi,%eax
 29d:	5b                   	pop    %ebx
 29e:	5e                   	pop    %esi
 29f:	5f                   	pop    %edi
 2a0:	5d                   	pop    %ebp
 2a1:	c3                   	ret    
 2a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			wait();
 2a8:	e8 9e 02 00 00       	call   54b <wait>
			for(int i = 10; string[i] != 0; i++) {
 2ad:	b9 0e 0b 00 00       	mov    $0xb0e,%ecx
 2b2:	8d 46 0a             	lea    0xa(%esi),%eax
 2b5:	ba 43 00 00 00       	mov    $0x43,%edx
 2ba:	29 f1                	sub    %esi,%ecx
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
				ptr[i] = string[i];
 2c0:	88 10                	mov    %dl,(%eax)
			for(int i = 10; string[i] != 0; i++) {
 2c2:	83 c0 01             	add    $0x1,%eax
 2c5:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
 2c9:	84 d2                	test   %dl,%dl
 2cb:	75 f3                	jne    2c0 <forkTest+0x160>
 2cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d0:	89 f8                	mov    %edi,%eax
 2d2:	5b                   	pop    %ebx
 2d3:	5e                   	pop    %esi
 2d4:	5f                   	pop    %edi
 2d5:	5d                   	pop    %ebp
 2d6:	c3                   	ret    
 2d7:	66 90                	xchg   %ax,%ax
 2d9:	66 90                	xchg   %ax,%ax
 2db:	66 90                	xchg   %ax,%ax
 2dd:	66 90                	xchg   %ax,%ax
 2df:	90                   	nop

000002e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2e0:	f3 0f 1e fb          	endbr32 
 2e4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2e5:	31 c0                	xor    %eax,%eax
{
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	53                   	push   %ebx
 2ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 2f0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2f4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2f7:	83 c0 01             	add    $0x1,%eax
 2fa:	84 d2                	test   %dl,%dl
 2fc:	75 f2                	jne    2f0 <strcpy+0x10>
    ;
  return os;
}
 2fe:	89 c8                	mov    %ecx,%eax
 300:	5b                   	pop    %ebx
 301:	5d                   	pop    %ebp
 302:	c3                   	ret    
 303:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000310 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 310:	f3 0f 1e fb          	endbr32 
 314:	55                   	push   %ebp
 315:	89 e5                	mov    %esp,%ebp
 317:	53                   	push   %ebx
 318:	8b 4d 08             	mov    0x8(%ebp),%ecx
 31b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 31e:	0f b6 01             	movzbl (%ecx),%eax
 321:	0f b6 1a             	movzbl (%edx),%ebx
 324:	84 c0                	test   %al,%al
 326:	75 19                	jne    341 <strcmp+0x31>
 328:	eb 26                	jmp    350 <strcmp+0x40>
 32a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 330:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 334:	83 c1 01             	add    $0x1,%ecx
 337:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 33a:	0f b6 1a             	movzbl (%edx),%ebx
 33d:	84 c0                	test   %al,%al
 33f:	74 0f                	je     350 <strcmp+0x40>
 341:	38 d8                	cmp    %bl,%al
 343:	74 eb                	je     330 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 345:	29 d8                	sub    %ebx,%eax
}
 347:	5b                   	pop    %ebx
 348:	5d                   	pop    %ebp
 349:	c3                   	ret    
 34a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 350:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 352:	29 d8                	sub    %ebx,%eax
}
 354:	5b                   	pop    %ebx
 355:	5d                   	pop    %ebp
 356:	c3                   	ret    
 357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35e:	66 90                	xchg   %ax,%ax

00000360 <strlen>:

uint
strlen(const char *s)
{
 360:	f3 0f 1e fb          	endbr32 
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 36a:	80 3a 00             	cmpb   $0x0,(%edx)
 36d:	74 21                	je     390 <strlen+0x30>
 36f:	31 c0                	xor    %eax,%eax
 371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 378:	83 c0 01             	add    $0x1,%eax
 37b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 37f:	89 c1                	mov    %eax,%ecx
 381:	75 f5                	jne    378 <strlen+0x18>
    ;
  return n;
}
 383:	89 c8                	mov    %ecx,%eax
 385:	5d                   	pop    %ebp
 386:	c3                   	ret    
 387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 38e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 390:	31 c9                	xor    %ecx,%ecx
}
 392:	5d                   	pop    %ebp
 393:	89 c8                	mov    %ecx,%eax
 395:	c3                   	ret    
 396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39d:	8d 76 00             	lea    0x0(%esi),%esi

000003a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3a0:	f3 0f 1e fb          	endbr32 
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	57                   	push   %edi
 3a8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b1:	89 d7                	mov    %edx,%edi
 3b3:	fc                   	cld    
 3b4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3b6:	89 d0                	mov    %edx,%eax
 3b8:	5f                   	pop    %edi
 3b9:	5d                   	pop    %ebp
 3ba:	c3                   	ret    
 3bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3bf:	90                   	nop

000003c0 <strchr>:

char*
strchr(const char *s, char c)
{
 3c0:	f3 0f 1e fb          	endbr32 
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 3ce:	0f b6 10             	movzbl (%eax),%edx
 3d1:	84 d2                	test   %dl,%dl
 3d3:	75 16                	jne    3eb <strchr+0x2b>
 3d5:	eb 21                	jmp    3f8 <strchr+0x38>
 3d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3de:	66 90                	xchg   %ax,%ax
 3e0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 3e4:	83 c0 01             	add    $0x1,%eax
 3e7:	84 d2                	test   %dl,%dl
 3e9:	74 0d                	je     3f8 <strchr+0x38>
    if(*s == c)
 3eb:	38 d1                	cmp    %dl,%cl
 3ed:	75 f1                	jne    3e0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 3ef:	5d                   	pop    %ebp
 3f0:	c3                   	ret    
 3f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 3f8:	31 c0                	xor    %eax,%eax
}
 3fa:	5d                   	pop    %ebp
 3fb:	c3                   	ret    
 3fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000400 <gets>:

char*
gets(char *buf, int max)
{
 400:	f3 0f 1e fb          	endbr32 
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	57                   	push   %edi
 408:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 409:	31 f6                	xor    %esi,%esi
{
 40b:	53                   	push   %ebx
 40c:	89 f3                	mov    %esi,%ebx
 40e:	83 ec 1c             	sub    $0x1c,%esp
 411:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 414:	eb 33                	jmp    449 <gets+0x49>
 416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 420:	83 ec 04             	sub    $0x4,%esp
 423:	8d 45 e7             	lea    -0x19(%ebp),%eax
 426:	6a 01                	push   $0x1
 428:	50                   	push   %eax
 429:	6a 00                	push   $0x0
 42b:	e8 2b 01 00 00       	call   55b <read>
    if(cc < 1)
 430:	83 c4 10             	add    $0x10,%esp
 433:	85 c0                	test   %eax,%eax
 435:	7e 1c                	jle    453 <gets+0x53>
      break;
    buf[i++] = c;
 437:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 43b:	83 c7 01             	add    $0x1,%edi
 43e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 441:	3c 0a                	cmp    $0xa,%al
 443:	74 23                	je     468 <gets+0x68>
 445:	3c 0d                	cmp    $0xd,%al
 447:	74 1f                	je     468 <gets+0x68>
  for(i=0; i+1 < max; ){
 449:	83 c3 01             	add    $0x1,%ebx
 44c:	89 fe                	mov    %edi,%esi
 44e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 451:	7c cd                	jl     420 <gets+0x20>
 453:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 455:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 458:	c6 03 00             	movb   $0x0,(%ebx)
}
 45b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 45e:	5b                   	pop    %ebx
 45f:	5e                   	pop    %esi
 460:	5f                   	pop    %edi
 461:	5d                   	pop    %ebp
 462:	c3                   	ret    
 463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 467:	90                   	nop
 468:	8b 75 08             	mov    0x8(%ebp),%esi
 46b:	8b 45 08             	mov    0x8(%ebp),%eax
 46e:	01 de                	add    %ebx,%esi
 470:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 472:	c6 03 00             	movb   $0x0,(%ebx)
}
 475:	8d 65 f4             	lea    -0xc(%ebp),%esp
 478:	5b                   	pop    %ebx
 479:	5e                   	pop    %esi
 47a:	5f                   	pop    %edi
 47b:	5d                   	pop    %ebp
 47c:	c3                   	ret    
 47d:	8d 76 00             	lea    0x0(%esi),%esi

00000480 <stat>:

int
stat(const char *n, struct stat *st)
{
 480:	f3 0f 1e fb          	endbr32 
 484:	55                   	push   %ebp
 485:	89 e5                	mov    %esp,%ebp
 487:	56                   	push   %esi
 488:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 489:	83 ec 08             	sub    $0x8,%esp
 48c:	6a 00                	push   $0x0
 48e:	ff 75 08             	pushl  0x8(%ebp)
 491:	e8 ed 00 00 00       	call   583 <open>
  if(fd < 0)
 496:	83 c4 10             	add    $0x10,%esp
 499:	85 c0                	test   %eax,%eax
 49b:	78 2b                	js     4c8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 49d:	83 ec 08             	sub    $0x8,%esp
 4a0:	ff 75 0c             	pushl  0xc(%ebp)
 4a3:	89 c3                	mov    %eax,%ebx
 4a5:	50                   	push   %eax
 4a6:	e8 f0 00 00 00       	call   59b <fstat>
  close(fd);
 4ab:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4ae:	89 c6                	mov    %eax,%esi
  close(fd);
 4b0:	e8 b6 00 00 00       	call   56b <close>
  return r;
 4b5:	83 c4 10             	add    $0x10,%esp
}
 4b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4bb:	89 f0                	mov    %esi,%eax
 4bd:	5b                   	pop    %ebx
 4be:	5e                   	pop    %esi
 4bf:	5d                   	pop    %ebp
 4c0:	c3                   	ret    
 4c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 4c8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4cd:	eb e9                	jmp    4b8 <stat+0x38>
 4cf:	90                   	nop

000004d0 <atoi>:

int
atoi(const char *s)
{
 4d0:	f3 0f 1e fb          	endbr32 
 4d4:	55                   	push   %ebp
 4d5:	89 e5                	mov    %esp,%ebp
 4d7:	53                   	push   %ebx
 4d8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4db:	0f be 02             	movsbl (%edx),%eax
 4de:	8d 48 d0             	lea    -0x30(%eax),%ecx
 4e1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 4e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 4e9:	77 1a                	ja     505 <atoi+0x35>
 4eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4ef:	90                   	nop
    n = n*10 + *s++ - '0';
 4f0:	83 c2 01             	add    $0x1,%edx
 4f3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 4f6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 4fa:	0f be 02             	movsbl (%edx),%eax
 4fd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 500:	80 fb 09             	cmp    $0x9,%bl
 503:	76 eb                	jbe    4f0 <atoi+0x20>
  return n;
}
 505:	89 c8                	mov    %ecx,%eax
 507:	5b                   	pop    %ebx
 508:	5d                   	pop    %ebp
 509:	c3                   	ret    
 50a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000510 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 510:	f3 0f 1e fb          	endbr32 
 514:	55                   	push   %ebp
 515:	89 e5                	mov    %esp,%ebp
 517:	57                   	push   %edi
 518:	8b 45 10             	mov    0x10(%ebp),%eax
 51b:	8b 55 08             	mov    0x8(%ebp),%edx
 51e:	56                   	push   %esi
 51f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 522:	85 c0                	test   %eax,%eax
 524:	7e 0f                	jle    535 <memmove+0x25>
 526:	01 d0                	add    %edx,%eax
  dst = vdst;
 528:	89 d7                	mov    %edx,%edi
 52a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 530:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 531:	39 f8                	cmp    %edi,%eax
 533:	75 fb                	jne    530 <memmove+0x20>
  return vdst;
}
 535:	5e                   	pop    %esi
 536:	89 d0                	mov    %edx,%eax
 538:	5f                   	pop    %edi
 539:	5d                   	pop    %ebp
 53a:	c3                   	ret    

0000053b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 53b:	b8 01 00 00 00       	mov    $0x1,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <exit>:
SYSCALL(exit)
 543:	b8 02 00 00 00       	mov    $0x2,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <wait>:
SYSCALL(wait)
 54b:	b8 03 00 00 00       	mov    $0x3,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <pipe>:
SYSCALL(pipe)
 553:	b8 04 00 00 00       	mov    $0x4,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <read>:
SYSCALL(read)
 55b:	b8 05 00 00 00       	mov    $0x5,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <write>:
SYSCALL(write)
 563:	b8 10 00 00 00       	mov    $0x10,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <close>:
SYSCALL(close)
 56b:	b8 15 00 00 00       	mov    $0x15,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <kill>:
SYSCALL(kill)
 573:	b8 06 00 00 00       	mov    $0x6,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <exec>:
SYSCALL(exec)
 57b:	b8 07 00 00 00       	mov    $0x7,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <open>:
SYSCALL(open)
 583:	b8 0f 00 00 00       	mov    $0xf,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <mknod>:
SYSCALL(mknod)
 58b:	b8 11 00 00 00       	mov    $0x11,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <unlink>:
SYSCALL(unlink)
 593:	b8 12 00 00 00       	mov    $0x12,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <fstat>:
SYSCALL(fstat)
 59b:	b8 08 00 00 00       	mov    $0x8,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <link>:
SYSCALL(link)
 5a3:	b8 13 00 00 00       	mov    $0x13,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <mkdir>:
SYSCALL(mkdir)
 5ab:	b8 14 00 00 00       	mov    $0x14,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <chdir>:
SYSCALL(chdir)
 5b3:	b8 09 00 00 00       	mov    $0x9,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <dup>:
SYSCALL(dup)
 5bb:	b8 0a 00 00 00       	mov    $0xa,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <getpid>:
SYSCALL(getpid)
 5c3:	b8 0b 00 00 00       	mov    $0xb,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <sbrk>:
SYSCALL(sbrk)
 5cb:	b8 0c 00 00 00       	mov    $0xc,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <sleep>:
SYSCALL(sleep)
 5d3:	b8 0d 00 00 00       	mov    $0xd,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <uptime>:
SYSCALL(uptime)
 5db:	b8 0e 00 00 00       	mov    $0xe,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <find_digital_root>:
SYSCALL(find_digital_root)
 5e3:	b8 16 00 00 00       	mov    $0x16,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <get_process_lifetime>:
SYSCALL(get_process_lifetime)
 5eb:	b8 17 00 00 00       	mov    $0x17,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <copy_file>:
SYSCALL(copy_file)
 5f3:	b8 18 00 00 00       	mov    $0x18,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <get_uncle_count>:
SYSCALL(get_uncle_count)
 5fb:	b8 19 00 00 00       	mov    $0x19,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <change_sched_Q>:
SYSCALL(change_sched_Q)
 603:	b8 1b 00 00 00       	mov    $0x1b,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <show_process_info>:
SYSCALL(show_process_info)
 60b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <set_proc_bjf_params>:
SYSCALL(set_proc_bjf_params)
 613:	b8 1d 00 00 00       	mov    $0x1d,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <set_system_bjf_params>:
SYSCALL(set_system_bjf_params)
 61b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <priorityLock_test>:
SYSCALL(priorityLock_test)
 623:	b8 1e 00 00 00       	mov    $0x1e,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <syscalls_count>:
SYSCALL(syscalls_count)
 62b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <shmget>:

SYSCALL(shmget)
 633:	b8 20 00 00 00       	mov    $0x20,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <shmat>:
SYSCALL(shmat)
 63b:	b8 21 00 00 00       	mov    $0x21,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <shmdt>:
SYSCALL(shmdt)
 643:	b8 22 00 00 00       	mov    $0x22,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <shmctl>:
SYSCALL(shmctl)
 64b:	b8 23 00 00 00       	mov    $0x23,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    
 653:	66 90                	xchg   %ax,%ax
 655:	66 90                	xchg   %ax,%ax
 657:	66 90                	xchg   %ax,%ax
 659:	66 90                	xchg   %ax,%ax
 65b:	66 90                	xchg   %ax,%ax
 65d:	66 90                	xchg   %ax,%ax
 65f:	90                   	nop

00000660 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	83 ec 3c             	sub    $0x3c,%esp
 669:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 66c:	89 d1                	mov    %edx,%ecx
{
 66e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 671:	85 d2                	test   %edx,%edx
 673:	0f 89 7f 00 00 00    	jns    6f8 <printint+0x98>
 679:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 67d:	74 79                	je     6f8 <printint+0x98>
    neg = 1;
 67f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 686:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 688:	31 db                	xor    %ebx,%ebx
 68a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 68d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 690:	89 c8                	mov    %ecx,%eax
 692:	31 d2                	xor    %edx,%edx
 694:	89 cf                	mov    %ecx,%edi
 696:	f7 75 c4             	divl   -0x3c(%ebp)
 699:	0f b6 92 30 0b 00 00 	movzbl 0xb30(%edx),%edx
 6a0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 6a3:	89 d8                	mov    %ebx,%eax
 6a5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 6a8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 6ab:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 6ae:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 6b1:	76 dd                	jbe    690 <printint+0x30>
  if(neg)
 6b3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 6b6:	85 c9                	test   %ecx,%ecx
 6b8:	74 0c                	je     6c6 <printint+0x66>
    buf[i++] = '-';
 6ba:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 6bf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 6c1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 6c6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 6c9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 6cd:	eb 07                	jmp    6d6 <printint+0x76>
 6cf:	90                   	nop
 6d0:	0f b6 13             	movzbl (%ebx),%edx
 6d3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 6d6:	83 ec 04             	sub    $0x4,%esp
 6d9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 6dc:	6a 01                	push   $0x1
 6de:	56                   	push   %esi
 6df:	57                   	push   %edi
 6e0:	e8 7e fe ff ff       	call   563 <write>
  while(--i >= 0)
 6e5:	83 c4 10             	add    $0x10,%esp
 6e8:	39 de                	cmp    %ebx,%esi
 6ea:	75 e4                	jne    6d0 <printint+0x70>
    putc(fd, buf[i]);
}
 6ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6ef:	5b                   	pop    %ebx
 6f0:	5e                   	pop    %esi
 6f1:	5f                   	pop    %edi
 6f2:	5d                   	pop    %ebp
 6f3:	c3                   	ret    
 6f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 6f8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 6ff:	eb 87                	jmp    688 <printint+0x28>
 701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 70f:	90                   	nop

00000710 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 710:	f3 0f 1e fb          	endbr32 
 714:	55                   	push   %ebp
 715:	89 e5                	mov    %esp,%ebp
 717:	57                   	push   %edi
 718:	56                   	push   %esi
 719:	53                   	push   %ebx
 71a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 71d:	8b 75 0c             	mov    0xc(%ebp),%esi
 720:	0f b6 1e             	movzbl (%esi),%ebx
 723:	84 db                	test   %bl,%bl
 725:	0f 84 b4 00 00 00    	je     7df <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 72b:	8d 45 10             	lea    0x10(%ebp),%eax
 72e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 731:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 734:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 736:	89 45 d0             	mov    %eax,-0x30(%ebp)
 739:	eb 33                	jmp    76e <printf+0x5e>
 73b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 73f:	90                   	nop
 740:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 743:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 748:	83 f8 25             	cmp    $0x25,%eax
 74b:	74 17                	je     764 <printf+0x54>
  write(fd, &c, 1);
 74d:	83 ec 04             	sub    $0x4,%esp
 750:	88 5d e7             	mov    %bl,-0x19(%ebp)
 753:	6a 01                	push   $0x1
 755:	57                   	push   %edi
 756:	ff 75 08             	pushl  0x8(%ebp)
 759:	e8 05 fe ff ff       	call   563 <write>
 75e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 761:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 764:	0f b6 1e             	movzbl (%esi),%ebx
 767:	83 c6 01             	add    $0x1,%esi
 76a:	84 db                	test   %bl,%bl
 76c:	74 71                	je     7df <printf+0xcf>
    c = fmt[i] & 0xff;
 76e:	0f be cb             	movsbl %bl,%ecx
 771:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 774:	85 d2                	test   %edx,%edx
 776:	74 c8                	je     740 <printf+0x30>
      }
    } else if(state == '%'){
 778:	83 fa 25             	cmp    $0x25,%edx
 77b:	75 e7                	jne    764 <printf+0x54>
      if(c == 'd'){
 77d:	83 f8 64             	cmp    $0x64,%eax
 780:	0f 84 9a 00 00 00    	je     820 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 786:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 78c:	83 f9 70             	cmp    $0x70,%ecx
 78f:	74 5f                	je     7f0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 791:	83 f8 73             	cmp    $0x73,%eax
 794:	0f 84 d6 00 00 00    	je     870 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 79a:	83 f8 63             	cmp    $0x63,%eax
 79d:	0f 84 8d 00 00 00    	je     830 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 7a3:	83 f8 25             	cmp    $0x25,%eax
 7a6:	0f 84 b4 00 00 00    	je     860 <printf+0x150>
  write(fd, &c, 1);
 7ac:	83 ec 04             	sub    $0x4,%esp
 7af:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7b3:	6a 01                	push   $0x1
 7b5:	57                   	push   %edi
 7b6:	ff 75 08             	pushl  0x8(%ebp)
 7b9:	e8 a5 fd ff ff       	call   563 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 7be:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 7c1:	83 c4 0c             	add    $0xc,%esp
 7c4:	6a 01                	push   $0x1
 7c6:	83 c6 01             	add    $0x1,%esi
 7c9:	57                   	push   %edi
 7ca:	ff 75 08             	pushl  0x8(%ebp)
 7cd:	e8 91 fd ff ff       	call   563 <write>
  for(i = 0; fmt[i]; i++){
 7d2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 7d6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7d9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 7db:	84 db                	test   %bl,%bl
 7dd:	75 8f                	jne    76e <printf+0x5e>
    }
  }
}
 7df:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7e2:	5b                   	pop    %ebx
 7e3:	5e                   	pop    %esi
 7e4:	5f                   	pop    %edi
 7e5:	5d                   	pop    %ebp
 7e6:	c3                   	ret    
 7e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ee:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 7f0:	83 ec 0c             	sub    $0xc,%esp
 7f3:	b9 10 00 00 00       	mov    $0x10,%ecx
 7f8:	6a 00                	push   $0x0
 7fa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7fd:	8b 45 08             	mov    0x8(%ebp),%eax
 800:	8b 13                	mov    (%ebx),%edx
 802:	e8 59 fe ff ff       	call   660 <printint>
        ap++;
 807:	89 d8                	mov    %ebx,%eax
 809:	83 c4 10             	add    $0x10,%esp
      state = 0;
 80c:	31 d2                	xor    %edx,%edx
        ap++;
 80e:	83 c0 04             	add    $0x4,%eax
 811:	89 45 d0             	mov    %eax,-0x30(%ebp)
 814:	e9 4b ff ff ff       	jmp    764 <printf+0x54>
 819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 820:	83 ec 0c             	sub    $0xc,%esp
 823:	b9 0a 00 00 00       	mov    $0xa,%ecx
 828:	6a 01                	push   $0x1
 82a:	eb ce                	jmp    7fa <printf+0xea>
 82c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 830:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 833:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 836:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 838:	6a 01                	push   $0x1
        ap++;
 83a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 83d:	57                   	push   %edi
 83e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 841:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 844:	e8 1a fd ff ff       	call   563 <write>
        ap++;
 849:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 84c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 84f:	31 d2                	xor    %edx,%edx
 851:	e9 0e ff ff ff       	jmp    764 <printf+0x54>
 856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 85d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 860:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 863:	83 ec 04             	sub    $0x4,%esp
 866:	e9 59 ff ff ff       	jmp    7c4 <printf+0xb4>
 86b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 86f:	90                   	nop
        s = (char*)*ap;
 870:	8b 45 d0             	mov    -0x30(%ebp),%eax
 873:	8b 18                	mov    (%eax),%ebx
        ap++;
 875:	83 c0 04             	add    $0x4,%eax
 878:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 87b:	85 db                	test   %ebx,%ebx
 87d:	74 17                	je     896 <printf+0x186>
        while(*s != 0){
 87f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 882:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 884:	84 c0                	test   %al,%al
 886:	0f 84 d8 fe ff ff    	je     764 <printf+0x54>
 88c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 88f:	89 de                	mov    %ebx,%esi
 891:	8b 5d 08             	mov    0x8(%ebp),%ebx
 894:	eb 1a                	jmp    8b0 <printf+0x1a0>
          s = "(null)";
 896:	bb 26 0b 00 00       	mov    $0xb26,%ebx
        while(*s != 0){
 89b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 89e:	b8 28 00 00 00       	mov    $0x28,%eax
 8a3:	89 de                	mov    %ebx,%esi
 8a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8af:	90                   	nop
  write(fd, &c, 1);
 8b0:	83 ec 04             	sub    $0x4,%esp
          s++;
 8b3:	83 c6 01             	add    $0x1,%esi
 8b6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 8b9:	6a 01                	push   $0x1
 8bb:	57                   	push   %edi
 8bc:	53                   	push   %ebx
 8bd:	e8 a1 fc ff ff       	call   563 <write>
        while(*s != 0){
 8c2:	0f b6 06             	movzbl (%esi),%eax
 8c5:	83 c4 10             	add    $0x10,%esp
 8c8:	84 c0                	test   %al,%al
 8ca:	75 e4                	jne    8b0 <printf+0x1a0>
 8cc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 8cf:	31 d2                	xor    %edx,%edx
 8d1:	e9 8e fe ff ff       	jmp    764 <printf+0x54>
 8d6:	66 90                	xchg   %ax,%ax
 8d8:	66 90                	xchg   %ax,%ax
 8da:	66 90                	xchg   %ax,%ax
 8dc:	66 90                	xchg   %ax,%ax
 8de:	66 90                	xchg   %ax,%ax

000008e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e0:	f3 0f 1e fb          	endbr32 
 8e4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e5:	a1 6c 0e 00 00       	mov    0xe6c,%eax
{
 8ea:	89 e5                	mov    %esp,%ebp
 8ec:	57                   	push   %edi
 8ed:	56                   	push   %esi
 8ee:	53                   	push   %ebx
 8ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8f2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 8f4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f7:	39 c8                	cmp    %ecx,%eax
 8f9:	73 15                	jae    910 <free+0x30>
 8fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8ff:	90                   	nop
 900:	39 d1                	cmp    %edx,%ecx
 902:	72 14                	jb     918 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 904:	39 d0                	cmp    %edx,%eax
 906:	73 10                	jae    918 <free+0x38>
{
 908:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90a:	8b 10                	mov    (%eax),%edx
 90c:	39 c8                	cmp    %ecx,%eax
 90e:	72 f0                	jb     900 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 910:	39 d0                	cmp    %edx,%eax
 912:	72 f4                	jb     908 <free+0x28>
 914:	39 d1                	cmp    %edx,%ecx
 916:	73 f0                	jae    908 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 918:	8b 73 fc             	mov    -0x4(%ebx),%esi
 91b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 91e:	39 fa                	cmp    %edi,%edx
 920:	74 1e                	je     940 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 922:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 925:	8b 50 04             	mov    0x4(%eax),%edx
 928:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 92b:	39 f1                	cmp    %esi,%ecx
 92d:	74 28                	je     957 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 92f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 931:	5b                   	pop    %ebx
  freep = p;
 932:	a3 6c 0e 00 00       	mov    %eax,0xe6c
}
 937:	5e                   	pop    %esi
 938:	5f                   	pop    %edi
 939:	5d                   	pop    %ebp
 93a:	c3                   	ret    
 93b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 93f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 940:	03 72 04             	add    0x4(%edx),%esi
 943:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 946:	8b 10                	mov    (%eax),%edx
 948:	8b 12                	mov    (%edx),%edx
 94a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 94d:	8b 50 04             	mov    0x4(%eax),%edx
 950:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 953:	39 f1                	cmp    %esi,%ecx
 955:	75 d8                	jne    92f <free+0x4f>
    p->s.size += bp->s.size;
 957:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 95a:	a3 6c 0e 00 00       	mov    %eax,0xe6c
    p->s.size += bp->s.size;
 95f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 962:	8b 53 f8             	mov    -0x8(%ebx),%edx
 965:	89 10                	mov    %edx,(%eax)
}
 967:	5b                   	pop    %ebx
 968:	5e                   	pop    %esi
 969:	5f                   	pop    %edi
 96a:	5d                   	pop    %ebp
 96b:	c3                   	ret    
 96c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000970 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 970:	f3 0f 1e fb          	endbr32 
 974:	55                   	push   %ebp
 975:	89 e5                	mov    %esp,%ebp
 977:	57                   	push   %edi
 978:	56                   	push   %esi
 979:	53                   	push   %ebx
 97a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 97d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 980:	8b 3d 6c 0e 00 00    	mov    0xe6c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 986:	8d 70 07             	lea    0x7(%eax),%esi
 989:	c1 ee 03             	shr    $0x3,%esi
 98c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 98f:	85 ff                	test   %edi,%edi
 991:	0f 84 a9 00 00 00    	je     a40 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 997:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 999:	8b 48 04             	mov    0x4(%eax),%ecx
 99c:	39 f1                	cmp    %esi,%ecx
 99e:	73 6d                	jae    a0d <malloc+0x9d>
 9a0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 9a6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9ab:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 9ae:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 9b5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 9b8:	eb 17                	jmp    9d1 <malloc+0x61>
 9ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 9c2:	8b 4a 04             	mov    0x4(%edx),%ecx
 9c5:	39 f1                	cmp    %esi,%ecx
 9c7:	73 4f                	jae    a18 <malloc+0xa8>
 9c9:	8b 3d 6c 0e 00 00    	mov    0xe6c,%edi
 9cf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d1:	39 c7                	cmp    %eax,%edi
 9d3:	75 eb                	jne    9c0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 9d5:	83 ec 0c             	sub    $0xc,%esp
 9d8:	ff 75 e4             	pushl  -0x1c(%ebp)
 9db:	e8 eb fb ff ff       	call   5cb <sbrk>
  if(p == (char*)-1)
 9e0:	83 c4 10             	add    $0x10,%esp
 9e3:	83 f8 ff             	cmp    $0xffffffff,%eax
 9e6:	74 1b                	je     a03 <malloc+0x93>
  hp->s.size = nu;
 9e8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 9eb:	83 ec 0c             	sub    $0xc,%esp
 9ee:	83 c0 08             	add    $0x8,%eax
 9f1:	50                   	push   %eax
 9f2:	e8 e9 fe ff ff       	call   8e0 <free>
  return freep;
 9f7:	a1 6c 0e 00 00       	mov    0xe6c,%eax
      if((p = morecore(nunits)) == 0)
 9fc:	83 c4 10             	add    $0x10,%esp
 9ff:	85 c0                	test   %eax,%eax
 a01:	75 bd                	jne    9c0 <malloc+0x50>
        return 0;
  }
}
 a03:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a06:	31 c0                	xor    %eax,%eax
}
 a08:	5b                   	pop    %ebx
 a09:	5e                   	pop    %esi
 a0a:	5f                   	pop    %edi
 a0b:	5d                   	pop    %ebp
 a0c:	c3                   	ret    
    if(p->s.size >= nunits){
 a0d:	89 c2                	mov    %eax,%edx
 a0f:	89 f8                	mov    %edi,%eax
 a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 a18:	39 ce                	cmp    %ecx,%esi
 a1a:	74 54                	je     a70 <malloc+0x100>
        p->s.size -= nunits;
 a1c:	29 f1                	sub    %esi,%ecx
 a1e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 a21:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 a24:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 a27:	a3 6c 0e 00 00       	mov    %eax,0xe6c
}
 a2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a2f:	8d 42 08             	lea    0x8(%edx),%eax
}
 a32:	5b                   	pop    %ebx
 a33:	5e                   	pop    %esi
 a34:	5f                   	pop    %edi
 a35:	5d                   	pop    %ebp
 a36:	c3                   	ret    
 a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a3e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 a40:	c7 05 6c 0e 00 00 70 	movl   $0xe70,0xe6c
 a47:	0e 00 00 
    base.s.size = 0;
 a4a:	bf 70 0e 00 00       	mov    $0xe70,%edi
    base.s.ptr = freep = prevp = &base;
 a4f:	c7 05 70 0e 00 00 70 	movl   $0xe70,0xe70
 a56:	0e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a59:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 a5b:	c7 05 74 0e 00 00 00 	movl   $0x0,0xe74
 a62:	00 00 00 
    if(p->s.size >= nunits){
 a65:	e9 36 ff ff ff       	jmp    9a0 <malloc+0x30>
 a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 a70:	8b 0a                	mov    (%edx),%ecx
 a72:	89 08                	mov    %ecx,(%eax)
 a74:	eb b1                	jmp    a27 <malloc+0xb7>
