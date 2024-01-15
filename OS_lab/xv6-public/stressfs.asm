
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
  int fd, i;
  char path[] = "stressfs0";
   b:	b8 30 00 00 00       	mov    $0x30,%eax
{
  10:	ff 71 fc             	pushl  -0x4(%ecx)
  13:	55                   	push   %ebp
  14:	89 e5                	mov    %esp,%ebp
  16:	57                   	push   %edi
  17:	56                   	push   %esi
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));
  18:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
{
  1e:	53                   	push   %ebx

  for(i = 0; i < 4; i++)
  1f:	31 db                	xor    %ebx,%ebx
{
  21:	51                   	push   %ecx
  22:	81 ec 20 02 00 00    	sub    $0x220,%esp
  char path[] = "stressfs0";
  28:	66 89 85 e6 fd ff ff 	mov    %ax,-0x21a(%ebp)
  printf(1, "stressfs starting\n");
  2f:	68 b8 08 00 00       	push   $0x8b8
  34:	6a 01                	push   $0x1
  char path[] = "stressfs0";
  36:	c7 85 de fd ff ff 73 	movl   $0x65727473,-0x222(%ebp)
  3d:	74 72 65 
  40:	c7 85 e2 fd ff ff 73 	movl   $0x73667373,-0x21e(%ebp)
  47:	73 66 73 
  printf(1, "stressfs starting\n");
  4a:	e8 01 05 00 00       	call   550 <printf>
  memset(data, 'a', sizeof(data));
  4f:	83 c4 0c             	add    $0xc,%esp
  52:	68 00 02 00 00       	push   $0x200
  57:	6a 61                	push   $0x61
  59:	56                   	push   %esi
  5a:	e8 a1 01 00 00       	call   200 <memset>
  5f:	83 c4 10             	add    $0x10,%esp
    if(fork() > 0)
  62:	e8 34 03 00 00       	call   39b <fork>
  67:	85 c0                	test   %eax,%eax
  69:	0f 8f bb 00 00 00    	jg     12a <main+0x12a>
  for(i = 0; i < 4; i++)
  6f:	83 c3 01             	add    $0x1,%ebx
  72:	83 fb 04             	cmp    $0x4,%ebx
  75:	75 eb                	jne    62 <main+0x62>
  77:	bf 04 00 00 00       	mov    $0x4,%edi
      break;

  printf(1, "write %d\n", i);
  7c:	83 ec 04             	sub    $0x4,%esp
  7f:	53                   	push   %ebx

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  80:	bb 14 00 00 00       	mov    $0x14,%ebx
  printf(1, "write %d\n", i);
  85:	68 cb 08 00 00       	push   $0x8cb
  8a:	6a 01                	push   $0x1
  8c:	e8 bf 04 00 00       	call   550 <printf>
  path[8] += i;
  91:	89 f8                	mov    %edi,%eax
  fd = open(path, O_CREATE | O_RDWR);
  93:	5f                   	pop    %edi
  path[8] += i;
  94:	00 85 e6 fd ff ff    	add    %al,-0x21a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  9a:	58                   	pop    %eax
  9b:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  a1:	68 02 02 00 00       	push   $0x202
  a6:	50                   	push   %eax
  a7:	e8 37 03 00 00       	call   3e3 <open>
  ac:	83 c4 10             	add    $0x10,%esp
  af:	89 c7                	mov    %eax,%edi
  for(i = 0; i < 20; i++)
  b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  b8:	83 ec 04             	sub    $0x4,%esp
  bb:	68 00 02 00 00       	push   $0x200
  c0:	56                   	push   %esi
  c1:	57                   	push   %edi
  c2:	e8 fc 02 00 00       	call   3c3 <write>
  for(i = 0; i < 20; i++)
  c7:	83 c4 10             	add    $0x10,%esp
  ca:	83 eb 01             	sub    $0x1,%ebx
  cd:	75 e9                	jne    b8 <main+0xb8>
  close(fd);
  cf:	83 ec 0c             	sub    $0xc,%esp
  d2:	57                   	push   %edi
  d3:	e8 f3 02 00 00       	call   3cb <close>

  printf(1, "read\n");
  d8:	58                   	pop    %eax
  d9:	5a                   	pop    %edx
  da:	68 d5 08 00 00       	push   $0x8d5
  df:	6a 01                	push   $0x1
  e1:	e8 6a 04 00 00       	call   550 <printf>

  fd = open(path, O_RDONLY);
  e6:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  ec:	59                   	pop    %ecx
  ed:	5b                   	pop    %ebx
  ee:	6a 00                	push   $0x0
  f0:	bb 14 00 00 00       	mov    $0x14,%ebx
  f5:	50                   	push   %eax
  f6:	e8 e8 02 00 00       	call   3e3 <open>
  fb:	83 c4 10             	add    $0x10,%esp
  fe:	89 c7                	mov    %eax,%edi
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
 100:	83 ec 04             	sub    $0x4,%esp
 103:	68 00 02 00 00       	push   $0x200
 108:	56                   	push   %esi
 109:	57                   	push   %edi
 10a:	e8 ac 02 00 00       	call   3bb <read>
  for (i = 0; i < 20; i++)
 10f:	83 c4 10             	add    $0x10,%esp
 112:	83 eb 01             	sub    $0x1,%ebx
 115:	75 e9                	jne    100 <main+0x100>
  close(fd);
 117:	83 ec 0c             	sub    $0xc,%esp
 11a:	57                   	push   %edi
 11b:	e8 ab 02 00 00       	call   3cb <close>

  wait();
 120:	e8 86 02 00 00       	call   3ab <wait>

  exit();
 125:	e8 79 02 00 00       	call   3a3 <exit>
 12a:	89 df                	mov    %ebx,%edi
 12c:	e9 4b ff ff ff       	jmp    7c <main+0x7c>
 131:	66 90                	xchg   %ax,%ax
 133:	66 90                	xchg   %ax,%ax
 135:	66 90                	xchg   %ax,%ax
 137:	66 90                	xchg   %ax,%ax
 139:	66 90                	xchg   %ax,%ax
 13b:	66 90                	xchg   %ax,%ax
 13d:	66 90                	xchg   %ax,%ax
 13f:	90                   	nop

00000140 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 140:	f3 0f 1e fb          	endbr32 
 144:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 145:	31 c0                	xor    %eax,%eax
{
 147:	89 e5                	mov    %esp,%ebp
 149:	53                   	push   %ebx
 14a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 14d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 150:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 154:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 157:	83 c0 01             	add    $0x1,%eax
 15a:	84 d2                	test   %dl,%dl
 15c:	75 f2                	jne    150 <strcpy+0x10>
    ;
  return os;
}
 15e:	89 c8                	mov    %ecx,%eax
 160:	5b                   	pop    %ebx
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    
 163:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000170 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 170:	f3 0f 1e fb          	endbr32 
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	53                   	push   %ebx
 178:	8b 4d 08             	mov    0x8(%ebp),%ecx
 17b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 17e:	0f b6 01             	movzbl (%ecx),%eax
 181:	0f b6 1a             	movzbl (%edx),%ebx
 184:	84 c0                	test   %al,%al
 186:	75 19                	jne    1a1 <strcmp+0x31>
 188:	eb 26                	jmp    1b0 <strcmp+0x40>
 18a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 190:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 194:	83 c1 01             	add    $0x1,%ecx
 197:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 19a:	0f b6 1a             	movzbl (%edx),%ebx
 19d:	84 c0                	test   %al,%al
 19f:	74 0f                	je     1b0 <strcmp+0x40>
 1a1:	38 d8                	cmp    %bl,%al
 1a3:	74 eb                	je     190 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 1a5:	29 d8                	sub    %ebx,%eax
}
 1a7:	5b                   	pop    %ebx
 1a8:	5d                   	pop    %ebp
 1a9:	c3                   	ret    
 1aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1b0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 1b2:	29 d8                	sub    %ebx,%eax
}
 1b4:	5b                   	pop    %ebx
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    
 1b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1be:	66 90                	xchg   %ax,%ax

