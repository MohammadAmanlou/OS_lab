
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	be 01 00 00 00       	mov    $0x1,%esi
  18:	53                   	push   %ebx
  19:	51                   	push   %ecx
  1a:	83 ec 18             	sub    $0x18,%esp
  1d:	8b 01                	mov    (%ecx),%eax
  1f:	8b 59 04             	mov    0x4(%ecx),%ebx
  22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  25:	83 c3 04             	add    $0x4,%ebx
  int fd, i;

  if(argc <= 1){
  28:	83 f8 01             	cmp    $0x1,%eax
  2b:	7e 50                	jle    7d <main+0x7d>
  2d:	8d 76 00             	lea    0x0(%esi),%esi
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  30:	83 ec 08             	sub    $0x8,%esp
  33:	6a 00                	push   $0x0
  35:	ff 33                	pushl  (%ebx)
  37:	e8 77 03 00 00       	call   3b3 <open>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	89 c7                	mov    %eax,%edi
  41:	85 c0                	test   %eax,%eax
  43:	78 24                	js     69 <main+0x69>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  45:	83 ec 0c             	sub    $0xc,%esp
  for(i = 1; i < argc; i++){
  48:	83 c6 01             	add    $0x1,%esi
  4b:	83 c3 04             	add    $0x4,%ebx
    cat(fd);
  4e:	50                   	push   %eax
  4f:	e8 3c 00 00 00       	call   90 <cat>
    close(fd);
  54:	89 3c 24             	mov    %edi,(%esp)
  57:	e8 3f 03 00 00       	call   39b <close>
  for(i = 1; i < argc; i++){
  5c:	83 c4 10             	add    $0x10,%esp
  5f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  62:	75 cc                	jne    30 <main+0x30>
  }
  exit();
  64:	e8 0a 03 00 00       	call   373 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  69:	50                   	push   %eax
  6a:	ff 33                	pushl  (%ebx)
  6c:	68 ab 08 00 00       	push   $0x8ab
  71:	6a 01                	push   $0x1
  73:	e8 a8 04 00 00       	call   520 <printf>
      exit();
  78:	e8 f6 02 00 00       	call   373 <exit>
    cat(0);
  7d:	83 ec 0c             	sub    $0xc,%esp
  80:	6a 00                	push   $0x0
  82:	e8 09 00 00 00       	call   90 <cat>
    exit();
  87:	e8 e7 02 00 00       	call   373 <exit>
  8c:	66 90                	xchg   %ax,%ax
  8e:	66 90                	xchg   %ax,%ax

00000090 <cat>:
{
  90:	f3 0f 1e fb          	endbr32 
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	56                   	push   %esi
  98:	8b 75 08             	mov    0x8(%ebp),%esi
  9b:	53                   	push   %ebx
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  9c:	eb 19                	jmp    b7 <cat+0x27>
  9e:	66 90                	xchg   %ax,%ax
    if (write(1, buf, n) != n) {
  a0:	83 ec 04             	sub    $0x4,%esp
  a3:	53                   	push   %ebx
  a4:	68 e0 0b 00 00       	push   $0xbe0
  a9:	6a 01                	push   $0x1
  ab:	e8 e3 02 00 00       	call   393 <write>
  b0:	83 c4 10             	add    $0x10,%esp
  b3:	39 d8                	cmp    %ebx,%eax
  b5:	75 25                	jne    dc <cat+0x4c>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  b7:	83 ec 04             	sub    $0x4,%esp
  ba:	68 00 02 00 00       	push   $0x200
  bf:	68 e0 0b 00 00       	push   $0xbe0
  c4:	56                   	push   %esi
  c5:	e8 c1 02 00 00       	call   38b <read>
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	89 c3                	mov    %eax,%ebx
  cf:	85 c0                	test   %eax,%eax
  d1:	7f cd                	jg     a0 <cat+0x10>
  if(n < 0){
  d3:	75 1b                	jne    f0 <cat+0x60>
}
  d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  d8:	5b                   	pop    %ebx
  d9:	5e                   	pop    %esi
  da:	5d                   	pop    %ebp
  db:	c3                   	ret    
      printf(1, "cat: write error\n");
  dc:	83 ec 08             	sub    $0x8,%esp
  df:	68 88 08 00 00       	push   $0x888
  e4:	6a 01                	push   $0x1
  e6:	e8 35 04 00 00       	call   520 <printf>
      exit();
  eb:	e8 83 02 00 00       	call   373 <exit>
    printf(1, "cat: read error\n");
  f0:	50                   	push   %eax
  f1:	50                   	push   %eax
  f2:	68 9a 08 00 00       	push   $0x89a
  f7:	6a 01                	push   $0x1
  f9:	e8 22 04 00 00       	call   520 <printf>
    exit();
  fe:	e8 70 02 00 00       	call   373 <exit>
 103:	66 90                	xchg   %ax,%ax
 105:	66 90                	xchg   %ax,%ax
 107:	66 90                	xchg   %ax,%ax
 109:	66 90                	xchg   %ax,%ax
 10b:	66 90                	xchg   %ax,%ax
 10d:	66 90                	xchg   %ax,%ax
 10f:	90                   	nop

00000110 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 110:	f3 0f 1e fb          	endbr32 
 114:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 115:	31 c0                	xor    %eax,%eax
{
 117:	89 e5                	mov    %esp,%ebp
 119:	53                   	push   %ebx
 11a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 120:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 124:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 127:	83 c0 01             	add    $0x1,%eax
 12a:	84 d2                	test   %dl,%dl
 12c:	75 f2                	jne    120 <strcpy+0x10>
    ;
  return os;
}
 12e:	89 c8                	mov    %ecx,%eax
 130:	5b                   	pop    %ebx
 131:	5d                   	pop    %ebp
 132:	c3                   	ret    
 133:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000140 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 140:	f3 0f 1e fb          	endbr32 
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	53                   	push   %ebx
 148:	8b 4d 08             	mov    0x8(%ebp),%ecx
 14b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 14e:	0f b6 01             	movzbl (%ecx),%eax
 151:	0f b6 1a             	movzbl (%edx),%ebx
 154:	84 c0                	test   %al,%al
 156:	75 19                	jne    171 <strcmp+0x31>
 158:	eb 26                	jmp    180 <strcmp+0x40>
 15a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 160:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 164:	83 c1 01             	add    $0x1,%ecx
 167:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 16a:	0f b6 1a             	movzbl (%edx),%ebx
 16d:	84 c0                	test   %al,%al
 16f:	74 0f                	je     180 <strcmp+0x40>
 171:	38 d8                	cmp    %bl,%al
 173:	74 eb                	je     160 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 175:	29 d8                	sub    %ebx,%eax
}
 177:	5b                   	pop    %ebx
 178:	5d                   	pop    %ebp
 179:	c3                   	ret    
 17a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 180:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 182:	29 d8                	sub    %ebx,%eax
}
 184:	5b                   	pop    %ebx
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    
 187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18e:	66 90                	xchg   %ax,%ax

00000190 <strlen>:

uint
strlen(const char *s)
{
 190:	f3 0f 1e fb          	endbr32 
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 19a:	80 3a 00             	cmpb   $0x0,(%edx)
 19d:	74 21                	je     1c0 <strlen+0x30>
 19f:	31 c0                	xor    %eax,%eax
 1a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1a8:	83 c0 01             	add    $0x1,%eax
 1ab:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1af:	89 c1                	mov    %eax,%ecx
 1b1:	75 f5                	jne    1a8 <strlen+0x18>
    ;
  return n;
}
 1b3:	89 c8                	mov    %ecx,%eax
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    
 1b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1be:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 1c0:	31 c9                	xor    %ecx,%ecx
}
 1c2:	5d                   	pop    %ebp
 1c3:	89 c8                	mov    %ecx,%eax
 1c5:	c3                   	ret    
 1c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1cd:	8d 76 00             	lea    0x0(%esi),%esi

000001d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d0:	f3 0f 1e fb          	endbr32 
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	57                   	push   %edi
 1d8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1db:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1de:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e1:	89 d7                	mov    %edx,%edi
 1e3:	fc                   	cld    
 1e4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1e6:	89 d0                	mov    %edx,%eax
 1e8:	5f                   	pop    %edi
 1e9:	5d                   	pop    %ebp
 1ea:	c3                   	ret    
 1eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1ef:	90                   	nop

000001f0 <strchr>:

char*
strchr(const char *s, char c)
{
 1f0:	f3 0f 1e fb          	endbr32 
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1fe:	0f b6 10             	movzbl (%eax),%edx
 201:	84 d2                	test   %dl,%dl
 203:	75 16                	jne    21b <strchr+0x2b>
 205:	eb 21                	jmp    228 <strchr+0x38>
 207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20e:	66 90                	xchg   %ax,%ax
 210:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 214:	83 c0 01             	add    $0x1,%eax
 217:	84 d2                	test   %dl,%dl
 219:	74 0d                	je     228 <strchr+0x38>
    if(*s == c)
 21b:	38 d1                	cmp    %dl,%cl
 21d:	75 f1                	jne    210 <strchr+0x20>
      return (char*)s;
  return 0;
}
 21f:	5d                   	pop    %ebp
 220:	c3                   	ret    
 221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 228:	31 c0                	xor    %eax,%eax
}
 22a:	5d                   	pop    %ebp
 22b:	c3                   	ret    
 22c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000230 <gets>:

char*
gets(char *buf, int max)
{
 230:	f3 0f 1e fb          	endbr32 
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	57                   	push   %edi
 238:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 239:	31 f6                	xor    %esi,%esi
{
 23b:	53                   	push   %ebx
 23c:	89 f3                	mov    %esi,%ebx
 23e:	83 ec 1c             	sub    $0x1c,%esp
 241:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 244:	eb 33                	jmp    279 <gets+0x49>
 246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 250:	83 ec 04             	sub    $0x4,%esp
 253:	8d 45 e7             	lea    -0x19(%ebp),%eax
 256:	6a 01                	push   $0x1
 258:	50                   	push   %eax
 259:	6a 00                	push   $0x0
 25b:	e8 2b 01 00 00       	call   38b <read>
    if(cc < 1)
 260:	83 c4 10             	add    $0x10,%esp
 263:	85 c0                	test   %eax,%eax
 265:	7e 1c                	jle    283 <gets+0x53>
      break;
    buf[i++] = c;
 267:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 26b:	83 c7 01             	add    $0x1,%edi
 26e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 271:	3c 0a                	cmp    $0xa,%al
 273:	74 23                	je     298 <gets+0x68>
 275:	3c 0d                	cmp    $0xd,%al
 277:	74 1f                	je     298 <gets+0x68>
  for(i=0; i+1 < max; ){
 279:	83 c3 01             	add    $0x1,%ebx
 27c:	89 fe                	mov    %edi,%esi
 27e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 281:	7c cd                	jl     250 <gets+0x20>
 283:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 285:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 288:	c6 03 00             	movb   $0x0,(%ebx)
}
 28b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 28e:	5b                   	pop    %ebx
 28f:	5e                   	pop    %esi
 290:	5f                   	pop    %edi
 291:	5d                   	pop    %ebp
 292:	c3                   	ret    
 293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 297:	90                   	nop
 298:	8b 75 08             	mov    0x8(%ebp),%esi
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	01 de                	add    %ebx,%esi
 2a0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 2a2:	c6 03 00             	movb   $0x0,(%ebx)
}
 2a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2a8:	5b                   	pop    %ebx
 2a9:	5e                   	pop    %esi
 2aa:	5f                   	pop    %edi
 2ab:	5d                   	pop    %ebp
 2ac:	c3                   	ret    
 2ad:	8d 76 00             	lea    0x0(%esi),%esi

000002b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b0:	f3 0f 1e fb          	endbr32 
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	56                   	push   %esi
 2b8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b9:	83 ec 08             	sub    $0x8,%esp
 2bc:	6a 00                	push   $0x0
 2be:	ff 75 08             	pushl  0x8(%ebp)
 2c1:	e8 ed 00 00 00       	call   3b3 <open>
  if(fd < 0)
 2c6:	83 c4 10             	add    $0x10,%esp
 2c9:	85 c0                	test   %eax,%eax
 2cb:	78 2b                	js     2f8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 2cd:	83 ec 08             	sub    $0x8,%esp
 2d0:	ff 75 0c             	pushl  0xc(%ebp)
 2d3:	89 c3                	mov    %eax,%ebx
 2d5:	50                   	push   %eax
 2d6:	e8 f0 00 00 00       	call   3cb <fstat>
  close(fd);
 2db:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2de:	89 c6                	mov    %eax,%esi
  close(fd);
 2e0:	e8 b6 00 00 00       	call   39b <close>
  return r;
 2e5:	83 c4 10             	add    $0x10,%esp
}
 2e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2eb:	89 f0                	mov    %esi,%eax
 2ed:	5b                   	pop    %ebx
 2ee:	5e                   	pop    %esi
 2ef:	5d                   	pop    %ebp
 2f0:	c3                   	ret    
 2f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 2f8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2fd:	eb e9                	jmp    2e8 <stat+0x38>
 2ff:	90                   	nop

