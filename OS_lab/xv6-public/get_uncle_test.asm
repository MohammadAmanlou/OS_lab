
_get_uncle_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
//this is a comment
#include "types.h"
#include "stat.h"
#include "user.h"

int main(){
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 04             	sub    $0x4,%esp
	int c1, c2, c3;
	int grandchild;
	c1 = fork();
  15:	e8 91 03 00 00       	call   3ab <fork>
	if(c1 == 0){
  1a:	85 c0                	test   %eax,%eax
  1c:	75 56                	jne    74 <main+0x74>
		printf(1, "c1 forked. \n");
  1e:	50                   	push   %eax
  1f:	50                   	push   %eax
  20:	68 98 08 00 00       	push   $0x898
  25:	6a 01                	push   $0x1
  27:	e8 04 05 00 00       	call   530 <printf>
		sleep(100);
  2c:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  33:	e8 0b 04 00 00       	call   443 <sleep>
		grandchild = fork();
  38:	e8 6e 03 00 00       	call   3ab <fork>
		if(grandchild == 0){
  3d:	83 c4 10             	add    $0x10,%esp
  40:	85 c0                	test   %eax,%eax
  42:	75 4c                	jne    90 <main+0x90>
			printf(1,"grandparent forked\n");
  44:	50                   	push   %eax
  45:	50                   	push   %eax
  46:	68 a5 08 00 00       	push   $0x8a5
  4b:	6a 01                	push   $0x1
  4d:	e8 de 04 00 00       	call   530 <printf>
			int pid = getpid();
  52:	e8 dc 03 00 00       	call   433 <getpid>
			int uncles = get_uncle_count(pid);
  57:	89 04 24             	mov    %eax,(%esp)
  5a:	e8 0c 04 00 00       	call   46b <get_uncle_count>
			printf(1, "uncles of c1: %d\n", uncles);
  5f:	83 c4 0c             	add    $0xc,%esp
  62:	50                   	push   %eax
  63:	68 b9 08 00 00       	push   $0x8b9
  68:	6a 01                	push   $0x1
  6a:	e8 c1 04 00 00       	call   530 <printf>
			exit();
  6f:	e8 3f 03 00 00       	call   3b3 <exit>
		}
		wait();
		exit();
	}

	c2 = fork();
  74:	e8 32 03 00 00       	call   3ab <fork>
	if(c2 == 0){
  79:	85 c0                	test   %eax,%eax
  7b:	74 1d                	je     9a <main+0x9a>
		}
		wait();
		exit();
	}

	c3 = fork();
  7d:	e8 29 03 00 00       	call   3ab <fork>
	if(c3 == 0){
  82:	85 c0                	test   %eax,%eax
  84:	74 6a                	je     f0 <main+0xf0>
			exit();
		}
		wait();
		exit();
	}
	wait();
  86:	e8 30 03 00 00       	call   3bb <wait>
	wait();
  8b:	e8 2b 03 00 00       	call   3bb <wait>
	wait();
  90:	e8 26 03 00 00       	call   3bb <wait>
	exit();
  95:	e8 19 03 00 00       	call   3b3 <exit>
		printf(1, "c2 forked. \n");
  9a:	50                   	push   %eax
  9b:	50                   	push   %eax
  9c:	68 cb 08 00 00       	push   $0x8cb
  a1:	6a 01                	push   $0x1
  a3:	e8 88 04 00 00       	call   530 <printf>
		sleep(200);
  a8:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
  af:	e8 8f 03 00 00       	call   443 <sleep>
		grandchild = fork();
  b4:	e8 f2 02 00 00       	call   3ab <fork>
		if(grandchild == 0){
  b9:	83 c4 10             	add    $0x10,%esp
  bc:	85 c0                	test   %eax,%eax
  be:	75 d0                	jne    90 <main+0x90>
			printf(1,"grandparent forked\n");
  c0:	51                   	push   %ecx
  c1:	51                   	push   %ecx
  c2:	68 a5 08 00 00       	push   $0x8a5
  c7:	6a 01                	push   $0x1
  c9:	e8 62 04 00 00       	call   530 <printf>
			int pid = getpid();
  ce:	e8 60 03 00 00       	call   433 <getpid>
			int uncles = get_uncle_count(pid);
  d3:	89 04 24             	mov    %eax,(%esp)
  d6:	e8 90 03 00 00       	call   46b <get_uncle_count>
			printf(1, "uncles of c2: %d\n", uncles);
  db:	83 c4 0c             	add    $0xc,%esp
  de:	50                   	push   %eax
  df:	68 d8 08 00 00       	push   $0x8d8
  e4:	6a 01                	push   $0x1
  e6:	e8 45 04 00 00       	call   530 <printf>
			exit();
  eb:	e8 c3 02 00 00       	call   3b3 <exit>
		printf(1, "c3 forked. \n");
  f0:	52                   	push   %edx
  f1:	52                   	push   %edx
  f2:	68 ea 08 00 00       	push   $0x8ea
  f7:	6a 01                	push   $0x1
  f9:	e8 32 04 00 00       	call   530 <printf>
		sleep(300);
  fe:	c7 04 24 2c 01 00 00 	movl   $0x12c,(%esp)
 105:	e8 39 03 00 00       	call   443 <sleep>
		grandchild = fork();
 10a:	e8 9c 02 00 00       	call   3ab <fork>
		if(grandchild == 0){
 10f:	83 c4 10             	add    $0x10,%esp
 112:	85 c0                	test   %eax,%eax
 114:	0f 85 76 ff ff ff    	jne    90 <main+0x90>
			printf(1,"grandparent forked\n");
 11a:	50                   	push   %eax
 11b:	50                   	push   %eax
 11c:	68 a5 08 00 00       	push   $0x8a5
 121:	6a 01                	push   $0x1
 123:	e8 08 04 00 00       	call   530 <printf>
			int pid = getpid();
 128:	e8 06 03 00 00       	call   433 <getpid>
			int uncles = get_uncle_count(pid);
 12d:	89 04 24             	mov    %eax,(%esp)
 130:	e8 36 03 00 00       	call   46b <get_uncle_count>
			printf(1, "uncles of c3: %d\n", uncles);
 135:	83 c4 0c             	add    $0xc,%esp
 138:	50                   	push   %eax
 139:	68 f7 08 00 00       	push   $0x8f7
 13e:	6a 01                	push   $0x1
 140:	e8 eb 03 00 00       	call   530 <printf>
			exit();
 145:	e8 69 02 00 00       	call   3b3 <exit>
 14a:	66 90                	xchg   %ax,%ax
 14c:	66 90                	xchg   %ax,%ax
 14e:	66 90                	xchg   %ax,%ax

00000150 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 150:	f3 0f 1e fb          	endbr32 
 154:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 155:	31 c0                	xor    %eax,%eax
{
 157:	89 e5                	mov    %esp,%ebp
 159:	53                   	push   %ebx
 15a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 160:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 164:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 167:	83 c0 01             	add    $0x1,%eax
 16a:	84 d2                	test   %dl,%dl
 16c:	75 f2                	jne    160 <strcpy+0x10>
    ;
  return os;
}
 16e:	89 c8                	mov    %ecx,%eax
 170:	5b                   	pop    %ebx
 171:	5d                   	pop    %ebp
 172:	c3                   	ret    
 173:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 17a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000180 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 180:	f3 0f 1e fb          	endbr32 
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	53                   	push   %ebx
 188:	8b 4d 08             	mov    0x8(%ebp),%ecx
 18b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 18e:	0f b6 01             	movzbl (%ecx),%eax
 191:	0f b6 1a             	movzbl (%edx),%ebx
 194:	84 c0                	test   %al,%al
 196:	75 19                	jne    1b1 <strcmp+0x31>
 198:	eb 26                	jmp    1c0 <strcmp+0x40>
 19a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1a0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 1a4:	83 c1 01             	add    $0x1,%ecx
 1a7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1aa:	0f b6 1a             	movzbl (%edx),%ebx
 1ad:	84 c0                	test   %al,%al
 1af:	74 0f                	je     1c0 <strcmp+0x40>
 1b1:	38 d8                	cmp    %bl,%al
 1b3:	74 eb                	je     1a0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 1b5:	29 d8                	sub    %ebx,%eax
}
 1b7:	5b                   	pop    %ebx
 1b8:	5d                   	pop    %ebp
 1b9:	c3                   	ret    
 1ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1c0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 1c2:	29 d8                	sub    %ebx,%eax
}
 1c4:	5b                   	pop    %ebx
 1c5:	5d                   	pop    %ebp
 1c6:	c3                   	ret    
 1c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ce:	66 90                	xchg   %ax,%ax