000001c0 <strlen>:

uint
strlen(const char *s)
{
 1c0:	f3 0f 1e fb          	endbr32 
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1ca:	80 3a 00             	cmpb   $0x0,(%edx)
 1cd:	74 21                	je     1f0 <strlen+0x30>
 1cf:	31 c0                	xor    %eax,%eax
 1d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1d8:	83 c0 01             	add    $0x1,%eax
 1db:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1df:	89 c1                	mov    %eax,%ecx
 1e1:	75 f5                	jne    1d8 <strlen+0x18>
    ;
  return n;
}
 1e3:	89 c8                	mov    %ecx,%eax
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    
 1e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ee:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 1f0:	31 c9                	xor    %ecx,%ecx
}
 1f2:	5d                   	pop    %ebp
 1f3:	89 c8                	mov    %ecx,%eax
 1f5:	c3                   	ret    
 1f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1fd:	8d 76 00             	lea    0x0(%esi),%esi

00000200 <memset>:

void*
memset(void *dst, int c, uint n)
{
 200:	f3 0f 1e fb          	endbr32 
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	57                   	push   %edi
 208:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 20b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 20e:	8b 45 0c             	mov    0xc(%ebp),%eax
 211:	89 d7                	mov    %edx,%edi
 213:	fc                   	cld    
 214:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 216:	89 d0                	mov    %edx,%eax
 218:	5f                   	pop    %edi
 219:	5d                   	pop    %ebp
 21a:	c3                   	ret    
 21b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 21f:	90                   	nop

00000220 <strchr>:

char*
strchr(const char *s, char c)
{
 220:	f3 0f 1e fb          	endbr32 
 224:	55                   	push   %ebp
 225:	89 e5                	mov    %esp,%ebp
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 22e:	0f b6 10             	movzbl (%eax),%edx
 231:	84 d2                	test   %dl,%dl
 233:	75 16                	jne    24b <strchr+0x2b>
 235:	eb 21                	jmp    258 <strchr+0x38>
 237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23e:	66 90                	xchg   %ax,%ax
 240:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 244:	83 c0 01             	add    $0x1,%eax
 247:	84 d2                	test   %dl,%dl
 249:	74 0d                	je     258 <strchr+0x38>
    if(*s == c)
 24b:	38 d1                	cmp    %dl,%cl
 24d:	75 f1                	jne    240 <strchr+0x20>
      return (char*)s;
  return 0;
}
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    
 251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 258:	31 c0                	xor    %eax,%eax
}
 25a:	5d                   	pop    %ebp
 25b:	c3                   	ret    
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000260 <gets>:

char*
gets(char *buf, int max)
{
 260:	f3 0f 1e fb          	endbr32 
 264:	55                   	push   %ebp
 265:	89 e5                	mov    %esp,%ebp
 267:	57                   	push   %edi
 268:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 269:	31 f6                	xor    %esi,%esi
{
 26b:	53                   	push   %ebx
 26c:	89 f3                	mov    %esi,%ebx
 26e:	83 ec 1c             	sub    $0x1c,%esp
 271:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 274:	eb 33                	jmp    2a9 <gets+0x49>
 276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 280:	83 ec 04             	sub    $0x4,%esp
 283:	8d 45 e7             	lea    -0x19(%ebp),%eax
 286:	6a 01                	push   $0x1
 288:	50                   	push   %eax
 289:	6a 00                	push   $0x0
 28b:	e8 2b 01 00 00       	call   3bb <read>
    if(cc < 1)
 290:	83 c4 10             	add    $0x10,%esp
 293:	85 c0                	test   %eax,%eax
 295:	7e 1c                	jle    2b3 <gets+0x53>
      break;
    buf[i++] = c;
 297:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 29b:	83 c7 01             	add    $0x1,%edi
 29e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 2a1:	3c 0a                	cmp    $0xa,%al
 2a3:	74 23                	je     2c8 <gets+0x68>
 2a5:	3c 0d                	cmp    $0xd,%al
 2a7:	74 1f                	je     2c8 <gets+0x68>
  for(i=0; i+1 < max; ){
 2a9:	83 c3 01             	add    $0x1,%ebx
 2ac:	89 fe                	mov    %edi,%esi
 2ae:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2b1:	7c cd                	jl     280 <gets+0x20>
 2b3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 2b8:	c6 03 00             	movb   $0x0,(%ebx)
}
 2bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2be:	5b                   	pop    %ebx
 2bf:	5e                   	pop    %esi
 2c0:	5f                   	pop    %edi
 2c1:	5d                   	pop    %ebp
 2c2:	c3                   	ret    
 2c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2c7:	90                   	nop
 2c8:	8b 75 08             	mov    0x8(%ebp),%esi
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	01 de                	add    %ebx,%esi
 2d0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 2d2:	c6 03 00             	movb   $0x0,(%ebx)
}
 2d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d8:	5b                   	pop    %ebx
 2d9:	5e                   	pop    %esi
 2da:	5f                   	pop    %edi
 2db:	5d                   	pop    %ebp
 2dc:	c3                   	ret    
 2dd:	8d 76 00             	lea    0x0(%esi),%esi

000002e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2e0:	f3 0f 1e fb          	endbr32 
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	56                   	push   %esi
 2e8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e9:	83 ec 08             	sub    $0x8,%esp
 2ec:	6a 00                	push   $0x0
 2ee:	ff 75 08             	pushl  0x8(%ebp)
 2f1:	e8 ed 00 00 00       	call   3e3 <open>
  if(fd < 0)
 2f6:	83 c4 10             	add    $0x10,%esp
 2f9:	85 c0                	test   %eax,%eax
 2fb:	78 2b                	js     328 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 2fd:	83 ec 08             	sub    $0x8,%esp
 300:	ff 75 0c             	pushl  0xc(%ebp)
 303:	89 c3                	mov    %eax,%ebx
 305:	50                   	push   %eax
 306:	e8 f0 00 00 00       	call   3fb <fstat>
  close(fd);
 30b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 30e:	89 c6                	mov    %eax,%esi
  close(fd);
 310:	e8 b6 00 00 00       	call   3cb <close>
  return r;
 315:	83 c4 10             	add    $0x10,%esp
}
 318:	8d 65 f8             	lea    -0x8(%ebp),%esp
 31b:	89 f0                	mov    %esi,%eax
 31d:	5b                   	pop    %ebx
 31e:	5e                   	pop    %esi
 31f:	5d                   	pop    %ebp
 320:	c3                   	ret    
 321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 328:	be ff ff ff ff       	mov    $0xffffffff,%esi
 32d:	eb e9                	jmp    318 <stat+0x38>
 32f:	90                   	nop