00000300 <atoi>:

int
atoi(const char *s)
{
 300:	f3 0f 1e fb          	endbr32 
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	53                   	push   %ebx
 308:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30b:	0f be 02             	movsbl (%edx),%eax
 30e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 311:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 314:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 319:	77 1a                	ja     335 <atoi+0x35>
 31b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 31f:	90                   	nop
    n = n*10 + *s++ - '0';
 320:	83 c2 01             	add    $0x1,%edx
 323:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 326:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 32a:	0f be 02             	movsbl (%edx),%eax
 32d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 330:	80 fb 09             	cmp    $0x9,%bl
 333:	76 eb                	jbe    320 <atoi+0x20>
  return n;
}
 335:	89 c8                	mov    %ecx,%eax
 337:	5b                   	pop    %ebx
 338:	5d                   	pop    %ebp
 339:	c3                   	ret    
 33a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000340 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 340:	f3 0f 1e fb          	endbr32 
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	57                   	push   %edi
 348:	8b 45 10             	mov    0x10(%ebp),%eax
 34b:	8b 55 08             	mov    0x8(%ebp),%edx
 34e:	56                   	push   %esi
 34f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 352:	85 c0                	test   %eax,%eax
 354:	7e 0f                	jle    365 <memmove+0x25>
 356:	01 d0                	add    %edx,%eax
  dst = vdst;
 358:	89 d7                	mov    %edx,%edi
 35a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 360:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 361:	39 f8                	cmp    %edi,%eax
 363:	75 fb                	jne    360 <memmove+0x20>
  return vdst;
}
 365:	5e                   	pop    %esi
 366:	89 d0                	mov    %edx,%eax
 368:	5f                   	pop    %edi
 369:	5d                   	pop    %ebp
 36a:	c3                   	ret    