000001d0 <strlen>:

uint
strlen(const char *s)
{
 1d0:	f3 0f 1e fb          	endbr32 
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1da:	80 3a 00             	cmpb   $0x0,(%edx)
 1dd:	74 21                	je     200 <strlen+0x30>
 1df:	31 c0                	xor    %eax,%eax
 1e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1e8:	83 c0 01             	add    $0x1,%eax
 1eb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1ef:	89 c1                	mov    %eax,%ecx
 1f1:	75 f5                	jne    1e8 <strlen+0x18>
    ;
  return n;
}
 1f3:	89 c8                	mov    %ecx,%eax
 1f5:	5d                   	pop    %ebp
 1f6:	c3                   	ret    
 1f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1fe:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 200:	31 c9                	xor    %ecx,%ecx
}
 202:	5d                   	pop    %ebp
 203:	89 c8                	mov    %ecx,%eax
 205:	c3                   	ret    
 206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20d:	8d 76 00             	lea    0x0(%esi),%esi

00000210 <memset>:

void*
memset(void *dst, int c, uint n)
{
 210:	f3 0f 1e fb          	endbr32 
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	57                   	push   %edi
 218:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 21b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 21e:	8b 45 0c             	mov    0xc(%ebp),%eax
 221:	89 d7                	mov    %edx,%edi
 223:	fc                   	cld    
 224:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 226:	89 d0                	mov    %edx,%eax
 228:	5f                   	pop    %edi
 229:	5d                   	pop    %ebp
 22a:	c3                   	ret    
 22b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 22f:	90                   	nop

00000230 <strchr>:

char*
strchr(const char *s, char c)
{
 230:	f3 0f 1e fb          	endbr32 
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 23e:	0f b6 10             	movzbl (%eax),%edx
 241:	84 d2                	test   %dl,%dl
 243:	75 16                	jne    25b <strchr+0x2b>
 245:	eb 21                	jmp    268 <strchr+0x38>
 247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24e:	66 90                	xchg   %ax,%ax
 250:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 254:	83 c0 01             	add    $0x1,%eax
 257:	84 d2                	test   %dl,%dl
 259:	74 0d                	je     268 <strchr+0x38>
    if(*s == c)
 25b:	38 d1                	cmp    %dl,%cl
 25d:	75 f1                	jne    250 <strchr+0x20>
      return (char*)s;
  return 0;
}
 25f:	5d                   	pop    %ebp
 260:	c3                   	ret    
 261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 268:	31 c0                	xor    %eax,%eax
}
 26a:	5d                   	pop    %ebp
 26b:	c3                   	ret    
 26c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000270 <gets>:

char*
gets(char *buf, int max)
{
 270:	f3 0f 1e fb          	endbr32 
 274:	55                   	push   %ebp
 275:	89 e5                	mov    %esp,%ebp
 277:	57                   	push   %edi
 278:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 279:	31 f6                	xor    %esi,%esi
{
 27b:	53                   	push   %ebx
 27c:	89 f3                	mov    %esi,%ebx
 27e:	83 ec 1c             	sub    $0x1c,%esp
 281:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 284:	eb 33                	jmp    2b9 <gets+0x49>
 286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 290:	83 ec 04             	sub    $0x4,%esp
 293:	8d 45 e7             	lea    -0x19(%ebp),%eax
 296:	6a 01                	push   $0x1
 298:	50                   	push   %eax
 299:	6a 00                	push   $0x0
 29b:	e8 2b 01 00 00       	call   3cb <read>
    if(cc < 1)
 2a0:	83 c4 10             	add    $0x10,%esp
 2a3:	85 c0                	test   %eax,%eax
 2a5:	7e 1c                	jle    2c3 <gets+0x53>
      break;
    buf[i++] = c;
 2a7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2ab:	83 c7 01             	add    $0x1,%edi
 2ae:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 2b1:	3c 0a                	cmp    $0xa,%al
 2b3:	74 23                	je     2d8 <gets+0x68>
 2b5:	3c 0d                	cmp    $0xd,%al
 2b7:	74 1f                	je     2d8 <gets+0x68>
  for(i=0; i+1 < max; ){
 2b9:	83 c3 01             	add    $0x1,%ebx
 2bc:	89 fe                	mov    %edi,%esi
 2be:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2c1:	7c cd                	jl     290 <gets+0x20>
 2c3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 2c8:	c6 03 00             	movb   $0x0,(%ebx)
}
 2cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2ce:	5b                   	pop    %ebx
 2cf:	5e                   	pop    %esi
 2d0:	5f                   	pop    %edi
 2d1:	5d                   	pop    %ebp
 2d2:	c3                   	ret    
 2d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2d7:	90                   	nop
 2d8:	8b 75 08             	mov    0x8(%ebp),%esi
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
 2de:	01 de                	add    %ebx,%esi
 2e0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 2e2:	c6 03 00             	movb   $0x0,(%ebx)
}
 2e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2e8:	5b                   	pop    %ebx
 2e9:	5e                   	pop    %esi
 2ea:	5f                   	pop    %edi
 2eb:	5d                   	pop    %ebp
 2ec:	c3                   	ret    
 2ed:	8d 76 00             	lea    0x0(%esi),%esi

000002f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2f0:	f3 0f 1e fb          	endbr32 
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	56                   	push   %esi
 2f8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f9:	83 ec 08             	sub    $0x8,%esp
 2fc:	6a 00                	push   $0x0
 2fe:	ff 75 08             	pushl  0x8(%ebp)
 301:	e8 ed 00 00 00       	call   3f3 <open>
  if(fd < 0)
 306:	83 c4 10             	add    $0x10,%esp
 309:	85 c0                	test   %eax,%eax
 30b:	78 2b                	js     338 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 30d:	83 ec 08             	sub    $0x8,%esp
 310:	ff 75 0c             	pushl  0xc(%ebp)
 313:	89 c3                	mov    %eax,%ebx
 315:	50                   	push   %eax
 316:	e8 f0 00 00 00       	call   40b <fstat>
  close(fd);
 31b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 31e:	89 c6                	mov    %eax,%esi
  close(fd);
 320:	e8 b6 00 00 00       	call   3db <close>
  return r;
 325:	83 c4 10             	add    $0x10,%esp
}
 328:	8d 65 f8             	lea    -0x8(%ebp),%esp
 32b:	89 f0                	mov    %esi,%eax
 32d:	5b                   	pop    %ebx
 32e:	5e                   	pop    %esi
 32f:	5d                   	pop    %ebp
 330:	c3                   	ret    
 331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 338:	be ff ff ff ff       	mov    $0xffffffff,%esi
 33d:	eb e9                	jmp    328 <stat+0x38>
 33f:	90                   	nop

