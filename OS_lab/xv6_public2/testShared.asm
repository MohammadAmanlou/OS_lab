
_testShared:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    wait();
  }
  printf(1, "Final value in shared memory: %d\n", *(int *)addr);
}

int main(void) {
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 e4 f0             	and    $0xfffffff0,%esp
  // test_open_sharedmem();
  // test_close_sharedmem();
  test_sharedmem_increment();
   a:	e8 11 01 00 00       	call   120 <test_sharedmem_increment>
  exit();
   f:	e8 1f 04 00 00       	call   433 <exit>
  14:	66 90                	xchg   %ax,%ax
  16:	66 90                	xchg   %ax,%ax
  18:	66 90                	xchg   %ax,%ax
  1a:	66 90                	xchg   %ax,%ax
  1c:	66 90                	xchg   %ax,%ax
  1e:	66 90                	xchg   %ax,%ax

00000020 <acuire_user>:
void acuire_user() {
  20:	f3 0f 1e fb          	endbr32 
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while ((open("lockfile", O_CREATE  | O_WRONLY)) < 0) ;
  30:	83 ec 08             	sub    $0x8,%esp
  33:	68 01 02 00 00       	push   $0x201
  38:	68 68 09 00 00       	push   $0x968
  3d:	e8 31 04 00 00       	call   473 <open>
  42:	83 c4 10             	add    $0x10,%esp
  45:	85 c0                	test   %eax,%eax
  47:	78 e7                	js     30 <acuire_user+0x10>
}
  49:	c9                   	leave  
  4a:	c3                   	ret    
  4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  4f:	90                   	nop

00000050 <release_user>:
void release_user() {
  50:	f3 0f 1e fb          	endbr32 
  54:	55                   	push   %ebp
  55:	89 e5                	mov    %esp,%ebp
  57:	83 ec 14             	sub    $0x14,%esp
    unlink("lockfile");
  5a:	68 68 09 00 00       	push   $0x968
  5f:	e8 1f 04 00 00       	call   483 <unlink>
}
  64:	83 c4 10             	add    $0x10,%esp
  67:	c9                   	leave  
  68:	c3                   	ret    
  69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000070 <test_open_sharedmem>:
void test_open_sharedmem() {
  70:	f3 0f 1e fb          	endbr32 
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	83 ec 10             	sub    $0x10,%esp
  void *addr = (void *)shmat(shmid , 1); 
  7a:	6a 01                	push   $0x1
  7c:	6a 00                	push   $0x0
  7e:	e8 a8 04 00 00       	call   52b <shmat>
  if (addr == (void *)-1) {
  83:	83 c4 10             	add    $0x10,%esp
  86:	83 f8 ff             	cmp    $0xffffffff,%eax
  89:	74 15                	je     a0 <test_open_sharedmem+0x30>
  printf(1, "Shared memory region with shmid %d attached at address %p\n", shmid, addr);
  8b:	50                   	push   %eax
  8c:	6a 00                	push   $0x0
  8e:	68 b0 09 00 00       	push   $0x9b0
  93:	6a 01                	push   $0x1
  95:	e8 66 05 00 00       	call   600 <printf>
  9a:	83 c4 10             	add    $0x10,%esp
}
  9d:	c9                   	leave  
  9e:	c3                   	ret    
  9f:	90                   	nop
    printf(1, "open_sharedmem failed\n");
  a0:	83 ec 08             	sub    $0x8,%esp
  a3:	68 71 09 00 00       	push   $0x971
  a8:	6a 01                	push   $0x1
  aa:	e8 51 05 00 00       	call   600 <printf>
    return;
  af:	83 c4 10             	add    $0x10,%esp
}
  b2:	c9                   	leave  
  b3:	c3                   	ret    
  b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bf:	90                   	nop

000000c0 <test_close_sharedmem>:
void test_close_sharedmem() {
  c0:	f3 0f 1e fb          	endbr32 
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	83 ec 10             	sub    $0x10,%esp
  void *addr = (void *)shmat(shmid , 1 ); 
  ca:	6a 01                	push   $0x1
  cc:	6a 00                	push   $0x0
  ce:	e8 58 04 00 00       	call   52b <shmat>
  if (shmdt(addr) == -1) { 
  d3:	89 04 24             	mov    %eax,(%esp)
  d6:	e8 58 04 00 00       	call   533 <shmdt>
  db:	83 c4 10             	add    $0x10,%esp
  de:	83 f8 ff             	cmp    $0xffffffff,%eax
  e1:	74 1d                	je     100 <test_close_sharedmem+0x40>
  printf(1, "Shared memory region detached\n");
  e3:	83 ec 08             	sub    $0x8,%esp
  e6:	68 ec 09 00 00       	push   $0x9ec
  eb:	6a 01                	push   $0x1
  ed:	e8 0e 05 00 00       	call   600 <printf>
  f2:	83 c4 10             	add    $0x10,%esp
}
  f5:	c9                   	leave  
  f6:	c3                   	ret    
  f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fe:	66 90                	xchg   %ax,%ax
    printf(1, "close_sharedmem failed\n");
 100:	83 ec 08             	sub    $0x8,%esp
 103:	68 88 09 00 00       	push   $0x988
 108:	6a 01                	push   $0x1
 10a:	e8 f1 04 00 00       	call   600 <printf>
    return;
 10f:	83 c4 10             	add    $0x10,%esp
}
 112:	c9                   	leave  
 113:	c3                   	ret    
 114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 11f:	90                   	nop

00000120 <test_sharedmem_increment>:
void test_sharedmem_increment() {
 120:	f3 0f 1e fb          	endbr32 
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	56                   	push   %esi
 128:	53                   	push   %ebx
  void *addr = (void *)shmat(shmid , 1); 
 129:	bb 0a 00 00 00       	mov    $0xa,%ebx
 12e:	83 ec 08             	sub    $0x8,%esp
 131:	6a 01                	push   $0x1
 133:	6a 00                	push   $0x0
 135:	e8 f1 03 00 00       	call   52b <shmat>
 13a:	83 c4 10             	add    $0x10,%esp
 13d:	89 c6                	mov    %eax,%esi
  for (int i = 0; i < NCHILD; i++) {
 13f:	90                   	nop
    int pid = fork();
 140:	e8 e6 02 00 00       	call   42b <fork>
    if (pid < 0) {
 145:	85 c0                	test   %eax,%eax
 147:	78 37                	js     180 <test_sharedmem_increment+0x60>
    } else if (pid == 0) {
 149:	74 4e                	je     199 <test_sharedmem_increment+0x79>
  for (int i = 0; i < NCHILD; i++) {
 14b:	83 eb 01             	sub    $0x1,%ebx
 14e:	75 f0                	jne    140 <test_sharedmem_increment+0x20>
 150:	bb 0a 00 00 00       	mov    $0xa,%ebx
 155:	8d 76 00             	lea    0x0(%esi),%esi
    wait();
 158:	e8 de 02 00 00       	call   43b <wait>
  for (int i = 0; i < NCHILD; i++) {
 15d:	83 eb 01             	sub    $0x1,%ebx
 160:	75 f6                	jne    158 <test_sharedmem_increment+0x38>
  printf(1, "Final value in shared memory: %d\n", *(int *)addr);
 162:	83 ec 04             	sub    $0x4,%esp
 165:	ff 36                	pushl  (%esi)
 167:	68 0c 0a 00 00       	push   $0xa0c
 16c:	6a 01                	push   $0x1
 16e:	e8 8d 04 00 00       	call   600 <printf>
 173:	83 c4 10             	add    $0x10,%esp
}
 176:	8d 65 f8             	lea    -0x8(%ebp),%esp
 179:	5b                   	pop    %ebx
 17a:	5e                   	pop    %esi
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    
 17d:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "fork failed\n");
 180:	83 ec 08             	sub    $0x8,%esp
 183:	68 a0 09 00 00       	push   $0x9a0
 188:	6a 01                	push   $0x1
 18a:	e8 71 04 00 00       	call   600 <printf>
 18f:	83 c4 10             	add    $0x10,%esp
}
 192:	8d 65 f8             	lea    -0x8(%ebp),%esp
 195:	5b                   	pop    %ebx
 196:	5e                   	pop    %esi
 197:	5d                   	pop    %ebp
 198:	c3                   	ret    
    while ((open("lockfile", O_CREATE  | O_WRONLY)) < 0) ;
 199:	83 ec 08             	sub    $0x8,%esp
 19c:	68 01 02 00 00       	push   $0x201
 1a1:	68 68 09 00 00       	push   $0x968
 1a6:	e8 c8 02 00 00       	call   473 <open>
 1ab:	83 c4 10             	add    $0x10,%esp
 1ae:	85 c0                	test   %eax,%eax
 1b0:	78 e7                	js     199 <test_sharedmem_increment+0x79>
    unlink("lockfile");
 1b2:	83 ec 0c             	sub    $0xc,%esp
      (*(int *)addr)++;
 1b5:	83 06 01             	addl   $0x1,(%esi)
    unlink("lockfile");
 1b8:	68 68 09 00 00       	push   $0x968
 1bd:	e8 c1 02 00 00       	call   483 <unlink>
      exit();
 1c2:	e8 6c 02 00 00       	call   433 <exit>
 1c7:	66 90                	xchg   %ax,%ax
 1c9:	66 90                	xchg   %ax,%ax
 1cb:	66 90                	xchg   %ax,%ax
 1cd:	66 90                	xchg   %ax,%ax
 1cf:	90                   	nop

000001d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1d0:	f3 0f 1e fb          	endbr32 
 1d4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1d5:	31 c0                	xor    %eax,%eax
{
 1d7:	89 e5                	mov    %esp,%ebp
 1d9:	53                   	push   %ebx
 1da:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 1e0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1e4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1e7:	83 c0 01             	add    $0x1,%eax
 1ea:	84 d2                	test   %dl,%dl
 1ec:	75 f2                	jne    1e0 <strcpy+0x10>
    ;
  return os;
}
 1ee:	89 c8                	mov    %ecx,%eax
 1f0:	5b                   	pop    %ebx
 1f1:	5d                   	pop    %ebp
 1f2:	c3                   	ret    
 1f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000200 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 200:	f3 0f 1e fb          	endbr32 
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	53                   	push   %ebx
 208:	8b 4d 08             	mov    0x8(%ebp),%ecx
 20b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 20e:	0f b6 01             	movzbl (%ecx),%eax
 211:	0f b6 1a             	movzbl (%edx),%ebx
 214:	84 c0                	test   %al,%al
 216:	75 19                	jne    231 <strcmp+0x31>
 218:	eb 26                	jmp    240 <strcmp+0x40>
 21a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 220:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 224:	83 c1 01             	add    $0x1,%ecx
 227:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 22a:	0f b6 1a             	movzbl (%edx),%ebx
 22d:	84 c0                	test   %al,%al
 22f:	74 0f                	je     240 <strcmp+0x40>
 231:	38 d8                	cmp    %bl,%al
 233:	74 eb                	je     220 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 235:	29 d8                	sub    %ebx,%eax
}
 237:	5b                   	pop    %ebx
 238:	5d                   	pop    %ebp
 239:	c3                   	ret    
 23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 240:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 242:	29 d8                	sub    %ebx,%eax
}
 244:	5b                   	pop    %ebx
 245:	5d                   	pop    %ebp
 246:	c3                   	ret    
 247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24e:	66 90                	xchg   %ax,%ax

00000250 <strlen>:

uint
strlen(const char *s)
{
 250:	f3 0f 1e fb          	endbr32 
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 25a:	80 3a 00             	cmpb   $0x0,(%edx)
 25d:	74 21                	je     280 <strlen+0x30>
 25f:	31 c0                	xor    %eax,%eax
 261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 268:	83 c0 01             	add    $0x1,%eax
 26b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 26f:	89 c1                	mov    %eax,%ecx
 271:	75 f5                	jne    268 <strlen+0x18>
    ;
  return n;
}
 273:	89 c8                	mov    %ecx,%eax
 275:	5d                   	pop    %ebp
 276:	c3                   	ret    
 277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 280:	31 c9                	xor    %ecx,%ecx
}
 282:	5d                   	pop    %ebp
 283:	89 c8                	mov    %ecx,%eax
 285:	c3                   	ret    
 286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28d:	8d 76 00             	lea    0x0(%esi),%esi