00000330 <atoi>:

int
atoi(const char *s)
{
 330:	f3 0f 1e fb          	endbr32 
 334:	55                   	push   %ebp
 335:	89 e5                	mov    %esp,%ebp
 337:	53                   	push   %ebx
 338:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 33b:	0f be 02             	movsbl (%edx),%eax
 33e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 341:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 344:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 349:	77 1a                	ja     365 <atoi+0x35>
 34b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 34f:	90                   	nop
    n = n*10 + *s++ - '0';
 350:	83 c2 01             	add    $0x1,%edx
 353:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 356:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 35a:	0f be 02             	movsbl (%edx),%eax
 35d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 360:	80 fb 09             	cmp    $0x9,%bl
 363:	76 eb                	jbe    350 <atoi+0x20>
  return n;
}
 365:	89 c8                	mov    %ecx,%eax
 367:	5b                   	pop    %ebx
 368:	5d                   	pop    %ebp
 369:	c3                   	ret    
 36a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000370 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 370:	f3 0f 1e fb          	endbr32 
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	57                   	push   %edi
 378:	8b 45 10             	mov    0x10(%ebp),%eax
 37b:	8b 55 08             	mov    0x8(%ebp),%edx
 37e:	56                   	push   %esi
 37f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 382:	85 c0                	test   %eax,%eax
 384:	7e 0f                	jle    395 <memmove+0x25>
 386:	01 d0                	add    %edx,%eax
  dst = vdst;
 388:	89 d7                	mov    %edx,%edi
 38a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 390:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 391:	39 f8                	cmp    %edi,%eax
 393:	75 fb                	jne    390 <memmove+0x20>
  return vdst;
}
 395:	5e                   	pop    %esi
 396:	89 d0                	mov    %edx,%eax
 398:	5f                   	pop    %edi
 399:	5d                   	pop    %ebp
 39a:	c3                   	ret    

0000039b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 39b:	b8 01 00 00 00       	mov    $0x1,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <exit>:
SYSCALL(exit)
 3a3:	b8 02 00 00 00       	mov    $0x2,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <wait>:
SYSCALL(wait)
 3ab:	b8 03 00 00 00       	mov    $0x3,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <pipe>:
SYSCALL(pipe)
 3b3:	b8 04 00 00 00       	mov    $0x4,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <read>:
SYSCALL(read)
 3bb:	b8 05 00 00 00       	mov    $0x5,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <write>:
SYSCALL(write)
 3c3:	b8 10 00 00 00       	mov    $0x10,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <close>:
SYSCALL(close)
 3cb:	b8 15 00 00 00       	mov    $0x15,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <kill>:
SYSCALL(kill)
 3d3:	b8 06 00 00 00       	mov    $0x6,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <exec>:
SYSCALL(exec)
 3db:	b8 07 00 00 00       	mov    $0x7,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <open>:
SYSCALL(open)
 3e3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <mknod>:
SYSCALL(mknod)
 3eb:	b8 11 00 00 00       	mov    $0x11,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <unlink>:
SYSCALL(unlink)
 3f3:	b8 12 00 00 00       	mov    $0x12,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <fstat>:
SYSCALL(fstat)
 3fb:	b8 08 00 00 00       	mov    $0x8,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <link>:
SYSCALL(link)
 403:	b8 13 00 00 00       	mov    $0x13,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <mkdir>:
SYSCALL(mkdir)
 40b:	b8 14 00 00 00       	mov    $0x14,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <chdir>:
SYSCALL(chdir)
 413:	b8 09 00 00 00       	mov    $0x9,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <dup>:
SYSCALL(dup)
 41b:	b8 0a 00 00 00       	mov    $0xa,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <getpid>:
SYSCALL(getpid)
 423:	b8 0b 00 00 00       	mov    $0xb,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <sbrk>:
SYSCALL(sbrk)
 42b:	b8 0c 00 00 00       	mov    $0xc,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <sleep>:
SYSCALL(sleep)
 433:	b8 0d 00 00 00       	mov    $0xd,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <uptime>:
SYSCALL(uptime)
 43b:	b8 0e 00 00 00       	mov    $0xe,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <find_digital_root>:
SYSCALL(find_digital_root)
 443:	b8 16 00 00 00       	mov    $0x16,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <get_process_lifetime>:
SYSCALL(get_process_lifetime)
 44b:	b8 17 00 00 00       	mov    $0x17,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <copy_file>:
SYSCALL(copy_file)
 453:	b8 18 00 00 00       	mov    $0x18,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <get_uncle_count>:
SYSCALL(get_uncle_count)
 45b:	b8 19 00 00 00       	mov    $0x19,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <change_sched_Q>:
SYSCALL(change_sched_Q)
 463:	b8 1b 00 00 00       	mov    $0x1b,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <show_process_info>:
SYSCALL(show_process_info)
 46b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <set_proc_bjf_params>:
SYSCALL(set_proc_bjf_params)
 473:	b8 1d 00 00 00       	mov    $0x1d,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <set_system_bjf_params>:
SYSCALL(set_system_bjf_params)
 47b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <priorityLock_test>:
SYSCALL(priorityLock_test)
 483:	b8 1e 00 00 00       	mov    $0x1e,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <syscalls_count>:
SYSCALL(syscalls_count)
 48b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    
 493:	66 90                	xchg   %ax,%ax
 495:	66 90                	xchg   %ax,%ax
 497:	66 90                	xchg   %ax,%ax
 499:	66 90                	xchg   %ax,%ax
 49b:	66 90                	xchg   %ax,%ax
 49d:	66 90                	xchg   %ax,%ax
 49f:	90                   	nop

000004a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
 4a6:	83 ec 3c             	sub    $0x3c,%esp
 4a9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4ac:	89 d1                	mov    %edx,%ecx
{
 4ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 4b1:	85 d2                	test   %edx,%edx
 4b3:	0f 89 7f 00 00 00    	jns    538 <printint+0x98>
 4b9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4bd:	74 79                	je     538 <printint+0x98>
    neg = 1;
 4bf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 4c6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 4c8:	31 db                	xor    %ebx,%ebx
 4ca:	8d 75 d7             	lea    -0x29(%ebp),%esi
 4cd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 4d0:	89 c8                	mov    %ecx,%eax
 4d2:	31 d2                	xor    %edx,%edx
 4d4:	89 cf                	mov    %ecx,%edi
 4d6:	f7 75 c4             	divl   -0x3c(%ebp)
 4d9:	0f b6 92 e4 08 00 00 	movzbl 0x8e4(%edx),%edx
 4e0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 4e3:	89 d8                	mov    %ebx,%eax
 4e5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 4e8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 4eb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 4ee:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 4f1:	76 dd                	jbe    4d0 <printint+0x30>
  if(neg)
 4f3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 4f6:	85 c9                	test   %ecx,%ecx
 4f8:	74 0c                	je     506 <printint+0x66>
    buf[i++] = '-';
 4fa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 4ff:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 501:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 506:	8b 7d b8             	mov    -0x48(%ebp),%edi
 509:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 50d:	eb 07                	jmp    516 <printint+0x76>
 50f:	90                   	nop
 510:	0f b6 13             	movzbl (%ebx),%edx
 513:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 516:	83 ec 04             	sub    $0x4,%esp
 519:	88 55 d7             	mov    %dl,-0x29(%ebp)
 51c:	6a 01                	push   $0x1
 51e:	56                   	push   %esi
 51f:	57                   	push   %edi
 520:	e8 9e fe ff ff       	call   3c3 <write>
  while(--i >= 0)
 525:	83 c4 10             	add    $0x10,%esp
 528:	39 de                	cmp    %ebx,%esi
 52a:	75 e4                	jne    510 <printint+0x70>
    putc(fd, buf[i]);
}
 52c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 52f:	5b                   	pop    %ebx
 530:	5e                   	pop    %esi
 531:	5f                   	pop    %edi
 532:	5d                   	pop    %ebp
 533:	c3                   	ret    
 534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 538:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 53f:	eb 87                	jmp    4c8 <printint+0x28>
 541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 54f:	90                   	nop