00000340 <atoi>:

int
atoi(const char *s)
{
 340:	f3 0f 1e fb          	endbr32 
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	53                   	push   %ebx
 348:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 34b:	0f be 02             	movsbl (%edx),%eax
 34e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 351:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 354:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 359:	77 1a                	ja     375 <atoi+0x35>
 35b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 35f:	90                   	nop
    n = n*10 + *s++ - '0';
 360:	83 c2 01             	add    $0x1,%edx
 363:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 366:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 36a:	0f be 02             	movsbl (%edx),%eax
 36d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 370:	80 fb 09             	cmp    $0x9,%bl
 373:	76 eb                	jbe    360 <atoi+0x20>
  return n;
}
 375:	89 c8                	mov    %ecx,%eax
 377:	5b                   	pop    %ebx
 378:	5d                   	pop    %ebp
 379:	c3                   	ret    
 37a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000380 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 380:	f3 0f 1e fb          	endbr32 
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	57                   	push   %edi
 388:	8b 45 10             	mov    0x10(%ebp),%eax
 38b:	8b 55 08             	mov    0x8(%ebp),%edx
 38e:	56                   	push   %esi
 38f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 392:	85 c0                	test   %eax,%eax
 394:	7e 0f                	jle    3a5 <memmove+0x25>
 396:	01 d0                	add    %edx,%eax
  dst = vdst;
 398:	89 d7                	mov    %edx,%edi
 39a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 3a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3a1:	39 f8                	cmp    %edi,%eax
 3a3:	75 fb                	jne    3a0 <memmove+0x20>
  return vdst;
}
 3a5:	5e                   	pop    %esi
 3a6:	89 d0                	mov    %edx,%eax
 3a8:	5f                   	pop    %edi
 3a9:	5d                   	pop    %ebp
 3aa:	c3                   	ret    

000003ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ab:	b8 01 00 00 00       	mov    $0x1,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <exit>:
SYSCALL(exit)
 3b3:	b8 02 00 00 00       	mov    $0x2,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <wait>:
SYSCALL(wait)
 3bb:	b8 03 00 00 00       	mov    $0x3,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <pipe>:
SYSCALL(pipe)
 3c3:	b8 04 00 00 00       	mov    $0x4,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <read>:
SYSCALL(read)
 3cb:	b8 05 00 00 00       	mov    $0x5,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <write>:
SYSCALL(write)
 3d3:	b8 10 00 00 00       	mov    $0x10,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <close>:
SYSCALL(close)
 3db:	b8 15 00 00 00       	mov    $0x15,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <kill>:
SYSCALL(kill)
 3e3:	b8 06 00 00 00       	mov    $0x6,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <exec>:
SYSCALL(exec)
 3eb:	b8 07 00 00 00       	mov    $0x7,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <open>:
SYSCALL(open)
 3f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <mknod>:
SYSCALL(mknod)
 3fb:	b8 11 00 00 00       	mov    $0x11,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <unlink>:
SYSCALL(unlink)
 403:	b8 12 00 00 00       	mov    $0x12,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <fstat>:
SYSCALL(fstat)
 40b:	b8 08 00 00 00       	mov    $0x8,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <link>:
SYSCALL(link)
 413:	b8 13 00 00 00       	mov    $0x13,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <mkdir>:
SYSCALL(mkdir)
 41b:	b8 14 00 00 00       	mov    $0x14,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <chdir>:
SYSCALL(chdir)
 423:	b8 09 00 00 00       	mov    $0x9,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <dup>:
SYSCALL(dup)
 42b:	b8 0a 00 00 00       	mov    $0xa,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <getpid>:
SYSCALL(getpid)
 433:	b8 0b 00 00 00       	mov    $0xb,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <sbrk>:
SYSCALL(sbrk)
 43b:	b8 0c 00 00 00       	mov    $0xc,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <sleep>:
SYSCALL(sleep)
 443:	b8 0d 00 00 00       	mov    $0xd,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <uptime>:
SYSCALL(uptime)
 44b:	b8 0e 00 00 00       	mov    $0xe,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <find_digital_root>:
SYSCALL(find_digital_root)
 453:	b8 16 00 00 00       	mov    $0x16,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <get_process_lifetime>:
SYSCALL(get_process_lifetime)
 45b:	b8 17 00 00 00       	mov    $0x17,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <copy_file>:
SYSCALL(copy_file)
 463:	b8 18 00 00 00       	mov    $0x18,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <get_uncle_count>:
SYSCALL(get_uncle_count)
 46b:	b8 19 00 00 00       	mov    $0x19,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    
 473:	66 90                	xchg   %ax,%ax
 475:	66 90                	xchg   %ax,%ax
 477:	66 90                	xchg   %ax,%ax
 479:	66 90                	xchg   %ax,%ax
 47b:	66 90                	xchg   %ax,%ax
 47d:	66 90                	xchg   %ax,%ax
 47f:	90                   	nop

00000480 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	56                   	push   %esi
 485:	53                   	push   %ebx
 486:	83 ec 3c             	sub    $0x3c,%esp
 489:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 48c:	89 d1                	mov    %edx,%ecx
{
 48e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 491:	85 d2                	test   %edx,%edx
 493:	0f 89 7f 00 00 00    	jns    518 <printint+0x98>
 499:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 49d:	74 79                	je     518 <printint+0x98>
    neg = 1;
 49f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 4a6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 4a8:	31 db                	xor    %ebx,%ebx
 4aa:	8d 75 d7             	lea    -0x29(%ebp),%esi
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 4b0:	89 c8                	mov    %ecx,%eax
 4b2:	31 d2                	xor    %edx,%edx
 4b4:	89 cf                	mov    %ecx,%edi
 4b6:	f7 75 c4             	divl   -0x3c(%ebp)
 4b9:	0f b6 92 10 09 00 00 	movzbl 0x910(%edx),%edx
 4c0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 4c3:	89 d8                	mov    %ebx,%eax
 4c5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 4c8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 4cb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 4ce:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 4d1:	76 dd                	jbe    4b0 <printint+0x30>
  if(neg)
 4d3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 4d6:	85 c9                	test   %ecx,%ecx
 4d8:	74 0c                	je     4e6 <printint+0x66>
    buf[i++] = '-';
 4da:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 4df:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 4e1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 4e6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 4e9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 4ed:	eb 07                	jmp    4f6 <printint+0x76>
 4ef:	90                   	nop
 4f0:	0f b6 13             	movzbl (%ebx),%edx
 4f3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 4f6:	83 ec 04             	sub    $0x4,%esp
 4f9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 4fc:	6a 01                	push   $0x1
 4fe:	56                   	push   %esi
 4ff:	57                   	push   %edi
 500:	e8 ce fe ff ff       	call   3d3 <write>
  while(--i >= 0)
 505:	83 c4 10             	add    $0x10,%esp
 508:	39 de                	cmp    %ebx,%esi
 50a:	75 e4                	jne    4f0 <printint+0x70>
    putc(fd, buf[i]);
}
 50c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 50f:	5b                   	pop    %ebx
 510:	5e                   	pop    %esi
 511:	5f                   	pop    %edi
 512:	5d                   	pop    %ebp
 513:	c3                   	ret    
 514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 518:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 51f:	eb 87                	jmp    4a8 <printint+0x28>
 521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52f:	90                   	nop

