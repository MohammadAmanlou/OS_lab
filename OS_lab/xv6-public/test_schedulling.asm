
_test_schedulling:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    printf(1, "  set_process_bjf <pid> <priority_ratio> <arrival_time_ratio> <executed_cycle_ratio> <process_size_ratio>\n");
    printf(1, "  set_system_bjf <priority_ratio> <arrival_time_ratio> <executed_cycle_ratio> <process_size_ratio>\n");
    exit();
}
int main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 18             	sub    $0x18,%esp
  18:	8b 31                	mov    (%ecx),%esi
  1a:	8b 59 04             	mov    0x4(%ecx),%ebx
    if (argc < 2)
  1d:	83 fe 01             	cmp    $0x1,%esi
  20:	7e 55                	jle    77 <main+0x77>
        wrong_command();

    if (!strcmp(argv[1], "info"))
  22:	50                   	push   %eax
  23:	50                   	push   %eax
  24:	68 81 0b 00 00       	push   $0xb81
  29:	ff 73 04             	pushl  0x4(%ebx)
  2c:	e8 6f 03 00 00       	call   3a0 <strcmp>
  31:	83 c4 10             	add    $0x10,%esp
  34:	85 c0                	test   %eax,%eax
  36:	75 0a                	jne    42 <main+0x42>
    show_process_info();
  38:	e8 5e 06 00 00       	call   69b <show_process_info>
            wrong_command();
        set_bjf_params(0,atoi(argv[2]), atoi(argv[3]), atoi(argv[4]),atoi(argv[5]),1);
    }


    exit();
  3d:	e8 91 05 00 00       	call   5d3 <exit>
    else if (!strcmp(argv[1], "set_queue"))
  42:	57                   	push   %edi
  43:	57                   	push   %edi
  44:	68 86 0b 00 00       	push   $0xb86
  49:	ff 73 04             	pushl  0x4(%ebx)
  4c:	e8 4f 03 00 00       	call   3a0 <strcmp>
  51:	83 c4 10             	add    $0x10,%esp
  54:	85 c0                	test   %eax,%eax
  56:	74 24                	je     7c <main+0x7c>
    else if (!strcmp(argv[1], "set_process_bjf"))
  58:	57                   	push   %edi
  59:	57                   	push   %edi
  5a:	68 90 0b 00 00       	push   $0xb90
  5f:	ff 73 04             	pushl  0x4(%ebx)
  62:	e8 39 03 00 00       	call   3a0 <strcmp>
  67:	83 c4 10             	add    $0x10,%esp
  6a:	85 c0                	test   %eax,%eax
  6c:	0f 85 88 00 00 00    	jne    fa <main+0xfa>
        if (argc < 7)
  72:	83 fe 06             	cmp    $0x6,%esi
  75:	7f 2e                	jg     a5 <main+0xa5>
        wrong_command();
  77:	e8 84 02 00 00       	call   300 <wrong_command>
        if (argc < 4)
  7c:	83 fe 03             	cmp    $0x3,%esi
  7f:	7e f6                	jle    77 <main+0x77>
        set_Q(atoi(argv[2]), atoi(argv[3]));
  81:	83 ec 0c             	sub    $0xc,%esp
  84:	ff 73 0c             	pushl  0xc(%ebx)
  87:	e8 d4 04 00 00       	call   560 <atoi>
  8c:	89 c6                	mov    %eax,%esi
  8e:	58                   	pop    %eax
  8f:	ff 73 08             	pushl  0x8(%ebx)
  92:	e8 c9 04 00 00       	call   560 <atoi>
  97:	5a                   	pop    %edx
  98:	59                   	pop    %ecx
  99:	56                   	push   %esi
  9a:	50                   	push   %eax
  9b:	e8 e0 00 00 00       	call   180 <set_Q>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	eb 98                	jmp    3d <main+0x3d>
        set_bjf_params(atoi(argv[2]), atoi(argv[3]), atoi(argv[4]), atoi(argv[5]),atoi(argv[6]),0);
  a5:	83 ec 0c             	sub    $0xc,%esp
  a8:	ff 73 18             	pushl  0x18(%ebx)
  ab:	e8 b0 04 00 00       	call   560 <atoi>
  b0:	5e                   	pop    %esi
  b1:	ff 73 14             	pushl  0x14(%ebx)
  b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  b7:	e8 a4 04 00 00       	call   560 <atoi>
  bc:	5f                   	pop    %edi
  bd:	ff 73 10             	pushl  0x10(%ebx)
  c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  c3:	e8 98 04 00 00       	call   560 <atoi>
  c8:	89 c7                	mov    %eax,%edi
  ca:	58                   	pop    %eax
  cb:	ff 73 0c             	pushl  0xc(%ebx)
  ce:	e8 8d 04 00 00       	call   560 <atoi>
  d3:	89 c6                	mov    %eax,%esi
  d5:	58                   	pop    %eax
  d6:	ff 73 08             	pushl  0x8(%ebx)
  d9:	e8 82 04 00 00       	call   560 <atoi>
  de:	5a                   	pop    %edx
  df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  e2:	59                   	pop    %ecx
  e3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  e6:	6a 00                	push   $0x0
  e8:	51                   	push   %ecx
  e9:	52                   	push   %edx
  ea:	57                   	push   %edi
  eb:	56                   	push   %esi
  ec:	50                   	push   %eax
  ed:	e8 1e 01 00 00       	call   210 <set_bjf_params>
  f2:	83 c4 20             	add    $0x20,%esp
  f5:	e9 43 ff ff ff       	jmp    3d <main+0x3d>
    else if (!strcmp(argv[1], "set_system_bjf"))
  fa:	51                   	push   %ecx
  fb:	51                   	push   %ecx
  fc:	68 a0 0b 00 00       	push   $0xba0
 101:	ff 73 04             	pushl  0x4(%ebx)
 104:	e8 97 02 00 00       	call   3a0 <strcmp>
 109:	83 c4 10             	add    $0x10,%esp
 10c:	85 c0                	test   %eax,%eax
 10e:	0f 85 29 ff ff ff    	jne    3d <main+0x3d>
        if (argc < 6)
 114:	83 fe 05             	cmp    $0x5,%esi
 117:	0f 8e 5a ff ff ff    	jle    77 <main+0x77>
        set_bjf_params(0,atoi(argv[2]), atoi(argv[3]), atoi(argv[4]),atoi(argv[5]),1);
 11d:	83 ec 0c             	sub    $0xc,%esp
 120:	ff 73 14             	pushl  0x14(%ebx)
 123:	e8 38 04 00 00       	call   560 <atoi>
 128:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 12b:	58                   	pop    %eax
 12c:	ff 73 10             	pushl  0x10(%ebx)
 12f:	e8 2c 04 00 00       	call   560 <atoi>
 134:	5a                   	pop    %edx
 135:	ff 73 0c             	pushl  0xc(%ebx)
 138:	89 c7                	mov    %eax,%edi
 13a:	e8 21 04 00 00       	call   560 <atoi>
 13f:	59                   	pop    %ecx
 140:	ff 73 08             	pushl  0x8(%ebx)
 143:	89 c6                	mov    %eax,%esi
 145:	e8 16 04 00 00       	call   560 <atoi>
 14a:	5b                   	pop    %ebx
 14b:	5a                   	pop    %edx
 14c:	6a 01                	push   $0x1
 14e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 151:	52                   	push   %edx
 152:	57                   	push   %edi
 153:	56                   	push   %esi
 154:	50                   	push   %eax
 155:	6a 00                	push   $0x0
 157:	e8 b4 00 00 00       	call   210 <set_bjf_params>
 15c:	83 c4 20             	add    $0x20,%esp
 15f:	e9 d9 fe ff ff       	jmp    3d <main+0x3d>
 164:	66 90                	xchg   %ax,%ax
 166:	66 90                	xchg   %ax,%ax
 168:	66 90                	xchg   %ax,%ax
 16a:	66 90                	xchg   %ax,%ax
 16c:	66 90                	xchg   %ax,%ax
 16e:	66 90                	xchg   %ax,%ax