0000036b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 36b:	b8 01 00 00 00       	mov    $0x1,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <exit>:
SYSCALL(exit)
 373:	b8 02 00 00 00       	mov    $0x2,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <wait>:
SYSCALL(wait)
 37b:	b8 03 00 00 00       	mov    $0x3,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <pipe>:
SYSCALL(pipe)
 383:	b8 04 00 00 00       	mov    $0x4,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <read>:
SYSCALL(read)
 38b:	b8 05 00 00 00       	mov    $0x5,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <write>:
SYSCALL(write)
 393:	b8 10 00 00 00       	mov    $0x10,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <close>:
SYSCALL(close)
 39b:	b8 15 00 00 00       	mov    $0x15,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <kill>:
SYSCALL(kill)
 3a3:	b8 06 00 00 00       	mov    $0x6,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <exec>:
SYSCALL(exec)
 3ab:	b8 07 00 00 00       	mov    $0x7,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <open>:
SYSCALL(open)
 3b3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <mknod>:
SYSCALL(mknod)
 3bb:	b8 11 00 00 00       	mov    $0x11,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <unlink>:
SYSCALL(unlink)
 3c3:	b8 12 00 00 00       	mov    $0x12,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <fstat>:
SYSCALL(fstat)
 3cb:	b8 08 00 00 00       	mov    $0x8,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <link>:
SYSCALL(link)
 3d3:	b8 13 00 00 00       	mov    $0x13,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <mkdir>:
SYSCALL(mkdir)
 3db:	b8 14 00 00 00       	mov    $0x14,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <chdir>:
SYSCALL(chdir)
 3e3:	b8 09 00 00 00       	mov    $0x9,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <dup>:
SYSCALL(dup)
 3eb:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <getpid>:
SYSCALL(getpid)
 3f3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <sbrk>:
SYSCALL(sbrk)
 3fb:	b8 0c 00 00 00       	mov    $0xc,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <sleep>:
SYSCALL(sleep)
 403:	b8 0d 00 00 00       	mov    $0xd,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <uptime>:
SYSCALL(uptime)
 40b:	b8 0e 00 00 00       	mov    $0xe,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <find_digital_root>:
SYSCALL(find_digital_root)
 413:	b8 16 00 00 00       	mov    $0x16,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <get_process_lifetime>:
SYSCALL(get_process_lifetime)
 41b:	b8 17 00 00 00       	mov    $0x17,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <copy_file>:
SYSCALL(copy_file)
 423:	b8 18 00 00 00       	mov    $0x18,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <get_uncle_count>:
SYSCALL(get_uncle_count)
 42b:	b8 19 00 00 00       	mov    $0x19,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <change_sched_Q>:
SYSCALL(change_sched_Q)
 433:	b8 1b 00 00 00       	mov    $0x1b,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <show_process_info>:
SYSCALL(show_process_info)
 43b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <set_proc_bjf_params>:
SYSCALL(set_proc_bjf_params)
 443:	b8 1d 00 00 00       	mov    $0x1d,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <set_system_bjf_params>:
SYSCALL(set_system_bjf_params)
 44b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <priorityLock_test>:
SYSCALL(priorityLock_test)
 453:	b8 1e 00 00 00       	mov    $0x1e,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <syscalls_count>:
SYSCALL(syscalls_count)
 45b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    
 463:	66 90                	xchg   %ax,%ax
 465:	66 90                	xchg   %ax,%ax
 467:	66 90                	xchg   %ax,%ax
 469:	66 90                	xchg   %ax,%ax
 46b:	66 90                	xchg   %ax,%ax
 46d:	66 90                	xchg   %ax,%ax
 46f:	90                   	nop

00000470 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
 476:	83 ec 3c             	sub    $0x3c,%esp
 479:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 47c:	89 d1                	mov    %edx,%ecx
{
 47e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 481:	85 d2                	test   %edx,%edx
 483:	0f 89 7f 00 00 00    	jns    508 <printint+0x98>
 489:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 48d:	74 79                	je     508 <printint+0x98>
    neg = 1;
 48f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 496:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 498:	31 db                	xor    %ebx,%ebx
 49a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 49d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 4a0:	89 c8                	mov    %ecx,%eax
 4a2:	31 d2                	xor    %edx,%edx
 4a4:	89 cf                	mov    %ecx,%edi
 4a6:	f7 75 c4             	divl   -0x3c(%ebp)
 4a9:	0f b6 92 c8 08 00 00 	movzbl 0x8c8(%edx),%edx
 4b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 4b3:	89 d8                	mov    %ebx,%eax
 4b5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 4b8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 4bb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 4be:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 4c1:	76 dd                	jbe    4a0 <printint+0x30>
  if(neg)
 4c3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 4c6:	85 c9                	test   %ecx,%ecx
 4c8:	74 0c                	je     4d6 <printint+0x66>
    buf[i++] = '-';
 4ca:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 4cf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 4d1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 4d6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 4d9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 4dd:	eb 07                	jmp    4e6 <printint+0x76>
 4df:	90                   	nop
 4e0:	0f b6 13             	movzbl (%ebx),%edx
 4e3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 4e6:	83 ec 04             	sub    $0x4,%esp
 4e9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 4ec:	6a 01                	push   $0x1
 4ee:	56                   	push   %esi
 4ef:	57                   	push   %edi
 4f0:	e8 9e fe ff ff       	call   393 <write>
  while(--i >= 0)
 4f5:	83 c4 10             	add    $0x10,%esp
 4f8:	39 de                	cmp    %ebx,%esi
 4fa:	75 e4                	jne    4e0 <printint+0x70>
    putc(fd, buf[i]);
}
 4fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ff:	5b                   	pop    %ebx
 500:	5e                   	pop    %esi
 501:	5f                   	pop    %edi
 502:	5d                   	pop    %ebp
 503:	c3                   	ret    
 504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 508:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 50f:	eb 87                	jmp    498 <printint+0x28>
 511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 51f:	90                   	nop