00000290 <memset>:

void*
memset(void *dst, int c, uint n)
{
 290:	f3 0f 1e fb          	endbr32 
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	57                   	push   %edi
 298:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 29b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 29e:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a1:	89 d7                	mov    %edx,%edi
 2a3:	fc                   	cld    
 2a4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2a6:	89 d0                	mov    %edx,%eax
 2a8:	5f                   	pop    %edi
 2a9:	5d                   	pop    %ebp
 2aa:	c3                   	ret    
 2ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2af:	90                   	nop

000002b0 <strchr>:

char*
strchr(const char *s, char c)
{
 2b0:	f3 0f 1e fb          	endbr32 
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2be:	0f b6 10             	movzbl (%eax),%edx
 2c1:	84 d2                	test   %dl,%dl
 2c3:	75 16                	jne    2db <strchr+0x2b>
 2c5:	eb 21                	jmp    2e8 <strchr+0x38>
 2c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ce:	66 90                	xchg   %ax,%ax
 2d0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2d4:	83 c0 01             	add    $0x1,%eax
 2d7:	84 d2                	test   %dl,%dl
 2d9:	74 0d                	je     2e8 <strchr+0x38>
    if(*s == c)
 2db:	38 d1                	cmp    %dl,%cl
 2dd:	75 f1                	jne    2d0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 2df:	5d                   	pop    %ebp
 2e0:	c3                   	ret    
 2e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2e8:	31 c0                	xor    %eax,%eax
}
 2ea:	5d                   	pop    %ebp
 2eb:	c3                   	ret    
 2ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002f0 <gets>:

char*
gets(char *buf, int max)
{
 2f0:	f3 0f 1e fb          	endbr32 
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	57                   	push   %edi
 2f8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f9:	31 f6                	xor    %esi,%esi
{
 2fb:	53                   	push   %ebx
 2fc:	89 f3                	mov    %esi,%ebx
 2fe:	83 ec 1c             	sub    $0x1c,%esp
 301:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 304:	eb 33                	jmp    339 <gets+0x49>
 306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 310:	83 ec 04             	sub    $0x4,%esp
 313:	8d 45 e7             	lea    -0x19(%ebp),%eax
 316:	6a 01                	push   $0x1
 318:	50                   	push   %eax
 319:	6a 00                	push   $0x0
 31b:	e8 2b 01 00 00       	call   44b <read>
    if(cc < 1)
 320:	83 c4 10             	add    $0x10,%esp
 323:	85 c0                	test   %eax,%eax
 325:	7e 1c                	jle    343 <gets+0x53>
      break;
    buf[i++] = c;
 327:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 32b:	83 c7 01             	add    $0x1,%edi
 32e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 331:	3c 0a                	cmp    $0xa,%al
 333:	74 23                	je     358 <gets+0x68>
 335:	3c 0d                	cmp    $0xd,%al
 337:	74 1f                	je     358 <gets+0x68>
  for(i=0; i+1 < max; ){
 339:	83 c3 01             	add    $0x1,%ebx
 33c:	89 fe                	mov    %edi,%esi
 33e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 341:	7c cd                	jl     310 <gets+0x20>
 343:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 345:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 348:	c6 03 00             	movb   $0x0,(%ebx)
}
 34b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34e:	5b                   	pop    %ebx
 34f:	5e                   	pop    %esi
 350:	5f                   	pop    %edi
 351:	5d                   	pop    %ebp
 352:	c3                   	ret    
 353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 357:	90                   	nop
 358:	8b 75 08             	mov    0x8(%ebp),%esi
 35b:	8b 45 08             	mov    0x8(%ebp),%eax
 35e:	01 de                	add    %ebx,%esi
 360:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 362:	c6 03 00             	movb   $0x0,(%ebx)
}
 365:	8d 65 f4             	lea    -0xc(%ebp),%esp
 368:	5b                   	pop    %ebx
 369:	5e                   	pop    %esi
 36a:	5f                   	pop    %edi
 36b:	5d                   	pop    %ebp
 36c:	c3                   	ret    
 36d:	8d 76 00             	lea    0x0(%esi),%esi

00000370 <stat>:

int
stat(const char *n, struct stat *st)
{
 370:	f3 0f 1e fb          	endbr32 
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	56                   	push   %esi
 378:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 379:	83 ec 08             	sub    $0x8,%esp
 37c:	6a 00                	push   $0x0
 37e:	ff 75 08             	pushl  0x8(%ebp)
 381:	e8 ed 00 00 00       	call   473 <open>
  if(fd < 0)
 386:	83 c4 10             	add    $0x10,%esp
 389:	85 c0                	test   %eax,%eax
 38b:	78 2b                	js     3b8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 38d:	83 ec 08             	sub    $0x8,%esp
 390:	ff 75 0c             	pushl  0xc(%ebp)
 393:	89 c3                	mov    %eax,%ebx
 395:	50                   	push   %eax
 396:	e8 f0 00 00 00       	call   48b <fstat>
  close(fd);
 39b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 39e:	89 c6                	mov    %eax,%esi
  close(fd);
 3a0:	e8 b6 00 00 00       	call   45b <close>
  return r;
 3a5:	83 c4 10             	add    $0x10,%esp
}
 3a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3ab:	89 f0                	mov    %esi,%eax
 3ad:	5b                   	pop    %ebx
 3ae:	5e                   	pop    %esi
 3af:	5d                   	pop    %ebp
 3b0:	c3                   	ret    
 3b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 3b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3bd:	eb e9                	jmp    3a8 <stat+0x38>
 3bf:	90                   	nop

000003c0 <atoi>:

int
atoi(const char *s)
{
 3c0:	f3 0f 1e fb          	endbr32 
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	53                   	push   %ebx
 3c8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3cb:	0f be 02             	movsbl (%edx),%eax
 3ce:	8d 48 d0             	lea    -0x30(%eax),%ecx
 3d1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3d9:	77 1a                	ja     3f5 <atoi+0x35>
 3db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3df:	90                   	nop
    n = n*10 + *s++ - '0';
 3e0:	83 c2 01             	add    $0x1,%edx
 3e3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3e6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3ea:	0f be 02             	movsbl (%edx),%eax
 3ed:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3f0:	80 fb 09             	cmp    $0x9,%bl
 3f3:	76 eb                	jbe    3e0 <atoi+0x20>
  return n;
}
 3f5:	89 c8                	mov    %ecx,%eax
 3f7:	5b                   	pop    %ebx
 3f8:	5d                   	pop    %ebp
 3f9:	c3                   	ret    
 3fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000400 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 400:	f3 0f 1e fb          	endbr32 
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	57                   	push   %edi
 408:	8b 45 10             	mov    0x10(%ebp),%eax
 40b:	8b 55 08             	mov    0x8(%ebp),%edx
 40e:	56                   	push   %esi
 40f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 412:	85 c0                	test   %eax,%eax
 414:	7e 0f                	jle    425 <memmove+0x25>
 416:	01 d0                	add    %edx,%eax
  dst = vdst;
 418:	89 d7                	mov    %edx,%edi
 41a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 420:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 421:	39 f8                	cmp    %edi,%eax
 423:	75 fb                	jne    420 <memmove+0x20>
  return vdst;
}
 425:	5e                   	pop    %esi
 426:	89 d0                	mov    %edx,%eax
 428:	5f                   	pop    %edi
 429:	5d                   	pop    %ebp
 42a:	c3                   	ret    

0000042b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 42b:	b8 01 00 00 00       	mov    $0x1,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <exit>:
SYSCALL(exit)
 433:	b8 02 00 00 00       	mov    $0x2,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <wait>:
SYSCALL(wait)
 43b:	b8 03 00 00 00       	mov    $0x3,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <pipe>:
SYSCALL(pipe)
 443:	b8 04 00 00 00       	mov    $0x4,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <read>:
SYSCALL(read)
 44b:	b8 05 00 00 00       	mov    $0x5,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <write>:
SYSCALL(write)
 453:	b8 10 00 00 00       	mov    $0x10,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <close>:
SYSCALL(close)
 45b:	b8 15 00 00 00       	mov    $0x15,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <kill>:
SYSCALL(kill)
 463:	b8 06 00 00 00       	mov    $0x6,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <exec>:
SYSCALL(exec)
 46b:	b8 07 00 00 00       	mov    $0x7,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <open>:
SYSCALL(open)
 473:	b8 0f 00 00 00       	mov    $0xf,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <mknod>:
SYSCALL(mknod)
 47b:	b8 11 00 00 00       	mov    $0x11,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <unlink>:
SYSCALL(unlink)
 483:	b8 12 00 00 00       	mov    $0x12,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <fstat>:
SYSCALL(fstat)
 48b:	b8 08 00 00 00       	mov    $0x8,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <link>:
SYSCALL(link)
 493:	b8 13 00 00 00       	mov    $0x13,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <mkdir>:
SYSCALL(mkdir)
 49b:	b8 14 00 00 00       	mov    $0x14,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <chdir>:
SYSCALL(chdir)
 4a3:	b8 09 00 00 00       	mov    $0x9,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <dup>:
SYSCALL(dup)
 4ab:	b8 0a 00 00 00       	mov    $0xa,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <getpid>:
SYSCALL(getpid)
 4b3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <sbrk>:
SYSCALL(sbrk)
 4bb:	b8 0c 00 00 00       	mov    $0xc,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <sleep>:
SYSCALL(sleep)
 4c3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <uptime>:
SYSCALL(uptime)
 4cb:	b8 0e 00 00 00       	mov    $0xe,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <find_digital_root>:
SYSCALL(find_digital_root)
 4d3:	b8 16 00 00 00       	mov    $0x16,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <get_process_lifetime>:
SYSCALL(get_process_lifetime)
 4db:	b8 17 00 00 00       	mov    $0x17,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <copy_file>:
SYSCALL(copy_file)
 4e3:	b8 18 00 00 00       	mov    $0x18,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <get_uncle_count>:
SYSCALL(get_uncle_count)
 4eb:	b8 19 00 00 00       	mov    $0x19,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <change_sched_Q>:
SYSCALL(change_sched_Q)
 4f3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <show_process_info>:
SYSCALL(show_process_info)
 4fb:	b8 1a 00 00 00       	mov    $0x1a,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <set_proc_bjf_params>:
SYSCALL(set_proc_bjf_params)
 503:	b8 1d 00 00 00       	mov    $0x1d,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <set_system_bjf_params>:
SYSCALL(set_system_bjf_params)
 50b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <priorityLock_test>:
SYSCALL(priorityLock_test)
 513:	b8 1e 00 00 00       	mov    $0x1e,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <syscalls_count>:
SYSCALL(syscalls_count)
 51b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <shmget>:
SYSCALL(shmget)
 523:	b8 20 00 00 00       	mov    $0x20,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <shmat>:
SYSCALL(shmat)
 52b:	b8 21 00 00 00       	mov    $0x21,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <shmdt>:
SYSCALL(shmdt)
 533:	b8 22 00 00 00       	mov    $0x22,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <shmctl>:
SYSCALL(shmctl)
 53b:	b8 23 00 00 00       	mov    $0x23,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    
 543:	66 90                	xchg   %ax,%ax
 545:	66 90                	xchg   %ax,%ax
 547:	66 90                	xchg   %ax,%ax
 549:	66 90                	xchg   %ax,%ax
 54b:	66 90                	xchg   %ax,%ax
 54d:	66 90                	xchg   %ax,%ax
 54f:	90                   	nop

00000550 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	57                   	push   %edi
 554:	56                   	push   %esi
 555:	53                   	push   %ebx
 556:	83 ec 3c             	sub    $0x3c,%esp
 559:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 55c:	89 d1                	mov    %edx,%ecx
{
 55e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 561:	85 d2                	test   %edx,%edx
 563:	0f 89 7f 00 00 00    	jns    5e8 <printint+0x98>
 569:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 56d:	74 79                	je     5e8 <printint+0x98>
    neg = 1;
 56f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 576:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 578:	31 db                	xor    %ebx,%ebx
 57a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 57d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 580:	89 c8                	mov    %ecx,%eax
 582:	31 d2                	xor    %edx,%edx
 584:	89 cf                	mov    %ecx,%edi
 586:	f7 75 c4             	divl   -0x3c(%ebp)
 589:	0f b6 92 38 0a 00 00 	movzbl 0xa38(%edx),%edx
 590:	89 45 c0             	mov    %eax,-0x40(%ebp)
 593:	89 d8                	mov    %ebx,%eax
 595:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 598:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 59b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 59e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 5a1:	76 dd                	jbe    580 <printint+0x30>
  if(neg)
 5a3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 5a6:	85 c9                	test   %ecx,%ecx
 5a8:	74 0c                	je     5b6 <printint+0x66>
    buf[i++] = '-';
 5aa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 5af:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 5b1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 5b6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 5b9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 5bd:	eb 07                	jmp    5c6 <printint+0x76>
 5bf:	90                   	nop
 5c0:	0f b6 13             	movzbl (%ebx),%edx
 5c3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 5c6:	83 ec 04             	sub    $0x4,%esp
 5c9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 5cc:	6a 01                	push   $0x1
 5ce:	56                   	push   %esi
 5cf:	57                   	push   %edi
 5d0:	e8 7e fe ff ff       	call   453 <write>
  while(--i >= 0)
 5d5:	83 c4 10             	add    $0x10,%esp
 5d8:	39 de                	cmp    %ebx,%esi
 5da:	75 e4                	jne    5c0 <printint+0x70>
    putc(fd, buf[i]);
}
 5dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5df:	5b                   	pop    %ebx
 5e0:	5e                   	pop    %esi
 5e1:	5f                   	pop    %edi
 5e2:	5d                   	pop    %ebp
 5e3:	c3                   	ret    
 5e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5e8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 5ef:	eb 87                	jmp    578 <printint+0x28>
 5f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ff:	90                   	nop

00000600 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 600:	f3 0f 1e fb          	endbr32 
 604:	55                   	push   %ebp
 605:	89 e5                	mov    %esp,%ebp
 607:	57                   	push   %edi
 608:	56                   	push   %esi
 609:	53                   	push   %ebx
 60a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 60d:	8b 75 0c             	mov    0xc(%ebp),%esi
 610:	0f b6 1e             	movzbl (%esi),%ebx
 613:	84 db                	test   %bl,%bl
 615:	0f 84 b4 00 00 00    	je     6cf <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 61b:	8d 45 10             	lea    0x10(%ebp),%eax
 61e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 621:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 624:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 626:	89 45 d0             	mov    %eax,-0x30(%ebp)
 629:	eb 33                	jmp    65e <printf+0x5e>
 62b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 62f:	90                   	nop
 630:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 633:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 638:	83 f8 25             	cmp    $0x25,%eax
 63b:	74 17                	je     654 <printf+0x54>
  write(fd, &c, 1);
 63d:	83 ec 04             	sub    $0x4,%esp
 640:	88 5d e7             	mov    %bl,-0x19(%ebp)
 643:	6a 01                	push   $0x1
 645:	57                   	push   %edi
 646:	ff 75 08             	pushl  0x8(%ebp)
 649:	e8 05 fe ff ff       	call   453 <write>
 64e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 651:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 654:	0f b6 1e             	movzbl (%esi),%ebx
 657:	83 c6 01             	add    $0x1,%esi
 65a:	84 db                	test   %bl,%bl
 65c:	74 71                	je     6cf <printf+0xcf>
    c = fmt[i] & 0xff;
 65e:	0f be cb             	movsbl %bl,%ecx
 661:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 664:	85 d2                	test   %edx,%edx
 666:	74 c8                	je     630 <printf+0x30>
      }
    } else if(state == '%'){
 668:	83 fa 25             	cmp    $0x25,%edx
 66b:	75 e7                	jne    654 <printf+0x54>
      if(c == 'd'){
 66d:	83 f8 64             	cmp    $0x64,%eax
 670:	0f 84 9a 00 00 00    	je     710 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 676:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 67c:	83 f9 70             	cmp    $0x70,%ecx
 67f:	74 5f                	je     6e0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 681:	83 f8 73             	cmp    $0x73,%eax
 684:	0f 84 d6 00 00 00    	je     760 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 68a:	83 f8 63             	cmp    $0x63,%eax
 68d:	0f 84 8d 00 00 00    	je     720 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 693:	83 f8 25             	cmp    $0x25,%eax
 696:	0f 84 b4 00 00 00    	je     750 <printf+0x150>
  write(fd, &c, 1);
 69c:	83 ec 04             	sub    $0x4,%esp
 69f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6a3:	6a 01                	push   $0x1
 6a5:	57                   	push   %edi
 6a6:	ff 75 08             	pushl  0x8(%ebp)
 6a9:	e8 a5 fd ff ff       	call   453 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 6ae:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6b1:	83 c4 0c             	add    $0xc,%esp
 6b4:	6a 01                	push   $0x1
 6b6:	83 c6 01             	add    $0x1,%esi
 6b9:	57                   	push   %edi
 6ba:	ff 75 08             	pushl  0x8(%ebp)
 6bd:	e8 91 fd ff ff       	call   453 <write>
  for(i = 0; fmt[i]; i++){
 6c2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 6c6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6c9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 6cb:	84 db                	test   %bl,%bl
 6cd:	75 8f                	jne    65e <printf+0x5e>
    }
  }
}
 6cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6d2:	5b                   	pop    %ebx
 6d3:	5e                   	pop    %esi
 6d4:	5f                   	pop    %edi
 6d5:	5d                   	pop    %ebp
 6d6:	c3                   	ret    
 6d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6de:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 6e0:	83 ec 0c             	sub    $0xc,%esp
 6e3:	b9 10 00 00 00       	mov    $0x10,%ecx
 6e8:	6a 00                	push   $0x0
 6ea:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6ed:	8b 45 08             	mov    0x8(%ebp),%eax
 6f0:	8b 13                	mov    (%ebx),%edx
 6f2:	e8 59 fe ff ff       	call   550 <printint>
        ap++;
 6f7:	89 d8                	mov    %ebx,%eax
 6f9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6fc:	31 d2                	xor    %edx,%edx
        ap++;
 6fe:	83 c0 04             	add    $0x4,%eax
 701:	89 45 d0             	mov    %eax,-0x30(%ebp)
 704:	e9 4b ff ff ff       	jmp    654 <printf+0x54>
 709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 710:	83 ec 0c             	sub    $0xc,%esp
 713:	b9 0a 00 00 00       	mov    $0xa,%ecx
 718:	6a 01                	push   $0x1
 71a:	eb ce                	jmp    6ea <printf+0xea>
 71c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 720:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 723:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 726:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 728:	6a 01                	push   $0x1
        ap++;
 72a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 72d:	57                   	push   %edi
 72e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 731:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 734:	e8 1a fd ff ff       	call   453 <write>
        ap++;
 739:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 73c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 73f:	31 d2                	xor    %edx,%edx
 741:	e9 0e ff ff ff       	jmp    654 <printf+0x54>
 746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 74d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 750:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 753:	83 ec 04             	sub    $0x4,%esp
 756:	e9 59 ff ff ff       	jmp    6b4 <printf+0xb4>
 75b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 75f:	90                   	nop
        s = (char*)*ap;
 760:	8b 45 d0             	mov    -0x30(%ebp),%eax
 763:	8b 18                	mov    (%eax),%ebx
        ap++;
 765:	83 c0 04             	add    $0x4,%eax
 768:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 76b:	85 db                	test   %ebx,%ebx
 76d:	74 17                	je     786 <printf+0x186>
        while(*s != 0){
 76f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 772:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 774:	84 c0                	test   %al,%al
 776:	0f 84 d8 fe ff ff    	je     654 <printf+0x54>
 77c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 77f:	89 de                	mov    %ebx,%esi
 781:	8b 5d 08             	mov    0x8(%ebp),%ebx
 784:	eb 1a                	jmp    7a0 <printf+0x1a0>
          s = "(null)";
 786:	bb 2e 0a 00 00       	mov    $0xa2e,%ebx
        while(*s != 0){
 78b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 78e:	b8 28 00 00 00       	mov    $0x28,%eax
 793:	89 de                	mov    %ebx,%esi
 795:	8b 5d 08             	mov    0x8(%ebp),%ebx
 798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 79f:	90                   	nop
  write(fd, &c, 1);
 7a0:	83 ec 04             	sub    $0x4,%esp
          s++;
 7a3:	83 c6 01             	add    $0x1,%esi
 7a6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7a9:	6a 01                	push   $0x1
 7ab:	57                   	push   %edi
 7ac:	53                   	push   %ebx
 7ad:	e8 a1 fc ff ff       	call   453 <write>
        while(*s != 0){
 7b2:	0f b6 06             	movzbl (%esi),%eax
 7b5:	83 c4 10             	add    $0x10,%esp
 7b8:	84 c0                	test   %al,%al
 7ba:	75 e4                	jne    7a0 <printf+0x1a0>
 7bc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 7bf:	31 d2                	xor    %edx,%edx
 7c1:	e9 8e fe ff ff       	jmp    654 <printf+0x54>
 7c6:	66 90                	xchg   %ax,%ax
 7c8:	66 90                	xchg   %ax,%ax
 7ca:	66 90                	xchg   %ax,%ax
 7cc:	66 90                	xchg   %ax,%ax
 7ce:	66 90                	xchg   %ax,%ax

000007d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d0:	f3 0f 1e fb          	endbr32 
 7d4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d5:	a1 a0 0d 00 00       	mov    0xda0,%eax
{
 7da:	89 e5                	mov    %esp,%ebp
 7dc:	57                   	push   %edi
 7dd:	56                   	push   %esi
 7de:	53                   	push   %ebx
 7df:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7e2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 7e4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e7:	39 c8                	cmp    %ecx,%eax
 7e9:	73 15                	jae    800 <free+0x30>
 7eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7ef:	90                   	nop
 7f0:	39 d1                	cmp    %edx,%ecx
 7f2:	72 14                	jb     808 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f4:	39 d0                	cmp    %edx,%eax
 7f6:	73 10                	jae    808 <free+0x38>
{
 7f8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fa:	8b 10                	mov    (%eax),%edx
 7fc:	39 c8                	cmp    %ecx,%eax
 7fe:	72 f0                	jb     7f0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 800:	39 d0                	cmp    %edx,%eax
 802:	72 f4                	jb     7f8 <free+0x28>
 804:	39 d1                	cmp    %edx,%ecx
 806:	73 f0                	jae    7f8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 808:	8b 73 fc             	mov    -0x4(%ebx),%esi
 80b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 80e:	39 fa                	cmp    %edi,%edx
 810:	74 1e                	je     830 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 812:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 815:	8b 50 04             	mov    0x4(%eax),%edx
 818:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 81b:	39 f1                	cmp    %esi,%ecx
 81d:	74 28                	je     847 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 81f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 821:	5b                   	pop    %ebx
  freep = p;
 822:	a3 a0 0d 00 00       	mov    %eax,0xda0
}
 827:	5e                   	pop    %esi
 828:	5f                   	pop    %edi
 829:	5d                   	pop    %ebp
 82a:	c3                   	ret    
 82b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 82f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 830:	03 72 04             	add    0x4(%edx),%esi
 833:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 836:	8b 10                	mov    (%eax),%edx
 838:	8b 12                	mov    (%edx),%edx
 83a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 83d:	8b 50 04             	mov    0x4(%eax),%edx
 840:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 843:	39 f1                	cmp    %esi,%ecx
 845:	75 d8                	jne    81f <free+0x4f>
    p->s.size += bp->s.size;
 847:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 84a:	a3 a0 0d 00 00       	mov    %eax,0xda0
    p->s.size += bp->s.size;
 84f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 852:	8b 53 f8             	mov    -0x8(%ebx),%edx
 855:	89 10                	mov    %edx,(%eax)
}
 857:	5b                   	pop    %ebx
 858:	5e                   	pop    %esi
 859:	5f                   	pop    %edi
 85a:	5d                   	pop    %ebp
 85b:	c3                   	ret    
 85c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000860 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 860:	f3 0f 1e fb          	endbr32 
 864:	55                   	push   %ebp
 865:	89 e5                	mov    %esp,%ebp
 867:	57                   	push   %edi
 868:	56                   	push   %esi
 869:	53                   	push   %ebx
 86a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 86d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 870:	8b 3d a0 0d 00 00    	mov    0xda0,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 876:	8d 70 07             	lea    0x7(%eax),%esi
 879:	c1 ee 03             	shr    $0x3,%esi
 87c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 87f:	85 ff                	test   %edi,%edi
 881:	0f 84 a9 00 00 00    	je     930 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 887:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 889:	8b 48 04             	mov    0x4(%eax),%ecx
 88c:	39 f1                	cmp    %esi,%ecx
 88e:	73 6d                	jae    8fd <malloc+0x9d>
 890:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 896:	bb 00 10 00 00       	mov    $0x1000,%ebx
 89b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 89e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 8a5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 8a8:	eb 17                	jmp    8c1 <malloc+0x61>
 8aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 8b2:	8b 4a 04             	mov    0x4(%edx),%ecx
 8b5:	39 f1                	cmp    %esi,%ecx
 8b7:	73 4f                	jae    908 <malloc+0xa8>
 8b9:	8b 3d a0 0d 00 00    	mov    0xda0,%edi
 8bf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c1:	39 c7                	cmp    %eax,%edi
 8c3:	75 eb                	jne    8b0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 8c5:	83 ec 0c             	sub    $0xc,%esp
 8c8:	ff 75 e4             	pushl  -0x1c(%ebp)
 8cb:	e8 eb fb ff ff       	call   4bb <sbrk>
  if(p == (char*)-1)
 8d0:	83 c4 10             	add    $0x10,%esp
 8d3:	83 f8 ff             	cmp    $0xffffffff,%eax
 8d6:	74 1b                	je     8f3 <malloc+0x93>
  hp->s.size = nu;
 8d8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8db:	83 ec 0c             	sub    $0xc,%esp
 8de:	83 c0 08             	add    $0x8,%eax
 8e1:	50                   	push   %eax
 8e2:	e8 e9 fe ff ff       	call   7d0 <free>
  return freep;
 8e7:	a1 a0 0d 00 00       	mov    0xda0,%eax
      if((p = morecore(nunits)) == 0)
 8ec:	83 c4 10             	add    $0x10,%esp
 8ef:	85 c0                	test   %eax,%eax
 8f1:	75 bd                	jne    8b0 <malloc+0x50>
        return 0;
  }
}
 8f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8f6:	31 c0                	xor    %eax,%eax
}
 8f8:	5b                   	pop    %ebx
 8f9:	5e                   	pop    %esi
 8fa:	5f                   	pop    %edi
 8fb:	5d                   	pop    %ebp
 8fc:	c3                   	ret    
    if(p->s.size >= nunits){
 8fd:	89 c2                	mov    %eax,%edx
 8ff:	89 f8                	mov    %edi,%eax
 901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 908:	39 ce                	cmp    %ecx,%esi
 90a:	74 54                	je     960 <malloc+0x100>
        p->s.size -= nunits;
 90c:	29 f1                	sub    %esi,%ecx
 90e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 911:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 914:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 917:	a3 a0 0d 00 00       	mov    %eax,0xda0
}
 91c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 91f:	8d 42 08             	lea    0x8(%edx),%eax
}
 922:	5b                   	pop    %ebx
 923:	5e                   	pop    %esi
 924:	5f                   	pop    %edi
 925:	5d                   	pop    %ebp
 926:	c3                   	ret    
 927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 92e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 930:	c7 05 a0 0d 00 00 a4 	movl   $0xda4,0xda0
 937:	0d 00 00 
    base.s.size = 0;
 93a:	bf a4 0d 00 00       	mov    $0xda4,%edi
    base.s.ptr = freep = prevp = &base;
 93f:	c7 05 a4 0d 00 00 a4 	movl   $0xda4,0xda4
 946:	0d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 949:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 94b:	c7 05 a8 0d 00 00 00 	movl   $0x0,0xda8
 952:	00 00 00 
    if(p->s.size >= nunits){
 955:	e9 36 ff ff ff       	jmp    890 <malloc+0x30>
 95a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 960:	8b 0a                	mov    (%edx),%ecx
 962:	89 08                	mov    %ecx,(%eax)
 964:	eb b1                	jmp    917 <malloc+0xb7>