00000170 <print_info>:
{
 170:	f3 0f 1e fb          	endbr32 
    show_process_info();
 174:	e9 22 05 00 00       	jmp    69b <show_process_info>
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000180 <set_Q>:
{
 180:	f3 0f 1e fb          	endbr32 
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	83 ec 08             	sub    $0x8,%esp
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	8b 55 0c             	mov    0xc(%ebp),%edx
    if (pid < 1)
 190:	85 c0                	test   %eax,%eax
 192:	7e 64                	jle    1f8 <set_Q+0x78>
    if (new_queue < 1 || new_queue > 3)
 194:	8d 4a ff             	lea    -0x1(%edx),%ecx
 197:	83 f9 02             	cmp    $0x2,%ecx
 19a:	77 44                	ja     1e0 <set_Q+0x60>
    int res = change_sched_Q(pid, new_queue);
 19c:	83 ec 08             	sub    $0x8,%esp
 19f:	52                   	push   %edx
 1a0:	50                   	push   %eax
 1a1:	e8 ed 04 00 00       	call   693 <change_sched_Q>
    if (res < 0)
 1a6:	83 c4 10             	add    $0x10,%esp
 1a9:	85 c0                	test   %eax,%eax
 1ab:	78 1b                	js     1c8 <set_Q+0x48>
        printf(1, "Queue changed successfully\n");
 1ad:	c7 45 0c 1a 0b 00 00 	movl   $0xb1a,0xc(%ebp)
 1b4:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
}
 1bb:	c9                   	leave  
        printf(1, "Queue changed successfully\n");
 1bc:	e9 bf 05 00 00       	jmp    780 <printf>
 1c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "Error changing queue\n");
 1c8:	c7 45 0c 04 0b 00 00 	movl   $0xb04,0xc(%ebp)
 1cf:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
}
 1d6:	c9                   	leave  
        printf(1, "Error changing queue\n");
 1d7:	e9 a4 05 00 00       	jmp    780 <printf>
 1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "Invalid queue\n");
 1e0:	c7 45 0c f5 0a 00 00 	movl   $0xaf5,0xc(%ebp)
 1e7:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
}
 1ee:	c9                   	leave  
        printf(1, "Invalid queue\n");
 1ef:	e9 8c 05 00 00       	jmp    780 <printf>
 1f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "Invalid pid\n");
 1f8:	c7 45 0c e8 0a 00 00 	movl   $0xae8,0xc(%ebp)
 1ff:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
}
 206:	c9                   	leave  
        printf(1, "Invalid pid\n");
 207:	e9 74 05 00 00       	jmp    780 <printf>
 20c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000210 <set_bjf_params>:
{
 210:	f3 0f 1e fb          	endbr32 
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	57                   	push   %edi
 218:	56                   	push   %esi
 219:	53                   	push   %ebx
 21a:	83 ec 1c             	sub    $0x1c,%esp
 21d:	8b 45 0c             	mov    0xc(%ebp),%eax
 220:	8b 75 08             	mov    0x8(%ebp),%esi
 223:	8b 55 10             	mov    0x10(%ebp),%edx
 226:	8b 4d 14             	mov    0x14(%ebp),%ecx
 229:	8b 5d 18             	mov    0x18(%ebp),%ebx
 22c:	8b 7d 1c             	mov    0x1c(%ebp),%edi
    if (priority_ratio < 0 || arrival_time_ratio < 0 || executed_cycle_ratio < 0 || process_size_ratio < 0)
 22f:	85 c0                	test   %eax,%eax
 231:	78 6d                	js     2a0 <set_bjf_params+0x90>
 233:	85 d2                	test   %edx,%edx
 235:	78 69                	js     2a0 <set_bjf_params+0x90>
 237:	85 c9                	test   %ecx,%ecx
 239:	78 65                	js     2a0 <set_bjf_params+0x90>
 23b:	85 db                	test   %ebx,%ebx
 23d:	78 61                	js     2a0 <set_bjf_params+0x90>
    if (system)
 23f:	85 ff                	test   %edi,%edi
 241:	75 6d                	jne    2b0 <set_bjf_params+0xa0>
    else if (pid < 1)
 243:	85 f6                	test   %esi,%esi
 245:	0f 8e a5 00 00 00    	jle    2f0 <set_bjf_params+0xe0>
        res = set_proc_bjf_params(pid, priority_ratio, arrival_time_ratio, executed_cycle_ratio, process_size_ratio);
 24b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
 24e:	db 45 e4             	fildl  -0x1c(%ebp)
 251:	83 ec 1c             	sub    $0x1c,%esp
 254:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 257:	d9 5c 24 0c          	fstps  0xc(%esp)
 25b:	db 45 e4             	fildl  -0x1c(%ebp)
 25e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 261:	d9 5c 24 08          	fstps  0x8(%esp)
 265:	db 45 e4             	fildl  -0x1c(%ebp)
 268:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 26b:	d9 5c 24 04          	fstps  0x4(%esp)
 26f:	db 45 e4             	fildl  -0x1c(%ebp)
 272:	d9 1c 24             	fstps  (%esp)
 275:	56                   	push   %esi
 276:	e8 28 04 00 00       	call   6a3 <set_proc_bjf_params>
 27b:	83 c4 20             	add    $0x20,%esp
    if (res < 0)
 27e:	85 c0                	test   %eax,%eax
 280:	78 64                	js     2e6 <set_bjf_params+0xd6>
        printf(1, "BJF params has been set successfully\n");
 282:	c7 45 0c b0 0b 00 00 	movl   $0xbb0,0xc(%ebp)
 289:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
}
 290:	8d 65 f4             	lea    -0xc(%ebp),%esp
 293:	5b                   	pop    %ebx
 294:	5e                   	pop    %esi
 295:	5f                   	pop    %edi
 296:	5d                   	pop    %ebp
        printf(1, "BJF params has been set successfully\n");
 297:	e9 e4 04 00 00       	jmp    780 <printf>
 29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "Invalid ratios\n");
 2a0:	c7 45 0c 36 0b 00 00 	movl   $0xb36,0xc(%ebp)
 2a7:	eb e0                	jmp    289 <set_bjf_params+0x79>
 2a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        res = set_system_bjf_params(priority_ratio, arrival_time_ratio, executed_cycle_ratio, process_size_ratio);
 2b0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
 2b3:	db 45 e4             	fildl  -0x1c(%ebp)
 2b6:	83 ec 10             	sub    $0x10,%esp
 2b9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 2bc:	d9 5c 24 0c          	fstps  0xc(%esp)
 2c0:	db 45 e4             	fildl  -0x1c(%ebp)
 2c3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 2c6:	d9 5c 24 08          	fstps  0x8(%esp)
 2ca:	db 45 e4             	fildl  -0x1c(%ebp)
 2cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 2d0:	d9 5c 24 04          	fstps  0x4(%esp)
 2d4:	db 45 e4             	fildl  -0x1c(%ebp)
 2d7:	d9 1c 24             	fstps  (%esp)
 2da:	e8 cc 03 00 00       	call   6ab <set_system_bjf_params>
 2df:	83 c4 10             	add    $0x10,%esp
    if (res < 0)
 2e2:	85 c0                	test   %eax,%eax
 2e4:	79 9c                	jns    282 <set_bjf_params+0x72>
        printf(1, "Error setting BJF params\n");
 2e6:	c7 45 0c 46 0b 00 00 	movl   $0xb46,0xc(%ebp)
 2ed:	eb 9a                	jmp    289 <set_bjf_params+0x79>
 2ef:	90                   	nop
        printf(1, "Invalid pid\n");
 2f0:	c7 45 0c e8 0a 00 00 	movl   $0xae8,0xc(%ebp)
 2f7:	eb 90                	jmp    289 <set_bjf_params+0x79>
 2f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000300 <wrong_command>:
void wrong_command(){
 300:	f3 0f 1e fb          	endbr32 
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	83 ec 10             	sub    $0x10,%esp
	printf(1, "usage: schedule command [arg...]\n");
 30a:	68 d8 0b 00 00       	push   $0xbd8
 30f:	6a 01                	push   $0x1
 311:	e8 6a 04 00 00       	call   780 <printf>
    printf(1, "Commands and Arguments:\n");
 316:	58                   	pop    %eax
 317:	5a                   	pop    %edx
 318:	68 60 0b 00 00       	push   $0xb60
 31d:	6a 01                	push   $0x1
 31f:	e8 5c 04 00 00       	call   780 <printf>
    printf(1, "  info\n");
 324:	59                   	pop    %ecx
 325:	58                   	pop    %eax
 326:	68 79 0b 00 00       	push   $0xb79
 32b:	6a 01                	push   $0x1
 32d:	e8 4e 04 00 00       	call   780 <printf>
    printf(1, "  set_queue <pid> <new_queue>\n");
 332:	58                   	pop    %eax
 333:	5a                   	pop    %edx
 334:	68 fc 0b 00 00       	push   $0xbfc
 339:	6a 01                	push   $0x1
 33b:	e8 40 04 00 00       	call   780 <printf>
    printf(1, "  set_process_bjf <pid> <priority_ratio> <arrival_time_ratio> <executed_cycle_ratio> <process_size_ratio>\n");
 340:	59                   	pop    %ecx
 341:	58                   	pop    %eax
 342:	68 1c 0c 00 00       	push   $0xc1c
 347:	6a 01                	push   $0x1
 349:	e8 32 04 00 00       	call   780 <printf>
    printf(1, "  set_system_bjf <priority_ratio> <arrival_time_ratio> <executed_cycle_ratio> <process_size_ratio>\n");
 34e:	58                   	pop    %eax
 34f:	5a                   	pop    %edx
 350:	68 88 0c 00 00       	push   $0xc88
 355:	6a 01                	push   $0x1
 357:	e8 24 04 00 00       	call   780 <printf>
    exit();
 35c:	e8 72 02 00 00       	call   5d3 <exit>
 361:	66 90                	xchg   %ax,%ax
 363:	66 90                	xchg   %ax,%ax
 365:	66 90                	xchg   %ax,%ax
 367:	66 90                	xchg   %ax,%ax
 369:	66 90                	xchg   %ax,%ax
 36b:	66 90                	xchg   %ax,%ax
 36d:	66 90                	xchg   %ax,%ax
 36f:	90                   	nop

00000370 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 370:	f3 0f 1e fb          	endbr32 
 374:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 375:	31 c0                	xor    %eax,%eax
{
 377:	89 e5                	mov    %esp,%ebp
 379:	53                   	push   %ebx
 37a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 37d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 380:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 384:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 387:	83 c0 01             	add    $0x1,%eax
 38a:	84 d2                	test   %dl,%dl
 38c:	75 f2                	jne    380 <strcpy+0x10>
    ;
  return os;
}
 38e:	89 c8                	mov    %ecx,%eax
 390:	5b                   	pop    %ebx
 391:	5d                   	pop    %ebp
 392:	c3                   	ret    
 393:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3a0:	f3 0f 1e fb          	endbr32 
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	53                   	push   %ebx
 3a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 3ae:	0f b6 01             	movzbl (%ecx),%eax
 3b1:	0f b6 1a             	movzbl (%edx),%ebx
 3b4:	84 c0                	test   %al,%al
 3b6:	75 19                	jne    3d1 <strcmp+0x31>
 3b8:	eb 26                	jmp    3e0 <strcmp+0x40>
 3ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3c0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 3c4:	83 c1 01             	add    $0x1,%ecx
 3c7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 3ca:	0f b6 1a             	movzbl (%edx),%ebx
 3cd:	84 c0                	test   %al,%al
 3cf:	74 0f                	je     3e0 <strcmp+0x40>
 3d1:	38 d8                	cmp    %bl,%al
 3d3:	74 eb                	je     3c0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 3d5:	29 d8                	sub    %ebx,%eax
}
 3d7:	5b                   	pop    %ebx
 3d8:	5d                   	pop    %ebp
 3d9:	c3                   	ret    
 3da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3e0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 3e2:	29 d8                	sub    %ebx,%eax
}
 3e4:	5b                   	pop    %ebx
 3e5:	5d                   	pop    %ebp
 3e6:	c3                   	ret    
 3e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ee:	66 90                	xchg   %ax,%ax