00000520 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 520:	f3 0f 1e fb          	endbr32 
 524:	55                   	push   %ebp
 525:	89 e5                	mov    %esp,%ebp
 527:	57                   	push   %edi
 528:	56                   	push   %esi
 529:	53                   	push   %ebx
 52a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 52d:	8b 75 0c             	mov    0xc(%ebp),%esi
 530:	0f b6 1e             	movzbl (%esi),%ebx
 533:	84 db                	test   %bl,%bl
 535:	0f 84 b4 00 00 00    	je     5ef <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 53b:	8d 45 10             	lea    0x10(%ebp),%eax
 53e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 541:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 544:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 546:	89 45 d0             	mov    %eax,-0x30(%ebp)
 549:	eb 33                	jmp    57e <printf+0x5e>
 54b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 54f:	90                   	nop
 550:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 553:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 558:	83 f8 25             	cmp    $0x25,%eax
 55b:	74 17                	je     574 <printf+0x54>
  write(fd, &c, 1);
 55d:	83 ec 04             	sub    $0x4,%esp
 560:	88 5d e7             	mov    %bl,-0x19(%ebp)
 563:	6a 01                	push   $0x1
 565:	57                   	push   %edi
 566:	ff 75 08             	pushl  0x8(%ebp)
 569:	e8 25 fe ff ff       	call   393 <write>
 56e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 571:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 574:	0f b6 1e             	movzbl (%esi),%ebx
 577:	83 c6 01             	add    $0x1,%esi
 57a:	84 db                	test   %bl,%bl
 57c:	74 71                	je     5ef <printf+0xcf>
    c = fmt[i] & 0xff;
 57e:	0f be cb             	movsbl %bl,%ecx
 581:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 584:	85 d2                	test   %edx,%edx
 586:	74 c8                	je     550 <printf+0x30>
      }
    } else if(state == '%'){
 588:	83 fa 25             	cmp    $0x25,%edx
 58b:	75 e7                	jne    574 <printf+0x54>
      if(c == 'd'){
 58d:	83 f8 64             	cmp    $0x64,%eax
 590:	0f 84 9a 00 00 00    	je     630 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 596:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 59c:	83 f9 70             	cmp    $0x70,%ecx
 59f:	74 5f                	je     600 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5a1:	83 f8 73             	cmp    $0x73,%eax
 5a4:	0f 84 d6 00 00 00    	je     680 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5aa:	83 f8 63             	cmp    $0x63,%eax
 5ad:	0f 84 8d 00 00 00    	je     640 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5b3:	83 f8 25             	cmp    $0x25,%eax
 5b6:	0f 84 b4 00 00 00    	je     670 <printf+0x150>
  write(fd, &c, 1);
 5bc:	83 ec 04             	sub    $0x4,%esp
 5bf:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5c3:	6a 01                	push   $0x1
 5c5:	57                   	push   %edi
 5c6:	ff 75 08             	pushl  0x8(%ebp)
 5c9:	e8 c5 fd ff ff       	call   393 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 5ce:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5d1:	83 c4 0c             	add    $0xc,%esp
 5d4:	6a 01                	push   $0x1
 5d6:	83 c6 01             	add    $0x1,%esi
 5d9:	57                   	push   %edi
 5da:	ff 75 08             	pushl  0x8(%ebp)
 5dd:	e8 b1 fd ff ff       	call   393 <write>
  for(i = 0; fmt[i]; i++){
 5e2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 5e6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5e9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 5eb:	84 db                	test   %bl,%bl
 5ed:	75 8f                	jne    57e <printf+0x5e>
    }
  }
}
 5ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5f2:	5b                   	pop    %ebx
 5f3:	5e                   	pop    %esi
 5f4:	5f                   	pop    %edi
 5f5:	5d                   	pop    %ebp
 5f6:	c3                   	ret    
 5f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5fe:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 600:	83 ec 0c             	sub    $0xc,%esp
 603:	b9 10 00 00 00       	mov    $0x10,%ecx
 608:	6a 00                	push   $0x0
 60a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 60d:	8b 45 08             	mov    0x8(%ebp),%eax
 610:	8b 13                	mov    (%ebx),%edx
 612:	e8 59 fe ff ff       	call   470 <printint>
        ap++;
 617:	89 d8                	mov    %ebx,%eax
 619:	83 c4 10             	add    $0x10,%esp
      state = 0;
 61c:	31 d2                	xor    %edx,%edx
        ap++;
 61e:	83 c0 04             	add    $0x4,%eax
 621:	89 45 d0             	mov    %eax,-0x30(%ebp)
 624:	e9 4b ff ff ff       	jmp    574 <printf+0x54>
 629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 630:	83 ec 0c             	sub    $0xc,%esp
 633:	b9 0a 00 00 00       	mov    $0xa,%ecx
 638:	6a 01                	push   $0x1
 63a:	eb ce                	jmp    60a <printf+0xea>
 63c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 640:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 643:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 646:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 648:	6a 01                	push   $0x1
        ap++;
 64a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 64d:	57                   	push   %edi
 64e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 651:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 654:	e8 3a fd ff ff       	call   393 <write>
        ap++;
 659:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 65c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 65f:	31 d2                	xor    %edx,%edx
 661:	e9 0e ff ff ff       	jmp    574 <printf+0x54>
 666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 670:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 673:	83 ec 04             	sub    $0x4,%esp
 676:	e9 59 ff ff ff       	jmp    5d4 <printf+0xb4>
 67b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 67f:	90                   	nop
        s = (char*)*ap;
 680:	8b 45 d0             	mov    -0x30(%ebp),%eax
 683:	8b 18                	mov    (%eax),%ebx
        ap++;
 685:	83 c0 04             	add    $0x4,%eax
 688:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 68b:	85 db                	test   %ebx,%ebx
 68d:	74 17                	je     6a6 <printf+0x186>
        while(*s != 0){
 68f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 692:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 694:	84 c0                	test   %al,%al
 696:	0f 84 d8 fe ff ff    	je     574 <printf+0x54>
 69c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 69f:	89 de                	mov    %ebx,%esi
 6a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6a4:	eb 1a                	jmp    6c0 <printf+0x1a0>
          s = "(null)";
 6a6:	bb c0 08 00 00       	mov    $0x8c0,%ebx
        while(*s != 0){
 6ab:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6ae:	b8 28 00 00 00       	mov    $0x28,%eax
 6b3:	89 de                	mov    %ebx,%esi
 6b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6bf:	90                   	nop
  write(fd, &c, 1);
 6c0:	83 ec 04             	sub    $0x4,%esp
          s++;
 6c3:	83 c6 01             	add    $0x1,%esi
 6c6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6c9:	6a 01                	push   $0x1
 6cb:	57                   	push   %edi
 6cc:	53                   	push   %ebx
 6cd:	e8 c1 fc ff ff       	call   393 <write>
        while(*s != 0){
 6d2:	0f b6 06             	movzbl (%esi),%eax
 6d5:	83 c4 10             	add    $0x10,%esp
 6d8:	84 c0                	test   %al,%al
 6da:	75 e4                	jne    6c0 <printf+0x1a0>
 6dc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 6df:	31 d2                	xor    %edx,%edx
 6e1:	e9 8e fe ff ff       	jmp    574 <printf+0x54>
 6e6:	66 90                	xchg   %ax,%ax
 6e8:	66 90                	xchg   %ax,%ax
 6ea:	66 90                	xchg   %ax,%ax
 6ec:	66 90                	xchg   %ax,%ax
 6ee:	66 90                	xchg   %ax,%ax

000006f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f0:	f3 0f 1e fb          	endbr32 
 6f4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f5:	a1 c0 0b 00 00       	mov    0xbc0,%eax
{
 6fa:	89 e5                	mov    %esp,%ebp
 6fc:	57                   	push   %edi
 6fd:	56                   	push   %esi
 6fe:	53                   	push   %ebx
 6ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
 702:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 704:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 707:	39 c8                	cmp    %ecx,%eax
 709:	73 15                	jae    720 <free+0x30>
 70b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 70f:	90                   	nop
 710:	39 d1                	cmp    %edx,%ecx
 712:	72 14                	jb     728 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 714:	39 d0                	cmp    %edx,%eax
 716:	73 10                	jae    728 <free+0x38>
{
 718:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71a:	8b 10                	mov    (%eax),%edx
 71c:	39 c8                	cmp    %ecx,%eax
 71e:	72 f0                	jb     710 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	39 d0                	cmp    %edx,%eax
 722:	72 f4                	jb     718 <free+0x28>
 724:	39 d1                	cmp    %edx,%ecx
 726:	73 f0                	jae    718 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 728:	8b 73 fc             	mov    -0x4(%ebx),%esi
 72b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 72e:	39 fa                	cmp    %edi,%edx
 730:	74 1e                	je     750 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 732:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 735:	8b 50 04             	mov    0x4(%eax),%edx
 738:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 73b:	39 f1                	cmp    %esi,%ecx
 73d:	74 28                	je     767 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 73f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 741:	5b                   	pop    %ebx
  freep = p;
 742:	a3 c0 0b 00 00       	mov    %eax,0xbc0
}
 747:	5e                   	pop    %esi
 748:	5f                   	pop    %edi
 749:	5d                   	pop    %ebp
 74a:	c3                   	ret    
 74b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 74f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 750:	03 72 04             	add    0x4(%edx),%esi
 753:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 756:	8b 10                	mov    (%eax),%edx
 758:	8b 12                	mov    (%edx),%edx
 75a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 75d:	8b 50 04             	mov    0x4(%eax),%edx
 760:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 763:	39 f1                	cmp    %esi,%ecx
 765:	75 d8                	jne    73f <free+0x4f>
    p->s.size += bp->s.size;
 767:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 76a:	a3 c0 0b 00 00       	mov    %eax,0xbc0
    p->s.size += bp->s.size;
 76f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 772:	8b 53 f8             	mov    -0x8(%ebx),%edx
 775:	89 10                	mov    %edx,(%eax)
}
 777:	5b                   	pop    %ebx
 778:	5e                   	pop    %esi
 779:	5f                   	pop    %edi
 77a:	5d                   	pop    %ebp
 77b:	c3                   	ret    
 77c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000780 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 780:	f3 0f 1e fb          	endbr32 
 784:	55                   	push   %ebp
 785:	89 e5                	mov    %esp,%ebp
 787:	57                   	push   %edi
 788:	56                   	push   %esi
 789:	53                   	push   %ebx
 78a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 790:	8b 3d c0 0b 00 00    	mov    0xbc0,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 796:	8d 70 07             	lea    0x7(%eax),%esi
 799:	c1 ee 03             	shr    $0x3,%esi
 79c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 79f:	85 ff                	test   %edi,%edi
 7a1:	0f 84 a9 00 00 00    	je     850 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 7a9:	8b 48 04             	mov    0x4(%eax),%ecx
 7ac:	39 f1                	cmp    %esi,%ecx
 7ae:	73 6d                	jae    81d <malloc+0x9d>
 7b0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 7b6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7bb:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 7be:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 7c5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 7c8:	eb 17                	jmp    7e1 <malloc+0x61>
 7ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 7d2:	8b 4a 04             	mov    0x4(%edx),%ecx
 7d5:	39 f1                	cmp    %esi,%ecx
 7d7:	73 4f                	jae    828 <malloc+0xa8>
 7d9:	8b 3d c0 0b 00 00    	mov    0xbc0,%edi
 7df:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e1:	39 c7                	cmp    %eax,%edi
 7e3:	75 eb                	jne    7d0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 7e5:	83 ec 0c             	sub    $0xc,%esp
 7e8:	ff 75 e4             	pushl  -0x1c(%ebp)
 7eb:	e8 0b fc ff ff       	call   3fb <sbrk>
  if(p == (char*)-1)
 7f0:	83 c4 10             	add    $0x10,%esp
 7f3:	83 f8 ff             	cmp    $0xffffffff,%eax
 7f6:	74 1b                	je     813 <malloc+0x93>
  hp->s.size = nu;
 7f8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7fb:	83 ec 0c             	sub    $0xc,%esp
 7fe:	83 c0 08             	add    $0x8,%eax
 801:	50                   	push   %eax
 802:	e8 e9 fe ff ff       	call   6f0 <free>
  return freep;
 807:	a1 c0 0b 00 00       	mov    0xbc0,%eax
      if((p = morecore(nunits)) == 0)
 80c:	83 c4 10             	add    $0x10,%esp
 80f:	85 c0                	test   %eax,%eax
 811:	75 bd                	jne    7d0 <malloc+0x50>
        return 0;
  }
}
 813:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 816:	31 c0                	xor    %eax,%eax
}
 818:	5b                   	pop    %ebx
 819:	5e                   	pop    %esi
 81a:	5f                   	pop    %edi
 81b:	5d                   	pop    %ebp
 81c:	c3                   	ret    
    if(p->s.size >= nunits){
 81d:	89 c2                	mov    %eax,%edx
 81f:	89 f8                	mov    %edi,%eax
 821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 828:	39 ce                	cmp    %ecx,%esi
 82a:	74 54                	je     880 <malloc+0x100>
        p->s.size -= nunits;
 82c:	29 f1                	sub    %esi,%ecx
 82e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 831:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 834:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 837:	a3 c0 0b 00 00       	mov    %eax,0xbc0
}
 83c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 83f:	8d 42 08             	lea    0x8(%edx),%eax
}
 842:	5b                   	pop    %ebx
 843:	5e                   	pop    %esi
 844:	5f                   	pop    %edi
 845:	5d                   	pop    %ebp
 846:	c3                   	ret    
 847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 84e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 850:	c7 05 c0 0b 00 00 c4 	movl   $0xbc4,0xbc0
 857:	0b 00 00 
    base.s.size = 0;
 85a:	bf c4 0b 00 00       	mov    $0xbc4,%edi
    base.s.ptr = freep = prevp = &base;
 85f:	c7 05 c4 0b 00 00 c4 	movl   $0xbc4,0xbc4
 866:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 869:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 86b:	c7 05 c8 0b 00 00 00 	movl   $0x0,0xbc8
 872:	00 00 00 
    if(p->s.size >= nunits){
 875:	e9 36 ff ff ff       	jmp    7b0 <malloc+0x30>
 87a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 880:	8b 0a                	mov    (%edx),%ecx
 882:	89 08                	mov    %ecx,(%eax)
 884:	eb b1                	jmp    837 <malloc+0xb7>