00000550 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 550:	f3 0f 1e fb          	endbr32 
 554:	55                   	push   %ebp
 555:	89 e5                	mov    %esp,%ebp
 557:	57                   	push   %edi
 558:	56                   	push   %esi
 559:	53                   	push   %ebx
 55a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 55d:	8b 75 0c             	mov    0xc(%ebp),%esi
 560:	0f b6 1e             	movzbl (%esi),%ebx
 563:	84 db                	test   %bl,%bl
 565:	0f 84 b4 00 00 00    	je     61f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 56b:	8d 45 10             	lea    0x10(%ebp),%eax
 56e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 571:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 574:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 576:	89 45 d0             	mov    %eax,-0x30(%ebp)
 579:	eb 33                	jmp    5ae <printf+0x5e>
 57b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 57f:	90                   	nop
 580:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 583:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 588:	83 f8 25             	cmp    $0x25,%eax
 58b:	74 17                	je     5a4 <printf+0x54>
  write(fd, &c, 1);
 58d:	83 ec 04             	sub    $0x4,%esp
 590:	88 5d e7             	mov    %bl,-0x19(%ebp)
 593:	6a 01                	push   $0x1
 595:	57                   	push   %edi
 596:	ff 75 08             	pushl  0x8(%ebp)
 599:	e8 25 fe ff ff       	call   3c3 <write>
 59e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 5a1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5a4:	0f b6 1e             	movzbl (%esi),%ebx
 5a7:	83 c6 01             	add    $0x1,%esi
 5aa:	84 db                	test   %bl,%bl
 5ac:	74 71                	je     61f <printf+0xcf>
    c = fmt[i] & 0xff;
 5ae:	0f be cb             	movsbl %bl,%ecx
 5b1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5b4:	85 d2                	test   %edx,%edx
 5b6:	74 c8                	je     580 <printf+0x30>
      }
    } else if(state == '%'){
 5b8:	83 fa 25             	cmp    $0x25,%edx
 5bb:	75 e7                	jne    5a4 <printf+0x54>
      if(c == 'd'){
 5bd:	83 f8 64             	cmp    $0x64,%eax
 5c0:	0f 84 9a 00 00 00    	je     660 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5c6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 5cc:	83 f9 70             	cmp    $0x70,%ecx
 5cf:	74 5f                	je     630 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5d1:	83 f8 73             	cmp    $0x73,%eax
 5d4:	0f 84 d6 00 00 00    	je     6b0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5da:	83 f8 63             	cmp    $0x63,%eax
 5dd:	0f 84 8d 00 00 00    	je     670 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5e3:	83 f8 25             	cmp    $0x25,%eax
 5e6:	0f 84 b4 00 00 00    	je     6a0 <printf+0x150>
  write(fd, &c, 1);
 5ec:	83 ec 04             	sub    $0x4,%esp
 5ef:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5f3:	6a 01                	push   $0x1
 5f5:	57                   	push   %edi
 5f6:	ff 75 08             	pushl  0x8(%ebp)
 5f9:	e8 c5 fd ff ff       	call   3c3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 5fe:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 601:	83 c4 0c             	add    $0xc,%esp
 604:	6a 01                	push   $0x1
 606:	83 c6 01             	add    $0x1,%esi
 609:	57                   	push   %edi
 60a:	ff 75 08             	pushl  0x8(%ebp)
 60d:	e8 b1 fd ff ff       	call   3c3 <write>
  for(i = 0; fmt[i]; i++){
 612:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 616:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 619:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 61b:	84 db                	test   %bl,%bl
 61d:	75 8f                	jne    5ae <printf+0x5e>
    }
  }
}
 61f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 622:	5b                   	pop    %ebx
 623:	5e                   	pop    %esi
 624:	5f                   	pop    %edi
 625:	5d                   	pop    %ebp
 626:	c3                   	ret    
 627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 62e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 630:	83 ec 0c             	sub    $0xc,%esp
 633:	b9 10 00 00 00       	mov    $0x10,%ecx
 638:	6a 00                	push   $0x0
 63a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 63d:	8b 45 08             	mov    0x8(%ebp),%eax
 640:	8b 13                	mov    (%ebx),%edx
 642:	e8 59 fe ff ff       	call   4a0 <printint>
        ap++;
 647:	89 d8                	mov    %ebx,%eax
 649:	83 c4 10             	add    $0x10,%esp
      state = 0;
 64c:	31 d2                	xor    %edx,%edx
        ap++;
 64e:	83 c0 04             	add    $0x4,%eax
 651:	89 45 d0             	mov    %eax,-0x30(%ebp)
 654:	e9 4b ff ff ff       	jmp    5a4 <printf+0x54>
 659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 660:	83 ec 0c             	sub    $0xc,%esp
 663:	b9 0a 00 00 00       	mov    $0xa,%ecx
 668:	6a 01                	push   $0x1
 66a:	eb ce                	jmp    63a <printf+0xea>
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 670:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 673:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 676:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 678:	6a 01                	push   $0x1
        ap++;
 67a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 67d:	57                   	push   %edi
 67e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 681:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 684:	e8 3a fd ff ff       	call   3c3 <write>
        ap++;
 689:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 68c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 68f:	31 d2                	xor    %edx,%edx
 691:	e9 0e ff ff ff       	jmp    5a4 <printf+0x54>
 696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 69d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 6a0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6a3:	83 ec 04             	sub    $0x4,%esp
 6a6:	e9 59 ff ff ff       	jmp    604 <printf+0xb4>
 6ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6af:	90                   	nop
        s = (char*)*ap;
 6b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6b3:	8b 18                	mov    (%eax),%ebx
        ap++;
 6b5:	83 c0 04             	add    $0x4,%eax
 6b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 6bb:	85 db                	test   %ebx,%ebx
 6bd:	74 17                	je     6d6 <printf+0x186>
        while(*s != 0){
 6bf:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 6c2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 6c4:	84 c0                	test   %al,%al
 6c6:	0f 84 d8 fe ff ff    	je     5a4 <printf+0x54>
 6cc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6cf:	89 de                	mov    %ebx,%esi
 6d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6d4:	eb 1a                	jmp    6f0 <printf+0x1a0>
          s = "(null)";
 6d6:	bb db 08 00 00       	mov    $0x8db,%ebx
        while(*s != 0){
 6db:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6de:	b8 28 00 00 00       	mov    $0x28,%eax
 6e3:	89 de                	mov    %ebx,%esi
 6e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ef:	90                   	nop
  write(fd, &c, 1);
 6f0:	83 ec 04             	sub    $0x4,%esp
          s++;
 6f3:	83 c6 01             	add    $0x1,%esi
 6f6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6f9:	6a 01                	push   $0x1
 6fb:	57                   	push   %edi
 6fc:	53                   	push   %ebx
 6fd:	e8 c1 fc ff ff       	call   3c3 <write>
        while(*s != 0){
 702:	0f b6 06             	movzbl (%esi),%eax
 705:	83 c4 10             	add    $0x10,%esp
 708:	84 c0                	test   %al,%al
 70a:	75 e4                	jne    6f0 <printf+0x1a0>
 70c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 70f:	31 d2                	xor    %edx,%edx
 711:	e9 8e fe ff ff       	jmp    5a4 <printf+0x54>
 716:	66 90                	xchg   %ax,%ax
 718:	66 90                	xchg   %ax,%ax
 71a:	66 90                	xchg   %ax,%ax
 71c:	66 90                	xchg   %ax,%ax
 71e:	66 90                	xchg   %ax,%ax

00000720 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 720:	f3 0f 1e fb          	endbr32 
 724:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 725:	a1 9c 0b 00 00       	mov    0xb9c,%eax
{
 72a:	89 e5                	mov    %esp,%ebp
 72c:	57                   	push   %edi
 72d:	56                   	push   %esi
 72e:	53                   	push   %ebx
 72f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 732:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 734:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 737:	39 c8                	cmp    %ecx,%eax
 739:	73 15                	jae    750 <free+0x30>
 73b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 73f:	90                   	nop
 740:	39 d1                	cmp    %edx,%ecx
 742:	72 14                	jb     758 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 744:	39 d0                	cmp    %edx,%eax
 746:	73 10                	jae    758 <free+0x38>
{
 748:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74a:	8b 10                	mov    (%eax),%edx
 74c:	39 c8                	cmp    %ecx,%eax
 74e:	72 f0                	jb     740 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 750:	39 d0                	cmp    %edx,%eax
 752:	72 f4                	jb     748 <free+0x28>
 754:	39 d1                	cmp    %edx,%ecx
 756:	73 f0                	jae    748 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 758:	8b 73 fc             	mov    -0x4(%ebx),%esi
 75b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 75e:	39 fa                	cmp    %edi,%edx
 760:	74 1e                	je     780 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 762:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 765:	8b 50 04             	mov    0x4(%eax),%edx
 768:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 76b:	39 f1                	cmp    %esi,%ecx
 76d:	74 28                	je     797 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 76f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 771:	5b                   	pop    %ebx
  freep = p;
 772:	a3 9c 0b 00 00       	mov    %eax,0xb9c
}
 777:	5e                   	pop    %esi
 778:	5f                   	pop    %edi
 779:	5d                   	pop    %ebp
 77a:	c3                   	ret    
 77b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 77f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 780:	03 72 04             	add    0x4(%edx),%esi
 783:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 786:	8b 10                	mov    (%eax),%edx
 788:	8b 12                	mov    (%edx),%edx
 78a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 78d:	8b 50 04             	mov    0x4(%eax),%edx
 790:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 793:	39 f1                	cmp    %esi,%ecx
 795:	75 d8                	jne    76f <free+0x4f>
    p->s.size += bp->s.size;
 797:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 79a:	a3 9c 0b 00 00       	mov    %eax,0xb9c
    p->s.size += bp->s.size;
 79f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7a5:	89 10                	mov    %edx,(%eax)
}
 7a7:	5b                   	pop    %ebx
 7a8:	5e                   	pop    %esi
 7a9:	5f                   	pop    %edi
 7aa:	5d                   	pop    %ebp
 7ab:	c3                   	ret    
 7ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b0:	f3 0f 1e fb          	endbr32 
 7b4:	55                   	push   %ebp
 7b5:	89 e5                	mov    %esp,%ebp
 7b7:	57                   	push   %edi
 7b8:	56                   	push   %esi
 7b9:	53                   	push   %ebx
 7ba:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7bd:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7c0:	8b 3d 9c 0b 00 00    	mov    0xb9c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c6:	8d 70 07             	lea    0x7(%eax),%esi
 7c9:	c1 ee 03             	shr    $0x3,%esi
 7cc:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 7cf:	85 ff                	test   %edi,%edi
 7d1:	0f 84 a9 00 00 00    	je     880 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 7d9:	8b 48 04             	mov    0x4(%eax),%ecx
 7dc:	39 f1                	cmp    %esi,%ecx
 7de:	73 6d                	jae    84d <malloc+0x9d>
 7e0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 7e6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7eb:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 7ee:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 7f5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 7f8:	eb 17                	jmp    811 <malloc+0x61>
 7fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 800:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 802:	8b 4a 04             	mov    0x4(%edx),%ecx
 805:	39 f1                	cmp    %esi,%ecx
 807:	73 4f                	jae    858 <malloc+0xa8>
 809:	8b 3d 9c 0b 00 00    	mov    0xb9c,%edi
 80f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 811:	39 c7                	cmp    %eax,%edi
 813:	75 eb                	jne    800 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 815:	83 ec 0c             	sub    $0xc,%esp
 818:	ff 75 e4             	pushl  -0x1c(%ebp)
 81b:	e8 0b fc ff ff       	call   42b <sbrk>
  if(p == (char*)-1)
 820:	83 c4 10             	add    $0x10,%esp
 823:	83 f8 ff             	cmp    $0xffffffff,%eax
 826:	74 1b                	je     843 <malloc+0x93>
  hp->s.size = nu;
 828:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 82b:	83 ec 0c             	sub    $0xc,%esp
 82e:	83 c0 08             	add    $0x8,%eax
 831:	50                   	push   %eax
 832:	e8 e9 fe ff ff       	call   720 <free>
  return freep;
 837:	a1 9c 0b 00 00       	mov    0xb9c,%eax
      if((p = morecore(nunits)) == 0)
 83c:	83 c4 10             	add    $0x10,%esp
 83f:	85 c0                	test   %eax,%eax
 841:	75 bd                	jne    800 <malloc+0x50>
        return 0;
  }
}
 843:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 846:	31 c0                	xor    %eax,%eax
}
 848:	5b                   	pop    %ebx
 849:	5e                   	pop    %esi
 84a:	5f                   	pop    %edi
 84b:	5d                   	pop    %ebp
 84c:	c3                   	ret    
    if(p->s.size >= nunits){
 84d:	89 c2                	mov    %eax,%edx
 84f:	89 f8                	mov    %edi,%eax
 851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 858:	39 ce                	cmp    %ecx,%esi
 85a:	74 54                	je     8b0 <malloc+0x100>
        p->s.size -= nunits;
 85c:	29 f1                	sub    %esi,%ecx
 85e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 861:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 864:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 867:	a3 9c 0b 00 00       	mov    %eax,0xb9c
}
 86c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 86f:	8d 42 08             	lea    0x8(%edx),%eax
}
 872:	5b                   	pop    %ebx
 873:	5e                   	pop    %esi
 874:	5f                   	pop    %edi
 875:	5d                   	pop    %ebp
 876:	c3                   	ret    
 877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 87e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 880:	c7 05 9c 0b 00 00 a0 	movl   $0xba0,0xb9c
 887:	0b 00 00 
    base.s.size = 0;
 88a:	bf a0 0b 00 00       	mov    $0xba0,%edi
    base.s.ptr = freep = prevp = &base;
 88f:	c7 05 a0 0b 00 00 a0 	movl   $0xba0,0xba0
 896:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 899:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 89b:	c7 05 a4 0b 00 00 00 	movl   $0x0,0xba4
 8a2:	00 00 00 
    if(p->s.size >= nunits){
 8a5:	e9 36 ff ff ff       	jmp    7e0 <malloc+0x30>
 8aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 8b0:	8b 0a                	mov    (%edx),%ecx
 8b2:	89 08                	mov    %ecx,(%eax)
 8b4:	eb b1                	jmp    867 <malloc+0xb7>