000003f0 <strlen>:

uint
strlen(const char *s)
{
 3f0:	f3 0f 1e fb          	endbr32 
 3f4:	55                   	push   %ebp
 3f5:	89 e5                	mov    %esp,%ebp
 3f7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 3fa:	80 3a 00             	cmpb   $0x0,(%edx)
 3fd:	74 21                	je     420 <strlen+0x30>
 3ff:	31 c0                	xor    %eax,%eax
 401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 408:	83 c0 01             	add    $0x1,%eax
 40b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 40f:	89 c1                	mov    %eax,%ecx
 411:	75 f5                	jne    408 <strlen+0x18>
    ;
  return n;
}
 413:	89 c8                	mov    %ecx,%eax
 415:	5d                   	pop    %ebp
 416:	c3                   	ret    
 417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 420:	31 c9                	xor    %ecx,%ecx
}
 422:	5d                   	pop    %ebp
 423:	89 c8                	mov    %ecx,%eax
 425:	c3                   	ret    
 426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42d:	8d 76 00             	lea    0x0(%esi),%esi

00000430 <memset>:

void*
memset(void *dst, int c, uint n)
{
 430:	f3 0f 1e fb          	endbr32 
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	57                   	push   %edi
 438:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 43b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 43e:	8b 45 0c             	mov    0xc(%ebp),%eax
 441:	89 d7                	mov    %edx,%edi
 443:	fc                   	cld    
 444:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 446:	89 d0                	mov    %edx,%eax
 448:	5f                   	pop    %edi
 449:	5d                   	pop    %ebp
 44a:	c3                   	ret    
 44b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 44f:	90                   	nop

00000450 <strchr>:

char*
strchr(const char *s, char c)
{
 450:	f3 0f 1e fb          	endbr32 
 454:	55                   	push   %ebp
 455:	89 e5                	mov    %esp,%ebp
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 45e:	0f b6 10             	movzbl (%eax),%edx
 461:	84 d2                	test   %dl,%dl
 463:	75 16                	jne    47b <strchr+0x2b>
 465:	eb 21                	jmp    488 <strchr+0x38>
 467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 46e:	66 90                	xchg   %ax,%ax
 470:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 474:	83 c0 01             	add    $0x1,%eax
 477:	84 d2                	test   %dl,%dl
 479:	74 0d                	je     488 <strchr+0x38>
    if(*s == c)
 47b:	38 d1                	cmp    %dl,%cl
 47d:	75 f1                	jne    470 <strchr+0x20>
      return (char*)s;
  return 0;
}
 47f:	5d                   	pop    %ebp
 480:	c3                   	ret    
 481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 488:	31 c0                	xor    %eax,%eax
}
 48a:	5d                   	pop    %ebp
 48b:	c3                   	ret    
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000490 <gets>:

char*
gets(char *buf, int max)
{
 490:	f3 0f 1e fb          	endbr32 
 494:	55                   	push   %ebp
 495:	89 e5                	mov    %esp,%ebp
 497:	57                   	push   %edi
 498:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 499:	31 f6                	xor    %esi,%esi
{
 49b:	53                   	push   %ebx
 49c:	89 f3                	mov    %esi,%ebx
 49e:	83 ec 1c             	sub    $0x1c,%esp
 4a1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 4a4:	eb 33                	jmp    4d9 <gets+0x49>
 4a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 4b0:	83 ec 04             	sub    $0x4,%esp
 4b3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4b6:	6a 01                	push   $0x1
 4b8:	50                   	push   %eax
 4b9:	6a 00                	push   $0x0
 4bb:	e8 2b 01 00 00       	call   5eb <read>
    if(cc < 1)
 4c0:	83 c4 10             	add    $0x10,%esp
 4c3:	85 c0                	test   %eax,%eax
 4c5:	7e 1c                	jle    4e3 <gets+0x53>
      break;
    buf[i++] = c;
 4c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4cb:	83 c7 01             	add    $0x1,%edi
 4ce:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 4d1:	3c 0a                	cmp    $0xa,%al
 4d3:	74 23                	je     4f8 <gets+0x68>
 4d5:	3c 0d                	cmp    $0xd,%al
 4d7:	74 1f                	je     4f8 <gets+0x68>
  for(i=0; i+1 < max; ){
 4d9:	83 c3 01             	add    $0x1,%ebx
 4dc:	89 fe                	mov    %edi,%esi
 4de:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4e1:	7c cd                	jl     4b0 <gets+0x20>
 4e3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 4e5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 4e8:	c6 03 00             	movb   $0x0,(%ebx)
}
 4eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ee:	5b                   	pop    %ebx
 4ef:	5e                   	pop    %esi
 4f0:	5f                   	pop    %edi
 4f1:	5d                   	pop    %ebp
 4f2:	c3                   	ret    
 4f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4f7:	90                   	nop
 4f8:	8b 75 08             	mov    0x8(%ebp),%esi
 4fb:	8b 45 08             	mov    0x8(%ebp),%eax
 4fe:	01 de                	add    %ebx,%esi
 500:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 502:	c6 03 00             	movb   $0x0,(%ebx)
}
 505:	8d 65 f4             	lea    -0xc(%ebp),%esp
 508:	5b                   	pop    %ebx
 509:	5e                   	pop    %esi
 50a:	5f                   	pop    %edi
 50b:	5d                   	pop    %ebp
 50c:	c3                   	ret    
 50d:	8d 76 00             	lea    0x0(%esi),%esi

00000510 <stat>:

int
stat(const char *n, struct stat *st)
{
 510:	f3 0f 1e fb          	endbr32 
 514:	55                   	push   %ebp
 515:	89 e5                	mov    %esp,%ebp
 517:	56                   	push   %esi
 518:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 519:	83 ec 08             	sub    $0x8,%esp
 51c:	6a 00                	push   $0x0
 51e:	ff 75 08             	pushl  0x8(%ebp)
 521:	e8 ed 00 00 00       	call   613 <open>
  if(fd < 0)
 526:	83 c4 10             	add    $0x10,%esp
 529:	85 c0                	test   %eax,%eax
 52b:	78 2b                	js     558 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 52d:	83 ec 08             	sub    $0x8,%esp
 530:	ff 75 0c             	pushl  0xc(%ebp)
 533:	89 c3                	mov    %eax,%ebx
 535:	50                   	push   %eax
 536:	e8 f0 00 00 00       	call   62b <fstat>
  close(fd);
 53b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 53e:	89 c6                	mov    %eax,%esi
  close(fd);
 540:	e8 b6 00 00 00       	call   5fb <close>
  return r;
 545:	83 c4 10             	add    $0x10,%esp
}
 548:	8d 65 f8             	lea    -0x8(%ebp),%esp
 54b:	89 f0                	mov    %esi,%eax
 54d:	5b                   	pop    %ebx
 54e:	5e                   	pop    %esi
 54f:	5d                   	pop    %ebp
 550:	c3                   	ret    
 551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 558:	be ff ff ff ff       	mov    $0xffffffff,%esi
 55d:	eb e9                	jmp    548 <stat+0x38>
 55f:	90                   	nop

00000560 <atoi>:

int
atoi(const char *s)
{
 560:	f3 0f 1e fb          	endbr32 
 564:	55                   	push   %ebp
 565:	89 e5                	mov    %esp,%ebp
 567:	53                   	push   %ebx
 568:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 56b:	0f be 02             	movsbl (%edx),%eax
 56e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 571:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 574:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 579:	77 1a                	ja     595 <atoi+0x35>
 57b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 57f:	90                   	nop
    n = n*10 + *s++ - '0';
 580:	83 c2 01             	add    $0x1,%edx
 583:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 586:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 58a:	0f be 02             	movsbl (%edx),%eax
 58d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 590:	80 fb 09             	cmp    $0x9,%bl
 593:	76 eb                	jbe    580 <atoi+0x20>
  return n;
}
 595:	89 c8                	mov    %ecx,%eax
 597:	5b                   	pop    %ebx
 598:	5d                   	pop    %ebp
 599:	c3                   	ret    
 59a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000005a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5a0:	f3 0f 1e fb          	endbr32 
 5a4:	55                   	push   %ebp
 5a5:	89 e5                	mov    %esp,%ebp
 5a7:	57                   	push   %edi
 5a8:	8b 45 10             	mov    0x10(%ebp),%eax
 5ab:	8b 55 08             	mov    0x8(%ebp),%edx
 5ae:	56                   	push   %esi
 5af:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5b2:	85 c0                	test   %eax,%eax
 5b4:	7e 0f                	jle    5c5 <memmove+0x25>
 5b6:	01 d0                	add    %edx,%eax
  dst = vdst;
 5b8:	89 d7                	mov    %edx,%edi
 5ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 5c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 5c1:	39 f8                	cmp    %edi,%eax
 5c3:	75 fb                	jne    5c0 <memmove+0x20>
  return vdst;
}
 5c5:	5e                   	pop    %esi
 5c6:	89 d0                	mov    %edx,%eax
 5c8:	5f                   	pop    %edi
 5c9:	5d                   	pop    %ebp
 5ca:	c3                   	ret    

000005cb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5cb:	b8 01 00 00 00       	mov    $0x1,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <exit>:
SYSCALL(exit)
 5d3:	b8 02 00 00 00       	mov    $0x2,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <wait>:
SYSCALL(wait)
 5db:	b8 03 00 00 00       	mov    $0x3,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <pipe>:
SYSCALL(pipe)
 5e3:	b8 04 00 00 00       	mov    $0x4,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <read>:
SYSCALL(read)
 5eb:	b8 05 00 00 00       	mov    $0x5,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <write>:
SYSCALL(write)
 5f3:	b8 10 00 00 00       	mov    $0x10,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <close>:
SYSCALL(close)
 5fb:	b8 15 00 00 00       	mov    $0x15,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <kill>:
SYSCALL(kill)
 603:	b8 06 00 00 00       	mov    $0x6,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <exec>:
SYSCALL(exec)
 60b:	b8 07 00 00 00       	mov    $0x7,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <open>:
SYSCALL(open)
 613:	b8 0f 00 00 00       	mov    $0xf,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <mknod>:
SYSCALL(mknod)
 61b:	b8 11 00 00 00       	mov    $0x11,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <unlink>:
SYSCALL(unlink)
 623:	b8 12 00 00 00       	mov    $0x12,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <fstat>:
SYSCALL(fstat)
 62b:	b8 08 00 00 00       	mov    $0x8,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <link>:
SYSCALL(link)
 633:	b8 13 00 00 00       	mov    $0x13,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <mkdir>:
SYSCALL(mkdir)
 63b:	b8 14 00 00 00       	mov    $0x14,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <chdir>:
SYSCALL(chdir)
 643:	b8 09 00 00 00       	mov    $0x9,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <dup>:
SYSCALL(dup)
 64b:	b8 0a 00 00 00       	mov    $0xa,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <getpid>:
SYSCALL(getpid)
 653:	b8 0b 00 00 00       	mov    $0xb,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    

0000065b <sbrk>:
SYSCALL(sbrk)
 65b:	b8 0c 00 00 00       	mov    $0xc,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret    

00000663 <sleep>:
SYSCALL(sleep)
 663:	b8 0d 00 00 00       	mov    $0xd,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret    

0000066b <uptime>:
SYSCALL(uptime)
 66b:	b8 0e 00 00 00       	mov    $0xe,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret    

00000673 <find_digital_root>:
SYSCALL(find_digital_root)
 673:	b8 16 00 00 00       	mov    $0x16,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret    

0000067b <get_process_lifetime>:
SYSCALL(get_process_lifetime)
 67b:	b8 17 00 00 00       	mov    $0x17,%eax
 680:	cd 40                	int    $0x40
 682:	c3                   	ret    