00000530 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 530:	f3 0f 1e fb          	endbr32 
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	57                   	push   %edi
 538:	56                   	push   %esi
 539:	53                   	push   %ebx
 53a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 53d:	8b 75 0c             	mov    0xc(%ebp),%esi
 540:	0f b6 1e             	movzbl (%esi),%ebx
 543:	84 db                	test   %bl,%bl
 545:	0f 84 b4 00 00 00    	je     5ff <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 54b:	8d 45 10             	lea    0x10(%ebp),%eax
 54e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 551:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 554:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 556:	89 45 d0             	mov    %eax,-0x30(%ebp)
 559:	eb 33                	jmp    58e <printf+0x5e>
 55b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 55f:	90                   	nop
 560:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 563:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 568:	83 f8 25             	cmp    $0x25,%eax
 56b:	74 17                	je     584 <printf+0x54>
  write(fd, &c, 1);
 56d:	83 ec 04             	sub    $0x4,%esp
 570:	88 5d e7             	mov    %bl,-0x19(%ebp)
 573:	6a 01                	push   $0x1
 575:	57                   	push   %edi
 576:	ff 75 08             	pushl  0x8(%ebp)
 579:	e8 55 fe ff ff       	call   3d3 <write>
 57e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 581:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 584:	0f b6 1e             	movzbl (%esi),%ebx
 587:	83 c6 01             	add    $0x1,%esi
 58a:	84 db                	test   %bl,%bl
 58c:	74 71                	je     5ff <printf+0xcf>
    c = fmt[i] & 0xff;
 58e:	0f be cb             	movsbl %bl,%ecx
 591:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 594:	85 d2                	test   %edx,%edx
 596:	74 c8                	je     560 <printf+0x30>
      }
    } else if(state == '%'){
 598:	83 fa 25             	cmp    $0x25,%edx
 59b:	75 e7                	jne    584 <printf+0x54>
      if(c == 'd'){
 59d:	83 f8 64             	cmp    $0x64,%eax
 5a0:	0f 84 9a 00 00 00    	je     640 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5a6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 5ac:	83 f9 70             	cmp    $0x70,%ecx
 5af:	74 5f                	je     610 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5b1:	83 f8 73             	cmp    $0x73,%eax
 5b4:	0f 84 d6 00 00 00    	je     690 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ba:	83 f8 63             	cmp    $0x63,%eax
 5bd:	0f 84 8d 00 00 00    	je     650 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5c3:	83 f8 25             	cmp    $0x25,%eax
 5c6:	0f 84 b4 00 00 00    	je     680 <printf+0x150>
  write(fd, &c, 1);
 5cc:	83 ec 04             	sub    $0x4,%esp
 5cf:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5d3:	6a 01                	push   $0x1
 5d5:	57                   	push   %edi
 5d6:	ff 75 08             	pushl  0x8(%ebp)
 5d9:	e8 f5 fd ff ff       	call   3d3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 5de:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5e1:	83 c4 0c             	add    $0xc,%esp
 5e4:	6a 01                	push   $0x1
 5e6:	83 c6 01             	add    $0x1,%esi
 5e9:	57                   	push   %edi
 5ea:	ff 75 08             	pushl  0x8(%ebp)
 5ed:	e8 e1 fd ff ff       	call   3d3 <write>
  for(i = 0; fmt[i]; i++){
 5f2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 5f6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5f9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 5fb:	84 db                	test   %bl,%bl
 5fd:	75 8f                	jne    58e <printf+0x5e>
    }
  }
}
 5ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
 602:	5b                   	pop    %ebx
 603:	5e                   	pop    %esi
 604:	5f                   	pop    %edi
 605:	5d                   	pop    %ebp
 606:	c3                   	ret    
 607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 610:	83 ec 0c             	sub    $0xc,%esp
 613:	b9 10 00 00 00       	mov    $0x10,%ecx
 618:	6a 00                	push   $0x0
 61a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 61d:	8b 45 08             	mov    0x8(%ebp),%eax
 620:	8b 13                	mov    (%ebx),%edx
 622:	e8 59 fe ff ff       	call   480 <printint>
        ap++;
 627:	89 d8                	mov    %ebx,%eax
 629:	83 c4 10             	add    $0x10,%esp
      state = 0;
 62c:	31 d2                	xor    %edx,%edx
        ap++;
 62e:	83 c0 04             	add    $0x4,%eax
 631:	89 45 d0             	mov    %eax,-0x30(%ebp)
 634:	e9 4b ff ff ff       	jmp    584 <printf+0x54>
 639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 640:	83 ec 0c             	sub    $0xc,%esp
 643:	b9 0a 00 00 00       	mov    $0xa,%ecx
 648:	6a 01                	push   $0x1
 64a:	eb ce                	jmp    61a <printf+0xea>
 64c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 650:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 653:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 656:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 658:	6a 01                	push   $0x1
        ap++;
 65a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 65d:	57                   	push   %edi
 65e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 661:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 664:	e8 6a fd ff ff       	call   3d3 <write>
        ap++;
 669:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 66c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 66f:	31 d2                	xor    %edx,%edx
 671:	e9 0e ff ff ff       	jmp    584 <printf+0x54>
 676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 67d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 680:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 683:	83 ec 04             	sub    $0x4,%esp
 686:	e9 59 ff ff ff       	jmp    5e4 <printf+0xb4>
 68b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 68f:	90                   	nop
        s = (char*)*ap;
 690:	8b 45 d0             	mov    -0x30(%ebp),%eax
 693:	8b 18                	mov    (%eax),%ebx
        ap++;
 695:	83 c0 04             	add    $0x4,%eax
 698:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 69b:	85 db                	test   %ebx,%ebx
 69d:	74 17                	je     6b6 <printf+0x186>
        while(*s != 0){
 69f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 6a2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 6a4:	84 c0                	test   %al,%al
 6a6:	0f 84 d8 fe ff ff    	je     584 <printf+0x54>
 6ac:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6af:	89 de                	mov    %ebx,%esi
 6b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6b4:	eb 1a                	jmp    6d0 <printf+0x1a0>
          s = "(null)";
 6b6:	bb 09 09 00 00       	mov    $0x909,%ebx
        while(*s != 0){
 6bb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6be:	b8 28 00 00 00       	mov    $0x28,%eax
 6c3:	89 de                	mov    %ebx,%esi
 6c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6cf:	90                   	nop
  write(fd, &c, 1);
 6d0:	83 ec 04             	sub    $0x4,%esp
          s++;
 6d3:	83 c6 01             	add    $0x1,%esi
 6d6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6d9:	6a 01                	push   $0x1
 6db:	57                   	push   %edi
 6dc:	53                   	push   %ebx
 6dd:	e8 f1 fc ff ff       	call   3d3 <write>
        while(*s != 0){
 6e2:	0f b6 06             	movzbl (%esi),%eax
 6e5:	83 c4 10             	add    $0x10,%esp
 6e8:	84 c0                	test   %al,%al
 6ea:	75 e4                	jne    6d0 <printf+0x1a0>
 6ec:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 6ef:	31 d2                	xor    %edx,%edx
 6f1:	e9 8e fe ff ff       	jmp    584 <printf+0x54>
 6f6:	66 90                	xchg   %ax,%ax
 6f8:	66 90                	xchg   %ax,%ax
 6fa:	66 90                	xchg   %ax,%ax
 6fc:	66 90                	xchg   %ax,%ax
 6fe:	66 90                	xchg   %ax,%ax

00000700 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 700:	f3 0f 1e fb          	endbr32 
 704:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 705:	a1 b8 0b 00 00       	mov    0xbb8,%eax
{
 70a:	89 e5                	mov    %esp,%ebp
 70c:	57                   	push   %edi
 70d:	56                   	push   %esi
 70e:	53                   	push   %ebx
 70f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 712:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 714:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 717:	39 c8                	cmp    %ecx,%eax
 719:	73 15                	jae    730 <free+0x30>
 71b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 71f:	90                   	nop
 720:	39 d1                	cmp    %edx,%ecx
 722:	72 14                	jb     738 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 724:	39 d0                	cmp    %edx,%eax
 726:	73 10                	jae    738 <free+0x38>
{
 728:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72a:	8b 10                	mov    (%eax),%edx
 72c:	39 c8                	cmp    %ecx,%eax
 72e:	72 f0                	jb     720 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 730:	39 d0                	cmp    %edx,%eax
 732:	72 f4                	jb     728 <free+0x28>
 734:	39 d1                	cmp    %edx,%ecx
 736:	73 f0                	jae    728 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 738:	8b 73 fc             	mov    -0x4(%ebx),%esi
 73b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 73e:	39 fa                	cmp    %edi,%edx
 740:	74 1e                	je     760 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 742:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 745:	8b 50 04             	mov    0x4(%eax),%edx
 748:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 74b:	39 f1                	cmp    %esi,%ecx
 74d:	74 28                	je     777 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 74f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 751:	5b                   	pop    %ebx
  freep = p;
 752:	a3 b8 0b 00 00       	mov    %eax,0xbb8
}
 757:	5e                   	pop    %esi
 758:	5f                   	pop    %edi
 759:	5d                   	pop    %ebp
 75a:	c3                   	ret    
 75b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 75f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 760:	03 72 04             	add    0x4(%edx),%esi
 763:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 766:	8b 10                	mov    (%eax),%edx
 768:	8b 12                	mov    (%edx),%edx
 76a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 76d:	8b 50 04             	mov    0x4(%eax),%edx
 770:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 773:	39 f1                	cmp    %esi,%ecx
 775:	75 d8                	jne    74f <free+0x4f>
    p->s.size += bp->s.size;
 777:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 77a:	a3 b8 0b 00 00       	mov    %eax,0xbb8
    p->s.size += bp->s.size;
 77f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 782:	8b 53 f8             	mov    -0x8(%ebx),%edx
 785:	89 10                	mov    %edx,(%eax)
}
 787:	5b                   	pop    %ebx
 788:	5e                   	pop    %esi
 789:	5f                   	pop    %edi
 78a:	5d                   	pop    %ebp
 78b:	c3                   	ret    
 78c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000790 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 790:	f3 0f 1e fb          	endbr32 
 794:	55                   	push   %ebp
 795:	89 e5                	mov    %esp,%ebp
 797:	57                   	push   %edi
 798:	56                   	push   %esi
 799:	53                   	push   %ebx
 79a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 79d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7a0:	8b 3d b8 0b 00 00    	mov    0xbb8,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a6:	8d 70 07             	lea    0x7(%eax),%esi
 7a9:	c1 ee 03             	shr    $0x3,%esi
 7ac:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 7af:	85 ff                	test   %edi,%edi
 7b1:	0f 84 a9 00 00 00    	je     860 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 7b9:	8b 48 04             	mov    0x4(%eax),%ecx
 7bc:	39 f1                	cmp    %esi,%ecx
 7be:	73 6d                	jae    82d <malloc+0x9d>
 7c0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 7c6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7cb:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 7ce:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 7d5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 7d8:	eb 17                	jmp    7f1 <malloc+0x61>
 7da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 7e2:	8b 4a 04             	mov    0x4(%edx),%ecx
 7e5:	39 f1                	cmp    %esi,%ecx
 7e7:	73 4f                	jae    838 <malloc+0xa8>
 7e9:	8b 3d b8 0b 00 00    	mov    0xbb8,%edi
 7ef:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f1:	39 c7                	cmp    %eax,%edi
 7f3:	75 eb                	jne    7e0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 7f5:	83 ec 0c             	sub    $0xc,%esp
 7f8:	ff 75 e4             	pushl  -0x1c(%ebp)
 7fb:	e8 3b fc ff ff       	call   43b <sbrk>
  if(p == (char*)-1)
 800:	83 c4 10             	add    $0x10,%esp
 803:	83 f8 ff             	cmp    $0xffffffff,%eax
 806:	74 1b                	je     823 <malloc+0x93>
  hp->s.size = nu;
 808:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 80b:	83 ec 0c             	sub    $0xc,%esp
 80e:	83 c0 08             	add    $0x8,%eax
 811:	50                   	push   %eax
 812:	e8 e9 fe ff ff       	call   700 <free>
  return freep;
 817:	a1 b8 0b 00 00       	mov    0xbb8,%eax
      if((p = morecore(nunits)) == 0)
 81c:	83 c4 10             	add    $0x10,%esp
 81f:	85 c0                	test   %eax,%eax
 821:	75 bd                	jne    7e0 <malloc+0x50>
        return 0;
  }
}
 823:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 826:	31 c0                	xor    %eax,%eax
}
 828:	5b                   	pop    %ebx
 829:	5e                   	pop    %esi
 82a:	5f                   	pop    %edi
 82b:	5d                   	pop    %ebp
 82c:	c3                   	ret    
    if(p->s.size >= nunits){
 82d:	89 c2                	mov    %eax,%edx
 82f:	89 f8                	mov    %edi,%eax
 831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 838:	39 ce                	cmp    %ecx,%esi
 83a:	74 54                	je     890 <malloc+0x100>
        p->s.size -= nunits;
 83c:	29 f1                	sub    %esi,%ecx
 83e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 841:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 844:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 847:	a3 b8 0b 00 00       	mov    %eax,0xbb8
}
 84c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 84f:	8d 42 08             	lea    0x8(%edx),%eax
}
 852:	5b                   	pop    %ebx
 853:	5e                   	pop    %esi
 854:	5f                   	pop    %edi
 855:	5d                   	pop    %ebp
 856:	c3                   	ret    
 857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 85e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 860:	c7 05 b8 0b 00 00 bc 	movl   $0xbbc,0xbb8
 867:	0b 00 00 
    base.s.size = 0;
 86a:	bf bc 0b 00 00       	mov    $0xbbc,%edi
    base.s.ptr = freep = prevp = &base;
 86f:	c7 05 bc 0b 00 00 bc 	movl   $0xbbc,0xbbc
 876:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 879:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 87b:	c7 05 c0 0b 00 00 00 	movl   $0x0,0xbc0
 882:	00 00 00 
    if(p->s.size >= nunits){
 885:	e9 36 ff ff ff       	jmp    7c0 <malloc+0x30>
 88a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 890:	8b 0a                	mov    (%edx),%ecx
 892:	89 08                	mov    %ecx,(%eax)
 894:	eb b1                	jmp    847 <malloc+0xb7>