00000683 <copy_file>:
SYSCALL(copy_file)
 683:	b8 18 00 00 00       	mov    $0x18,%eax
 688:	cd 40                	int    $0x40
 68a:	c3                   	ret    

0000068b <get_uncle_count>:
SYSCALL(get_uncle_count)
 68b:	b8 19 00 00 00       	mov    $0x19,%eax
 690:	cd 40                	int    $0x40
 692:	c3                   	ret    

00000693 <change_sched_Q>:
SYSCALL(change_sched_Q)
 693:	b8 1b 00 00 00       	mov    $0x1b,%eax
 698:	cd 40                	int    $0x40
 69a:	c3                   	ret    

0000069b <show_process_info>:
SYSCALL(show_process_info)
 69b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6a0:	cd 40                	int    $0x40
 6a2:	c3                   	ret    

000006a3 <set_proc_bjf_params>:
SYSCALL(set_proc_bjf_params)
 6a3:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6a8:	cd 40                	int    $0x40
 6aa:	c3                   	ret    

000006ab <set_system_bjf_params>:
SYSCALL(set_system_bjf_params)
 6ab:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6b0:	cd 40                	int    $0x40
 6b2:	c3                   	ret    

000006b3 <priorityLock_test>:
SYSCALL(priorityLock_test)
 6b3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 6b8:	cd 40                	int    $0x40
 6ba:	c3                   	ret    

000006bb <syscalls_count>:
SYSCALL(syscalls_count)
 6bb:	b8 1f 00 00 00       	mov    $0x1f,%eax
 6c0:	cd 40                	int    $0x40
 6c2:	c3                   	ret    
 6c3:	66 90                	xchg   %ax,%ax
 6c5:	66 90                	xchg   %ax,%ax
 6c7:	66 90                	xchg   %ax,%ax
 6c9:	66 90                	xchg   %ax,%ax
 6cb:	66 90                	xchg   %ax,%ax
 6cd:	66 90                	xchg   %ax,%ax
 6cf:	90                   	nop

000006d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	53                   	push   %ebx
 6d6:	83 ec 3c             	sub    $0x3c,%esp
 6d9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 6dc:	89 d1                	mov    %edx,%ecx
{
 6de:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 6e1:	85 d2                	test   %edx,%edx
 6e3:	0f 89 7f 00 00 00    	jns    768 <printint+0x98>
 6e9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6ed:	74 79                	je     768 <printint+0x98>
    neg = 1;
 6ef:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 6f6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 6f8:	31 db                	xor    %ebx,%ebx
 6fa:	8d 75 d7             	lea    -0x29(%ebp),%esi
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 700:	89 c8                	mov    %ecx,%eax
 702:	31 d2                	xor    %edx,%edx
 704:	89 cf                	mov    %ecx,%edi
 706:	f7 75 c4             	divl   -0x3c(%ebp)
 709:	0f b6 92 f4 0c 00 00 	movzbl 0xcf4(%edx),%edx
 710:	89 45 c0             	mov    %eax,-0x40(%ebp)
 713:	89 d8                	mov    %ebx,%eax
 715:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 718:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 71b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 71e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 721:	76 dd                	jbe    700 <printint+0x30>
  if(neg)
 723:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 726:	85 c9                	test   %ecx,%ecx
 728:	74 0c                	je     736 <printint+0x66>
    buf[i++] = '-';
 72a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 72f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 731:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 736:	8b 7d b8             	mov    -0x48(%ebp),%edi
 739:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 73d:	eb 07                	jmp    746 <printint+0x76>
 73f:	90                   	nop
 740:	0f b6 13             	movzbl (%ebx),%edx
 743:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 746:	83 ec 04             	sub    $0x4,%esp
 749:	88 55 d7             	mov    %dl,-0x29(%ebp)
 74c:	6a 01                	push   $0x1
 74e:	56                   	push   %esi
 74f:	57                   	push   %edi
 750:	e8 9e fe ff ff       	call   5f3 <write>
  while(--i >= 0)
 755:	83 c4 10             	add    $0x10,%esp
 758:	39 de                	cmp    %ebx,%esi
 75a:	75 e4                	jne    740 <printint+0x70>
    putc(fd, buf[i]);
}
 75c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 75f:	5b                   	pop    %ebx
 760:	5e                   	pop    %esi
 761:	5f                   	pop    %edi
 762:	5d                   	pop    %ebp
 763:	c3                   	ret    
 764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 768:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 76f:	eb 87                	jmp    6f8 <printint+0x28>
 771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 77f:	90                   	nop

00000780 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 780:	f3 0f 1e fb          	endbr32 
 784:	55                   	push   %ebp
 785:	89 e5                	mov    %esp,%ebp
 787:	57                   	push   %edi
 788:	56                   	push   %esi
 789:	53                   	push   %ebx
 78a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 78d:	8b 75 0c             	mov    0xc(%ebp),%esi
 790:	0f b6 1e             	movzbl (%esi),%ebx
 793:	84 db                	test   %bl,%bl
 795:	0f 84 b4 00 00 00    	je     84f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 79b:	8d 45 10             	lea    0x10(%ebp),%eax
 79e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 7a1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 7a4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 7a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 7a9:	eb 33                	jmp    7de <printf+0x5e>
 7ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7af:	90                   	nop
 7b0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 7b3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 7b8:	83 f8 25             	cmp    $0x25,%eax
 7bb:	74 17                	je     7d4 <printf+0x54>
  write(fd, &c, 1);
 7bd:	83 ec 04             	sub    $0x4,%esp
 7c0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7c3:	6a 01                	push   $0x1
 7c5:	57                   	push   %edi
 7c6:	ff 75 08             	pushl  0x8(%ebp)
 7c9:	e8 25 fe ff ff       	call   5f3 <write>
 7ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 7d1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 7d4:	0f b6 1e             	movzbl (%esi),%ebx
 7d7:	83 c6 01             	add    $0x1,%esi
 7da:	84 db                	test   %bl,%bl
 7dc:	74 71                	je     84f <printf+0xcf>
    c = fmt[i] & 0xff;
 7de:	0f be cb             	movsbl %bl,%ecx
 7e1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 7e4:	85 d2                	test   %edx,%edx
 7e6:	74 c8                	je     7b0 <printf+0x30>
      }
    } else if(state == '%'){
 7e8:	83 fa 25             	cmp    $0x25,%edx
 7eb:	75 e7                	jne    7d4 <printf+0x54>
      if(c == 'd'){
 7ed:	83 f8 64             	cmp    $0x64,%eax
 7f0:	0f 84 9a 00 00 00    	je     890 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7f6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 7fc:	83 f9 70             	cmp    $0x70,%ecx
 7ff:	74 5f                	je     860 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 801:	83 f8 73             	cmp    $0x73,%eax
 804:	0f 84 d6 00 00 00    	je     8e0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 80a:	83 f8 63             	cmp    $0x63,%eax
 80d:	0f 84 8d 00 00 00    	je     8a0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 813:	83 f8 25             	cmp    $0x25,%eax
 816:	0f 84 b4 00 00 00    	je     8d0 <printf+0x150>
  write(fd, &c, 1);
 81c:	83 ec 04             	sub    $0x4,%esp
 81f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 823:	6a 01                	push   $0x1
 825:	57                   	push   %edi
 826:	ff 75 08             	pushl  0x8(%ebp)
 829:	e8 c5 fd ff ff       	call   5f3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 82e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 831:	83 c4 0c             	add    $0xc,%esp
 834:	6a 01                	push   $0x1
 836:	83 c6 01             	add    $0x1,%esi
 839:	57                   	push   %edi
 83a:	ff 75 08             	pushl  0x8(%ebp)
 83d:	e8 b1 fd ff ff       	call   5f3 <write>
  for(i = 0; fmt[i]; i++){
 842:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 846:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 849:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 84b:	84 db                	test   %bl,%bl
 84d:	75 8f                	jne    7de <printf+0x5e>
    }
  }
}
 84f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 852:	5b                   	pop    %ebx
 853:	5e                   	pop    %esi
 854:	5f                   	pop    %edi
 855:	5d                   	pop    %ebp
 856:	c3                   	ret    
 857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 85e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 860:	83 ec 0c             	sub    $0xc,%esp
 863:	b9 10 00 00 00       	mov    $0x10,%ecx
 868:	6a 00                	push   $0x0
 86a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 86d:	8b 45 08             	mov    0x8(%ebp),%eax
 870:	8b 13                	mov    (%ebx),%edx
 872:	e8 59 fe ff ff       	call   6d0 <printint>
        ap++;
 877:	89 d8                	mov    %ebx,%eax
 879:	83 c4 10             	add    $0x10,%esp
      state = 0;
 87c:	31 d2                	xor    %edx,%edx
        ap++;
 87e:	83 c0 04             	add    $0x4,%eax
 881:	89 45 d0             	mov    %eax,-0x30(%ebp)
 884:	e9 4b ff ff ff       	jmp    7d4 <printf+0x54>
 889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 890:	83 ec 0c             	sub    $0xc,%esp
 893:	b9 0a 00 00 00       	mov    $0xa,%ecx
 898:	6a 01                	push   $0x1
 89a:	eb ce                	jmp    86a <printf+0xea>
 89c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 8a0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 8a3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 8a6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 8a8:	6a 01                	push   $0x1
        ap++;
 8aa:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 8ad:	57                   	push   %edi
 8ae:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 8b1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 8b4:	e8 3a fd ff ff       	call   5f3 <write>
        ap++;
 8b9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 8bc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 8bf:	31 d2                	xor    %edx,%edx
 8c1:	e9 0e ff ff ff       	jmp    7d4 <printf+0x54>
 8c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8cd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 8d0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 8d3:	83 ec 04             	sub    $0x4,%esp
 8d6:	e9 59 ff ff ff       	jmp    834 <printf+0xb4>
 8db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8df:	90                   	nop
        s = (char*)*ap;
 8e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8e3:	8b 18                	mov    (%eax),%ebx
        ap++;
 8e5:	83 c0 04             	add    $0x4,%eax
 8e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 8eb:	85 db                	test   %ebx,%ebx
 8ed:	74 17                	je     906 <printf+0x186>
        while(*s != 0){
 8ef:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 8f2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 8f4:	84 c0                	test   %al,%al
 8f6:	0f 84 d8 fe ff ff    	je     7d4 <printf+0x54>
 8fc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 8ff:	89 de                	mov    %ebx,%esi
 901:	8b 5d 08             	mov    0x8(%ebp),%ebx
 904:	eb 1a                	jmp    920 <printf+0x1a0>
          s = "(null)";
 906:	bb ec 0c 00 00       	mov    $0xcec,%ebx
        while(*s != 0){
 90b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 90e:	b8 28 00 00 00       	mov    $0x28,%eax
 913:	89 de                	mov    %ebx,%esi
 915:	8b 5d 08             	mov    0x8(%ebp),%ebx
 918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 91f:	90                   	nop
  write(fd, &c, 1);
 920:	83 ec 04             	sub    $0x4,%esp
          s++;
 923:	83 c6 01             	add    $0x1,%esi
 926:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 929:	6a 01                	push   $0x1
 92b:	57                   	push   %edi
 92c:	53                   	push   %ebx
 92d:	e8 c1 fc ff ff       	call   5f3 <write>
        while(*s != 0){
 932:	0f b6 06             	movzbl (%esi),%eax
 935:	83 c4 10             	add    $0x10,%esp
 938:	84 c0                	test   %al,%al
 93a:	75 e4                	jne    920 <printf+0x1a0>
 93c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 93f:	31 d2                	xor    %edx,%edx
 941:	e9 8e fe ff ff       	jmp    7d4 <printf+0x54>
 946:	66 90                	xchg   %ax,%ax
 948:	66 90                	xchg   %ax,%ax
 94a:	66 90                	xchg   %ax,%ax
 94c:	66 90                	xchg   %ax,%ax
 94e:	66 90                	xchg   %ax,%ax

00000950 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 950:	f3 0f 1e fb          	endbr32 
 954:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 955:	a1 40 10 00 00       	mov    0x1040,%eax
{
 95a:	89 e5                	mov    %esp,%ebp
 95c:	57                   	push   %edi
 95d:	56                   	push   %esi
 95e:	53                   	push   %ebx
 95f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 962:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 964:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 967:	39 c8                	cmp    %ecx,%eax
 969:	73 15                	jae    980 <free+0x30>
 96b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 96f:	90                   	nop
 970:	39 d1                	cmp    %edx,%ecx
 972:	72 14                	jb     988 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 974:	39 d0                	cmp    %edx,%eax
 976:	73 10                	jae    988 <free+0x38>
{
 978:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 97a:	8b 10                	mov    (%eax),%edx
 97c:	39 c8                	cmp    %ecx,%eax
 97e:	72 f0                	jb     970 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 980:	39 d0                	cmp    %edx,%eax
 982:	72 f4                	jb     978 <free+0x28>
 984:	39 d1                	cmp    %edx,%ecx
 986:	73 f0                	jae    978 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 988:	8b 73 fc             	mov    -0x4(%ebx),%esi
 98b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 98e:	39 fa                	cmp    %edi,%edx
 990:	74 1e                	je     9b0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 992:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 995:	8b 50 04             	mov    0x4(%eax),%edx
 998:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 99b:	39 f1                	cmp    %esi,%ecx
 99d:	74 28                	je     9c7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 99f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 9a1:	5b                   	pop    %ebx
  freep = p;
 9a2:	a3 40 10 00 00       	mov    %eax,0x1040
}
 9a7:	5e                   	pop    %esi
 9a8:	5f                   	pop    %edi
 9a9:	5d                   	pop    %ebp
 9aa:	c3                   	ret    
 9ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 9af:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 9b0:	03 72 04             	add    0x4(%edx),%esi
 9b3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 9b6:	8b 10                	mov    (%eax),%edx
 9b8:	8b 12                	mov    (%edx),%edx
 9ba:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 9bd:	8b 50 04             	mov    0x4(%eax),%edx
 9c0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 9c3:	39 f1                	cmp    %esi,%ecx
 9c5:	75 d8                	jne    99f <free+0x4f>
    p->s.size += bp->s.size;
 9c7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 9ca:	a3 40 10 00 00       	mov    %eax,0x1040
    p->s.size += bp->s.size;
 9cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9d2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 9d5:	89 10                	mov    %edx,(%eax)
}
 9d7:	5b                   	pop    %ebx
 9d8:	5e                   	pop    %esi
 9d9:	5f                   	pop    %edi
 9da:	5d                   	pop    %ebp
 9db:	c3                   	ret    
 9dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000009e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9e0:	f3 0f 1e fb          	endbr32 
 9e4:	55                   	push   %ebp
 9e5:	89 e5                	mov    %esp,%ebp
 9e7:	57                   	push   %edi
 9e8:	56                   	push   %esi
 9e9:	53                   	push   %ebx
 9ea:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ed:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9f0:	8b 3d 40 10 00 00    	mov    0x1040,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f6:	8d 70 07             	lea    0x7(%eax),%esi
 9f9:	c1 ee 03             	shr    $0x3,%esi
 9fc:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 9ff:	85 ff                	test   %edi,%edi
 a01:	0f 84 a9 00 00 00    	je     ab0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a07:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 a09:	8b 48 04             	mov    0x4(%eax),%ecx
 a0c:	39 f1                	cmp    %esi,%ecx
 a0e:	73 6d                	jae    a7d <malloc+0x9d>
 a10:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 a16:	bb 00 10 00 00       	mov    $0x1000,%ebx
 a1b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 a1e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 a25:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 a28:	eb 17                	jmp    a41 <malloc+0x61>
 a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a30:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 a32:	8b 4a 04             	mov    0x4(%edx),%ecx
 a35:	39 f1                	cmp    %esi,%ecx
 a37:	73 4f                	jae    a88 <malloc+0xa8>
 a39:	8b 3d 40 10 00 00    	mov    0x1040,%edi
 a3f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a41:	39 c7                	cmp    %eax,%edi
 a43:	75 eb                	jne    a30 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 a45:	83 ec 0c             	sub    $0xc,%esp
 a48:	ff 75 e4             	pushl  -0x1c(%ebp)
 a4b:	e8 0b fc ff ff       	call   65b <sbrk>
  if(p == (char*)-1)
 a50:	83 c4 10             	add    $0x10,%esp
 a53:	83 f8 ff             	cmp    $0xffffffff,%eax
 a56:	74 1b                	je     a73 <malloc+0x93>
  hp->s.size = nu;
 a58:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a5b:	83 ec 0c             	sub    $0xc,%esp
 a5e:	83 c0 08             	add    $0x8,%eax
 a61:	50                   	push   %eax
 a62:	e8 e9 fe ff ff       	call   950 <free>
  return freep;
 a67:	a1 40 10 00 00       	mov    0x1040,%eax
      if((p = morecore(nunits)) == 0)
 a6c:	83 c4 10             	add    $0x10,%esp
 a6f:	85 c0                	test   %eax,%eax
 a71:	75 bd                	jne    a30 <malloc+0x50>
        return 0;
  }
}
 a73:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a76:	31 c0                	xor    %eax,%eax
}
 a78:	5b                   	pop    %ebx
 a79:	5e                   	pop    %esi
 a7a:	5f                   	pop    %edi
 a7b:	5d                   	pop    %ebp
 a7c:	c3                   	ret    
    if(p->s.size >= nunits){
 a7d:	89 c2                	mov    %eax,%edx
 a7f:	89 f8                	mov    %edi,%eax
 a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 a88:	39 ce                	cmp    %ecx,%esi
 a8a:	74 54                	je     ae0 <malloc+0x100>
        p->s.size -= nunits;
 a8c:	29 f1                	sub    %esi,%ecx
 a8e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 a91:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 a94:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 a97:	a3 40 10 00 00       	mov    %eax,0x1040
}
 a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a9f:	8d 42 08             	lea    0x8(%edx),%eax
}
 aa2:	5b                   	pop    %ebx
 aa3:	5e                   	pop    %esi
 aa4:	5f                   	pop    %edi
 aa5:	5d                   	pop    %ebp
 aa6:	c3                   	ret    
 aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 aae:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 ab0:	c7 05 40 10 00 00 44 	movl   $0x1044,0x1040
 ab7:	10 00 00 
    base.s.size = 0;
 aba:	bf 44 10 00 00       	mov    $0x1044,%edi
    base.s.ptr = freep = prevp = &base;
 abf:	c7 05 44 10 00 00 44 	movl   $0x1044,0x1044
 ac6:	10 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ac9:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 acb:	c7 05 48 10 00 00 00 	movl   $0x0,0x1048
 ad2:	00 00 00 
    if(p->s.size >= nunits){
 ad5:	e9 36 ff ff ff       	jmp    a10 <malloc+0x30>
 ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 ae0:	8b 0a                	mov    (%edx),%ecx
 ae2:	89 08                	mov    %ecx,(%eax)
 ae4:	eb b1                	jmp    a97 <malloc+0xb7>
