
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp
8010002d:	b8 f0 35 10 80       	mov    $0x801035f0,%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx
80100048:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
8010004d:	83 ec 0c             	sub    $0xc,%esp
80100050:	68 a0 76 10 80       	push   $0x801076a0
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 31 49 00 00       	call   80104990 <initlock>
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
80100067:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006e:	0c 11 80 
80100071:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100078:	0c 11 80 
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
80100092:	68 a7 76 10 80       	push   $0x801076a7
80100097:	50                   	push   %eax
80100098:	e8 b3 47 00 00       	call   80104850 <initsleeplock>
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
801000b6:	81 fb 60 0a 11 80    	cmp    $0x80110a60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
801000e3:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e8:	e8 23 4a 00 00       	call   80104b10 <acquire>
801000ed:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 69 4a 00 00       	call   80104bd0 <release>
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 47 00 00       	call   80104890 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 9f 26 00 00       	call   80102830 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ae 76 10 80       	push   $0x801076ae
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 69 47 00 00       	call   80104930 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
801001d8:	e9 53 26 00 00       	jmp    80102830 <iderw>
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 bf 76 10 80       	push   $0x801076bf
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 28 47 00 00       	call   80104930 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 d8 46 00 00       	call   801048f0 <releasesleep>
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 ec 48 00 00       	call   80104b10 <acquire>
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100227:	83 c4 10             	add    $0x10,%esp
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
80100246:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010024b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
80100255:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
8010025d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
80100263:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
80100270:	e9 5b 49 00 00       	jmp    80104bd0 <release>
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 c6 76 10 80       	push   $0x801076c6
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 46 1b 00 00       	call   80101df0 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 5a 48 00 00       	call   80104b10 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cb:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 0f 11 80       	push   $0x80110fa0
801002e5:	e8 e6 41 00 00       	call   801044d0 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 11 3c 00 00       	call   80103f10 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 bd 48 00 00       	call   80104bd0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 f4 19 00 00       	call   80101d10 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 66 48 00 00       	call   80104bd0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 9d 19 00 00       	call   80101d10 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 9e 2a 00 00       	call   80102e50 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 cd 76 10 80       	push   $0x801076cd
801003bb:	e8 c0 05 00 00       	call   80100980 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 b7 05 00 00       	call   80100980 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 57 80 10 80 	movl   $0x80108057,(%esp)
801003d0:	e8 ab 05 00 00       	call   80100980 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 cf 45 00 00       	call   801049b0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 e1 76 10 80       	push   $0x801076e1
801003f1:	e8 8a 05 00 00       	call   80100980 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 5c b5 10 80 01 	movl   $0x1,0x8010b55c
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c) // Important function 
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	89 c6                	mov    %eax,%esi
80100417:	53                   	push   %ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 62 01 00 00    	je     80100588 <consputc.part.0+0x178>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 61 5e 00 00       	call   80106290 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c3                	mov    %eax,%ebx
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 d8                	or     %ebx,%eax
  if(c == '\n'){
8010045f:	83 fe 0a             	cmp    $0xa,%esi
80100462:	0f 84 f8 00 00 00    	je     80100560 <consputc.part.0+0x150>
  else if(c == BACKSPACE){
80100468:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
8010046e:	8d 0c 38             	lea    (%eax,%edi,1),%ecx
80100471:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100477:	0f 84 a3 00 00 00    	je     80100520 <consputc.part.0+0x110>
  for (int i = pos + backs; i > pos; i--)
8010047d:	39 c8                	cmp    %ecx,%eax
8010047f:	7d 1d                	jge    8010049e <consputc.part.0+0x8e>
80100481:	8d 94 09 fe 7f 0b 80 	lea    -0x7ff48002(%ecx,%ecx,1),%edx
80100488:	8d 9c 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%ebx
8010048f:	90                   	nop
    crt[i] = crt[i - 1];
80100490:	0f b7 0a             	movzwl (%edx),%ecx
80100493:	83 ea 02             	sub    $0x2,%edx
80100496:	66 89 4a 04          	mov    %cx,0x4(%edx)
  for (int i = pos + backs; i > pos; i--)
8010049a:	39 d3                	cmp    %edx,%ebx
8010049c:	75 f2                	jne    80100490 <consputc.part.0+0x80>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010049e:	89 f1                	mov    %esi,%ecx
801004a0:	8d 58 01             	lea    0x1(%eax),%ebx
801004a3:	0f b6 f1             	movzbl %cl,%esi
801004a6:	66 81 ce 00 07       	or     $0x700,%si
801004ab:	66 89 b4 00 00 80 0b 	mov    %si,-0x7ff48000(%eax,%eax,1)
801004b2:	80 
  if(pos < 0 || pos > 25*80)
801004b3:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801004b9:	0f 8f 45 01 00 00    	jg     80100604 <consputc.part.0+0x1f4>
  if((pos/80) >= 24){  // Scroll up.
801004bf:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004c5:	0f 8f ed 00 00 00    	jg     801005b8 <consputc.part.0+0x1a8>
801004cb:	0f b6 c7             	movzbl %bh,%eax
801004ce:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801004d4:	89 de                	mov    %ebx,%esi
801004d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801004d9:	01 df                	add    %ebx,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004db:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004e0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004e5:	89 da                	mov    %ebx,%edx
801004e7:	ee                   	out    %al,(%dx)
801004e8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ed:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
801004f1:	89 ca                	mov    %ecx,%edx
801004f3:	ee                   	out    %al,(%dx)
801004f4:	b8 0f 00 00 00       	mov    $0xf,%eax
801004f9:	89 da                	mov    %ebx,%edx
801004fb:	ee                   	out    %al,(%dx)
801004fc:	89 f0                	mov    %esi,%eax
801004fe:	89 ca                	mov    %ecx,%edx
80100500:	ee                   	out    %al,(%dx)
  crt[pos + backs] = ' ' | 0x0700; //
80100501:	b8 20 07 00 00       	mov    $0x720,%eax
80100506:	66 89 84 3f 00 80 0b 	mov    %ax,-0x7ff48000(%edi,%edi,1)
8010050d:	80 
}
8010050e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100511:	5b                   	pop    %ebx
80100512:	5e                   	pop    %esi
80100513:	5f                   	pop    %edi
80100514:	5d                   	pop    %ebp
80100515:	c3                   	ret    
80100516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010051d:	8d 76 00             	lea    0x0(%esi),%esi
  for (int i = pos - 1; i < pos + backs; i++)
80100520:	8d 58 ff             	lea    -0x1(%eax),%ebx
80100523:	8d 94 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%edx
8010052a:	89 de                	mov    %ebx,%esi
8010052c:	85 ff                	test   %edi,%edi
8010052e:	78 1c                	js     8010054c <consputc.part.0+0x13c>
80100530:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100533:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100537:	90                   	nop
      crt[i] = crt[i + 1];
80100538:	0f b7 02             	movzwl (%edx),%eax
  for (int i = pos - 1; i < pos + backs; i++)
8010053b:	83 c6 01             	add    $0x1,%esi
8010053e:	83 c2 02             	add    $0x2,%edx
      crt[i] = crt[i + 1];
80100541:	66 89 42 fc          	mov    %ax,-0x4(%edx)
  for (int i = pos - 1; i < pos + backs; i++)
80100545:	39 ce                	cmp    %ecx,%esi
80100547:	7c ef                	jl     80100538 <consputc.part.0+0x128>
80100549:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(pos > 0) --pos;
8010054c:	85 c0                	test   %eax,%eax
8010054e:	0f 85 5f ff ff ff    	jne    801004b3 <consputc.part.0+0xa3>
80100554:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
80100558:	31 f6                	xor    %esi,%esi
8010055a:	e9 7c ff ff ff       	jmp    801004db <consputc.part.0+0xcb>
8010055f:	90                   	nop
    backs = 0;
80100560:	c7 05 58 b5 10 80 00 	movl   $0x0,0x8010b558
80100567:	00 00 00 
    pos += 80 - pos%80;
8010056a:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010056f:	f7 e2                	mul    %edx
80100571:	c1 ea 06             	shr    $0x6,%edx
80100574:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100577:	c1 e0 04             	shl    $0x4,%eax
8010057a:	8d 58 50             	lea    0x50(%eax),%ebx
    backs = 0;
8010057d:	e9 31 ff ff ff       	jmp    801004b3 <consputc.part.0+0xa3>
80100582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');      
80100588:	83 ec 0c             	sub    $0xc,%esp
8010058b:	6a 08                	push   $0x8
8010058d:	e8 fe 5c 00 00       	call   80106290 <uartputc>
80100592:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100599:	e8 f2 5c 00 00       	call   80106290 <uartputc>
8010059e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005a5:	e8 e6 5c 00 00       	call   80106290 <uartputc>
801005aa:	83 c4 10             	add    $0x10,%esp
801005ad:	e9 80 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
801005b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801005b8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801005bb:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801005be:	68 60 0e 00 00       	push   $0xe60
801005c3:	89 de                	mov    %ebx,%esi
801005c5:	68 a0 80 0b 80       	push   $0x800b80a0
801005ca:	68 00 80 0b 80       	push   $0x800b8000
801005cf:	e8 ec 46 00 00       	call   80104cc0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005d4:	b8 80 07 00 00       	mov    $0x780,%eax
801005d9:	83 c4 0c             	add    $0xc,%esp
801005dc:	29 d8                	sub    %ebx,%eax
801005de:	01 c0                	add    %eax,%eax
801005e0:	50                   	push   %eax
801005e1:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
801005e8:	6a 00                	push   $0x0
801005ea:	50                   	push   %eax
801005eb:	e8 30 46 00 00       	call   80104c20 <memset>
801005f0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801005f6:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801005fa:	83 c4 10             	add    $0x10,%esp
801005fd:	01 df                	add    %ebx,%edi
801005ff:	e9 d7 fe ff ff       	jmp    801004db <consputc.part.0+0xcb>
    panic("pos under/overflow");
80100604:	83 ec 0c             	sub    $0xc,%esp
80100607:	68 e5 76 10 80       	push   $0x801076e5
8010060c:	e8 7f fd ff ff       	call   80100390 <panic>
80100611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010061f:	90                   	nop

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	83 ec 2c             	sub    $0x2c,%esp
80100629:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010062c:	85 c9                	test   %ecx,%ecx
8010062e:	74 04                	je     80100634 <printint+0x14>
80100630:	85 c0                	test   %eax,%eax
80100632:	78 6d                	js     801006a1 <printint+0x81>
    x = xx;
80100634:	89 c1                	mov    %eax,%ecx
80100636:	31 f6                	xor    %esi,%esi
  i = 0;
80100638:	89 75 cc             	mov    %esi,-0x34(%ebp)
8010063b:	31 db                	xor    %ebx,%ebx
8010063d:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 ce                	mov    %ecx,%esi
80100646:	f7 75 d4             	divl   -0x2c(%ebp)
80100649:	0f b6 92 68 77 10 80 	movzbl -0x7fef8898(%edx),%edx
80100650:	89 45 d0             	mov    %eax,-0x30(%ebp)
80100653:	89 d8                	mov    %ebx,%eax
80100655:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
80100658:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010065b:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
8010065e:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
80100661:	8b 75 d4             	mov    -0x2c(%ebp),%esi
80100664:	39 75 d0             	cmp    %esi,-0x30(%ebp)
80100667:	73 d7                	jae    80100640 <printint+0x20>
80100669:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
8010066c:	85 f6                	test   %esi,%esi
8010066e:	74 0c                	je     8010067c <printint+0x5c>
    buf[i++] = '-';
80100670:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100675:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
80100677:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010067c:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100680:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100683:	8b 15 5c b5 10 80    	mov    0x8010b55c,%edx
80100689:	85 d2                	test   %edx,%edx
8010068b:	74 03                	je     80100690 <printint+0x70>
  asm volatile("cli");
8010068d:	fa                   	cli    
    for(;;)
8010068e:	eb fe                	jmp    8010068e <printint+0x6e>
80100690:	e8 7b fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100695:	39 fb                	cmp    %edi,%ebx
80100697:	74 10                	je     801006a9 <printint+0x89>
80100699:	0f be 03             	movsbl (%ebx),%eax
8010069c:	83 eb 01             	sub    $0x1,%ebx
8010069f:	eb e2                	jmp    80100683 <printint+0x63>
    x = -xx;
801006a1:	f7 d8                	neg    %eax
801006a3:	89 ce                	mov    %ecx,%esi
801006a5:	89 c1                	mov    %eax,%ecx
801006a7:	eb 8f                	jmp    80100638 <printint+0x18>
}
801006a9:	83 c4 2c             	add    $0x2c,%esp
801006ac:	5b                   	pop    %ebx
801006ad:	5e                   	pop    %esi
801006ae:	5f                   	pop    %edi
801006af:	5d                   	pop    %ebp
801006b0:	c3                   	ret    
801006b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006bf:	90                   	nop

801006c0 <arrow>:
static void arrow(enum Arrow arr){
801006c0:	55                   	push   %ebp
801006c1:	89 e5                	mov    %esp,%ebp
801006c3:	57                   	push   %edi
801006c4:	56                   	push   %esi
801006c5:	53                   	push   %ebx
801006c6:	83 ec 1c             	sub    $0x1c,%esp
801006c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for (int i= 0 ; i < backs ; i ++){
801006cc:	a1 58 b5 10 80       	mov    0x8010b558,%eax
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	85 c0                	test   %eax,%eax
801006d6:	7e 57                	jle    8010072f <arrow+0x6f>
801006d8:	31 ff                	xor    %edi,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801006da:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801006df:	b8 0e 00 00 00       	mov    $0xe,%eax
801006e4:	89 da                	mov    %ebx,%edx
801006e6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801006e7:	be d5 03 00 00       	mov    $0x3d5,%esi
801006ec:	89 f2                	mov    %esi,%edx
801006ee:	ec                   	in     (%dx),%al
801006ef:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801006f2:	89 da                	mov    %ebx,%edx
801006f4:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT + 1) << 8;
801006f9:	c1 e1 08             	shl    $0x8,%ecx
801006fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801006fd:	89 f2                	mov    %esi,%edx
801006ff:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100700:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100703:	89 da                	mov    %ebx,%edx
80100705:	09 c1                	or     %eax,%ecx
80100707:	b8 0e 00 00 00       	mov    $0xe,%eax
    pos++;
8010070c:	83 c1 01             	add    $0x1,%ecx
8010070f:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100710:	89 ca                	mov    %ecx,%edx
80100712:	c1 fa 08             	sar    $0x8,%edx
80100715:	89 d0                	mov    %edx,%eax
80100717:	89 f2                	mov    %esi,%edx
80100719:	ee                   	out    %al,(%dx)
8010071a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010071f:	89 da                	mov    %ebx,%edx
80100721:	ee                   	out    %al,(%dx)
80100722:	89 c8                	mov    %ecx,%eax
80100724:	89 f2                	mov    %esi,%edx
80100726:	ee                   	out    %al,(%dx)
  for (int i= 0 ; i < backs ; i ++){
80100727:	83 c7 01             	add    $0x1,%edi
8010072a:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
8010072d:	75 b0                	jne    801006df <arrow+0x1f>
  backs = 0;
8010072f:	c7 05 58 b5 10 80 00 	movl   $0x0,0x8010b558
80100736:	00 00 00 
  for ( int i = input.e ; i > input.w ; i-- ){
80100739:	8b 1d a8 0f 11 80    	mov    0x80110fa8,%ebx
8010073f:	3b 1d a4 0f 11 80    	cmp    0x80110fa4,%ebx
80100745:	76 2b                	jbe    80100772 <arrow+0xb2>
    if (input.buf[i - 1] != '\n'){
80100747:	83 eb 01             	sub    $0x1,%ebx
8010074a:	80 bb 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%ebx)
80100751:	74 17                	je     8010076a <arrow+0xaa>
  if(panicked){
80100753:	8b 0d 5c b5 10 80    	mov    0x8010b55c,%ecx
80100759:	85 c9                	test   %ecx,%ecx
8010075b:	74 03                	je     80100760 <arrow+0xa0>
  asm volatile("cli");
8010075d:	fa                   	cli    
    for(;;)
8010075e:	eb fe                	jmp    8010075e <arrow+0x9e>
80100760:	b8 00 01 00 00       	mov    $0x100,%eax
80100765:	e8 a6 fc ff ff       	call   80100410 <consputc.part.0>
  for ( int i = input.e ; i > input.w ; i-- ){
8010076a:	39 1d a4 0f 11 80    	cmp    %ebx,0x80110fa4
80100770:	72 d5                	jb     80100747 <arrow+0x87>
  if (arr == UP){
80100772:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80100775:	a1 38 15 11 80       	mov    0x80111538,%eax
8010077a:	85 db                	test   %ebx,%ebx
8010077c:	74 50                	je     801007ce <arrow+0x10e>
  if ((arr == DOWN)&&(history.index < 9)&&(history.index + 1 < history.last )){
8010077e:	83 f8 08             	cmp    $0x8,%eax
80100781:	0f 8f ce 00 00 00    	jg     80100855 <arrow+0x195>
80100787:	8d 50 01             	lea    0x1(%eax),%edx
8010078a:	3b 15 40 15 11 80    	cmp    0x80111540,%edx
80100790:	0f 8d c7 00 00 00    	jge    8010085d <arrow+0x19d>
    input = history.hist[history.index + 2 ];
80100796:	8d 70 02             	lea    0x2(%eax),%esi
80100799:	bf 20 0f 11 80       	mov    $0x80110f20,%edi
8010079e:	b9 23 00 00 00       	mov    $0x23,%ecx
    history.index ++ ;
801007a3:	89 15 38 15 11 80    	mov    %edx,0x80111538
    input = history.hist[history.index + 2 ];
801007a9:	69 f6 8c 00 00 00    	imul   $0x8c,%esi,%esi
801007af:	81 c6 c0 0f 11 80    	add    $0x80110fc0,%esi
801007b5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    input.e -- ;
801007b7:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801007bc:	8d 48 ff             	lea    -0x1(%eax),%ecx
    input.buf[input.e] = '\0';
801007bf:	c6 80 1f 0f 11 80 00 	movb   $0x0,-0x7feef0e1(%eax)
    input.e -- ;
801007c6:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
    input.buf[input.e] = '\0';
801007cc:	eb 35                	jmp    80100803 <arrow+0x143>
    input = history.hist[history.index ];
801007ce:	69 f0 8c 00 00 00    	imul   $0x8c,%eax,%esi
801007d4:	bf 20 0f 11 80       	mov    $0x80110f20,%edi
801007d9:	b9 23 00 00 00       	mov    $0x23,%ecx
    history.index -- ;
801007de:	83 e8 01             	sub    $0x1,%eax
801007e1:	a3 38 15 11 80       	mov    %eax,0x80111538
    input = history.hist[history.index ];
801007e6:	81 c6 c0 0f 11 80    	add    $0x80110fc0,%esi
801007ec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    input.e -- ;
801007ee:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801007f3:	8d 48 ff             	lea    -0x1(%eax),%ecx
    input.buf[input.e] = '\0';
801007f6:	c6 80 1f 0f 11 80 00 	movb   $0x0,-0x7feef0e1(%eax)
    input.e -- ;
801007fd:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
  for (int i = input.w ; i < input.e; i++)
80100803:	8b 1d a4 0f 11 80    	mov    0x80110fa4,%ebx
80100809:	39 cb                	cmp    %ecx,%ebx
8010080b:	73 2a                	jae    80100837 <arrow+0x177>
  if(panicked){
8010080d:	a1 5c b5 10 80       	mov    0x8010b55c,%eax
80100812:	85 c0                	test   %eax,%eax
80100814:	74 0a                	je     80100820 <arrow+0x160>
80100816:	fa                   	cli    
    for(;;)
80100817:	eb fe                	jmp    80100817 <arrow+0x157>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(input.buf[i]);
80100820:	0f be 83 20 0f 11 80 	movsbl -0x7feef0e0(%ebx),%eax
  for (int i = input.w ; i < input.e; i++)
80100827:	83 c3 01             	add    $0x1,%ebx
8010082a:	e8 e1 fb ff ff       	call   80100410 <consputc.part.0>
8010082f:	39 1d a8 0f 11 80    	cmp    %ebx,0x80110fa8
80100835:	77 d6                	ja     8010080d <arrow+0x14d>
}
80100837:	83 c4 1c             	add    $0x1c,%esp
8010083a:	5b                   	pop    %ebx
8010083b:	5e                   	pop    %esi
8010083c:	5f                   	pop    %edi
8010083d:	5d                   	pop    %ebp
8010083e:	c3                   	ret    
8010083f:	b8 00 01 00 00       	mov    $0x100,%eax
80100844:	e8 c7 fb ff ff       	call   80100410 <consputc.part.0>
    for ( int i = input.e ; i > input.w ; i-- ){
80100849:	39 1d a4 0f 11 80    	cmp    %ebx,0x80110fa4
8010084f:	0f 82 94 00 00 00    	jb     801008e9 <arrow+0x229>
80100855:	8b 0d a8 0f 11 80    	mov    0x80110fa8,%ecx
8010085b:	eb a6                	jmp    80100803 <arrow+0x143>
  else if ((arr == DOWN)&&(history.index < 9)&&(history.index + 1 == history.last )){
8010085d:	8b 0d a8 0f 11 80    	mov    0x80110fa8,%ecx
80100863:	75 9e                	jne    80100803 <arrow+0x143>
    for (int i= 0 ; i < backs ; i ++){
80100865:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010086a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010086d:	85 c0                	test   %eax,%eax
8010086f:	7e 60                	jle    801008d1 <arrow+0x211>
80100871:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100878:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010087d:	b8 0e 00 00 00       	mov    $0xe,%eax
80100882:	89 fa                	mov    %edi,%edx
80100884:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100885:	be d5 03 00 00       	mov    $0x3d5,%esi
8010088a:	89 f2                	mov    %esi,%edx
8010088c:	ec                   	in     (%dx),%al
8010088d:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100890:	89 fa                	mov    %edi,%edx
80100892:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT + 1) << 8;
80100897:	c1 e3 08             	shl    $0x8,%ebx
8010089a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010089b:	89 f2                	mov    %esi,%edx
8010089d:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
8010089e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801008a1:	89 fa                	mov    %edi,%edx
801008a3:	09 c3                	or     %eax,%ebx
801008a5:	b8 0e 00 00 00       	mov    $0xe,%eax
    pos++;
801008aa:	83 c3 01             	add    $0x1,%ebx
801008ad:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
801008ae:	89 da                	mov    %ebx,%edx
801008b0:	c1 fa 08             	sar    $0x8,%edx
801008b3:	89 d0                	mov    %edx,%eax
801008b5:	89 f2                	mov    %esi,%edx
801008b7:	ee                   	out    %al,(%dx)
801008b8:	b8 0f 00 00 00       	mov    $0xf,%eax
801008bd:	89 fa                	mov    %edi,%edx
801008bf:	ee                   	out    %al,(%dx)
801008c0:	89 d8                	mov    %ebx,%eax
801008c2:	89 f2                	mov    %esi,%edx
801008c4:	ee                   	out    %al,(%dx)
    for (int i= 0 ; i < backs ; i ++){
801008c5:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801008c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801008cc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
801008cf:	75 ac                	jne    8010087d <arrow+0x1bd>
    backs = 0;
801008d1:	c7 05 58 b5 10 80 00 	movl   $0x0,0x8010b558
801008d8:	00 00 00 
    for ( int i = input.e ; i > input.w ; i-- ){
801008db:	89 cb                	mov    %ecx,%ebx
801008dd:	3b 0d a4 0f 11 80    	cmp    0x80110fa4,%ecx
801008e3:	0f 86 4e ff ff ff    	jbe    80100837 <arrow+0x177>
      if (input.buf[i - 1] != '\n'){
801008e9:	83 eb 01             	sub    $0x1,%ebx
801008ec:	80 bb 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%ebx)
801008f3:	0f 84 50 ff ff ff    	je     80100849 <arrow+0x189>
  if(panicked){
801008f9:	8b 15 5c b5 10 80    	mov    0x8010b55c,%edx
801008ff:	85 d2                	test   %edx,%edx
80100901:	0f 84 38 ff ff ff    	je     8010083f <arrow+0x17f>
  asm volatile("cli");
80100907:	fa                   	cli    
    for(;;)
80100908:	eb fe                	jmp    80100908 <arrow+0x248>
8010090a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100910 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100910:	f3 0f 1e fb          	endbr32 
80100914:	55                   	push   %ebp
80100915:	89 e5                	mov    %esp,%ebp
80100917:	57                   	push   %edi
80100918:	56                   	push   %esi
80100919:	53                   	push   %ebx
8010091a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010091d:	ff 75 08             	pushl  0x8(%ebp)
{
80100920:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100923:	e8 c8 14 00 00       	call   80101df0 <iunlock>
  acquire(&cons.lock);
80100928:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010092f:	e8 dc 41 00 00       	call   80104b10 <acquire>
  for(i = 0; i < n; i++)
80100934:	83 c4 10             	add    $0x10,%esp
80100937:	85 db                	test   %ebx,%ebx
80100939:	7e 24                	jle    8010095f <consolewrite+0x4f>
8010093b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010093e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100941:	8b 15 5c b5 10 80    	mov    0x8010b55c,%edx
80100947:	85 d2                	test   %edx,%edx
80100949:	74 05                	je     80100950 <consolewrite+0x40>
8010094b:	fa                   	cli    
    for(;;)
8010094c:	eb fe                	jmp    8010094c <consolewrite+0x3c>
8010094e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100950:	0f b6 07             	movzbl (%edi),%eax
80100953:	83 c7 01             	add    $0x1,%edi
80100956:	e8 b5 fa ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010095b:	39 fe                	cmp    %edi,%esi
8010095d:	75 e2                	jne    80100941 <consolewrite+0x31>
  release(&cons.lock);
8010095f:	83 ec 0c             	sub    $0xc,%esp
80100962:	68 20 b5 10 80       	push   $0x8010b520
80100967:	e8 64 42 00 00       	call   80104bd0 <release>
  ilock(ip);
8010096c:	58                   	pop    %eax
8010096d:	ff 75 08             	pushl  0x8(%ebp)
80100970:	e8 9b 13 00 00       	call   80101d10 <ilock>

  return n;
}
80100975:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100978:	89 d8                	mov    %ebx,%eax
8010097a:	5b                   	pop    %ebx
8010097b:	5e                   	pop    %esi
8010097c:	5f                   	pop    %edi
8010097d:	5d                   	pop    %ebp
8010097e:	c3                   	ret    
8010097f:	90                   	nop

80100980 <cprintf>:
{
80100980:	f3 0f 1e fb          	endbr32 
80100984:	55                   	push   %ebp
80100985:	89 e5                	mov    %esp,%ebp
80100987:	57                   	push   %edi
80100988:	56                   	push   %esi
80100989:	53                   	push   %ebx
8010098a:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
8010098d:	a1 54 b5 10 80       	mov    0x8010b554,%eax
80100992:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100995:	85 c0                	test   %eax,%eax
80100997:	0f 85 e8 00 00 00    	jne    80100a85 <cprintf+0x105>
  if (fmt == 0)
8010099d:	8b 45 08             	mov    0x8(%ebp),%eax
801009a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801009a3:	85 c0                	test   %eax,%eax
801009a5:	0f 84 5a 01 00 00    	je     80100b05 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801009ab:	0f b6 00             	movzbl (%eax),%eax
801009ae:	85 c0                	test   %eax,%eax
801009b0:	74 36                	je     801009e8 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801009b2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801009b5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801009b7:	83 f8 25             	cmp    $0x25,%eax
801009ba:	74 44                	je     80100a00 <cprintf+0x80>
  if(panicked){
801009bc:	8b 0d 5c b5 10 80    	mov    0x8010b55c,%ecx
801009c2:	85 c9                	test   %ecx,%ecx
801009c4:	74 0f                	je     801009d5 <cprintf+0x55>
801009c6:	fa                   	cli    
    for(;;)
801009c7:	eb fe                	jmp    801009c7 <cprintf+0x47>
801009c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009d0:	b8 25 00 00 00       	mov    $0x25,%eax
801009d5:	e8 36 fa ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801009da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801009dd:	83 c6 01             	add    $0x1,%esi
801009e0:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
801009e4:	85 c0                	test   %eax,%eax
801009e6:	75 cf                	jne    801009b7 <cprintf+0x37>
  if(locking)
801009e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801009eb:	85 c0                	test   %eax,%eax
801009ed:	0f 85 fd 00 00 00    	jne    80100af0 <cprintf+0x170>
}
801009f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009f6:	5b                   	pop    %ebx
801009f7:	5e                   	pop    %esi
801009f8:	5f                   	pop    %edi
801009f9:	5d                   	pop    %ebp
801009fa:	c3                   	ret    
801009fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009ff:	90                   	nop
    c = fmt[++i] & 0xff;
80100a00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100a03:	83 c6 01             	add    $0x1,%esi
80100a06:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
80100a0a:	85 ff                	test   %edi,%edi
80100a0c:	74 da                	je     801009e8 <cprintf+0x68>
    switch(c){
80100a0e:	83 ff 70             	cmp    $0x70,%edi
80100a11:	74 5a                	je     80100a6d <cprintf+0xed>
80100a13:	7f 2a                	jg     80100a3f <cprintf+0xbf>
80100a15:	83 ff 25             	cmp    $0x25,%edi
80100a18:	0f 84 92 00 00 00    	je     80100ab0 <cprintf+0x130>
80100a1e:	83 ff 64             	cmp    $0x64,%edi
80100a21:	0f 85 a1 00 00 00    	jne    80100ac8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100a27:	8b 03                	mov    (%ebx),%eax
80100a29:	8d 7b 04             	lea    0x4(%ebx),%edi
80100a2c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100a31:	ba 0a 00 00 00       	mov    $0xa,%edx
80100a36:	89 fb                	mov    %edi,%ebx
80100a38:	e8 e3 fb ff ff       	call   80100620 <printint>
      break;
80100a3d:	eb 9b                	jmp    801009da <cprintf+0x5a>
    switch(c){
80100a3f:	83 ff 73             	cmp    $0x73,%edi
80100a42:	75 24                	jne    80100a68 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100a44:	8d 7b 04             	lea    0x4(%ebx),%edi
80100a47:	8b 1b                	mov    (%ebx),%ebx
80100a49:	85 db                	test   %ebx,%ebx
80100a4b:	75 55                	jne    80100aa2 <cprintf+0x122>
        s = "(null)";
80100a4d:	bb f8 76 10 80       	mov    $0x801076f8,%ebx
      for(; *s; s++)
80100a52:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100a57:	8b 15 5c b5 10 80    	mov    0x8010b55c,%edx
80100a5d:	85 d2                	test   %edx,%edx
80100a5f:	74 39                	je     80100a9a <cprintf+0x11a>
80100a61:	fa                   	cli    
    for(;;)
80100a62:	eb fe                	jmp    80100a62 <cprintf+0xe2>
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100a68:	83 ff 78             	cmp    $0x78,%edi
80100a6b:	75 5b                	jne    80100ac8 <cprintf+0x148>
      printint(*argp++, 16, 0);
80100a6d:	8b 03                	mov    (%ebx),%eax
80100a6f:	8d 7b 04             	lea    0x4(%ebx),%edi
80100a72:	31 c9                	xor    %ecx,%ecx
80100a74:	ba 10 00 00 00       	mov    $0x10,%edx
80100a79:	89 fb                	mov    %edi,%ebx
80100a7b:	e8 a0 fb ff ff       	call   80100620 <printint>
      break;
80100a80:	e9 55 ff ff ff       	jmp    801009da <cprintf+0x5a>
    acquire(&cons.lock);
80100a85:	83 ec 0c             	sub    $0xc,%esp
80100a88:	68 20 b5 10 80       	push   $0x8010b520
80100a8d:	e8 7e 40 00 00       	call   80104b10 <acquire>
80100a92:	83 c4 10             	add    $0x10,%esp
80100a95:	e9 03 ff ff ff       	jmp    8010099d <cprintf+0x1d>
80100a9a:	e8 71 f9 ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
80100a9f:	83 c3 01             	add    $0x1,%ebx
80100aa2:	0f be 03             	movsbl (%ebx),%eax
80100aa5:	84 c0                	test   %al,%al
80100aa7:	75 ae                	jne    80100a57 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
80100aa9:	89 fb                	mov    %edi,%ebx
80100aab:	e9 2a ff ff ff       	jmp    801009da <cprintf+0x5a>
  if(panicked){
80100ab0:	8b 3d 5c b5 10 80    	mov    0x8010b55c,%edi
80100ab6:	85 ff                	test   %edi,%edi
80100ab8:	0f 84 12 ff ff ff    	je     801009d0 <cprintf+0x50>
80100abe:	fa                   	cli    
    for(;;)
80100abf:	eb fe                	jmp    80100abf <cprintf+0x13f>
80100ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100ac8:	8b 0d 5c b5 10 80    	mov    0x8010b55c,%ecx
80100ace:	85 c9                	test   %ecx,%ecx
80100ad0:	74 06                	je     80100ad8 <cprintf+0x158>
80100ad2:	fa                   	cli    
    for(;;)
80100ad3:	eb fe                	jmp    80100ad3 <cprintf+0x153>
80100ad5:	8d 76 00             	lea    0x0(%esi),%esi
80100ad8:	b8 25 00 00 00       	mov    $0x25,%eax
80100add:	e8 2e f9 ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100ae2:	8b 15 5c b5 10 80    	mov    0x8010b55c,%edx
80100ae8:	85 d2                	test   %edx,%edx
80100aea:	74 2c                	je     80100b18 <cprintf+0x198>
80100aec:	fa                   	cli    
    for(;;)
80100aed:	eb fe                	jmp    80100aed <cprintf+0x16d>
80100aef:	90                   	nop
    release(&cons.lock);
80100af0:	83 ec 0c             	sub    $0xc,%esp
80100af3:	68 20 b5 10 80       	push   $0x8010b520
80100af8:	e8 d3 40 00 00       	call   80104bd0 <release>
80100afd:	83 c4 10             	add    $0x10,%esp
}
80100b00:	e9 ee fe ff ff       	jmp    801009f3 <cprintf+0x73>
    panic("null fmt");
80100b05:	83 ec 0c             	sub    $0xc,%esp
80100b08:	68 ff 76 10 80       	push   $0x801076ff
80100b0d:	e8 7e f8 ff ff       	call   80100390 <panic>
80100b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100b18:	89 f8                	mov    %edi,%eax
80100b1a:	e8 f1 f8 ff ff       	call   80100410 <consputc.part.0>
80100b1f:	e9 b6 fe ff ff       	jmp    801009da <cprintf+0x5a>
80100b24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b2f:	90                   	nop

80100b30 <consoleintr>:
{
80100b30:	f3 0f 1e fb          	endbr32 
80100b34:	55                   	push   %ebp
80100b35:	89 e5                	mov    %esp,%ebp
80100b37:	57                   	push   %edi
80100b38:	56                   	push   %esi
80100b39:	53                   	push   %ebx
  int c, doprocdump = 0;
80100b3a:	31 db                	xor    %ebx,%ebx
{
80100b3c:	83 ec 28             	sub    $0x28,%esp
80100b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
80100b42:	68 20 b5 10 80       	push   $0x8010b520
{
80100b47:	89 45 dc             	mov    %eax,-0x24(%ebp)
  acquire(&cons.lock);
80100b4a:	e8 c1 3f 00 00       	call   80104b10 <acquire>
  while((c = getc()) >= 0){
80100b4f:	83 c4 10             	add    $0x10,%esp
80100b52:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100b55:	ff d0                	call   *%eax
80100b57:	89 c6                	mov    %eax,%esi
80100b59:	85 c0                	test   %eax,%eax
80100b5b:	0f 88 bc 02 00 00    	js     80100e1d <consoleintr+0x2ed>
    switch(c){
80100b61:	83 fe 15             	cmp    $0x15,%esi
80100b64:	7f 5a                	jg     80100bc0 <consoleintr+0x90>
80100b66:	83 fe 01             	cmp    $0x1,%esi
80100b69:	0f 8e b1 01 00 00    	jle    80100d20 <consoleintr+0x1f0>
80100b6f:	83 fe 15             	cmp    $0x15,%esi
80100b72:	0f 87 a8 01 00 00    	ja     80100d20 <consoleintr+0x1f0>
80100b78:	3e ff 24 b5 10 77 10 	notrack jmp *-0x7fef88f0(,%esi,4)
80100b7f:	80 
80100b80:	bb 01 00 00 00       	mov    $0x1,%ebx
80100b85:	eb cb                	jmp    80100b52 <consoleintr+0x22>
80100b87:	b8 00 01 00 00       	mov    $0x100,%eax
80100b8c:	e8 7f f8 ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
80100b91:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100b96:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100b9c:	74 b4                	je     80100b52 <consoleintr+0x22>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100b9e:	83 e8 01             	sub    $0x1,%eax
80100ba1:	89 c2                	mov    %eax,%edx
80100ba3:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100ba6:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100bad:	74 a3                	je     80100b52 <consoleintr+0x22>
        input.e--;
80100baf:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100bb4:	a1 5c b5 10 80       	mov    0x8010b55c,%eax
80100bb9:	85 c0                	test   %eax,%eax
80100bbb:	74 ca                	je     80100b87 <consoleintr+0x57>
80100bbd:	fa                   	cli    
    for(;;)
80100bbe:	eb fe                	jmp    80100bbe <consoleintr+0x8e>
    switch(c){
80100bc0:	81 fe e2 00 00 00    	cmp    $0xe2,%esi
80100bc6:	0f 84 24 02 00 00    	je     80100df0 <consoleintr+0x2c0>
80100bcc:	81 fe e3 00 00 00    	cmp    $0xe3,%esi
80100bd2:	75 34                	jne    80100c08 <consoleintr+0xd8>
      if ((history.count != 0 ) && (history.last - history.index > 0))
80100bd4:	a1 3c 15 11 80       	mov    0x8011153c,%eax
80100bd9:	85 c0                	test   %eax,%eax
80100bdb:	0f 84 71 ff ff ff    	je     80100b52 <consoleintr+0x22>
80100be1:	a1 40 15 11 80       	mov    0x80111540,%eax
80100be6:	2b 05 38 15 11 80    	sub    0x80111538,%eax
80100bec:	85 c0                	test   %eax,%eax
80100bee:	0f 8e 5e ff ff ff    	jle    80100b52 <consoleintr+0x22>
        arrow(DOWN);
80100bf4:	b8 01 00 00 00       	mov    $0x1,%eax
80100bf9:	e8 c2 fa ff ff       	call   801006c0 <arrow>
80100bfe:	e9 4f ff ff ff       	jmp    80100b52 <consoleintr+0x22>
80100c03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c07:	90                   	nop
    switch(c){
80100c08:	83 fe 7f             	cmp    $0x7f,%esi
80100c0b:	0f 85 17 01 00 00    	jne    80100d28 <consoleintr+0x1f8>
      if(input.e != input.w){
80100c11:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100c16:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100c1c:	0f 84 30 ff ff ff    	je     80100b52 <consoleintr+0x22>
        input.e--;  
80100c22:	83 e8 01             	sub    $0x1,%eax
80100c25:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100c2a:	a1 5c b5 10 80       	mov    0x8010b55c,%eax
80100c2f:	85 c0                	test   %eax,%eax
80100c31:	0f 84 06 02 00 00    	je     80100e3d <consoleintr+0x30d>
80100c37:	fa                   	cli    
    for(;;)
80100c38:	eb fe                	jmp    80100c38 <consoleintr+0x108>
      if (backs > 0) {
80100c3a:	a1 58 b5 10 80       	mov    0x8010b558,%eax
80100c3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100c42:	85 c0                	test   %eax,%eax
80100c44:	0f 8e 08 ff ff ff    	jle    80100b52 <consoleintr+0x22>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c4a:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100c4f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c54:	89 fa                	mov    %edi,%edx
80100c56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c57:	be d5 03 00 00       	mov    $0x3d5,%esi
80100c5c:	89 f2                	mov    %esi,%edx
80100c5e:	ec                   	in     (%dx),%al
80100c5f:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c62:	89 fa                	mov    %edi,%edx
80100c64:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT + 1) << 8;
80100c69:	c1 e1 08             	shl    $0x8,%ecx
80100c6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c6d:	89 f2                	mov    %esi,%edx
80100c6f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100c70:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c73:	89 fa                	mov    %edi,%edx
80100c75:	09 c1                	or     %eax,%ecx
80100c77:	b8 0e 00 00 00       	mov    $0xe,%eax
    pos++;
80100c7c:	83 c1 01             	add    $0x1,%ecx
80100c7f:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100c80:	89 ca                	mov    %ecx,%edx
80100c82:	c1 fa 08             	sar    $0x8,%edx
80100c85:	89 d0                	mov    %edx,%eax
80100c87:	89 f2                	mov    %esi,%edx
80100c89:	ee                   	out    %al,(%dx)
80100c8a:	b8 0f 00 00 00       	mov    $0xf,%eax
80100c8f:	89 fa                	mov    %edi,%edx
80100c91:	ee                   	out    %al,(%dx)
80100c92:	89 c8                	mov    %ecx,%eax
80100c94:	89 f2                	mov    %esi,%edx
80100c96:	ee                   	out    %al,(%dx)
        backs--;
80100c97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c9a:	83 e8 01             	sub    $0x1,%eax
80100c9d:	a3 58 b5 10 80       	mov    %eax,0x8010b558
80100ca2:	e9 ab fe ff ff       	jmp    80100b52 <consoleintr+0x22>
      if ((input.e - backs) > input.w)
80100ca7:	a1 58 b5 10 80       	mov    0x8010b558,%eax
80100cac:	8b 3d a8 0f 11 80    	mov    0x80110fa8,%edi
80100cb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100cb5:	29 c7                	sub    %eax,%edi
80100cb7:	3b 3d a4 0f 11 80    	cmp    0x80110fa4,%edi
80100cbd:	0f 86 8f fe ff ff    	jbe    80100b52 <consoleintr+0x22>
80100cc3:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100cc8:	b8 0e 00 00 00       	mov    $0xe,%eax
80100ccd:	89 fa                	mov    %edi,%edx
80100ccf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100cd0:	be d5 03 00 00       	mov    $0x3d5,%esi
80100cd5:	89 f2                	mov    %esi,%edx
80100cd7:	ec                   	in     (%dx),%al
80100cd8:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100cdb:	89 fa                	mov    %edi,%edx
80100cdd:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT + 1) << 8;
80100ce2:	c1 e1 08             	shl    $0x8,%ecx
80100ce5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100ce6:	89 f2                	mov    %esi,%edx
80100ce8:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100ce9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100cec:	89 fa                	mov    %edi,%edx
80100cee:	09 c1                	or     %eax,%ecx
80100cf0:	b8 0e 00 00 00       	mov    $0xe,%eax
    pos--;
80100cf5:	83 e9 01             	sub    $0x1,%ecx
80100cf8:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100cf9:	89 ca                	mov    %ecx,%edx
80100cfb:	c1 fa 08             	sar    $0x8,%edx
80100cfe:	89 d0                	mov    %edx,%eax
80100d00:	89 f2                	mov    %esi,%edx
80100d02:	ee                   	out    %al,(%dx)
80100d03:	b8 0f 00 00 00       	mov    $0xf,%eax
80100d08:	89 fa                	mov    %edi,%edx
80100d0a:	ee                   	out    %al,(%dx)
80100d0b:	89 c8                	mov    %ecx,%eax
80100d0d:	89 f2                	mov    %esi,%edx
80100d0f:	ee                   	out    %al,(%dx)
        backs++;
80100d10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d13:	83 c0 01             	add    $0x1,%eax
80100d16:	a3 58 b5 10 80       	mov    %eax,0x8010b558
80100d1b:	e9 32 fe ff ff       	jmp    80100b52 <consoleintr+0x22>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100d20:	85 f6                	test   %esi,%esi
80100d22:	0f 84 2a fe ff ff    	je     80100b52 <consoleintr+0x22>
80100d28:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100d2d:	89 c2                	mov    %eax,%edx
80100d2f:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
80100d35:	83 fa 7f             	cmp    $0x7f,%edx
80100d38:	0f 87 14 fe ff ff    	ja     80100b52 <consoleintr+0x22>
        c = (c == '\r') ? '\n' : c;
80100d3e:	8d 48 01             	lea    0x1(%eax),%ecx
80100d41:	8b 15 5c b5 10 80    	mov    0x8010b55c,%edx
80100d47:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
80100d4a:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
80100d50:	83 fe 0d             	cmp    $0xd,%esi
80100d53:	0f 84 f3 00 00 00    	je     80100e4c <consoleintr+0x31c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100d59:	89 f1                	mov    %esi,%ecx
80100d5b:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
  if(panicked){
80100d61:	85 d2                	test   %edx,%edx
80100d63:	0f 84 d7 01 00 00    	je     80100f40 <consoleintr+0x410>
  asm volatile("cli");
80100d69:	fa                   	cli    
    for(;;)
80100d6a:	eb fe                	jmp    80100d6a <consoleintr+0x23a>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d6c:	be d4 03 00 00       	mov    $0x3d4,%esi
80100d71:	b8 0e 00 00 00       	mov    $0xe,%eax
80100d76:	89 f2                	mov    %esi,%edx
80100d78:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d79:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100d7e:	89 ca                	mov    %ecx,%edx
80100d80:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d81:	b8 0f 00 00 00       	mov    $0xf,%eax
80100d86:	89 f2                	mov    %esi,%edx
80100d88:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d89:	89 ca                	mov    %ecx,%edx
80100d8b:	ec                   	in     (%dx),%al
80100d8c:	be d0 07 00 00       	mov    $0x7d0,%esi
  if(panicked){
80100d91:	8b 3d 5c b5 10 80    	mov    0x8010b55c,%edi
80100d97:	85 ff                	test   %edi,%edi
80100d99:	74 05                	je     80100da0 <consoleintr+0x270>
  asm volatile("cli");
80100d9b:	fa                   	cli    
    for(;;)
80100d9c:	eb fe                	jmp    80100d9c <consoleintr+0x26c>
80100d9e:	66 90                	xchg   %ax,%ax
80100da0:	b8 00 01 00 00       	mov    $0x100,%eax
80100da5:	e8 66 f6 ff ff       	call   80100410 <consputc.part.0>
  for (int pos = 0; pos < SCREEN_SIZE ; pos++){
80100daa:	83 ee 01             	sub    $0x1,%esi
80100dad:	75 e2                	jne    80100d91 <consoleintr+0x261>
  if(panicked){
80100daf:	8b 0d 5c b5 10 80    	mov    0x8010b55c,%ecx
  backs = 0;
80100db5:	c7 05 58 b5 10 80 00 	movl   $0x0,0x8010b558
80100dbc:	00 00 00 
  input.e = input.w = input.r = 0;
80100dbf:	c7 05 a0 0f 11 80 00 	movl   $0x0,0x80110fa0
80100dc6:	00 00 00 
80100dc9:	c7 05 a4 0f 11 80 00 	movl   $0x0,0x80110fa4
80100dd0:	00 00 00 
80100dd3:	c7 05 a8 0f 11 80 00 	movl   $0x0,0x80110fa8
80100dda:	00 00 00 
  if(panicked){
80100ddd:	85 c9                	test   %ecx,%ecx
80100ddf:	0f 84 fb 00 00 00    	je     80100ee0 <consoleintr+0x3b0>
80100de5:	fa                   	cli    
    for(;;)
80100de6:	eb fe                	jmp    80100de6 <consoleintr+0x2b6>
80100de8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100def:	90                   	nop
      if ((history.count != 0)  && (history.last - history.index < history.count))
80100df0:	8b 15 3c 15 11 80    	mov    0x8011153c,%edx
80100df6:	85 d2                	test   %edx,%edx
80100df8:	0f 84 54 fd ff ff    	je     80100b52 <consoleintr+0x22>
80100dfe:	a1 40 15 11 80       	mov    0x80111540,%eax
80100e03:	2b 05 38 15 11 80    	sub    0x80111538,%eax
80100e09:	39 c2                	cmp    %eax,%edx
80100e0b:	0f 8e 41 fd ff ff    	jle    80100b52 <consoleintr+0x22>
        arrow(UP);
80100e11:	31 c0                	xor    %eax,%eax
80100e13:	e8 a8 f8 ff ff       	call   801006c0 <arrow>
80100e18:	e9 35 fd ff ff       	jmp    80100b52 <consoleintr+0x22>
  release(&cons.lock);
80100e1d:	83 ec 0c             	sub    $0xc,%esp
80100e20:	68 20 b5 10 80       	push   $0x8010b520
80100e25:	e8 a6 3d 00 00       	call   80104bd0 <release>
  if(doprocdump) {
80100e2a:	83 c4 10             	add    $0x10,%esp
80100e2d:	85 db                	test   %ebx,%ebx
80100e2f:	0f 85 40 01 00 00    	jne    80100f75 <consoleintr+0x445>
}
80100e35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e38:	5b                   	pop    %ebx
80100e39:	5e                   	pop    %esi
80100e3a:	5f                   	pop    %edi
80100e3b:	5d                   	pop    %ebp
80100e3c:	c3                   	ret    
80100e3d:	b8 00 01 00 00       	mov    $0x100,%eax
80100e42:	e8 c9 f5 ff ff       	call   80100410 <consputc.part.0>
80100e47:	e9 06 fd ff ff       	jmp    80100b52 <consoleintr+0x22>
        input.buf[input.e++ % INPUT_BUF] = c;
80100e4c:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
  if(panicked){
80100e53:	85 d2                	test   %edx,%edx
80100e55:	0f 85 0e ff ff ff    	jne    80100d69 <consoleintr+0x239>
80100e5b:	b8 0a 00 00 00       	mov    $0xa,%eax
80100e60:	e8 ab f5 ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100e65:	8b 15 a8 0f 11 80    	mov    0x80110fa8,%edx
          if (history.count < 9){
80100e6b:	a1 3c 15 11 80       	mov    0x8011153c,%eax
80100e70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100e73:	83 f8 08             	cmp    $0x8,%eax
80100e76:	0f 8f 05 01 00 00    	jg     80100f81 <consoleintr+0x451>
            history.hist[history.last + 1] = input;
80100e7c:	8b 3d 40 15 11 80    	mov    0x80111540,%edi
80100e82:	b9 23 00 00 00       	mov    $0x23,%ecx
80100e87:	be 20 0f 11 80       	mov    $0x80110f20,%esi
80100e8c:	83 c7 01             	add    $0x1,%edi
80100e8f:	69 c7 8c 00 00 00    	imul   $0x8c,%edi,%eax
80100e95:	89 7d e0             	mov    %edi,-0x20(%ebp)
80100e98:	05 c0 0f 11 80       	add    $0x80110fc0,%eax
80100e9d:	89 c7                	mov    %eax,%edi
            history.count ++ ;
80100e9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
            history.hist[history.last + 1] = input;
80100ea2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            history.last ++ ;
80100ea4:	8b 7d e0             	mov    -0x20(%ebp),%edi
            history.count ++ ;
80100ea7:	83 c0 01             	add    $0x1,%eax
            history.last ++ ;
80100eaa:	89 3d 40 15 11 80    	mov    %edi,0x80111540
            history.index = history.last;
80100eb0:	89 3d 38 15 11 80    	mov    %edi,0x80111538
            history.count ++ ;
80100eb6:	a3 3c 15 11 80       	mov    %eax,0x8011153c
          wakeup(&input.r);
80100ebb:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100ebe:	89 15 a4 0f 11 80    	mov    %edx,0x80110fa4
          wakeup(&input.r);
80100ec4:	68 a0 0f 11 80       	push   $0x80110fa0
          backs = 0;
80100ec9:	c7 05 58 b5 10 80 00 	movl   $0x0,0x8010b558
80100ed0:	00 00 00 
          wakeup(&input.r);
80100ed3:	e8 b8 37 00 00       	call   80104690 <wakeup>
80100ed8:	83 c4 10             	add    $0x10,%esp
80100edb:	e9 72 fc ff ff       	jmp    80100b52 <consoleintr+0x22>
80100ee0:	b8 24 00 00 00       	mov    $0x24,%eax
80100ee5:	e8 26 f5 ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100eea:	8b 15 5c b5 10 80    	mov    0x8010b55c,%edx
80100ef0:	85 d2                	test   %edx,%edx
80100ef2:	74 0c                	je     80100f00 <consoleintr+0x3d0>
80100ef4:	fa                   	cli    
    for(;;)
80100ef5:	eb fe                	jmp    80100ef5 <consoleintr+0x3c5>
80100ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100efe:	66 90                	xchg   %ax,%ax
80100f00:	b8 20 00 00 00       	mov    $0x20,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100f05:	be d4 03 00 00       	mov    $0x3d4,%esi
80100f0a:	e8 01 f5 ff ff       	call   80100410 <consputc.part.0>
80100f0f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100f14:	89 f2                	mov    %esi,%edx
80100f16:	ee                   	out    %al,(%dx)
80100f17:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100f1c:	31 c0                	xor    %eax,%eax
80100f1e:	89 ca                	mov    %ecx,%edx
80100f20:	ee                   	out    %al,(%dx)
80100f21:	b8 0f 00 00 00       	mov    $0xf,%eax
80100f26:	89 f2                	mov    %esi,%edx
80100f28:	ee                   	out    %al,(%dx)
80100f29:	b8 02 00 00 00       	mov    $0x2,%eax
80100f2e:	89 ca                	mov    %ecx,%edx
80100f30:	ee                   	out    %al,(%dx)
}
80100f31:	e9 1c fc ff ff       	jmp    80100b52 <consoleintr+0x22>
80100f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f3d:	8d 76 00             	lea    0x0(%esi),%esi
80100f40:	89 f0                	mov    %esi,%eax
80100f42:	e8 c9 f4 ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100f47:	83 fe 0a             	cmp    $0xa,%esi
80100f4a:	0f 84 15 ff ff ff    	je     80100e65 <consoleintr+0x335>
80100f50:	83 fe 04             	cmp    $0x4,%esi
80100f53:	0f 84 0c ff ff ff    	je     80100e65 <consoleintr+0x335>
80100f59:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
80100f5e:	8d 90 80 00 00 00    	lea    0x80(%eax),%edx
80100f64:	39 15 a8 0f 11 80    	cmp    %edx,0x80110fa8
80100f6a:	0f 85 e2 fb ff ff    	jne    80100b52 <consoleintr+0x22>
80100f70:	e9 f6 fe ff ff       	jmp    80100e6b <consoleintr+0x33b>
}
80100f75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f78:	5b                   	pop    %ebx
80100f79:	5e                   	pop    %esi
80100f7a:	5f                   	pop    %edi
80100f7b:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100f7c:	e9 ff 37 00 00       	jmp    80104780 <procdump>
80100f81:	b8 c0 0f 11 80       	mov    $0x80110fc0,%eax
              history.hist[h] = history.hist[h+1]; 
80100f86:	8d b0 8c 00 00 00    	lea    0x8c(%eax),%esi
80100f8c:	89 c7                	mov    %eax,%edi
80100f8e:	b9 23 00 00 00       	mov    $0x23,%ecx
80100f93:	05 8c 00 00 00       	add    $0x8c,%eax
80100f98:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            for (int h = 0; h < 9; h++) {
80100f9a:	bf ac 14 11 80       	mov    $0x801114ac,%edi
80100f9f:	39 c7                	cmp    %eax,%edi
80100fa1:	75 e3                	jne    80100f86 <consoleintr+0x456>
            history.hist[9] = input;
80100fa3:	b9 23 00 00 00       	mov    $0x23,%ecx
80100fa8:	be 20 0f 11 80       	mov    $0x80110f20,%esi
            history.index = 9;
80100fad:	c7 05 38 15 11 80 09 	movl   $0x9,0x80111538
80100fb4:	00 00 00 
            history.hist[9] = input;
80100fb7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            history.last = 9;
80100fb9:	c7 05 40 15 11 80 09 	movl   $0x9,0x80111540
80100fc0:	00 00 00 
            history.count = 10;
80100fc3:	c7 05 3c 15 11 80 0a 	movl   $0xa,0x8011153c
80100fca:	00 00 00 
80100fcd:	e9 e9 fe ff ff       	jmp    80100ebb <consoleintr+0x38b>
80100fd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <consoleinit>:

void
consoleinit(void)
{
80100fe0:	f3 0f 1e fb          	endbr32 
80100fe4:	55                   	push   %ebp
80100fe5:	89 e5                	mov    %esp,%ebp
80100fe7:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100fea:	68 08 77 10 80       	push   $0x80107708
80100fef:	68 20 b5 10 80       	push   $0x8010b520
80100ff4:	e8 97 39 00 00       	call   80104990 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ff9:	58                   	pop    %eax
80100ffa:	5a                   	pop    %edx
80100ffb:	6a 00                	push   $0x0
80100ffd:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100fff:	c7 05 0c 1f 11 80 10 	movl   $0x80100910,0x80111f0c
80101006:	09 10 80 
  devsw[CONSOLE].read = consoleread;
80101009:	c7 05 08 1f 11 80 90 	movl   $0x80100290,0x80111f08
80101010:	02 10 80 
  cons.locking = 1;
80101013:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
8010101a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
8010101d:	e8 be 19 00 00       	call   801029e0 <ioapicenable>
}
80101022:	83 c4 10             	add    $0x10,%esp
80101025:	c9                   	leave  
80101026:	c3                   	ret    
80101027:	66 90                	xchg   %ax,%ax
80101029:	66 90                	xchg   %ax,%ax
8010102b:	66 90                	xchg   %ax,%ax
8010102d:	66 90                	xchg   %ax,%ax
8010102f:	90                   	nop

80101030 <exec>:
80101030:	f3 0f 1e fb          	endbr32 
80101034:	55                   	push   %ebp
80101035:	89 e5                	mov    %esp,%ebp
80101037:	57                   	push   %edi
80101038:	56                   	push   %esi
80101039:	53                   	push   %ebx
8010103a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
80101040:	e8 cb 2e 00 00       	call   80103f10 <myproc>
80101045:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
8010104b:	e8 90 22 00 00       	call   801032e0 <begin_op>
80101050:	83 ec 0c             	sub    $0xc,%esp
80101053:	ff 75 08             	pushl  0x8(%ebp)
80101056:	e8 85 15 00 00       	call   801025e0 <namei>
8010105b:	83 c4 10             	add    $0x10,%esp
8010105e:	85 c0                	test   %eax,%eax
80101060:	0f 84 fe 02 00 00    	je     80101364 <exec+0x334>
80101066:	83 ec 0c             	sub    $0xc,%esp
80101069:	89 c3                	mov    %eax,%ebx
8010106b:	50                   	push   %eax
8010106c:	e8 9f 0c 00 00       	call   80101d10 <ilock>
80101071:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101077:	6a 34                	push   $0x34
80101079:	6a 00                	push   $0x0
8010107b:	50                   	push   %eax
8010107c:	53                   	push   %ebx
8010107d:	e8 8e 0f 00 00       	call   80102010 <readi>
80101082:	83 c4 20             	add    $0x20,%esp
80101085:	83 f8 34             	cmp    $0x34,%eax
80101088:	74 26                	je     801010b0 <exec+0x80>
8010108a:	83 ec 0c             	sub    $0xc,%esp
8010108d:	53                   	push   %ebx
8010108e:	e8 1d 0f 00 00       	call   80101fb0 <iunlockput>
80101093:	e8 b8 22 00 00       	call   80103350 <end_op>
80101098:	83 c4 10             	add    $0x10,%esp
8010109b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a3:	5b                   	pop    %ebx
801010a4:	5e                   	pop    %esi
801010a5:	5f                   	pop    %edi
801010a6:	5d                   	pop    %ebp
801010a7:	c3                   	ret    
801010a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010af:	90                   	nop
801010b0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801010b7:	45 4c 46 
801010ba:	75 ce                	jne    8010108a <exec+0x5a>
801010bc:	e8 3f 63 00 00       	call   80107400 <setupkvm>
801010c1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801010c7:	85 c0                	test   %eax,%eax
801010c9:	74 bf                	je     8010108a <exec+0x5a>
801010cb:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801010d2:	00 
801010d3:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
801010d9:	0f 84 a4 02 00 00    	je     80101383 <exec+0x353>
801010df:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801010e6:	00 00 00 
801010e9:	31 ff                	xor    %edi,%edi
801010eb:	e9 86 00 00 00       	jmp    80101176 <exec+0x146>
801010f0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801010f7:	75 6c                	jne    80101165 <exec+0x135>
801010f9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801010ff:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101105:	0f 82 87 00 00 00    	jb     80101192 <exec+0x162>
8010110b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101111:	72 7f                	jb     80101192 <exec+0x162>
80101113:	83 ec 04             	sub    $0x4,%esp
80101116:	50                   	push   %eax
80101117:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
8010111d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101123:	e8 f8 60 00 00       	call   80107220 <allocuvm>
80101128:	83 c4 10             	add    $0x10,%esp
8010112b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101131:	85 c0                	test   %eax,%eax
80101133:	74 5d                	je     80101192 <exec+0x162>
80101135:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010113b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101140:	75 50                	jne    80101192 <exec+0x162>
80101142:	83 ec 0c             	sub    $0xc,%esp
80101145:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
8010114b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80101151:	53                   	push   %ebx
80101152:	50                   	push   %eax
80101153:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101159:	e8 f2 5f 00 00       	call   80107150 <loaduvm>
8010115e:	83 c4 20             	add    $0x20,%esp
80101161:	85 c0                	test   %eax,%eax
80101163:	78 2d                	js     80101192 <exec+0x162>
80101165:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010116c:	83 c7 01             	add    $0x1,%edi
8010116f:	83 c6 20             	add    $0x20,%esi
80101172:	39 f8                	cmp    %edi,%eax
80101174:	7e 3a                	jle    801011b0 <exec+0x180>
80101176:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010117c:	6a 20                	push   $0x20
8010117e:	56                   	push   %esi
8010117f:	50                   	push   %eax
80101180:	53                   	push   %ebx
80101181:	e8 8a 0e 00 00       	call   80102010 <readi>
80101186:	83 c4 10             	add    $0x10,%esp
80101189:	83 f8 20             	cmp    $0x20,%eax
8010118c:	0f 84 5e ff ff ff    	je     801010f0 <exec+0xc0>
80101192:	83 ec 0c             	sub    $0xc,%esp
80101195:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010119b:	e8 e0 61 00 00       	call   80107380 <freevm>
801011a0:	83 c4 10             	add    $0x10,%esp
801011a3:	e9 e2 fe ff ff       	jmp    8010108a <exec+0x5a>
801011a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011af:	90                   	nop
801011b0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801011b6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
801011bc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801011c2:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
801011c8:	83 ec 0c             	sub    $0xc,%esp
801011cb:	53                   	push   %ebx
801011cc:	e8 df 0d 00 00       	call   80101fb0 <iunlockput>
801011d1:	e8 7a 21 00 00       	call   80103350 <end_op>
801011d6:	83 c4 0c             	add    $0xc,%esp
801011d9:	56                   	push   %esi
801011da:	57                   	push   %edi
801011db:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
801011e1:	57                   	push   %edi
801011e2:	e8 39 60 00 00       	call   80107220 <allocuvm>
801011e7:	83 c4 10             	add    $0x10,%esp
801011ea:	89 c6                	mov    %eax,%esi
801011ec:	85 c0                	test   %eax,%eax
801011ee:	0f 84 94 00 00 00    	je     80101288 <exec+0x258>
801011f4:	83 ec 08             	sub    $0x8,%esp
801011f7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
801011fd:	89 f3                	mov    %esi,%ebx
801011ff:	50                   	push   %eax
80101200:	57                   	push   %edi
80101201:	31 ff                	xor    %edi,%edi
80101203:	e8 98 62 00 00       	call   801074a0 <clearpteu>
80101208:	8b 45 0c             	mov    0xc(%ebp),%eax
8010120b:	83 c4 10             	add    $0x10,%esp
8010120e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101214:	8b 00                	mov    (%eax),%eax
80101216:	85 c0                	test   %eax,%eax
80101218:	0f 84 8b 00 00 00    	je     801012a9 <exec+0x279>
8010121e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101224:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
8010122a:	eb 23                	jmp    8010124f <exec+0x21f>
8010122c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101230:	8b 45 0c             	mov    0xc(%ebp),%eax
80101233:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
8010123a:	83 c7 01             	add    $0x1,%edi
8010123d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101243:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101246:	85 c0                	test   %eax,%eax
80101248:	74 59                	je     801012a3 <exec+0x273>
8010124a:	83 ff 20             	cmp    $0x20,%edi
8010124d:	74 39                	je     80101288 <exec+0x258>
8010124f:	83 ec 0c             	sub    $0xc,%esp
80101252:	50                   	push   %eax
80101253:	e8 c8 3b 00 00       	call   80104e20 <strlen>
80101258:	f7 d0                	not    %eax
8010125a:	01 c3                	add    %eax,%ebx
8010125c:	58                   	pop    %eax
8010125d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101260:	83 e3 fc             	and    $0xfffffffc,%ebx
80101263:	ff 34 b8             	pushl  (%eax,%edi,4)
80101266:	e8 b5 3b 00 00       	call   80104e20 <strlen>
8010126b:	83 c0 01             	add    $0x1,%eax
8010126e:	50                   	push   %eax
8010126f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101272:	ff 34 b8             	pushl  (%eax,%edi,4)
80101275:	53                   	push   %ebx
80101276:	56                   	push   %esi
80101277:	e8 84 63 00 00       	call   80107600 <copyout>
8010127c:	83 c4 20             	add    $0x20,%esp
8010127f:	85 c0                	test   %eax,%eax
80101281:	79 ad                	jns    80101230 <exec+0x200>
80101283:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101287:	90                   	nop
80101288:	83 ec 0c             	sub    $0xc,%esp
8010128b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101291:	e8 ea 60 00 00       	call   80107380 <freevm>
80101296:	83 c4 10             	add    $0x10,%esp
80101299:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010129e:	e9 fd fd ff ff       	jmp    801010a0 <exec+0x70>
801012a3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
801012a9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
801012b0:	89 d9                	mov    %ebx,%ecx
801012b2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
801012b9:	00 00 00 00 
801012bd:	29 c1                	sub    %eax,%ecx
801012bf:	83 c0 0c             	add    $0xc,%eax
801012c2:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
801012c8:	29 c3                	sub    %eax,%ebx
801012ca:	50                   	push   %eax
801012cb:	52                   	push   %edx
801012cc:	53                   	push   %ebx
801012cd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801012d3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801012da:	ff ff ff 
801012dd:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
801012e3:	e8 18 63 00 00       	call   80107600 <copyout>
801012e8:	83 c4 10             	add    $0x10,%esp
801012eb:	85 c0                	test   %eax,%eax
801012ed:	78 99                	js     80101288 <exec+0x258>
801012ef:	8b 45 08             	mov    0x8(%ebp),%eax
801012f2:	8b 55 08             	mov    0x8(%ebp),%edx
801012f5:	0f b6 00             	movzbl (%eax),%eax
801012f8:	84 c0                	test   %al,%al
801012fa:	74 13                	je     8010130f <exec+0x2df>
801012fc:	89 d1                	mov    %edx,%ecx
801012fe:	66 90                	xchg   %ax,%ax
80101300:	83 c1 01             	add    $0x1,%ecx
80101303:	3c 2f                	cmp    $0x2f,%al
80101305:	0f b6 01             	movzbl (%ecx),%eax
80101308:	0f 44 d1             	cmove  %ecx,%edx
8010130b:	84 c0                	test   %al,%al
8010130d:	75 f1                	jne    80101300 <exec+0x2d0>
8010130f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101315:	83 ec 04             	sub    $0x4,%esp
80101318:	6a 10                	push   $0x10
8010131a:	89 f8                	mov    %edi,%eax
8010131c:	52                   	push   %edx
8010131d:	83 c0 6c             	add    $0x6c,%eax
80101320:	50                   	push   %eax
80101321:	e8 ba 3a 00 00       	call   80104de0 <safestrcpy>
80101326:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
8010132c:	89 f8                	mov    %edi,%eax
8010132e:	8b 7f 04             	mov    0x4(%edi),%edi
80101331:	89 30                	mov    %esi,(%eax)
80101333:	89 48 04             	mov    %ecx,0x4(%eax)
80101336:	89 c1                	mov    %eax,%ecx
80101338:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010133e:	8b 40 18             	mov    0x18(%eax),%eax
80101341:	89 50 38             	mov    %edx,0x38(%eax)
80101344:	8b 41 18             	mov    0x18(%ecx),%eax
80101347:	89 58 44             	mov    %ebx,0x44(%eax)
8010134a:	89 0c 24             	mov    %ecx,(%esp)
8010134d:	e8 6e 5c 00 00       	call   80106fc0 <switchuvm>
80101352:	89 3c 24             	mov    %edi,(%esp)
80101355:	e8 26 60 00 00       	call   80107380 <freevm>
8010135a:	83 c4 10             	add    $0x10,%esp
8010135d:	31 c0                	xor    %eax,%eax
8010135f:	e9 3c fd ff ff       	jmp    801010a0 <exec+0x70>
80101364:	e8 e7 1f 00 00       	call   80103350 <end_op>
80101369:	83 ec 0c             	sub    $0xc,%esp
8010136c:	68 79 77 10 80       	push   $0x80107779
80101371:	e8 0a f6 ff ff       	call   80100980 <cprintf>
80101376:	83 c4 10             	add    $0x10,%esp
80101379:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010137e:	e9 1d fd ff ff       	jmp    801010a0 <exec+0x70>
80101383:	31 ff                	xor    %edi,%edi
80101385:	be 00 20 00 00       	mov    $0x2000,%esi
8010138a:	e9 39 fe ff ff       	jmp    801011c8 <exec+0x198>
8010138f:	90                   	nop

80101390 <fileinit>:
80101390:	f3 0f 1e fb          	endbr32 
80101394:	55                   	push   %ebp
80101395:	89 e5                	mov    %esp,%ebp
80101397:	83 ec 10             	sub    $0x10,%esp
8010139a:	68 85 77 10 80       	push   $0x80107785
8010139f:	68 60 15 11 80       	push   $0x80111560
801013a4:	e8 e7 35 00 00       	call   80104990 <initlock>
801013a9:	83 c4 10             	add    $0x10,%esp
801013ac:	c9                   	leave  
801013ad:	c3                   	ret    
801013ae:	66 90                	xchg   %ax,%ax

801013b0 <filealloc>:
801013b0:	f3 0f 1e fb          	endbr32 
801013b4:	55                   	push   %ebp
801013b5:	89 e5                	mov    %esp,%ebp
801013b7:	53                   	push   %ebx
801013b8:	bb 94 15 11 80       	mov    $0x80111594,%ebx
801013bd:	83 ec 10             	sub    $0x10,%esp
801013c0:	68 60 15 11 80       	push   $0x80111560
801013c5:	e8 46 37 00 00       	call   80104b10 <acquire>
801013ca:	83 c4 10             	add    $0x10,%esp
801013cd:	eb 0c                	jmp    801013db <filealloc+0x2b>
801013cf:	90                   	nop
801013d0:	83 c3 18             	add    $0x18,%ebx
801013d3:	81 fb f4 1e 11 80    	cmp    $0x80111ef4,%ebx
801013d9:	74 25                	je     80101400 <filealloc+0x50>
801013db:	8b 43 04             	mov    0x4(%ebx),%eax
801013de:	85 c0                	test   %eax,%eax
801013e0:	75 ee                	jne    801013d0 <filealloc+0x20>
801013e2:	83 ec 0c             	sub    $0xc,%esp
801013e5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
801013ec:	68 60 15 11 80       	push   $0x80111560
801013f1:	e8 da 37 00 00       	call   80104bd0 <release>
801013f6:	89 d8                	mov    %ebx,%eax
801013f8:	83 c4 10             	add    $0x10,%esp
801013fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013fe:	c9                   	leave  
801013ff:	c3                   	ret    
80101400:	83 ec 0c             	sub    $0xc,%esp
80101403:	31 db                	xor    %ebx,%ebx
80101405:	68 60 15 11 80       	push   $0x80111560
8010140a:	e8 c1 37 00 00       	call   80104bd0 <release>
8010140f:	89 d8                	mov    %ebx,%eax
80101411:	83 c4 10             	add    $0x10,%esp
80101414:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101417:	c9                   	leave  
80101418:	c3                   	ret    
80101419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101420 <filedup>:
80101420:	f3 0f 1e fb          	endbr32 
80101424:	55                   	push   %ebp
80101425:	89 e5                	mov    %esp,%ebp
80101427:	53                   	push   %ebx
80101428:	83 ec 10             	sub    $0x10,%esp
8010142b:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010142e:	68 60 15 11 80       	push   $0x80111560
80101433:	e8 d8 36 00 00       	call   80104b10 <acquire>
80101438:	8b 43 04             	mov    0x4(%ebx),%eax
8010143b:	83 c4 10             	add    $0x10,%esp
8010143e:	85 c0                	test   %eax,%eax
80101440:	7e 1a                	jle    8010145c <filedup+0x3c>
80101442:	83 c0 01             	add    $0x1,%eax
80101445:	83 ec 0c             	sub    $0xc,%esp
80101448:	89 43 04             	mov    %eax,0x4(%ebx)
8010144b:	68 60 15 11 80       	push   $0x80111560
80101450:	e8 7b 37 00 00       	call   80104bd0 <release>
80101455:	89 d8                	mov    %ebx,%eax
80101457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010145a:	c9                   	leave  
8010145b:	c3                   	ret    
8010145c:	83 ec 0c             	sub    $0xc,%esp
8010145f:	68 8c 77 10 80       	push   $0x8010778c
80101464:	e8 27 ef ff ff       	call   80100390 <panic>
80101469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101470 <fileclose>:
80101470:	f3 0f 1e fb          	endbr32 
80101474:	55                   	push   %ebp
80101475:	89 e5                	mov    %esp,%ebp
80101477:	57                   	push   %edi
80101478:	56                   	push   %esi
80101479:	53                   	push   %ebx
8010147a:	83 ec 28             	sub    $0x28,%esp
8010147d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101480:	68 60 15 11 80       	push   $0x80111560
80101485:	e8 86 36 00 00       	call   80104b10 <acquire>
8010148a:	8b 53 04             	mov    0x4(%ebx),%edx
8010148d:	83 c4 10             	add    $0x10,%esp
80101490:	85 d2                	test   %edx,%edx
80101492:	0f 8e a1 00 00 00    	jle    80101539 <fileclose+0xc9>
80101498:	83 ea 01             	sub    $0x1,%edx
8010149b:	89 53 04             	mov    %edx,0x4(%ebx)
8010149e:	75 40                	jne    801014e0 <fileclose+0x70>
801014a0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
801014a4:	83 ec 0c             	sub    $0xc,%esp
801014a7:	8b 3b                	mov    (%ebx),%edi
801014a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801014af:	8b 73 0c             	mov    0xc(%ebx),%esi
801014b2:	88 45 e7             	mov    %al,-0x19(%ebp)
801014b5:	8b 43 10             	mov    0x10(%ebx),%eax
801014b8:	68 60 15 11 80       	push   $0x80111560
801014bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
801014c0:	e8 0b 37 00 00       	call   80104bd0 <release>
801014c5:	83 c4 10             	add    $0x10,%esp
801014c8:	83 ff 01             	cmp    $0x1,%edi
801014cb:	74 53                	je     80101520 <fileclose+0xb0>
801014cd:	83 ff 02             	cmp    $0x2,%edi
801014d0:	74 26                	je     801014f8 <fileclose+0x88>
801014d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014d5:	5b                   	pop    %ebx
801014d6:	5e                   	pop    %esi
801014d7:	5f                   	pop    %edi
801014d8:	5d                   	pop    %ebp
801014d9:	c3                   	ret    
801014da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014e0:	c7 45 08 60 15 11 80 	movl   $0x80111560,0x8(%ebp)
801014e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014ea:	5b                   	pop    %ebx
801014eb:	5e                   	pop    %esi
801014ec:	5f                   	pop    %edi
801014ed:	5d                   	pop    %ebp
801014ee:	e9 dd 36 00 00       	jmp    80104bd0 <release>
801014f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014f7:	90                   	nop
801014f8:	e8 e3 1d 00 00       	call   801032e0 <begin_op>
801014fd:	83 ec 0c             	sub    $0xc,%esp
80101500:	ff 75 e0             	pushl  -0x20(%ebp)
80101503:	e8 38 09 00 00       	call   80101e40 <iput>
80101508:	83 c4 10             	add    $0x10,%esp
8010150b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150e:	5b                   	pop    %ebx
8010150f:	5e                   	pop    %esi
80101510:	5f                   	pop    %edi
80101511:	5d                   	pop    %ebp
80101512:	e9 39 1e 00 00       	jmp    80103350 <end_op>
80101517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010151e:	66 90                	xchg   %ax,%ax
80101520:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101524:	83 ec 08             	sub    $0x8,%esp
80101527:	53                   	push   %ebx
80101528:	56                   	push   %esi
80101529:	e8 82 25 00 00       	call   80103ab0 <pipeclose>
8010152e:	83 c4 10             	add    $0x10,%esp
80101531:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101534:	5b                   	pop    %ebx
80101535:	5e                   	pop    %esi
80101536:	5f                   	pop    %edi
80101537:	5d                   	pop    %ebp
80101538:	c3                   	ret    
80101539:	83 ec 0c             	sub    $0xc,%esp
8010153c:	68 94 77 10 80       	push   $0x80107794
80101541:	e8 4a ee ff ff       	call   80100390 <panic>
80101546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010154d:	8d 76 00             	lea    0x0(%esi),%esi

80101550 <filestat>:
80101550:	f3 0f 1e fb          	endbr32 
80101554:	55                   	push   %ebp
80101555:	89 e5                	mov    %esp,%ebp
80101557:	53                   	push   %ebx
80101558:	83 ec 04             	sub    $0x4,%esp
8010155b:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010155e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101561:	75 2d                	jne    80101590 <filestat+0x40>
80101563:	83 ec 0c             	sub    $0xc,%esp
80101566:	ff 73 10             	pushl  0x10(%ebx)
80101569:	e8 a2 07 00 00       	call   80101d10 <ilock>
8010156e:	58                   	pop    %eax
8010156f:	5a                   	pop    %edx
80101570:	ff 75 0c             	pushl  0xc(%ebp)
80101573:	ff 73 10             	pushl  0x10(%ebx)
80101576:	e8 65 0a 00 00       	call   80101fe0 <stati>
8010157b:	59                   	pop    %ecx
8010157c:	ff 73 10             	pushl  0x10(%ebx)
8010157f:	e8 6c 08 00 00       	call   80101df0 <iunlock>
80101584:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101587:	83 c4 10             	add    $0x10,%esp
8010158a:	31 c0                	xor    %eax,%eax
8010158c:	c9                   	leave  
8010158d:	c3                   	ret    
8010158e:	66 90                	xchg   %ax,%ax
80101590:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101593:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101598:	c9                   	leave  
80101599:	c3                   	ret    
8010159a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015a0 <fileread>:
801015a0:	f3 0f 1e fb          	endbr32 
801015a4:	55                   	push   %ebp
801015a5:	89 e5                	mov    %esp,%ebp
801015a7:	57                   	push   %edi
801015a8:	56                   	push   %esi
801015a9:	53                   	push   %ebx
801015aa:	83 ec 0c             	sub    $0xc,%esp
801015ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
801015b0:	8b 75 0c             	mov    0xc(%ebp),%esi
801015b3:	8b 7d 10             	mov    0x10(%ebp),%edi
801015b6:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801015ba:	74 64                	je     80101620 <fileread+0x80>
801015bc:	8b 03                	mov    (%ebx),%eax
801015be:	83 f8 01             	cmp    $0x1,%eax
801015c1:	74 45                	je     80101608 <fileread+0x68>
801015c3:	83 f8 02             	cmp    $0x2,%eax
801015c6:	75 5f                	jne    80101627 <fileread+0x87>
801015c8:	83 ec 0c             	sub    $0xc,%esp
801015cb:	ff 73 10             	pushl  0x10(%ebx)
801015ce:	e8 3d 07 00 00       	call   80101d10 <ilock>
801015d3:	57                   	push   %edi
801015d4:	ff 73 14             	pushl  0x14(%ebx)
801015d7:	56                   	push   %esi
801015d8:	ff 73 10             	pushl  0x10(%ebx)
801015db:	e8 30 0a 00 00       	call   80102010 <readi>
801015e0:	83 c4 20             	add    $0x20,%esp
801015e3:	89 c6                	mov    %eax,%esi
801015e5:	85 c0                	test   %eax,%eax
801015e7:	7e 03                	jle    801015ec <fileread+0x4c>
801015e9:	01 43 14             	add    %eax,0x14(%ebx)
801015ec:	83 ec 0c             	sub    $0xc,%esp
801015ef:	ff 73 10             	pushl  0x10(%ebx)
801015f2:	e8 f9 07 00 00       	call   80101df0 <iunlock>
801015f7:	83 c4 10             	add    $0x10,%esp
801015fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015fd:	89 f0                	mov    %esi,%eax
801015ff:	5b                   	pop    %ebx
80101600:	5e                   	pop    %esi
80101601:	5f                   	pop    %edi
80101602:	5d                   	pop    %ebp
80101603:	c3                   	ret    
80101604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101608:	8b 43 0c             	mov    0xc(%ebx),%eax
8010160b:	89 45 08             	mov    %eax,0x8(%ebp)
8010160e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101611:	5b                   	pop    %ebx
80101612:	5e                   	pop    %esi
80101613:	5f                   	pop    %edi
80101614:	5d                   	pop    %ebp
80101615:	e9 36 26 00 00       	jmp    80103c50 <piperead>
8010161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101620:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101625:	eb d3                	jmp    801015fa <fileread+0x5a>
80101627:	83 ec 0c             	sub    $0xc,%esp
8010162a:	68 9e 77 10 80       	push   $0x8010779e
8010162f:	e8 5c ed ff ff       	call   80100390 <panic>
80101634:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010163f:	90                   	nop

80101640 <filewrite>:
80101640:	f3 0f 1e fb          	endbr32 
80101644:	55                   	push   %ebp
80101645:	89 e5                	mov    %esp,%ebp
80101647:	57                   	push   %edi
80101648:	56                   	push   %esi
80101649:	53                   	push   %ebx
8010164a:	83 ec 1c             	sub    $0x1c,%esp
8010164d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101650:	8b 75 08             	mov    0x8(%ebp),%esi
80101653:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101656:	8b 45 10             	mov    0x10(%ebp),%eax
80101659:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
8010165d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101660:	0f 84 c1 00 00 00    	je     80101727 <filewrite+0xe7>
80101666:	8b 06                	mov    (%esi),%eax
80101668:	83 f8 01             	cmp    $0x1,%eax
8010166b:	0f 84 c3 00 00 00    	je     80101734 <filewrite+0xf4>
80101671:	83 f8 02             	cmp    $0x2,%eax
80101674:	0f 85 cc 00 00 00    	jne    80101746 <filewrite+0x106>
8010167a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010167d:	31 ff                	xor    %edi,%edi
8010167f:	85 c0                	test   %eax,%eax
80101681:	7f 34                	jg     801016b7 <filewrite+0x77>
80101683:	e9 98 00 00 00       	jmp    80101720 <filewrite+0xe0>
80101688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010168f:	90                   	nop
80101690:	01 46 14             	add    %eax,0x14(%esi)
80101693:	83 ec 0c             	sub    $0xc,%esp
80101696:	ff 76 10             	pushl  0x10(%esi)
80101699:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010169c:	e8 4f 07 00 00       	call   80101df0 <iunlock>
801016a1:	e8 aa 1c 00 00       	call   80103350 <end_op>
801016a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801016a9:	83 c4 10             	add    $0x10,%esp
801016ac:	39 c3                	cmp    %eax,%ebx
801016ae:	75 60                	jne    80101710 <filewrite+0xd0>
801016b0:	01 df                	add    %ebx,%edi
801016b2:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801016b5:	7e 69                	jle    80101720 <filewrite+0xe0>
801016b7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801016ba:	b8 00 06 00 00       	mov    $0x600,%eax
801016bf:	29 fb                	sub    %edi,%ebx
801016c1:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801016c7:	0f 4f d8             	cmovg  %eax,%ebx
801016ca:	e8 11 1c 00 00       	call   801032e0 <begin_op>
801016cf:	83 ec 0c             	sub    $0xc,%esp
801016d2:	ff 76 10             	pushl  0x10(%esi)
801016d5:	e8 36 06 00 00       	call   80101d10 <ilock>
801016da:	8b 45 dc             	mov    -0x24(%ebp),%eax
801016dd:	53                   	push   %ebx
801016de:	ff 76 14             	pushl  0x14(%esi)
801016e1:	01 f8                	add    %edi,%eax
801016e3:	50                   	push   %eax
801016e4:	ff 76 10             	pushl  0x10(%esi)
801016e7:	e8 24 0a 00 00       	call   80102110 <writei>
801016ec:	83 c4 20             	add    $0x20,%esp
801016ef:	85 c0                	test   %eax,%eax
801016f1:	7f 9d                	jg     80101690 <filewrite+0x50>
801016f3:	83 ec 0c             	sub    $0xc,%esp
801016f6:	ff 76 10             	pushl  0x10(%esi)
801016f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801016fc:	e8 ef 06 00 00       	call   80101df0 <iunlock>
80101701:	e8 4a 1c 00 00       	call   80103350 <end_op>
80101706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101709:	83 c4 10             	add    $0x10,%esp
8010170c:	85 c0                	test   %eax,%eax
8010170e:	75 17                	jne    80101727 <filewrite+0xe7>
80101710:	83 ec 0c             	sub    $0xc,%esp
80101713:	68 a7 77 10 80       	push   $0x801077a7
80101718:	e8 73 ec ff ff       	call   80100390 <panic>
8010171d:	8d 76 00             	lea    0x0(%esi),%esi
80101720:	89 f8                	mov    %edi,%eax
80101722:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101725:	74 05                	je     8010172c <filewrite+0xec>
80101727:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010172c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010172f:	5b                   	pop    %ebx
80101730:	5e                   	pop    %esi
80101731:	5f                   	pop    %edi
80101732:	5d                   	pop    %ebp
80101733:	c3                   	ret    
80101734:	8b 46 0c             	mov    0xc(%esi),%eax
80101737:	89 45 08             	mov    %eax,0x8(%ebp)
8010173a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010173d:	5b                   	pop    %ebx
8010173e:	5e                   	pop    %esi
8010173f:	5f                   	pop    %edi
80101740:	5d                   	pop    %ebp
80101741:	e9 0a 24 00 00       	jmp    80103b50 <pipewrite>
80101746:	83 ec 0c             	sub    $0xc,%esp
80101749:	68 ad 77 10 80       	push   $0x801077ad
8010174e:	e8 3d ec ff ff       	call   80100390 <panic>
80101753:	66 90                	xchg   %ax,%ax
80101755:	66 90                	xchg   %ax,%ax
80101757:	66 90                	xchg   %ax,%ax
80101759:	66 90                	xchg   %ax,%ax
8010175b:	66 90                	xchg   %ax,%ax
8010175d:	66 90                	xchg   %ax,%ax
8010175f:	90                   	nop

80101760 <bfree>:
80101760:	55                   	push   %ebp
80101761:	89 c1                	mov    %eax,%ecx
80101763:	89 d0                	mov    %edx,%eax
80101765:	c1 e8 0c             	shr    $0xc,%eax
80101768:	03 05 78 1f 11 80    	add    0x80111f78,%eax
8010176e:	89 e5                	mov    %esp,%ebp
80101770:	56                   	push   %esi
80101771:	53                   	push   %ebx
80101772:	89 d3                	mov    %edx,%ebx
80101774:	83 ec 08             	sub    $0x8,%esp
80101777:	50                   	push   %eax
80101778:	51                   	push   %ecx
80101779:	e8 52 e9 ff ff       	call   801000d0 <bread>
8010177e:	89 d9                	mov    %ebx,%ecx
80101780:	c1 fb 03             	sar    $0x3,%ebx
80101783:	ba 01 00 00 00       	mov    $0x1,%edx
80101788:	83 e1 07             	and    $0x7,%ecx
8010178b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101791:	83 c4 10             	add    $0x10,%esp
80101794:	d3 e2                	shl    %cl,%edx
80101796:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010179b:	85 d1                	test   %edx,%ecx
8010179d:	74 25                	je     801017c4 <bfree+0x64>
8010179f:	f7 d2                	not    %edx
801017a1:	83 ec 0c             	sub    $0xc,%esp
801017a4:	89 c6                	mov    %eax,%esi
801017a6:	21 ca                	and    %ecx,%edx
801017a8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
801017ac:	50                   	push   %eax
801017ad:	e8 0e 1d 00 00       	call   801034c0 <log_write>
801017b2:	89 34 24             	mov    %esi,(%esp)
801017b5:	e8 36 ea ff ff       	call   801001f0 <brelse>
801017ba:	83 c4 10             	add    $0x10,%esp
801017bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017c0:	5b                   	pop    %ebx
801017c1:	5e                   	pop    %esi
801017c2:	5d                   	pop    %ebp
801017c3:	c3                   	ret    
801017c4:	83 ec 0c             	sub    $0xc,%esp
801017c7:	68 b7 77 10 80       	push   $0x801077b7
801017cc:	e8 bf eb ff ff       	call   80100390 <panic>
801017d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017df:	90                   	nop

801017e0 <balloc>:
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
801017e4:	56                   	push   %esi
801017e5:	53                   	push   %ebx
801017e6:	83 ec 1c             	sub    $0x1c,%esp
801017e9:	8b 0d 60 1f 11 80    	mov    0x80111f60,%ecx
801017ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
801017f2:	85 c9                	test   %ecx,%ecx
801017f4:	0f 84 87 00 00 00    	je     80101881 <balloc+0xa1>
801017fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80101801:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101804:	83 ec 08             	sub    $0x8,%esp
80101807:	89 f0                	mov    %esi,%eax
80101809:	c1 f8 0c             	sar    $0xc,%eax
8010180c:	03 05 78 1f 11 80    	add    0x80111f78,%eax
80101812:	50                   	push   %eax
80101813:	ff 75 d8             	pushl  -0x28(%ebp)
80101816:	e8 b5 e8 ff ff       	call   801000d0 <bread>
8010181b:	83 c4 10             	add    $0x10,%esp
8010181e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101821:	a1 60 1f 11 80       	mov    0x80111f60,%eax
80101826:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101829:	31 c0                	xor    %eax,%eax
8010182b:	eb 2f                	jmp    8010185c <balloc+0x7c>
8010182d:	8d 76 00             	lea    0x0(%esi),%esi
80101830:	89 c1                	mov    %eax,%ecx
80101832:	bb 01 00 00 00       	mov    $0x1,%ebx
80101837:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010183a:	83 e1 07             	and    $0x7,%ecx
8010183d:	d3 e3                	shl    %cl,%ebx
8010183f:	89 c1                	mov    %eax,%ecx
80101841:	c1 f9 03             	sar    $0x3,%ecx
80101844:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101849:	89 fa                	mov    %edi,%edx
8010184b:	85 df                	test   %ebx,%edi
8010184d:	74 41                	je     80101890 <balloc+0xb0>
8010184f:	83 c0 01             	add    $0x1,%eax
80101852:	83 c6 01             	add    $0x1,%esi
80101855:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010185a:	74 05                	je     80101861 <balloc+0x81>
8010185c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010185f:	77 cf                	ja     80101830 <balloc+0x50>
80101861:	83 ec 0c             	sub    $0xc,%esp
80101864:	ff 75 e4             	pushl  -0x1c(%ebp)
80101867:	e8 84 e9 ff ff       	call   801001f0 <brelse>
8010186c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101873:	83 c4 10             	add    $0x10,%esp
80101876:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101879:	39 05 60 1f 11 80    	cmp    %eax,0x80111f60
8010187f:	77 80                	ja     80101801 <balloc+0x21>
80101881:	83 ec 0c             	sub    $0xc,%esp
80101884:	68 ca 77 10 80       	push   $0x801077ca
80101889:	e8 02 eb ff ff       	call   80100390 <panic>
8010188e:	66 90                	xchg   %ax,%ax
80101890:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101893:	83 ec 0c             	sub    $0xc,%esp
80101896:	09 da                	or     %ebx,%edx
80101898:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
8010189c:	57                   	push   %edi
8010189d:	e8 1e 1c 00 00       	call   801034c0 <log_write>
801018a2:	89 3c 24             	mov    %edi,(%esp)
801018a5:	e8 46 e9 ff ff       	call   801001f0 <brelse>
801018aa:	58                   	pop    %eax
801018ab:	5a                   	pop    %edx
801018ac:	56                   	push   %esi
801018ad:	ff 75 d8             	pushl  -0x28(%ebp)
801018b0:	e8 1b e8 ff ff       	call   801000d0 <bread>
801018b5:	83 c4 0c             	add    $0xc,%esp
801018b8:	89 c3                	mov    %eax,%ebx
801018ba:	8d 40 5c             	lea    0x5c(%eax),%eax
801018bd:	68 00 02 00 00       	push   $0x200
801018c2:	6a 00                	push   $0x0
801018c4:	50                   	push   %eax
801018c5:	e8 56 33 00 00       	call   80104c20 <memset>
801018ca:	89 1c 24             	mov    %ebx,(%esp)
801018cd:	e8 ee 1b 00 00       	call   801034c0 <log_write>
801018d2:	89 1c 24             	mov    %ebx,(%esp)
801018d5:	e8 16 e9 ff ff       	call   801001f0 <brelse>
801018da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018dd:	89 f0                	mov    %esi,%eax
801018df:	5b                   	pop    %ebx
801018e0:	5e                   	pop    %esi
801018e1:	5f                   	pop    %edi
801018e2:	5d                   	pop    %ebp
801018e3:	c3                   	ret    
801018e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018ef:	90                   	nop

801018f0 <iget>:
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	57                   	push   %edi
801018f4:	89 c7                	mov    %eax,%edi
801018f6:	56                   	push   %esi
801018f7:	31 f6                	xor    %esi,%esi
801018f9:	53                   	push   %ebx
801018fa:	bb b4 1f 11 80       	mov    $0x80111fb4,%ebx
801018ff:	83 ec 28             	sub    $0x28,%esp
80101902:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101905:	68 80 1f 11 80       	push   $0x80111f80
8010190a:	e8 01 32 00 00       	call   80104b10 <acquire>
8010190f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101912:	83 c4 10             	add    $0x10,%esp
80101915:	eb 1b                	jmp    80101932 <iget+0x42>
80101917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010191e:	66 90                	xchg   %ax,%ax
80101920:	39 3b                	cmp    %edi,(%ebx)
80101922:	74 6c                	je     80101990 <iget+0xa0>
80101924:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010192a:	81 fb d4 3b 11 80    	cmp    $0x80113bd4,%ebx
80101930:	73 26                	jae    80101958 <iget+0x68>
80101932:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101935:	85 c9                	test   %ecx,%ecx
80101937:	7f e7                	jg     80101920 <iget+0x30>
80101939:	85 f6                	test   %esi,%esi
8010193b:	75 e7                	jne    80101924 <iget+0x34>
8010193d:	89 d8                	mov    %ebx,%eax
8010193f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101945:	85 c9                	test   %ecx,%ecx
80101947:	75 6e                	jne    801019b7 <iget+0xc7>
80101949:	89 c6                	mov    %eax,%esi
8010194b:	81 fb d4 3b 11 80    	cmp    $0x80113bd4,%ebx
80101951:	72 df                	jb     80101932 <iget+0x42>
80101953:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101957:	90                   	nop
80101958:	85 f6                	test   %esi,%esi
8010195a:	74 73                	je     801019cf <iget+0xdf>
8010195c:	83 ec 0c             	sub    $0xc,%esp
8010195f:	89 3e                	mov    %edi,(%esi)
80101961:	89 56 04             	mov    %edx,0x4(%esi)
80101964:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
8010196b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101972:	68 80 1f 11 80       	push   $0x80111f80
80101977:	e8 54 32 00 00       	call   80104bd0 <release>
8010197c:	83 c4 10             	add    $0x10,%esp
8010197f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101982:	89 f0                	mov    %esi,%eax
80101984:	5b                   	pop    %ebx
80101985:	5e                   	pop    %esi
80101986:	5f                   	pop    %edi
80101987:	5d                   	pop    %ebp
80101988:	c3                   	ret    
80101989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101990:	39 53 04             	cmp    %edx,0x4(%ebx)
80101993:	75 8f                	jne    80101924 <iget+0x34>
80101995:	83 ec 0c             	sub    $0xc,%esp
80101998:	83 c1 01             	add    $0x1,%ecx
8010199b:	89 de                	mov    %ebx,%esi
8010199d:	68 80 1f 11 80       	push   $0x80111f80
801019a2:	89 4b 08             	mov    %ecx,0x8(%ebx)
801019a5:	e8 26 32 00 00       	call   80104bd0 <release>
801019aa:	83 c4 10             	add    $0x10,%esp
801019ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019b0:	89 f0                	mov    %esi,%eax
801019b2:	5b                   	pop    %ebx
801019b3:	5e                   	pop    %esi
801019b4:	5f                   	pop    %edi
801019b5:	5d                   	pop    %ebp
801019b6:	c3                   	ret    
801019b7:	81 fb d4 3b 11 80    	cmp    $0x80113bd4,%ebx
801019bd:	73 10                	jae    801019cf <iget+0xdf>
801019bf:	8b 4b 08             	mov    0x8(%ebx),%ecx
801019c2:	85 c9                	test   %ecx,%ecx
801019c4:	0f 8f 56 ff ff ff    	jg     80101920 <iget+0x30>
801019ca:	e9 6e ff ff ff       	jmp    8010193d <iget+0x4d>
801019cf:	83 ec 0c             	sub    $0xc,%esp
801019d2:	68 e0 77 10 80       	push   $0x801077e0
801019d7:	e8 b4 e9 ff ff       	call   80100390 <panic>
801019dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019e0 <bmap>:
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	57                   	push   %edi
801019e4:	56                   	push   %esi
801019e5:	89 c6                	mov    %eax,%esi
801019e7:	53                   	push   %ebx
801019e8:	83 ec 1c             	sub    $0x1c,%esp
801019eb:	83 fa 0b             	cmp    $0xb,%edx
801019ee:	0f 86 84 00 00 00    	jbe    80101a78 <bmap+0x98>
801019f4:	8d 5a f4             	lea    -0xc(%edx),%ebx
801019f7:	83 fb 7f             	cmp    $0x7f,%ebx
801019fa:	0f 87 98 00 00 00    	ja     80101a98 <bmap+0xb8>
80101a00:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101a06:	8b 16                	mov    (%esi),%edx
80101a08:	85 c0                	test   %eax,%eax
80101a0a:	74 54                	je     80101a60 <bmap+0x80>
80101a0c:	83 ec 08             	sub    $0x8,%esp
80101a0f:	50                   	push   %eax
80101a10:	52                   	push   %edx
80101a11:	e8 ba e6 ff ff       	call   801000d0 <bread>
80101a16:	83 c4 10             	add    $0x10,%esp
80101a19:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
80101a1d:	89 c7                	mov    %eax,%edi
80101a1f:	8b 1a                	mov    (%edx),%ebx
80101a21:	85 db                	test   %ebx,%ebx
80101a23:	74 1b                	je     80101a40 <bmap+0x60>
80101a25:	83 ec 0c             	sub    $0xc,%esp
80101a28:	57                   	push   %edi
80101a29:	e8 c2 e7 ff ff       	call   801001f0 <brelse>
80101a2e:	83 c4 10             	add    $0x10,%esp
80101a31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a34:	89 d8                	mov    %ebx,%eax
80101a36:	5b                   	pop    %ebx
80101a37:	5e                   	pop    %esi
80101a38:	5f                   	pop    %edi
80101a39:	5d                   	pop    %ebp
80101a3a:	c3                   	ret    
80101a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a3f:	90                   	nop
80101a40:	8b 06                	mov    (%esi),%eax
80101a42:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101a45:	e8 96 fd ff ff       	call   801017e0 <balloc>
80101a4a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101a4d:	83 ec 0c             	sub    $0xc,%esp
80101a50:	89 c3                	mov    %eax,%ebx
80101a52:	89 02                	mov    %eax,(%edx)
80101a54:	57                   	push   %edi
80101a55:	e8 66 1a 00 00       	call   801034c0 <log_write>
80101a5a:	83 c4 10             	add    $0x10,%esp
80101a5d:	eb c6                	jmp    80101a25 <bmap+0x45>
80101a5f:	90                   	nop
80101a60:	89 d0                	mov    %edx,%eax
80101a62:	e8 79 fd ff ff       	call   801017e0 <balloc>
80101a67:	8b 16                	mov    (%esi),%edx
80101a69:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101a6f:	eb 9b                	jmp    80101a0c <bmap+0x2c>
80101a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a78:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80101a7b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101a7e:	85 db                	test   %ebx,%ebx
80101a80:	75 af                	jne    80101a31 <bmap+0x51>
80101a82:	8b 00                	mov    (%eax),%eax
80101a84:	e8 57 fd ff ff       	call   801017e0 <balloc>
80101a89:	89 47 5c             	mov    %eax,0x5c(%edi)
80101a8c:	89 c3                	mov    %eax,%ebx
80101a8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a91:	89 d8                	mov    %ebx,%eax
80101a93:	5b                   	pop    %ebx
80101a94:	5e                   	pop    %esi
80101a95:	5f                   	pop    %edi
80101a96:	5d                   	pop    %ebp
80101a97:	c3                   	ret    
80101a98:	83 ec 0c             	sub    $0xc,%esp
80101a9b:	68 f0 77 10 80       	push   $0x801077f0
80101aa0:	e8 eb e8 ff ff       	call   80100390 <panic>
80101aa5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ab0 <readsb>:
80101ab0:	f3 0f 1e fb          	endbr32 
80101ab4:	55                   	push   %ebp
80101ab5:	89 e5                	mov    %esp,%ebp
80101ab7:	56                   	push   %esi
80101ab8:	53                   	push   %ebx
80101ab9:	8b 75 0c             	mov    0xc(%ebp),%esi
80101abc:	83 ec 08             	sub    $0x8,%esp
80101abf:	6a 01                	push   $0x1
80101ac1:	ff 75 08             	pushl  0x8(%ebp)
80101ac4:	e8 07 e6 ff ff       	call   801000d0 <bread>
80101ac9:	83 c4 0c             	add    $0xc,%esp
80101acc:	89 c3                	mov    %eax,%ebx
80101ace:	8d 40 5c             	lea    0x5c(%eax),%eax
80101ad1:	6a 1c                	push   $0x1c
80101ad3:	50                   	push   %eax
80101ad4:	56                   	push   %esi
80101ad5:	e8 e6 31 00 00       	call   80104cc0 <memmove>
80101ada:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101add:	83 c4 10             	add    $0x10,%esp
80101ae0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ae3:	5b                   	pop    %ebx
80101ae4:	5e                   	pop    %esi
80101ae5:	5d                   	pop    %ebp
80101ae6:	e9 05 e7 ff ff       	jmp    801001f0 <brelse>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop

80101af0 <iinit>:
80101af0:	f3 0f 1e fb          	endbr32 
80101af4:	55                   	push   %ebp
80101af5:	89 e5                	mov    %esp,%ebp
80101af7:	53                   	push   %ebx
80101af8:	bb c0 1f 11 80       	mov    $0x80111fc0,%ebx
80101afd:	83 ec 0c             	sub    $0xc,%esp
80101b00:	68 03 78 10 80       	push   $0x80107803
80101b05:	68 80 1f 11 80       	push   $0x80111f80
80101b0a:	e8 81 2e 00 00       	call   80104990 <initlock>
80101b0f:	83 c4 10             	add    $0x10,%esp
80101b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101b18:	83 ec 08             	sub    $0x8,%esp
80101b1b:	68 0a 78 10 80       	push   $0x8010780a
80101b20:	53                   	push   %ebx
80101b21:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101b27:	e8 24 2d 00 00       	call   80104850 <initsleeplock>
80101b2c:	83 c4 10             	add    $0x10,%esp
80101b2f:	81 fb e0 3b 11 80    	cmp    $0x80113be0,%ebx
80101b35:	75 e1                	jne    80101b18 <iinit+0x28>
80101b37:	83 ec 08             	sub    $0x8,%esp
80101b3a:	68 60 1f 11 80       	push   $0x80111f60
80101b3f:	ff 75 08             	pushl  0x8(%ebp)
80101b42:	e8 69 ff ff ff       	call   80101ab0 <readsb>
80101b47:	ff 35 78 1f 11 80    	pushl  0x80111f78
80101b4d:	ff 35 74 1f 11 80    	pushl  0x80111f74
80101b53:	ff 35 70 1f 11 80    	pushl  0x80111f70
80101b59:	ff 35 6c 1f 11 80    	pushl  0x80111f6c
80101b5f:	ff 35 68 1f 11 80    	pushl  0x80111f68
80101b65:	ff 35 64 1f 11 80    	pushl  0x80111f64
80101b6b:	ff 35 60 1f 11 80    	pushl  0x80111f60
80101b71:	68 70 78 10 80       	push   $0x80107870
80101b76:	e8 05 ee ff ff       	call   80100980 <cprintf>
80101b7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b7e:	83 c4 30             	add    $0x30,%esp
80101b81:	c9                   	leave  
80101b82:	c3                   	ret    
80101b83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101b90 <ialloc>:
80101b90:	f3 0f 1e fb          	endbr32 
80101b94:	55                   	push   %ebp
80101b95:	89 e5                	mov    %esp,%ebp
80101b97:	57                   	push   %edi
80101b98:	56                   	push   %esi
80101b99:	53                   	push   %ebx
80101b9a:	83 ec 1c             	sub    $0x1c,%esp
80101b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ba0:	83 3d 68 1f 11 80 01 	cmpl   $0x1,0x80111f68
80101ba7:	8b 75 08             	mov    0x8(%ebp),%esi
80101baa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101bad:	0f 86 8d 00 00 00    	jbe    80101c40 <ialloc+0xb0>
80101bb3:	bf 01 00 00 00       	mov    $0x1,%edi
80101bb8:	eb 1d                	jmp    80101bd7 <ialloc+0x47>
80101bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101bc0:	83 ec 0c             	sub    $0xc,%esp
80101bc3:	83 c7 01             	add    $0x1,%edi
80101bc6:	53                   	push   %ebx
80101bc7:	e8 24 e6 ff ff       	call   801001f0 <brelse>
80101bcc:	83 c4 10             	add    $0x10,%esp
80101bcf:	3b 3d 68 1f 11 80    	cmp    0x80111f68,%edi
80101bd5:	73 69                	jae    80101c40 <ialloc+0xb0>
80101bd7:	89 f8                	mov    %edi,%eax
80101bd9:	83 ec 08             	sub    $0x8,%esp
80101bdc:	c1 e8 03             	shr    $0x3,%eax
80101bdf:	03 05 74 1f 11 80    	add    0x80111f74,%eax
80101be5:	50                   	push   %eax
80101be6:	56                   	push   %esi
80101be7:	e8 e4 e4 ff ff       	call   801000d0 <bread>
80101bec:	83 c4 10             	add    $0x10,%esp
80101bef:	89 c3                	mov    %eax,%ebx
80101bf1:	89 f8                	mov    %edi,%eax
80101bf3:	83 e0 07             	and    $0x7,%eax
80101bf6:	c1 e0 06             	shl    $0x6,%eax
80101bf9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
80101bfd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101c01:	75 bd                	jne    80101bc0 <ialloc+0x30>
80101c03:	83 ec 04             	sub    $0x4,%esp
80101c06:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101c09:	6a 40                	push   $0x40
80101c0b:	6a 00                	push   $0x0
80101c0d:	51                   	push   %ecx
80101c0e:	e8 0d 30 00 00       	call   80104c20 <memset>
80101c13:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101c17:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101c1a:	66 89 01             	mov    %ax,(%ecx)
80101c1d:	89 1c 24             	mov    %ebx,(%esp)
80101c20:	e8 9b 18 00 00       	call   801034c0 <log_write>
80101c25:	89 1c 24             	mov    %ebx,(%esp)
80101c28:	e8 c3 e5 ff ff       	call   801001f0 <brelse>
80101c2d:	83 c4 10             	add    $0x10,%esp
80101c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c33:	89 fa                	mov    %edi,%edx
80101c35:	5b                   	pop    %ebx
80101c36:	89 f0                	mov    %esi,%eax
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	e9 b0 fc ff ff       	jmp    801018f0 <iget>
80101c40:	83 ec 0c             	sub    $0xc,%esp
80101c43:	68 10 78 10 80       	push   $0x80107810
80101c48:	e8 43 e7 ff ff       	call   80100390 <panic>
80101c4d:	8d 76 00             	lea    0x0(%esi),%esi

80101c50 <iupdate>:
80101c50:	f3 0f 1e fb          	endbr32 
80101c54:	55                   	push   %ebp
80101c55:	89 e5                	mov    %esp,%ebp
80101c57:	56                   	push   %esi
80101c58:	53                   	push   %ebx
80101c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101c5c:	8b 43 04             	mov    0x4(%ebx),%eax
80101c5f:	83 c3 5c             	add    $0x5c,%ebx
80101c62:	83 ec 08             	sub    $0x8,%esp
80101c65:	c1 e8 03             	shr    $0x3,%eax
80101c68:	03 05 74 1f 11 80    	add    0x80111f74,%eax
80101c6e:	50                   	push   %eax
80101c6f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101c72:	e8 59 e4 ff ff       	call   801000d0 <bread>
80101c77:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
80101c7b:	83 c4 0c             	add    $0xc,%esp
80101c7e:	89 c6                	mov    %eax,%esi
80101c80:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101c83:	83 e0 07             	and    $0x7,%eax
80101c86:	c1 e0 06             	shl    $0x6,%eax
80101c89:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
80101c8d:	66 89 10             	mov    %dx,(%eax)
80101c90:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
80101c94:	83 c0 0c             	add    $0xc,%eax
80101c97:	66 89 50 f6          	mov    %dx,-0xa(%eax)
80101c9b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101c9f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
80101ca3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101ca7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
80101cab:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101cae:	89 50 fc             	mov    %edx,-0x4(%eax)
80101cb1:	6a 34                	push   $0x34
80101cb3:	53                   	push   %ebx
80101cb4:	50                   	push   %eax
80101cb5:	e8 06 30 00 00       	call   80104cc0 <memmove>
80101cba:	89 34 24             	mov    %esi,(%esp)
80101cbd:	e8 fe 17 00 00       	call   801034c0 <log_write>
80101cc2:	89 75 08             	mov    %esi,0x8(%ebp)
80101cc5:	83 c4 10             	add    $0x10,%esp
80101cc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ccb:	5b                   	pop    %ebx
80101ccc:	5e                   	pop    %esi
80101ccd:	5d                   	pop    %ebp
80101cce:	e9 1d e5 ff ff       	jmp    801001f0 <brelse>
80101cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ce0 <idup>:
80101ce0:	f3 0f 1e fb          	endbr32 
80101ce4:	55                   	push   %ebp
80101ce5:	89 e5                	mov    %esp,%ebp
80101ce7:	53                   	push   %ebx
80101ce8:	83 ec 10             	sub    $0x10,%esp
80101ceb:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101cee:	68 80 1f 11 80       	push   $0x80111f80
80101cf3:	e8 18 2e 00 00       	call   80104b10 <acquire>
80101cf8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
80101cfc:	c7 04 24 80 1f 11 80 	movl   $0x80111f80,(%esp)
80101d03:	e8 c8 2e 00 00       	call   80104bd0 <release>
80101d08:	89 d8                	mov    %ebx,%eax
80101d0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d0d:	c9                   	leave  
80101d0e:	c3                   	ret    
80101d0f:	90                   	nop

80101d10 <ilock>:
80101d10:	f3 0f 1e fb          	endbr32 
80101d14:	55                   	push   %ebp
80101d15:	89 e5                	mov    %esp,%ebp
80101d17:	56                   	push   %esi
80101d18:	53                   	push   %ebx
80101d19:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101d1c:	85 db                	test   %ebx,%ebx
80101d1e:	0f 84 b3 00 00 00    	je     80101dd7 <ilock+0xc7>
80101d24:	8b 53 08             	mov    0x8(%ebx),%edx
80101d27:	85 d2                	test   %edx,%edx
80101d29:	0f 8e a8 00 00 00    	jle    80101dd7 <ilock+0xc7>
80101d2f:	83 ec 0c             	sub    $0xc,%esp
80101d32:	8d 43 0c             	lea    0xc(%ebx),%eax
80101d35:	50                   	push   %eax
80101d36:	e8 55 2b 00 00       	call   80104890 <acquiresleep>
80101d3b:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101d3e:	83 c4 10             	add    $0x10,%esp
80101d41:	85 c0                	test   %eax,%eax
80101d43:	74 0b                	je     80101d50 <ilock+0x40>
80101d45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d48:	5b                   	pop    %ebx
80101d49:	5e                   	pop    %esi
80101d4a:	5d                   	pop    %ebp
80101d4b:	c3                   	ret    
80101d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d50:	8b 43 04             	mov    0x4(%ebx),%eax
80101d53:	83 ec 08             	sub    $0x8,%esp
80101d56:	c1 e8 03             	shr    $0x3,%eax
80101d59:	03 05 74 1f 11 80    	add    0x80111f74,%eax
80101d5f:	50                   	push   %eax
80101d60:	ff 33                	pushl  (%ebx)
80101d62:	e8 69 e3 ff ff       	call   801000d0 <bread>
80101d67:	83 c4 0c             	add    $0xc,%esp
80101d6a:	89 c6                	mov    %eax,%esi
80101d6c:	8b 43 04             	mov    0x4(%ebx),%eax
80101d6f:	83 e0 07             	and    $0x7,%eax
80101d72:	c1 e0 06             	shl    $0x6,%eax
80101d75:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
80101d79:	0f b7 10             	movzwl (%eax),%edx
80101d7c:	83 c0 0c             	add    $0xc,%eax
80101d7f:	66 89 53 50          	mov    %dx,0x50(%ebx)
80101d83:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101d87:	66 89 53 52          	mov    %dx,0x52(%ebx)
80101d8b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101d8f:	66 89 53 54          	mov    %dx,0x54(%ebx)
80101d93:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101d97:	66 89 53 56          	mov    %dx,0x56(%ebx)
80101d9b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101d9e:	89 53 58             	mov    %edx,0x58(%ebx)
80101da1:	6a 34                	push   $0x34
80101da3:	50                   	push   %eax
80101da4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101da7:	50                   	push   %eax
80101da8:	e8 13 2f 00 00       	call   80104cc0 <memmove>
80101dad:	89 34 24             	mov    %esi,(%esp)
80101db0:	e8 3b e4 ff ff       	call   801001f0 <brelse>
80101db5:	83 c4 10             	add    $0x10,%esp
80101db8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101dbd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
80101dc4:	0f 85 7b ff ff ff    	jne    80101d45 <ilock+0x35>
80101dca:	83 ec 0c             	sub    $0xc,%esp
80101dcd:	68 28 78 10 80       	push   $0x80107828
80101dd2:	e8 b9 e5 ff ff       	call   80100390 <panic>
80101dd7:	83 ec 0c             	sub    $0xc,%esp
80101dda:	68 22 78 10 80       	push   $0x80107822
80101ddf:	e8 ac e5 ff ff       	call   80100390 <panic>
80101de4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101def:	90                   	nop

80101df0 <iunlock>:
80101df0:	f3 0f 1e fb          	endbr32 
80101df4:	55                   	push   %ebp
80101df5:	89 e5                	mov    %esp,%ebp
80101df7:	56                   	push   %esi
80101df8:	53                   	push   %ebx
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101dfc:	85 db                	test   %ebx,%ebx
80101dfe:	74 28                	je     80101e28 <iunlock+0x38>
80101e00:	83 ec 0c             	sub    $0xc,%esp
80101e03:	8d 73 0c             	lea    0xc(%ebx),%esi
80101e06:	56                   	push   %esi
80101e07:	e8 24 2b 00 00       	call   80104930 <holdingsleep>
80101e0c:	83 c4 10             	add    $0x10,%esp
80101e0f:	85 c0                	test   %eax,%eax
80101e11:	74 15                	je     80101e28 <iunlock+0x38>
80101e13:	8b 43 08             	mov    0x8(%ebx),%eax
80101e16:	85 c0                	test   %eax,%eax
80101e18:	7e 0e                	jle    80101e28 <iunlock+0x38>
80101e1a:	89 75 08             	mov    %esi,0x8(%ebp)
80101e1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e20:	5b                   	pop    %ebx
80101e21:	5e                   	pop    %esi
80101e22:	5d                   	pop    %ebp
80101e23:	e9 c8 2a 00 00       	jmp    801048f0 <releasesleep>
80101e28:	83 ec 0c             	sub    $0xc,%esp
80101e2b:	68 37 78 10 80       	push   $0x80107837
80101e30:	e8 5b e5 ff ff       	call   80100390 <panic>
80101e35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e40 <iput>:
80101e40:	f3 0f 1e fb          	endbr32 
80101e44:	55                   	push   %ebp
80101e45:	89 e5                	mov    %esp,%ebp
80101e47:	57                   	push   %edi
80101e48:	56                   	push   %esi
80101e49:	53                   	push   %ebx
80101e4a:	83 ec 28             	sub    $0x28,%esp
80101e4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101e50:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101e53:	57                   	push   %edi
80101e54:	e8 37 2a 00 00       	call   80104890 <acquiresleep>
80101e59:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101e5c:	83 c4 10             	add    $0x10,%esp
80101e5f:	85 d2                	test   %edx,%edx
80101e61:	74 07                	je     80101e6a <iput+0x2a>
80101e63:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101e68:	74 36                	je     80101ea0 <iput+0x60>
80101e6a:	83 ec 0c             	sub    $0xc,%esp
80101e6d:	57                   	push   %edi
80101e6e:	e8 7d 2a 00 00       	call   801048f0 <releasesleep>
80101e73:	c7 04 24 80 1f 11 80 	movl   $0x80111f80,(%esp)
80101e7a:	e8 91 2c 00 00       	call   80104b10 <acquire>
80101e7f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
80101e83:	83 c4 10             	add    $0x10,%esp
80101e86:	c7 45 08 80 1f 11 80 	movl   $0x80111f80,0x8(%ebp)
80101e8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e90:	5b                   	pop    %ebx
80101e91:	5e                   	pop    %esi
80101e92:	5f                   	pop    %edi
80101e93:	5d                   	pop    %ebp
80101e94:	e9 37 2d 00 00       	jmp    80104bd0 <release>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea0:	83 ec 0c             	sub    $0xc,%esp
80101ea3:	68 80 1f 11 80       	push   $0x80111f80
80101ea8:	e8 63 2c 00 00       	call   80104b10 <acquire>
80101ead:	8b 73 08             	mov    0x8(%ebx),%esi
80101eb0:	c7 04 24 80 1f 11 80 	movl   $0x80111f80,(%esp)
80101eb7:	e8 14 2d 00 00       	call   80104bd0 <release>
80101ebc:	83 c4 10             	add    $0x10,%esp
80101ebf:	83 fe 01             	cmp    $0x1,%esi
80101ec2:	75 a6                	jne    80101e6a <iput+0x2a>
80101ec4:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101eca:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101ecd:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101ed0:	89 cf                	mov    %ecx,%edi
80101ed2:	eb 0b                	jmp    80101edf <iput+0x9f>
80101ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ed8:	83 c6 04             	add    $0x4,%esi
80101edb:	39 fe                	cmp    %edi,%esi
80101edd:	74 19                	je     80101ef8 <iput+0xb8>
80101edf:	8b 16                	mov    (%esi),%edx
80101ee1:	85 d2                	test   %edx,%edx
80101ee3:	74 f3                	je     80101ed8 <iput+0x98>
80101ee5:	8b 03                	mov    (%ebx),%eax
80101ee7:	e8 74 f8 ff ff       	call   80101760 <bfree>
80101eec:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101ef2:	eb e4                	jmp    80101ed8 <iput+0x98>
80101ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101efe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101f01:	85 c0                	test   %eax,%eax
80101f03:	75 33                	jne    80101f38 <iput+0xf8>
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
80101f0f:	53                   	push   %ebx
80101f10:	e8 3b fd ff ff       	call   80101c50 <iupdate>
80101f15:	31 c0                	xor    %eax,%eax
80101f17:	66 89 43 50          	mov    %ax,0x50(%ebx)
80101f1b:	89 1c 24             	mov    %ebx,(%esp)
80101f1e:	e8 2d fd ff ff       	call   80101c50 <iupdate>
80101f23:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101f2a:	83 c4 10             	add    $0x10,%esp
80101f2d:	e9 38 ff ff ff       	jmp    80101e6a <iput+0x2a>
80101f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f38:	83 ec 08             	sub    $0x8,%esp
80101f3b:	50                   	push   %eax
80101f3c:	ff 33                	pushl  (%ebx)
80101f3e:	e8 8d e1 ff ff       	call   801000d0 <bread>
80101f43:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101f46:	83 c4 10             	add    $0x10,%esp
80101f49:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101f4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101f52:	8d 70 5c             	lea    0x5c(%eax),%esi
80101f55:	89 cf                	mov    %ecx,%edi
80101f57:	eb 0e                	jmp    80101f67 <iput+0x127>
80101f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f60:	83 c6 04             	add    $0x4,%esi
80101f63:	39 f7                	cmp    %esi,%edi
80101f65:	74 19                	je     80101f80 <iput+0x140>
80101f67:	8b 16                	mov    (%esi),%edx
80101f69:	85 d2                	test   %edx,%edx
80101f6b:	74 f3                	je     80101f60 <iput+0x120>
80101f6d:	8b 03                	mov    (%ebx),%eax
80101f6f:	e8 ec f7 ff ff       	call   80101760 <bfree>
80101f74:	eb ea                	jmp    80101f60 <iput+0x120>
80101f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7d:	8d 76 00             	lea    0x0(%esi),%esi
80101f80:	83 ec 0c             	sub    $0xc,%esp
80101f83:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f86:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101f89:	e8 62 e2 ff ff       	call   801001f0 <brelse>
80101f8e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101f94:	8b 03                	mov    (%ebx),%eax
80101f96:	e8 c5 f7 ff ff       	call   80101760 <bfree>
80101f9b:	83 c4 10             	add    $0x10,%esp
80101f9e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101fa5:	00 00 00 
80101fa8:	e9 58 ff ff ff       	jmp    80101f05 <iput+0xc5>
80101fad:	8d 76 00             	lea    0x0(%esi),%esi

80101fb0 <iunlockput>:
80101fb0:	f3 0f 1e fb          	endbr32 
80101fb4:	55                   	push   %ebp
80101fb5:	89 e5                	mov    %esp,%ebp
80101fb7:	53                   	push   %ebx
80101fb8:	83 ec 10             	sub    $0x10,%esp
80101fbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101fbe:	53                   	push   %ebx
80101fbf:	e8 2c fe ff ff       	call   80101df0 <iunlock>
80101fc4:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101fc7:	83 c4 10             	add    $0x10,%esp
80101fca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101fcd:	c9                   	leave  
80101fce:	e9 6d fe ff ff       	jmp    80101e40 <iput>
80101fd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101fe0 <stati>:
80101fe0:	f3 0f 1e fb          	endbr32 
80101fe4:	55                   	push   %ebp
80101fe5:	89 e5                	mov    %esp,%ebp
80101fe7:	8b 55 08             	mov    0x8(%ebp),%edx
80101fea:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fed:	8b 0a                	mov    (%edx),%ecx
80101fef:	89 48 04             	mov    %ecx,0x4(%eax)
80101ff2:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ff5:	89 48 08             	mov    %ecx,0x8(%eax)
80101ff8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ffc:	66 89 08             	mov    %cx,(%eax)
80101fff:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80102003:	66 89 48 0c          	mov    %cx,0xc(%eax)
80102007:	8b 52 58             	mov    0x58(%edx),%edx
8010200a:	89 50 10             	mov    %edx,0x10(%eax)
8010200d:	5d                   	pop    %ebp
8010200e:	c3                   	ret    
8010200f:	90                   	nop

80102010 <readi>:
80102010:	f3 0f 1e fb          	endbr32 
80102014:	55                   	push   %ebp
80102015:	89 e5                	mov    %esp,%ebp
80102017:	57                   	push   %edi
80102018:	56                   	push   %esi
80102019:	53                   	push   %ebx
8010201a:	83 ec 1c             	sub    $0x1c,%esp
8010201d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102020:	8b 45 08             	mov    0x8(%ebp),%eax
80102023:	8b 75 10             	mov    0x10(%ebp),%esi
80102026:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102029:	8b 7d 14             	mov    0x14(%ebp),%edi
8010202c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80102031:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102034:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102037:	0f 84 a3 00 00 00    	je     801020e0 <readi+0xd0>
8010203d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102040:	8b 40 58             	mov    0x58(%eax),%eax
80102043:	39 c6                	cmp    %eax,%esi
80102045:	0f 87 b6 00 00 00    	ja     80102101 <readi+0xf1>
8010204b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010204e:	31 c9                	xor    %ecx,%ecx
80102050:	89 da                	mov    %ebx,%edx
80102052:	01 f2                	add    %esi,%edx
80102054:	0f 92 c1             	setb   %cl
80102057:	89 cf                	mov    %ecx,%edi
80102059:	0f 82 a2 00 00 00    	jb     80102101 <readi+0xf1>
8010205f:	89 c1                	mov    %eax,%ecx
80102061:	29 f1                	sub    %esi,%ecx
80102063:	39 d0                	cmp    %edx,%eax
80102065:	0f 43 cb             	cmovae %ebx,%ecx
80102068:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010206b:	85 c9                	test   %ecx,%ecx
8010206d:	74 63                	je     801020d2 <readi+0xc2>
8010206f:	90                   	nop
80102070:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102073:	89 f2                	mov    %esi,%edx
80102075:	c1 ea 09             	shr    $0x9,%edx
80102078:	89 d8                	mov    %ebx,%eax
8010207a:	e8 61 f9 ff ff       	call   801019e0 <bmap>
8010207f:	83 ec 08             	sub    $0x8,%esp
80102082:	50                   	push   %eax
80102083:	ff 33                	pushl  (%ebx)
80102085:	e8 46 e0 ff ff       	call   801000d0 <bread>
8010208a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010208d:	b9 00 02 00 00       	mov    $0x200,%ecx
80102092:	83 c4 0c             	add    $0xc,%esp
80102095:	89 c2                	mov    %eax,%edx
80102097:	89 f0                	mov    %esi,%eax
80102099:	25 ff 01 00 00       	and    $0x1ff,%eax
8010209e:	29 fb                	sub    %edi,%ebx
801020a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801020a3:	29 c1                	sub    %eax,%ecx
801020a5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801020a9:	39 d9                	cmp    %ebx,%ecx
801020ab:	0f 46 d9             	cmovbe %ecx,%ebx
801020ae:	53                   	push   %ebx
801020af:	01 df                	add    %ebx,%edi
801020b1:	01 de                	add    %ebx,%esi
801020b3:	50                   	push   %eax
801020b4:	ff 75 e0             	pushl  -0x20(%ebp)
801020b7:	e8 04 2c 00 00       	call   80104cc0 <memmove>
801020bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
801020bf:	89 14 24             	mov    %edx,(%esp)
801020c2:	e8 29 e1 ff ff       	call   801001f0 <brelse>
801020c7:	01 5d e0             	add    %ebx,-0x20(%ebp)
801020ca:	83 c4 10             	add    $0x10,%esp
801020cd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801020d0:	77 9e                	ja     80102070 <readi+0x60>
801020d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801020d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020d8:	5b                   	pop    %ebx
801020d9:	5e                   	pop    %esi
801020da:	5f                   	pop    %edi
801020db:	5d                   	pop    %ebp
801020dc:	c3                   	ret    
801020dd:	8d 76 00             	lea    0x0(%esi),%esi
801020e0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801020e4:	66 83 f8 09          	cmp    $0x9,%ax
801020e8:	77 17                	ja     80102101 <readi+0xf1>
801020ea:	8b 04 c5 00 1f 11 80 	mov    -0x7feee100(,%eax,8),%eax
801020f1:	85 c0                	test   %eax,%eax
801020f3:	74 0c                	je     80102101 <readi+0xf1>
801020f5:	89 7d 10             	mov    %edi,0x10(%ebp)
801020f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020fb:	5b                   	pop    %ebx
801020fc:	5e                   	pop    %esi
801020fd:	5f                   	pop    %edi
801020fe:	5d                   	pop    %ebp
801020ff:	ff e0                	jmp    *%eax
80102101:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102106:	eb cd                	jmp    801020d5 <readi+0xc5>
80102108:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210f:	90                   	nop

80102110 <writei>:
80102110:	f3 0f 1e fb          	endbr32 
80102114:	55                   	push   %ebp
80102115:	89 e5                	mov    %esp,%ebp
80102117:	57                   	push   %edi
80102118:	56                   	push   %esi
80102119:	53                   	push   %ebx
8010211a:	83 ec 1c             	sub    $0x1c,%esp
8010211d:	8b 45 08             	mov    0x8(%ebp),%eax
80102120:	8b 75 0c             	mov    0xc(%ebp),%esi
80102123:	8b 7d 14             	mov    0x14(%ebp),%edi
80102126:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
8010212b:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010212e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102131:	8b 75 10             	mov    0x10(%ebp),%esi
80102134:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102137:	0f 84 b3 00 00 00    	je     801021f0 <writei+0xe0>
8010213d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102140:	39 70 58             	cmp    %esi,0x58(%eax)
80102143:	0f 82 e3 00 00 00    	jb     8010222c <writei+0x11c>
80102149:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010214c:	89 f8                	mov    %edi,%eax
8010214e:	01 f0                	add    %esi,%eax
80102150:	0f 82 d6 00 00 00    	jb     8010222c <writei+0x11c>
80102156:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010215b:	0f 87 cb 00 00 00    	ja     8010222c <writei+0x11c>
80102161:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102168:	85 ff                	test   %edi,%edi
8010216a:	74 75                	je     801021e1 <writei+0xd1>
8010216c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102170:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102173:	89 f2                	mov    %esi,%edx
80102175:	c1 ea 09             	shr    $0x9,%edx
80102178:	89 f8                	mov    %edi,%eax
8010217a:	e8 61 f8 ff ff       	call   801019e0 <bmap>
8010217f:	83 ec 08             	sub    $0x8,%esp
80102182:	50                   	push   %eax
80102183:	ff 37                	pushl  (%edi)
80102185:	e8 46 df ff ff       	call   801000d0 <bread>
8010218a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010218f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102192:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
80102195:	89 c7                	mov    %eax,%edi
80102197:	89 f0                	mov    %esi,%eax
80102199:	83 c4 0c             	add    $0xc,%esp
8010219c:	25 ff 01 00 00       	and    $0x1ff,%eax
801021a1:	29 c1                	sub    %eax,%ecx
801021a3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
801021a7:	39 d9                	cmp    %ebx,%ecx
801021a9:	0f 46 d9             	cmovbe %ecx,%ebx
801021ac:	53                   	push   %ebx
801021ad:	01 de                	add    %ebx,%esi
801021af:	ff 75 dc             	pushl  -0x24(%ebp)
801021b2:	50                   	push   %eax
801021b3:	e8 08 2b 00 00       	call   80104cc0 <memmove>
801021b8:	89 3c 24             	mov    %edi,(%esp)
801021bb:	e8 00 13 00 00       	call   801034c0 <log_write>
801021c0:	89 3c 24             	mov    %edi,(%esp)
801021c3:	e8 28 e0 ff ff       	call   801001f0 <brelse>
801021c8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801021cb:	83 c4 10             	add    $0x10,%esp
801021ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801021d1:	01 5d dc             	add    %ebx,-0x24(%ebp)
801021d4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801021d7:	77 97                	ja     80102170 <writei+0x60>
801021d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801021dc:	3b 70 58             	cmp    0x58(%eax),%esi
801021df:	77 37                	ja     80102218 <writei+0x108>
801021e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801021e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021e7:	5b                   	pop    %ebx
801021e8:	5e                   	pop    %esi
801021e9:	5f                   	pop    %edi
801021ea:	5d                   	pop    %ebp
801021eb:	c3                   	ret    
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021f0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801021f4:	66 83 f8 09          	cmp    $0x9,%ax
801021f8:	77 32                	ja     8010222c <writei+0x11c>
801021fa:	8b 04 c5 04 1f 11 80 	mov    -0x7feee0fc(,%eax,8),%eax
80102201:	85 c0                	test   %eax,%eax
80102203:	74 27                	je     8010222c <writei+0x11c>
80102205:	89 7d 10             	mov    %edi,0x10(%ebp)
80102208:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010220b:	5b                   	pop    %ebx
8010220c:	5e                   	pop    %esi
8010220d:	5f                   	pop    %edi
8010220e:	5d                   	pop    %ebp
8010220f:	ff e0                	jmp    *%eax
80102211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102218:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010221b:	83 ec 0c             	sub    $0xc,%esp
8010221e:	89 70 58             	mov    %esi,0x58(%eax)
80102221:	50                   	push   %eax
80102222:	e8 29 fa ff ff       	call   80101c50 <iupdate>
80102227:	83 c4 10             	add    $0x10,%esp
8010222a:	eb b5                	jmp    801021e1 <writei+0xd1>
8010222c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102231:	eb b1                	jmp    801021e4 <writei+0xd4>
80102233:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102240 <namecmp>:
80102240:	f3 0f 1e fb          	endbr32 
80102244:	55                   	push   %ebp
80102245:	89 e5                	mov    %esp,%ebp
80102247:	83 ec 0c             	sub    $0xc,%esp
8010224a:	6a 0e                	push   $0xe
8010224c:	ff 75 0c             	pushl  0xc(%ebp)
8010224f:	ff 75 08             	pushl  0x8(%ebp)
80102252:	e8 d9 2a 00 00       	call   80104d30 <strncmp>
80102257:	c9                   	leave  
80102258:	c3                   	ret    
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102260 <dirlookup>:
80102260:	f3 0f 1e fb          	endbr32 
80102264:	55                   	push   %ebp
80102265:	89 e5                	mov    %esp,%ebp
80102267:	57                   	push   %edi
80102268:	56                   	push   %esi
80102269:	53                   	push   %ebx
8010226a:	83 ec 1c             	sub    $0x1c,%esp
8010226d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102270:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102275:	0f 85 89 00 00 00    	jne    80102304 <dirlookup+0xa4>
8010227b:	8b 53 58             	mov    0x58(%ebx),%edx
8010227e:	31 ff                	xor    %edi,%edi
80102280:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102283:	85 d2                	test   %edx,%edx
80102285:	74 42                	je     801022c9 <dirlookup+0x69>
80102287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228e:	66 90                	xchg   %ax,%ax
80102290:	6a 10                	push   $0x10
80102292:	57                   	push   %edi
80102293:	56                   	push   %esi
80102294:	53                   	push   %ebx
80102295:	e8 76 fd ff ff       	call   80102010 <readi>
8010229a:	83 c4 10             	add    $0x10,%esp
8010229d:	83 f8 10             	cmp    $0x10,%eax
801022a0:	75 55                	jne    801022f7 <dirlookup+0x97>
801022a2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801022a7:	74 18                	je     801022c1 <dirlookup+0x61>
801022a9:	83 ec 04             	sub    $0x4,%esp
801022ac:	8d 45 da             	lea    -0x26(%ebp),%eax
801022af:	6a 0e                	push   $0xe
801022b1:	50                   	push   %eax
801022b2:	ff 75 0c             	pushl  0xc(%ebp)
801022b5:	e8 76 2a 00 00       	call   80104d30 <strncmp>
801022ba:	83 c4 10             	add    $0x10,%esp
801022bd:	85 c0                	test   %eax,%eax
801022bf:	74 17                	je     801022d8 <dirlookup+0x78>
801022c1:	83 c7 10             	add    $0x10,%edi
801022c4:	3b 7b 58             	cmp    0x58(%ebx),%edi
801022c7:	72 c7                	jb     80102290 <dirlookup+0x30>
801022c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022cc:	31 c0                	xor    %eax,%eax
801022ce:	5b                   	pop    %ebx
801022cf:	5e                   	pop    %esi
801022d0:	5f                   	pop    %edi
801022d1:	5d                   	pop    %ebp
801022d2:	c3                   	ret    
801022d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022d7:	90                   	nop
801022d8:	8b 45 10             	mov    0x10(%ebp),%eax
801022db:	85 c0                	test   %eax,%eax
801022dd:	74 05                	je     801022e4 <dirlookup+0x84>
801022df:	8b 45 10             	mov    0x10(%ebp),%eax
801022e2:	89 38                	mov    %edi,(%eax)
801022e4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
801022e8:	8b 03                	mov    (%ebx),%eax
801022ea:	e8 01 f6 ff ff       	call   801018f0 <iget>
801022ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022f2:	5b                   	pop    %ebx
801022f3:	5e                   	pop    %esi
801022f4:	5f                   	pop    %edi
801022f5:	5d                   	pop    %ebp
801022f6:	c3                   	ret    
801022f7:	83 ec 0c             	sub    $0xc,%esp
801022fa:	68 51 78 10 80       	push   $0x80107851
801022ff:	e8 8c e0 ff ff       	call   80100390 <panic>
80102304:	83 ec 0c             	sub    $0xc,%esp
80102307:	68 3f 78 10 80       	push   $0x8010783f
8010230c:	e8 7f e0 ff ff       	call   80100390 <panic>
80102311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010231f:	90                   	nop

80102320 <namex>:
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	57                   	push   %edi
80102324:	56                   	push   %esi
80102325:	53                   	push   %ebx
80102326:	89 c3                	mov    %eax,%ebx
80102328:	83 ec 1c             	sub    $0x1c,%esp
8010232b:	80 38 2f             	cmpb   $0x2f,(%eax)
8010232e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102331:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102334:	0f 84 86 01 00 00    	je     801024c0 <namex+0x1a0>
8010233a:	e8 d1 1b 00 00       	call   80103f10 <myproc>
8010233f:	83 ec 0c             	sub    $0xc,%esp
80102342:	89 df                	mov    %ebx,%edi
80102344:	8b 70 68             	mov    0x68(%eax),%esi
80102347:	68 80 1f 11 80       	push   $0x80111f80
8010234c:	e8 bf 27 00 00       	call   80104b10 <acquire>
80102351:	83 46 08 01          	addl   $0x1,0x8(%esi)
80102355:	c7 04 24 80 1f 11 80 	movl   $0x80111f80,(%esp)
8010235c:	e8 6f 28 00 00       	call   80104bd0 <release>
80102361:	83 c4 10             	add    $0x10,%esp
80102364:	eb 0d                	jmp    80102373 <namex+0x53>
80102366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010236d:	8d 76 00             	lea    0x0(%esi),%esi
80102370:	83 c7 01             	add    $0x1,%edi
80102373:	0f b6 07             	movzbl (%edi),%eax
80102376:	3c 2f                	cmp    $0x2f,%al
80102378:	74 f6                	je     80102370 <namex+0x50>
8010237a:	84 c0                	test   %al,%al
8010237c:	0f 84 ee 00 00 00    	je     80102470 <namex+0x150>
80102382:	0f b6 07             	movzbl (%edi),%eax
80102385:	84 c0                	test   %al,%al
80102387:	0f 84 fb 00 00 00    	je     80102488 <namex+0x168>
8010238d:	89 fb                	mov    %edi,%ebx
8010238f:	3c 2f                	cmp    $0x2f,%al
80102391:	0f 84 f1 00 00 00    	je     80102488 <namex+0x168>
80102397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010239e:	66 90                	xchg   %ax,%ax
801023a0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
801023a4:	83 c3 01             	add    $0x1,%ebx
801023a7:	3c 2f                	cmp    $0x2f,%al
801023a9:	74 04                	je     801023af <namex+0x8f>
801023ab:	84 c0                	test   %al,%al
801023ad:	75 f1                	jne    801023a0 <namex+0x80>
801023af:	89 d8                	mov    %ebx,%eax
801023b1:	29 f8                	sub    %edi,%eax
801023b3:	83 f8 0d             	cmp    $0xd,%eax
801023b6:	0f 8e 84 00 00 00    	jle    80102440 <namex+0x120>
801023bc:	83 ec 04             	sub    $0x4,%esp
801023bf:	6a 0e                	push   $0xe
801023c1:	57                   	push   %edi
801023c2:	89 df                	mov    %ebx,%edi
801023c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801023c7:	e8 f4 28 00 00       	call   80104cc0 <memmove>
801023cc:	83 c4 10             	add    $0x10,%esp
801023cf:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801023d2:	75 0c                	jne    801023e0 <namex+0xc0>
801023d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023d8:	83 c7 01             	add    $0x1,%edi
801023db:	80 3f 2f             	cmpb   $0x2f,(%edi)
801023de:	74 f8                	je     801023d8 <namex+0xb8>
801023e0:	83 ec 0c             	sub    $0xc,%esp
801023e3:	56                   	push   %esi
801023e4:	e8 27 f9 ff ff       	call   80101d10 <ilock>
801023e9:	83 c4 10             	add    $0x10,%esp
801023ec:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801023f1:	0f 85 a1 00 00 00    	jne    80102498 <namex+0x178>
801023f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801023fa:	85 d2                	test   %edx,%edx
801023fc:	74 09                	je     80102407 <namex+0xe7>
801023fe:	80 3f 00             	cmpb   $0x0,(%edi)
80102401:	0f 84 d9 00 00 00    	je     801024e0 <namex+0x1c0>
80102407:	83 ec 04             	sub    $0x4,%esp
8010240a:	6a 00                	push   $0x0
8010240c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010240f:	56                   	push   %esi
80102410:	e8 4b fe ff ff       	call   80102260 <dirlookup>
80102415:	83 c4 10             	add    $0x10,%esp
80102418:	89 c3                	mov    %eax,%ebx
8010241a:	85 c0                	test   %eax,%eax
8010241c:	74 7a                	je     80102498 <namex+0x178>
8010241e:	83 ec 0c             	sub    $0xc,%esp
80102421:	56                   	push   %esi
80102422:	e8 c9 f9 ff ff       	call   80101df0 <iunlock>
80102427:	89 34 24             	mov    %esi,(%esp)
8010242a:	89 de                	mov    %ebx,%esi
8010242c:	e8 0f fa ff ff       	call   80101e40 <iput>
80102431:	83 c4 10             	add    $0x10,%esp
80102434:	e9 3a ff ff ff       	jmp    80102373 <namex+0x53>
80102439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102440:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102443:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102446:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80102449:	83 ec 04             	sub    $0x4,%esp
8010244c:	50                   	push   %eax
8010244d:	57                   	push   %edi
8010244e:	89 df                	mov    %ebx,%edi
80102450:	ff 75 e4             	pushl  -0x1c(%ebp)
80102453:	e8 68 28 00 00       	call   80104cc0 <memmove>
80102458:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010245b:	83 c4 10             	add    $0x10,%esp
8010245e:	c6 00 00             	movb   $0x0,(%eax)
80102461:	e9 69 ff ff ff       	jmp    801023cf <namex+0xaf>
80102466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010246d:	8d 76 00             	lea    0x0(%esi),%esi
80102470:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102473:	85 c0                	test   %eax,%eax
80102475:	0f 85 85 00 00 00    	jne    80102500 <namex+0x1e0>
8010247b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010247e:	89 f0                	mov    %esi,%eax
80102480:	5b                   	pop    %ebx
80102481:	5e                   	pop    %esi
80102482:	5f                   	pop    %edi
80102483:	5d                   	pop    %ebp
80102484:	c3                   	ret    
80102485:	8d 76 00             	lea    0x0(%esi),%esi
80102488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010248b:	89 fb                	mov    %edi,%ebx
8010248d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102490:	31 c0                	xor    %eax,%eax
80102492:	eb b5                	jmp    80102449 <namex+0x129>
80102494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102498:	83 ec 0c             	sub    $0xc,%esp
8010249b:	56                   	push   %esi
8010249c:	e8 4f f9 ff ff       	call   80101df0 <iunlock>
801024a1:	89 34 24             	mov    %esi,(%esp)
801024a4:	31 f6                	xor    %esi,%esi
801024a6:	e8 95 f9 ff ff       	call   80101e40 <iput>
801024ab:	83 c4 10             	add    $0x10,%esp
801024ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024b1:	89 f0                	mov    %esi,%eax
801024b3:	5b                   	pop    %ebx
801024b4:	5e                   	pop    %esi
801024b5:	5f                   	pop    %edi
801024b6:	5d                   	pop    %ebp
801024b7:	c3                   	ret    
801024b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024bf:	90                   	nop
801024c0:	ba 01 00 00 00       	mov    $0x1,%edx
801024c5:	b8 01 00 00 00       	mov    $0x1,%eax
801024ca:	89 df                	mov    %ebx,%edi
801024cc:	e8 1f f4 ff ff       	call   801018f0 <iget>
801024d1:	89 c6                	mov    %eax,%esi
801024d3:	e9 9b fe ff ff       	jmp    80102373 <namex+0x53>
801024d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024df:	90                   	nop
801024e0:	83 ec 0c             	sub    $0xc,%esp
801024e3:	56                   	push   %esi
801024e4:	e8 07 f9 ff ff       	call   80101df0 <iunlock>
801024e9:	83 c4 10             	add    $0x10,%esp
801024ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024ef:	89 f0                	mov    %esi,%eax
801024f1:	5b                   	pop    %ebx
801024f2:	5e                   	pop    %esi
801024f3:	5f                   	pop    %edi
801024f4:	5d                   	pop    %ebp
801024f5:	c3                   	ret    
801024f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024fd:	8d 76 00             	lea    0x0(%esi),%esi
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	56                   	push   %esi
80102504:	31 f6                	xor    %esi,%esi
80102506:	e8 35 f9 ff ff       	call   80101e40 <iput>
8010250b:	83 c4 10             	add    $0x10,%esp
8010250e:	e9 68 ff ff ff       	jmp    8010247b <namex+0x15b>
80102513:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010251a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102520 <dirlink>:
80102520:	f3 0f 1e fb          	endbr32 
80102524:	55                   	push   %ebp
80102525:	89 e5                	mov    %esp,%ebp
80102527:	57                   	push   %edi
80102528:	56                   	push   %esi
80102529:	53                   	push   %ebx
8010252a:	83 ec 20             	sub    $0x20,%esp
8010252d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102530:	6a 00                	push   $0x0
80102532:	ff 75 0c             	pushl  0xc(%ebp)
80102535:	53                   	push   %ebx
80102536:	e8 25 fd ff ff       	call   80102260 <dirlookup>
8010253b:	83 c4 10             	add    $0x10,%esp
8010253e:	85 c0                	test   %eax,%eax
80102540:	75 6b                	jne    801025ad <dirlink+0x8d>
80102542:	8b 7b 58             	mov    0x58(%ebx),%edi
80102545:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102548:	85 ff                	test   %edi,%edi
8010254a:	74 2d                	je     80102579 <dirlink+0x59>
8010254c:	31 ff                	xor    %edi,%edi
8010254e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102551:	eb 0d                	jmp    80102560 <dirlink+0x40>
80102553:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102557:	90                   	nop
80102558:	83 c7 10             	add    $0x10,%edi
8010255b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010255e:	73 19                	jae    80102579 <dirlink+0x59>
80102560:	6a 10                	push   $0x10
80102562:	57                   	push   %edi
80102563:	56                   	push   %esi
80102564:	53                   	push   %ebx
80102565:	e8 a6 fa ff ff       	call   80102010 <readi>
8010256a:	83 c4 10             	add    $0x10,%esp
8010256d:	83 f8 10             	cmp    $0x10,%eax
80102570:	75 4e                	jne    801025c0 <dirlink+0xa0>
80102572:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102577:	75 df                	jne    80102558 <dirlink+0x38>
80102579:	83 ec 04             	sub    $0x4,%esp
8010257c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010257f:	6a 0e                	push   $0xe
80102581:	ff 75 0c             	pushl  0xc(%ebp)
80102584:	50                   	push   %eax
80102585:	e8 f6 27 00 00       	call   80104d80 <strncpy>
8010258a:	6a 10                	push   $0x10
8010258c:	8b 45 10             	mov    0x10(%ebp),%eax
8010258f:	57                   	push   %edi
80102590:	56                   	push   %esi
80102591:	53                   	push   %ebx
80102592:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
80102596:	e8 75 fb ff ff       	call   80102110 <writei>
8010259b:	83 c4 20             	add    $0x20,%esp
8010259e:	83 f8 10             	cmp    $0x10,%eax
801025a1:	75 2a                	jne    801025cd <dirlink+0xad>
801025a3:	31 c0                	xor    %eax,%eax
801025a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025a8:	5b                   	pop    %ebx
801025a9:	5e                   	pop    %esi
801025aa:	5f                   	pop    %edi
801025ab:	5d                   	pop    %ebp
801025ac:	c3                   	ret    
801025ad:	83 ec 0c             	sub    $0xc,%esp
801025b0:	50                   	push   %eax
801025b1:	e8 8a f8 ff ff       	call   80101e40 <iput>
801025b6:	83 c4 10             	add    $0x10,%esp
801025b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025be:	eb e5                	jmp    801025a5 <dirlink+0x85>
801025c0:	83 ec 0c             	sub    $0xc,%esp
801025c3:	68 60 78 10 80       	push   $0x80107860
801025c8:	e8 c3 dd ff ff       	call   80100390 <panic>
801025cd:	83 ec 0c             	sub    $0xc,%esp
801025d0:	68 3e 7e 10 80       	push   $0x80107e3e
801025d5:	e8 b6 dd ff ff       	call   80100390 <panic>
801025da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801025e0 <namei>:
801025e0:	f3 0f 1e fb          	endbr32 
801025e4:	55                   	push   %ebp
801025e5:	31 d2                	xor    %edx,%edx
801025e7:	89 e5                	mov    %esp,%ebp
801025e9:	83 ec 18             	sub    $0x18,%esp
801025ec:	8b 45 08             	mov    0x8(%ebp),%eax
801025ef:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801025f2:	e8 29 fd ff ff       	call   80102320 <namex>
801025f7:	c9                   	leave  
801025f8:	c3                   	ret    
801025f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102600 <nameiparent>:
80102600:	f3 0f 1e fb          	endbr32 
80102604:	55                   	push   %ebp
80102605:	ba 01 00 00 00       	mov    $0x1,%edx
8010260a:	89 e5                	mov    %esp,%ebp
8010260c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010260f:	8b 45 08             	mov    0x8(%ebp),%eax
80102612:	5d                   	pop    %ebp
80102613:	e9 08 fd ff ff       	jmp    80102320 <namex>
80102618:	66 90                	xchg   %ax,%ax
8010261a:	66 90                	xchg   %ax,%ax
8010261c:	66 90                	xchg   %ax,%ax
8010261e:	66 90                	xchg   %ax,%ax

80102620 <idestart>:
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	57                   	push   %edi
80102624:	56                   	push   %esi
80102625:	53                   	push   %ebx
80102626:	83 ec 0c             	sub    $0xc,%esp
80102629:	85 c0                	test   %eax,%eax
8010262b:	0f 84 b4 00 00 00    	je     801026e5 <idestart+0xc5>
80102631:	8b 70 08             	mov    0x8(%eax),%esi
80102634:	89 c3                	mov    %eax,%ebx
80102636:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010263c:	0f 87 96 00 00 00    	ja     801026d8 <idestart+0xb8>
80102642:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010264e:	66 90                	xchg   %ax,%ax
80102650:	89 ca                	mov    %ecx,%edx
80102652:	ec                   	in     (%dx),%al
80102653:	83 e0 c0             	and    $0xffffffc0,%eax
80102656:	3c 40                	cmp    $0x40,%al
80102658:	75 f6                	jne    80102650 <idestart+0x30>
8010265a:	31 ff                	xor    %edi,%edi
8010265c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102661:	89 f8                	mov    %edi,%eax
80102663:	ee                   	out    %al,(%dx)
80102664:	b8 01 00 00 00       	mov    $0x1,%eax
80102669:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010266e:	ee                   	out    %al,(%dx)
8010266f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102674:	89 f0                	mov    %esi,%eax
80102676:	ee                   	out    %al,(%dx)
80102677:	89 f0                	mov    %esi,%eax
80102679:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010267e:	c1 f8 08             	sar    $0x8,%eax
80102681:	ee                   	out    %al,(%dx)
80102682:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102687:	89 f8                	mov    %edi,%eax
80102689:	ee                   	out    %al,(%dx)
8010268a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010268e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102693:	c1 e0 04             	shl    $0x4,%eax
80102696:	83 e0 10             	and    $0x10,%eax
80102699:	83 c8 e0             	or     $0xffffffe0,%eax
8010269c:	ee                   	out    %al,(%dx)
8010269d:	f6 03 04             	testb  $0x4,(%ebx)
801026a0:	75 16                	jne    801026b8 <idestart+0x98>
801026a2:	b8 20 00 00 00       	mov    $0x20,%eax
801026a7:	89 ca                	mov    %ecx,%edx
801026a9:	ee                   	out    %al,(%dx)
801026aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026ad:	5b                   	pop    %ebx
801026ae:	5e                   	pop    %esi
801026af:	5f                   	pop    %edi
801026b0:	5d                   	pop    %ebp
801026b1:	c3                   	ret    
801026b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801026b8:	b8 30 00 00 00       	mov    $0x30,%eax
801026bd:	89 ca                	mov    %ecx,%edx
801026bf:	ee                   	out    %al,(%dx)
801026c0:	b9 80 00 00 00       	mov    $0x80,%ecx
801026c5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801026c8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801026cd:	fc                   	cld    
801026ce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801026d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026d3:	5b                   	pop    %ebx
801026d4:	5e                   	pop    %esi
801026d5:	5f                   	pop    %edi
801026d6:	5d                   	pop    %ebp
801026d7:	c3                   	ret    
801026d8:	83 ec 0c             	sub    $0xc,%esp
801026db:	68 cc 78 10 80       	push   $0x801078cc
801026e0:	e8 ab dc ff ff       	call   80100390 <panic>
801026e5:	83 ec 0c             	sub    $0xc,%esp
801026e8:	68 c3 78 10 80       	push   $0x801078c3
801026ed:	e8 9e dc ff ff       	call   80100390 <panic>
801026f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102700 <ideinit>:
80102700:	f3 0f 1e fb          	endbr32 
80102704:	55                   	push   %ebp
80102705:	89 e5                	mov    %esp,%ebp
80102707:	83 ec 10             	sub    $0x10,%esp
8010270a:	68 de 78 10 80       	push   $0x801078de
8010270f:	68 80 b5 10 80       	push   $0x8010b580
80102714:	e8 77 22 00 00       	call   80104990 <initlock>
80102719:	58                   	pop    %eax
8010271a:	a1 a0 42 11 80       	mov    0x801142a0,%eax
8010271f:	5a                   	pop    %edx
80102720:	83 e8 01             	sub    $0x1,%eax
80102723:	50                   	push   %eax
80102724:	6a 0e                	push   $0xe
80102726:	e8 b5 02 00 00       	call   801029e0 <ioapicenable>
8010272b:	83 c4 10             	add    $0x10,%esp
8010272e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102733:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102737:	90                   	nop
80102738:	ec                   	in     (%dx),%al
80102739:	83 e0 c0             	and    $0xffffffc0,%eax
8010273c:	3c 40                	cmp    $0x40,%al
8010273e:	75 f8                	jne    80102738 <ideinit+0x38>
80102740:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102745:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010274a:	ee                   	out    %al,(%dx)
8010274b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102750:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102755:	eb 0e                	jmp    80102765 <ideinit+0x65>
80102757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010275e:	66 90                	xchg   %ax,%ax
80102760:	83 e9 01             	sub    $0x1,%ecx
80102763:	74 0f                	je     80102774 <ideinit+0x74>
80102765:	ec                   	in     (%dx),%al
80102766:	84 c0                	test   %al,%al
80102768:	74 f6                	je     80102760 <ideinit+0x60>
8010276a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102771:	00 00 00 
80102774:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102779:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010277e:	ee                   	out    %al,(%dx)
8010277f:	c9                   	leave  
80102780:	c3                   	ret    
80102781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278f:	90                   	nop

80102790 <ideintr>:
80102790:	f3 0f 1e fb          	endbr32 
80102794:	55                   	push   %ebp
80102795:	89 e5                	mov    %esp,%ebp
80102797:	57                   	push   %edi
80102798:	56                   	push   %esi
80102799:	53                   	push   %ebx
8010279a:	83 ec 18             	sub    $0x18,%esp
8010279d:	68 80 b5 10 80       	push   $0x8010b580
801027a2:	e8 69 23 00 00       	call   80104b10 <acquire>
801027a7:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801027ad:	83 c4 10             	add    $0x10,%esp
801027b0:	85 db                	test   %ebx,%ebx
801027b2:	74 5f                	je     80102813 <ideintr+0x83>
801027b4:	8b 43 58             	mov    0x58(%ebx),%eax
801027b7:	a3 64 b5 10 80       	mov    %eax,0x8010b564
801027bc:	8b 33                	mov    (%ebx),%esi
801027be:	f7 c6 04 00 00 00    	test   $0x4,%esi
801027c4:	75 2b                	jne    801027f1 <ideintr+0x61>
801027c6:	ba f7 01 00 00       	mov    $0x1f7,%edx
801027cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027cf:	90                   	nop
801027d0:	ec                   	in     (%dx),%al
801027d1:	89 c1                	mov    %eax,%ecx
801027d3:	83 e1 c0             	and    $0xffffffc0,%ecx
801027d6:	80 f9 40             	cmp    $0x40,%cl
801027d9:	75 f5                	jne    801027d0 <ideintr+0x40>
801027db:	a8 21                	test   $0x21,%al
801027dd:	75 12                	jne    801027f1 <ideintr+0x61>
801027df:	8d 7b 5c             	lea    0x5c(%ebx),%edi
801027e2:	b9 80 00 00 00       	mov    $0x80,%ecx
801027e7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801027ec:	fc                   	cld    
801027ed:	f3 6d                	rep insl (%dx),%es:(%edi)
801027ef:	8b 33                	mov    (%ebx),%esi
801027f1:	83 e6 fb             	and    $0xfffffffb,%esi
801027f4:	83 ec 0c             	sub    $0xc,%esp
801027f7:	83 ce 02             	or     $0x2,%esi
801027fa:	89 33                	mov    %esi,(%ebx)
801027fc:	53                   	push   %ebx
801027fd:	e8 8e 1e 00 00       	call   80104690 <wakeup>
80102802:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102807:	83 c4 10             	add    $0x10,%esp
8010280a:	85 c0                	test   %eax,%eax
8010280c:	74 05                	je     80102813 <ideintr+0x83>
8010280e:	e8 0d fe ff ff       	call   80102620 <idestart>
80102813:	83 ec 0c             	sub    $0xc,%esp
80102816:	68 80 b5 10 80       	push   $0x8010b580
8010281b:	e8 b0 23 00 00       	call   80104bd0 <release>
80102820:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102823:	5b                   	pop    %ebx
80102824:	5e                   	pop    %esi
80102825:	5f                   	pop    %edi
80102826:	5d                   	pop    %ebp
80102827:	c3                   	ret    
80102828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010282f:	90                   	nop

80102830 <iderw>:
80102830:	f3 0f 1e fb          	endbr32 
80102834:	55                   	push   %ebp
80102835:	89 e5                	mov    %esp,%ebp
80102837:	53                   	push   %ebx
80102838:	83 ec 10             	sub    $0x10,%esp
8010283b:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010283e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102841:	50                   	push   %eax
80102842:	e8 e9 20 00 00       	call   80104930 <holdingsleep>
80102847:	83 c4 10             	add    $0x10,%esp
8010284a:	85 c0                	test   %eax,%eax
8010284c:	0f 84 cf 00 00 00    	je     80102921 <iderw+0xf1>
80102852:	8b 03                	mov    (%ebx),%eax
80102854:	83 e0 06             	and    $0x6,%eax
80102857:	83 f8 02             	cmp    $0x2,%eax
8010285a:	0f 84 b4 00 00 00    	je     80102914 <iderw+0xe4>
80102860:	8b 53 04             	mov    0x4(%ebx),%edx
80102863:	85 d2                	test   %edx,%edx
80102865:	74 0d                	je     80102874 <iderw+0x44>
80102867:	a1 60 b5 10 80       	mov    0x8010b560,%eax
8010286c:	85 c0                	test   %eax,%eax
8010286e:	0f 84 93 00 00 00    	je     80102907 <iderw+0xd7>
80102874:	83 ec 0c             	sub    $0xc,%esp
80102877:	68 80 b5 10 80       	push   $0x8010b580
8010287c:	e8 8f 22 00 00       	call   80104b10 <acquire>
80102881:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102886:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
8010288d:	83 c4 10             	add    $0x10,%esp
80102890:	85 c0                	test   %eax,%eax
80102892:	74 6c                	je     80102900 <iderw+0xd0>
80102894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102898:	89 c2                	mov    %eax,%edx
8010289a:	8b 40 58             	mov    0x58(%eax),%eax
8010289d:	85 c0                	test   %eax,%eax
8010289f:	75 f7                	jne    80102898 <iderw+0x68>
801028a1:	83 c2 58             	add    $0x58,%edx
801028a4:	89 1a                	mov    %ebx,(%edx)
801028a6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801028ac:	74 42                	je     801028f0 <iderw+0xc0>
801028ae:	8b 03                	mov    (%ebx),%eax
801028b0:	83 e0 06             	and    $0x6,%eax
801028b3:	83 f8 02             	cmp    $0x2,%eax
801028b6:	74 23                	je     801028db <iderw+0xab>
801028b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop
801028c0:	83 ec 08             	sub    $0x8,%esp
801028c3:	68 80 b5 10 80       	push   $0x8010b580
801028c8:	53                   	push   %ebx
801028c9:	e8 02 1c 00 00       	call   801044d0 <sleep>
801028ce:	8b 03                	mov    (%ebx),%eax
801028d0:	83 c4 10             	add    $0x10,%esp
801028d3:	83 e0 06             	and    $0x6,%eax
801028d6:	83 f8 02             	cmp    $0x2,%eax
801028d9:	75 e5                	jne    801028c0 <iderw+0x90>
801028db:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
801028e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028e5:	c9                   	leave  
801028e6:	e9 e5 22 00 00       	jmp    80104bd0 <release>
801028eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028ef:	90                   	nop
801028f0:	89 d8                	mov    %ebx,%eax
801028f2:	e8 29 fd ff ff       	call   80102620 <idestart>
801028f7:	eb b5                	jmp    801028ae <iderw+0x7e>
801028f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102900:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102905:	eb 9d                	jmp    801028a4 <iderw+0x74>
80102907:	83 ec 0c             	sub    $0xc,%esp
8010290a:	68 0d 79 10 80       	push   $0x8010790d
8010290f:	e8 7c da ff ff       	call   80100390 <panic>
80102914:	83 ec 0c             	sub    $0xc,%esp
80102917:	68 f8 78 10 80       	push   $0x801078f8
8010291c:	e8 6f da ff ff       	call   80100390 <panic>
80102921:	83 ec 0c             	sub    $0xc,%esp
80102924:	68 e2 78 10 80       	push   $0x801078e2
80102929:	e8 62 da ff ff       	call   80100390 <panic>
8010292e:	66 90                	xchg   %ax,%ax

80102930 <ioapicinit>:
80102930:	f3 0f 1e fb          	endbr32 
80102934:	55                   	push   %ebp
80102935:	c7 05 d4 3b 11 80 00 	movl   $0xfec00000,0x80113bd4
8010293c:	00 c0 fe 
8010293f:	89 e5                	mov    %esp,%ebp
80102941:	56                   	push   %esi
80102942:	53                   	push   %ebx
80102943:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010294a:	00 00 00 
8010294d:	8b 15 d4 3b 11 80    	mov    0x80113bd4,%edx
80102953:	8b 72 10             	mov    0x10(%edx),%esi
80102956:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
8010295c:	8b 0d d4 3b 11 80    	mov    0x80113bd4,%ecx
80102962:	0f b6 15 00 3d 11 80 	movzbl 0x80113d00,%edx
80102969:	c1 ee 10             	shr    $0x10,%esi
8010296c:	89 f0                	mov    %esi,%eax
8010296e:	0f b6 f0             	movzbl %al,%esi
80102971:	8b 41 10             	mov    0x10(%ecx),%eax
80102974:	c1 e8 18             	shr    $0x18,%eax
80102977:	39 c2                	cmp    %eax,%edx
80102979:	74 16                	je     80102991 <ioapicinit+0x61>
8010297b:	83 ec 0c             	sub    $0xc,%esp
8010297e:	68 2c 79 10 80       	push   $0x8010792c
80102983:	e8 f8 df ff ff       	call   80100980 <cprintf>
80102988:	8b 0d d4 3b 11 80    	mov    0x80113bd4,%ecx
8010298e:	83 c4 10             	add    $0x10,%esp
80102991:	83 c6 21             	add    $0x21,%esi
80102994:	ba 10 00 00 00       	mov    $0x10,%edx
80102999:	b8 20 00 00 00       	mov    $0x20,%eax
8010299e:	66 90                	xchg   %ax,%ax
801029a0:	89 11                	mov    %edx,(%ecx)
801029a2:	89 c3                	mov    %eax,%ebx
801029a4:	8b 0d d4 3b 11 80    	mov    0x80113bd4,%ecx
801029aa:	83 c0 01             	add    $0x1,%eax
801029ad:	81 cb 00 00 01 00    	or     $0x10000,%ebx
801029b3:	89 59 10             	mov    %ebx,0x10(%ecx)
801029b6:	8d 5a 01             	lea    0x1(%edx),%ebx
801029b9:	83 c2 02             	add    $0x2,%edx
801029bc:	89 19                	mov    %ebx,(%ecx)
801029be:	8b 0d d4 3b 11 80    	mov    0x80113bd4,%ecx
801029c4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
801029cb:	39 f0                	cmp    %esi,%eax
801029cd:	75 d1                	jne    801029a0 <ioapicinit+0x70>
801029cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029d2:	5b                   	pop    %ebx
801029d3:	5e                   	pop    %esi
801029d4:	5d                   	pop    %ebp
801029d5:	c3                   	ret    
801029d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029dd:	8d 76 00             	lea    0x0(%esi),%esi

801029e0 <ioapicenable>:
801029e0:	f3 0f 1e fb          	endbr32 
801029e4:	55                   	push   %ebp
801029e5:	8b 0d d4 3b 11 80    	mov    0x80113bd4,%ecx
801029eb:	89 e5                	mov    %esp,%ebp
801029ed:	8b 45 08             	mov    0x8(%ebp),%eax
801029f0:	8d 50 20             	lea    0x20(%eax),%edx
801029f3:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
801029f7:	89 01                	mov    %eax,(%ecx)
801029f9:	8b 0d d4 3b 11 80    	mov    0x80113bd4,%ecx
801029ff:	83 c0 01             	add    $0x1,%eax
80102a02:	89 51 10             	mov    %edx,0x10(%ecx)
80102a05:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a08:	89 01                	mov    %eax,(%ecx)
80102a0a:	a1 d4 3b 11 80       	mov    0x80113bd4,%eax
80102a0f:	c1 e2 18             	shl    $0x18,%edx
80102a12:	89 50 10             	mov    %edx,0x10(%eax)
80102a15:	5d                   	pop    %ebp
80102a16:	c3                   	ret    
80102a17:	66 90                	xchg   %ax,%ax
80102a19:	66 90                	xchg   %ax,%ax
80102a1b:	66 90                	xchg   %ax,%ax
80102a1d:	66 90                	xchg   %ax,%ax
80102a1f:	90                   	nop

80102a20 <kfree>:
80102a20:	f3 0f 1e fb          	endbr32 
80102a24:	55                   	push   %ebp
80102a25:	89 e5                	mov    %esp,%ebp
80102a27:	53                   	push   %ebx
80102a28:	83 ec 04             	sub    $0x4,%esp
80102a2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a2e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102a34:	75 7a                	jne    80102ab0 <kfree+0x90>
80102a36:	81 fb 48 6a 11 80    	cmp    $0x80116a48,%ebx
80102a3c:	72 72                	jb     80102ab0 <kfree+0x90>
80102a3e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102a44:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a49:	77 65                	ja     80102ab0 <kfree+0x90>
80102a4b:	83 ec 04             	sub    $0x4,%esp
80102a4e:	68 00 10 00 00       	push   $0x1000
80102a53:	6a 01                	push   $0x1
80102a55:	53                   	push   %ebx
80102a56:	e8 c5 21 00 00       	call   80104c20 <memset>
80102a5b:	8b 15 14 3c 11 80    	mov    0x80113c14,%edx
80102a61:	83 c4 10             	add    $0x10,%esp
80102a64:	85 d2                	test   %edx,%edx
80102a66:	75 20                	jne    80102a88 <kfree+0x68>
80102a68:	a1 18 3c 11 80       	mov    0x80113c18,%eax
80102a6d:	89 03                	mov    %eax,(%ebx)
80102a6f:	a1 14 3c 11 80       	mov    0x80113c14,%eax
80102a74:	89 1d 18 3c 11 80    	mov    %ebx,0x80113c18
80102a7a:	85 c0                	test   %eax,%eax
80102a7c:	75 22                	jne    80102aa0 <kfree+0x80>
80102a7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a81:	c9                   	leave  
80102a82:	c3                   	ret    
80102a83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a87:	90                   	nop
80102a88:	83 ec 0c             	sub    $0xc,%esp
80102a8b:	68 e0 3b 11 80       	push   $0x80113be0
80102a90:	e8 7b 20 00 00       	call   80104b10 <acquire>
80102a95:	83 c4 10             	add    $0x10,%esp
80102a98:	eb ce                	jmp    80102a68 <kfree+0x48>
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102aa0:	c7 45 08 e0 3b 11 80 	movl   $0x80113be0,0x8(%ebp)
80102aa7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102aaa:	c9                   	leave  
80102aab:	e9 20 21 00 00       	jmp    80104bd0 <release>
80102ab0:	83 ec 0c             	sub    $0xc,%esp
80102ab3:	68 5e 79 10 80       	push   $0x8010795e
80102ab8:	e8 d3 d8 ff ff       	call   80100390 <panic>
80102abd:	8d 76 00             	lea    0x0(%esi),%esi

80102ac0 <freerange>:
80102ac0:	f3 0f 1e fb          	endbr32 
80102ac4:	55                   	push   %ebp
80102ac5:	89 e5                	mov    %esp,%ebp
80102ac7:	56                   	push   %esi
80102ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80102acb:	8b 75 0c             	mov    0xc(%ebp),%esi
80102ace:	53                   	push   %ebx
80102acf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ad5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80102adb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102ae1:	39 de                	cmp    %ebx,%esi
80102ae3:	72 1f                	jb     80102b04 <freerange+0x44>
80102ae5:	8d 76 00             	lea    0x0(%esi),%esi
80102ae8:	83 ec 0c             	sub    $0xc,%esp
80102aeb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102af1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102af7:	50                   	push   %eax
80102af8:	e8 23 ff ff ff       	call   80102a20 <kfree>
80102afd:	83 c4 10             	add    $0x10,%esp
80102b00:	39 f3                	cmp    %esi,%ebx
80102b02:	76 e4                	jbe    80102ae8 <freerange+0x28>
80102b04:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b07:	5b                   	pop    %ebx
80102b08:	5e                   	pop    %esi
80102b09:	5d                   	pop    %ebp
80102b0a:	c3                   	ret    
80102b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b0f:	90                   	nop

80102b10 <kinit1>:
80102b10:	f3 0f 1e fb          	endbr32 
80102b14:	55                   	push   %ebp
80102b15:	89 e5                	mov    %esp,%ebp
80102b17:	56                   	push   %esi
80102b18:	53                   	push   %ebx
80102b19:	8b 75 0c             	mov    0xc(%ebp),%esi
80102b1c:	83 ec 08             	sub    $0x8,%esp
80102b1f:	68 64 79 10 80       	push   $0x80107964
80102b24:	68 e0 3b 11 80       	push   $0x80113be0
80102b29:	e8 62 1e 00 00       	call   80104990 <initlock>
80102b2e:	8b 45 08             	mov    0x8(%ebp),%eax
80102b31:	83 c4 10             	add    $0x10,%esp
80102b34:	c7 05 14 3c 11 80 00 	movl   $0x0,0x80113c14
80102b3b:	00 00 00 
80102b3e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b44:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80102b4a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b50:	39 de                	cmp    %ebx,%esi
80102b52:	72 20                	jb     80102b74 <kinit1+0x64>
80102b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b58:	83 ec 0c             	sub    $0xc,%esp
80102b5b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102b61:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b67:	50                   	push   %eax
80102b68:	e8 b3 fe ff ff       	call   80102a20 <kfree>
80102b6d:	83 c4 10             	add    $0x10,%esp
80102b70:	39 de                	cmp    %ebx,%esi
80102b72:	73 e4                	jae    80102b58 <kinit1+0x48>
80102b74:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b77:	5b                   	pop    %ebx
80102b78:	5e                   	pop    %esi
80102b79:	5d                   	pop    %ebp
80102b7a:	c3                   	ret    
80102b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b7f:	90                   	nop

80102b80 <kinit2>:
80102b80:	f3 0f 1e fb          	endbr32 
80102b84:	55                   	push   %ebp
80102b85:	89 e5                	mov    %esp,%ebp
80102b87:	56                   	push   %esi
80102b88:	8b 45 08             	mov    0x8(%ebp),%eax
80102b8b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102b8e:	53                   	push   %ebx
80102b8f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b95:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80102b9b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102ba1:	39 de                	cmp    %ebx,%esi
80102ba3:	72 1f                	jb     80102bc4 <kinit2+0x44>
80102ba5:	8d 76 00             	lea    0x0(%esi),%esi
80102ba8:	83 ec 0c             	sub    $0xc,%esp
80102bab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102bb1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102bb7:	50                   	push   %eax
80102bb8:	e8 63 fe ff ff       	call   80102a20 <kfree>
80102bbd:	83 c4 10             	add    $0x10,%esp
80102bc0:	39 de                	cmp    %ebx,%esi
80102bc2:	73 e4                	jae    80102ba8 <kinit2+0x28>
80102bc4:	c7 05 14 3c 11 80 01 	movl   $0x1,0x80113c14
80102bcb:	00 00 00 
80102bce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102bd1:	5b                   	pop    %ebx
80102bd2:	5e                   	pop    %esi
80102bd3:	5d                   	pop    %ebp
80102bd4:	c3                   	ret    
80102bd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102be0 <kalloc>:
80102be0:	f3 0f 1e fb          	endbr32 
80102be4:	a1 14 3c 11 80       	mov    0x80113c14,%eax
80102be9:	85 c0                	test   %eax,%eax
80102beb:	75 1b                	jne    80102c08 <kalloc+0x28>
80102bed:	a1 18 3c 11 80       	mov    0x80113c18,%eax
80102bf2:	85 c0                	test   %eax,%eax
80102bf4:	74 0a                	je     80102c00 <kalloc+0x20>
80102bf6:	8b 10                	mov    (%eax),%edx
80102bf8:	89 15 18 3c 11 80    	mov    %edx,0x80113c18
80102bfe:	c3                   	ret    
80102bff:	90                   	nop
80102c00:	c3                   	ret    
80102c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c08:	55                   	push   %ebp
80102c09:	89 e5                	mov    %esp,%ebp
80102c0b:	83 ec 24             	sub    $0x24,%esp
80102c0e:	68 e0 3b 11 80       	push   $0x80113be0
80102c13:	e8 f8 1e 00 00       	call   80104b10 <acquire>
80102c18:	a1 18 3c 11 80       	mov    0x80113c18,%eax
80102c1d:	8b 15 14 3c 11 80    	mov    0x80113c14,%edx
80102c23:	83 c4 10             	add    $0x10,%esp
80102c26:	85 c0                	test   %eax,%eax
80102c28:	74 08                	je     80102c32 <kalloc+0x52>
80102c2a:	8b 08                	mov    (%eax),%ecx
80102c2c:	89 0d 18 3c 11 80    	mov    %ecx,0x80113c18
80102c32:	85 d2                	test   %edx,%edx
80102c34:	74 16                	je     80102c4c <kalloc+0x6c>
80102c36:	83 ec 0c             	sub    $0xc,%esp
80102c39:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102c3c:	68 e0 3b 11 80       	push   $0x80113be0
80102c41:	e8 8a 1f 00 00       	call   80104bd0 <release>
80102c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c49:	83 c4 10             	add    $0x10,%esp
80102c4c:	c9                   	leave  
80102c4d:	c3                   	ret    
80102c4e:	66 90                	xchg   %ax,%ax

80102c50 <kbdgetc>:
80102c50:	f3 0f 1e fb          	endbr32 
80102c54:	ba 64 00 00 00       	mov    $0x64,%edx
80102c59:	ec                   	in     (%dx),%al
80102c5a:	a8 01                	test   $0x1,%al
80102c5c:	0f 84 be 00 00 00    	je     80102d20 <kbdgetc+0xd0>
80102c62:	55                   	push   %ebp
80102c63:	ba 60 00 00 00       	mov    $0x60,%edx
80102c68:	89 e5                	mov    %esp,%ebp
80102c6a:	53                   	push   %ebx
80102c6b:	ec                   	in     (%dx),%al
80102c6c:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
80102c72:	0f b6 d0             	movzbl %al,%edx
80102c75:	3c e0                	cmp    $0xe0,%al
80102c77:	74 57                	je     80102cd0 <kbdgetc+0x80>
80102c79:	89 d9                	mov    %ebx,%ecx
80102c7b:	83 e1 40             	and    $0x40,%ecx
80102c7e:	84 c0                	test   %al,%al
80102c80:	78 5e                	js     80102ce0 <kbdgetc+0x90>
80102c82:	85 c9                	test   %ecx,%ecx
80102c84:	74 09                	je     80102c8f <kbdgetc+0x3f>
80102c86:	83 c8 80             	or     $0xffffff80,%eax
80102c89:	83 e3 bf             	and    $0xffffffbf,%ebx
80102c8c:	0f b6 d0             	movzbl %al,%edx
80102c8f:	0f b6 8a a0 7a 10 80 	movzbl -0x7fef8560(%edx),%ecx
80102c96:	0f b6 82 a0 79 10 80 	movzbl -0x7fef8660(%edx),%eax
80102c9d:	09 d9                	or     %ebx,%ecx
80102c9f:	31 c1                	xor    %eax,%ecx
80102ca1:	89 c8                	mov    %ecx,%eax
80102ca3:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
80102ca9:	83 e0 03             	and    $0x3,%eax
80102cac:	83 e1 08             	and    $0x8,%ecx
80102caf:	8b 04 85 80 79 10 80 	mov    -0x7fef8680(,%eax,4),%eax
80102cb6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
80102cba:	74 0b                	je     80102cc7 <kbdgetc+0x77>
80102cbc:	8d 50 9f             	lea    -0x61(%eax),%edx
80102cbf:	83 fa 19             	cmp    $0x19,%edx
80102cc2:	77 44                	ja     80102d08 <kbdgetc+0xb8>
80102cc4:	83 e8 20             	sub    $0x20,%eax
80102cc7:	5b                   	pop    %ebx
80102cc8:	5d                   	pop    %ebp
80102cc9:	c3                   	ret    
80102cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102cd0:	83 cb 40             	or     $0x40,%ebx
80102cd3:	31 c0                	xor    %eax,%eax
80102cd5:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
80102cdb:	5b                   	pop    %ebx
80102cdc:	5d                   	pop    %ebp
80102cdd:	c3                   	ret    
80102cde:	66 90                	xchg   %ax,%ax
80102ce0:	83 e0 7f             	and    $0x7f,%eax
80102ce3:	85 c9                	test   %ecx,%ecx
80102ce5:	0f 44 d0             	cmove  %eax,%edx
80102ce8:	31 c0                	xor    %eax,%eax
80102cea:	0f b6 8a a0 7a 10 80 	movzbl -0x7fef8560(%edx),%ecx
80102cf1:	83 c9 40             	or     $0x40,%ecx
80102cf4:	0f b6 c9             	movzbl %cl,%ecx
80102cf7:	f7 d1                	not    %ecx
80102cf9:	21 d9                	and    %ebx,%ecx
80102cfb:	5b                   	pop    %ebx
80102cfc:	5d                   	pop    %ebp
80102cfd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
80102d03:	c3                   	ret    
80102d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d08:	8d 48 bf             	lea    -0x41(%eax),%ecx
80102d0b:	8d 50 20             	lea    0x20(%eax),%edx
80102d0e:	5b                   	pop    %ebx
80102d0f:	5d                   	pop    %ebp
80102d10:	83 f9 1a             	cmp    $0x1a,%ecx
80102d13:	0f 42 c2             	cmovb  %edx,%eax
80102d16:	c3                   	ret    
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
80102d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d25:	c3                   	ret    
80102d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2d:	8d 76 00             	lea    0x0(%esi),%esi

80102d30 <kbdintr>:
80102d30:	f3 0f 1e fb          	endbr32 
80102d34:	55                   	push   %ebp
80102d35:	89 e5                	mov    %esp,%ebp
80102d37:	83 ec 14             	sub    $0x14,%esp
80102d3a:	68 50 2c 10 80       	push   $0x80102c50
80102d3f:	e8 ec dd ff ff       	call   80100b30 <consoleintr>
80102d44:	83 c4 10             	add    $0x10,%esp
80102d47:	c9                   	leave  
80102d48:	c3                   	ret    
80102d49:	66 90                	xchg   %ax,%ax
80102d4b:	66 90                	xchg   %ax,%ax
80102d4d:	66 90                	xchg   %ax,%ax
80102d4f:	90                   	nop

80102d50 <lapicinit>:
80102d50:	f3 0f 1e fb          	endbr32 
80102d54:	a1 1c 3c 11 80       	mov    0x80113c1c,%eax
80102d59:	85 c0                	test   %eax,%eax
80102d5b:	0f 84 c7 00 00 00    	je     80102e28 <lapicinit+0xd8>
80102d61:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102d68:	01 00 00 
80102d6b:	8b 50 20             	mov    0x20(%eax),%edx
80102d6e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102d75:	00 00 00 
80102d78:	8b 50 20             	mov    0x20(%eax),%edx
80102d7b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102d82:	00 02 00 
80102d85:	8b 50 20             	mov    0x20(%eax),%edx
80102d88:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102d8f:	96 98 00 
80102d92:	8b 50 20             	mov    0x20(%eax),%edx
80102d95:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102d9c:	00 01 00 
80102d9f:	8b 50 20             	mov    0x20(%eax),%edx
80102da2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102da9:	00 01 00 
80102dac:	8b 50 20             	mov    0x20(%eax),%edx
80102daf:	8b 50 30             	mov    0x30(%eax),%edx
80102db2:	c1 ea 10             	shr    $0x10,%edx
80102db5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102dbb:	75 73                	jne    80102e30 <lapicinit+0xe0>
80102dbd:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102dc4:	00 00 00 
80102dc7:	8b 50 20             	mov    0x20(%eax),%edx
80102dca:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102dd1:	00 00 00 
80102dd4:	8b 50 20             	mov    0x20(%eax),%edx
80102dd7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102dde:	00 00 00 
80102de1:	8b 50 20             	mov    0x20(%eax),%edx
80102de4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102deb:	00 00 00 
80102dee:	8b 50 20             	mov    0x20(%eax),%edx
80102df1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102df8:	00 00 00 
80102dfb:	8b 50 20             	mov    0x20(%eax),%edx
80102dfe:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102e05:	85 08 00 
80102e08:	8b 50 20             	mov    0x20(%eax),%edx
80102e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e0f:	90                   	nop
80102e10:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102e16:	80 e6 10             	and    $0x10,%dh
80102e19:	75 f5                	jne    80102e10 <lapicinit+0xc0>
80102e1b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102e22:	00 00 00 
80102e25:	8b 40 20             	mov    0x20(%eax),%eax
80102e28:	c3                   	ret    
80102e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e30:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102e37:	00 01 00 
80102e3a:	8b 50 20             	mov    0x20(%eax),%edx
80102e3d:	e9 7b ff ff ff       	jmp    80102dbd <lapicinit+0x6d>
80102e42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e50 <lapicid>:
80102e50:	f3 0f 1e fb          	endbr32 
80102e54:	a1 1c 3c 11 80       	mov    0x80113c1c,%eax
80102e59:	85 c0                	test   %eax,%eax
80102e5b:	74 0b                	je     80102e68 <lapicid+0x18>
80102e5d:	8b 40 20             	mov    0x20(%eax),%eax
80102e60:	c1 e8 18             	shr    $0x18,%eax
80102e63:	c3                   	ret    
80102e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e68:	31 c0                	xor    %eax,%eax
80102e6a:	c3                   	ret    
80102e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop

80102e70 <lapiceoi>:
80102e70:	f3 0f 1e fb          	endbr32 
80102e74:	a1 1c 3c 11 80       	mov    0x80113c1c,%eax
80102e79:	85 c0                	test   %eax,%eax
80102e7b:	74 0d                	je     80102e8a <lapiceoi+0x1a>
80102e7d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102e84:	00 00 00 
80102e87:	8b 40 20             	mov    0x20(%eax),%eax
80102e8a:	c3                   	ret    
80102e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e8f:	90                   	nop

80102e90 <microdelay>:
80102e90:	f3 0f 1e fb          	endbr32 
80102e94:	c3                   	ret    
80102e95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ea0 <lapicstartap>:
80102ea0:	f3 0f 1e fb          	endbr32 
80102ea4:	55                   	push   %ebp
80102ea5:	b8 0f 00 00 00       	mov    $0xf,%eax
80102eaa:	ba 70 00 00 00       	mov    $0x70,%edx
80102eaf:	89 e5                	mov    %esp,%ebp
80102eb1:	53                   	push   %ebx
80102eb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102eb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102eb8:	ee                   	out    %al,(%dx)
80102eb9:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ebe:	ba 71 00 00 00       	mov    $0x71,%edx
80102ec3:	ee                   	out    %al,(%dx)
80102ec4:	31 c0                	xor    %eax,%eax
80102ec6:	c1 e3 18             	shl    $0x18,%ebx
80102ec9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
80102ecf:	89 c8                	mov    %ecx,%eax
80102ed1:	c1 e9 0c             	shr    $0xc,%ecx
80102ed4:	89 da                	mov    %ebx,%edx
80102ed6:	c1 e8 04             	shr    $0x4,%eax
80102ed9:	80 cd 06             	or     $0x6,%ch
80102edc:	66 a3 69 04 00 80    	mov    %ax,0x80000469
80102ee2:	a1 1c 3c 11 80       	mov    0x80113c1c,%eax
80102ee7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
80102eed:	8b 58 20             	mov    0x20(%eax),%ebx
80102ef0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ef7:	c5 00 00 
80102efa:	8b 58 20             	mov    0x20(%eax),%ebx
80102efd:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102f04:	85 00 00 
80102f07:	8b 58 20             	mov    0x20(%eax),%ebx
80102f0a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
80102f10:	8b 58 20             	mov    0x20(%eax),%ebx
80102f13:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
80102f19:	8b 58 20             	mov    0x20(%eax),%ebx
80102f1c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
80102f22:	8b 50 20             	mov    0x20(%eax),%edx
80102f25:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
80102f2b:	5b                   	pop    %ebx
80102f2c:	8b 40 20             	mov    0x20(%eax),%eax
80102f2f:	5d                   	pop    %ebp
80102f30:	c3                   	ret    
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <cmostime>:
80102f40:	f3 0f 1e fb          	endbr32 
80102f44:	55                   	push   %ebp
80102f45:	b8 0b 00 00 00       	mov    $0xb,%eax
80102f4a:	ba 70 00 00 00       	mov    $0x70,%edx
80102f4f:	89 e5                	mov    %esp,%ebp
80102f51:	57                   	push   %edi
80102f52:	56                   	push   %esi
80102f53:	53                   	push   %ebx
80102f54:	83 ec 4c             	sub    $0x4c,%esp
80102f57:	ee                   	out    %al,(%dx)
80102f58:	ba 71 00 00 00       	mov    $0x71,%edx
80102f5d:	ec                   	in     (%dx),%al
80102f5e:	83 e0 04             	and    $0x4,%eax
80102f61:	bb 70 00 00 00       	mov    $0x70,%ebx
80102f66:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f70:	31 c0                	xor    %eax,%eax
80102f72:	89 da                	mov    %ebx,%edx
80102f74:	ee                   	out    %al,(%dx)
80102f75:	b9 71 00 00 00       	mov    $0x71,%ecx
80102f7a:	89 ca                	mov    %ecx,%edx
80102f7c:	ec                   	in     (%dx),%al
80102f7d:	88 45 b7             	mov    %al,-0x49(%ebp)
80102f80:	89 da                	mov    %ebx,%edx
80102f82:	b8 02 00 00 00       	mov    $0x2,%eax
80102f87:	ee                   	out    %al,(%dx)
80102f88:	89 ca                	mov    %ecx,%edx
80102f8a:	ec                   	in     (%dx),%al
80102f8b:	88 45 b6             	mov    %al,-0x4a(%ebp)
80102f8e:	89 da                	mov    %ebx,%edx
80102f90:	b8 04 00 00 00       	mov    $0x4,%eax
80102f95:	ee                   	out    %al,(%dx)
80102f96:	89 ca                	mov    %ecx,%edx
80102f98:	ec                   	in     (%dx),%al
80102f99:	88 45 b5             	mov    %al,-0x4b(%ebp)
80102f9c:	89 da                	mov    %ebx,%edx
80102f9e:	b8 07 00 00 00       	mov    $0x7,%eax
80102fa3:	ee                   	out    %al,(%dx)
80102fa4:	89 ca                	mov    %ecx,%edx
80102fa6:	ec                   	in     (%dx),%al
80102fa7:	88 45 b4             	mov    %al,-0x4c(%ebp)
80102faa:	89 da                	mov    %ebx,%edx
80102fac:	b8 08 00 00 00       	mov    $0x8,%eax
80102fb1:	ee                   	out    %al,(%dx)
80102fb2:	89 ca                	mov    %ecx,%edx
80102fb4:	ec                   	in     (%dx),%al
80102fb5:	89 c7                	mov    %eax,%edi
80102fb7:	89 da                	mov    %ebx,%edx
80102fb9:	b8 09 00 00 00       	mov    $0x9,%eax
80102fbe:	ee                   	out    %al,(%dx)
80102fbf:	89 ca                	mov    %ecx,%edx
80102fc1:	ec                   	in     (%dx),%al
80102fc2:	89 c6                	mov    %eax,%esi
80102fc4:	89 da                	mov    %ebx,%edx
80102fc6:	b8 0a 00 00 00       	mov    $0xa,%eax
80102fcb:	ee                   	out    %al,(%dx)
80102fcc:	89 ca                	mov    %ecx,%edx
80102fce:	ec                   	in     (%dx),%al
80102fcf:	84 c0                	test   %al,%al
80102fd1:	78 9d                	js     80102f70 <cmostime+0x30>
80102fd3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102fd7:	89 fa                	mov    %edi,%edx
80102fd9:	0f b6 fa             	movzbl %dl,%edi
80102fdc:	89 f2                	mov    %esi,%edx
80102fde:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102fe1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102fe5:	0f b6 f2             	movzbl %dl,%esi
80102fe8:	89 da                	mov    %ebx,%edx
80102fea:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102fed:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ff0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102ff4:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102ff7:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ffa:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ffe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103001:	31 c0                	xor    %eax,%eax
80103003:	ee                   	out    %al,(%dx)
80103004:	89 ca                	mov    %ecx,%edx
80103006:	ec                   	in     (%dx),%al
80103007:	0f b6 c0             	movzbl %al,%eax
8010300a:	89 da                	mov    %ebx,%edx
8010300c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010300f:	b8 02 00 00 00       	mov    $0x2,%eax
80103014:	ee                   	out    %al,(%dx)
80103015:	89 ca                	mov    %ecx,%edx
80103017:	ec                   	in     (%dx),%al
80103018:	0f b6 c0             	movzbl %al,%eax
8010301b:	89 da                	mov    %ebx,%edx
8010301d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103020:	b8 04 00 00 00       	mov    $0x4,%eax
80103025:	ee                   	out    %al,(%dx)
80103026:	89 ca                	mov    %ecx,%edx
80103028:	ec                   	in     (%dx),%al
80103029:	0f b6 c0             	movzbl %al,%eax
8010302c:	89 da                	mov    %ebx,%edx
8010302e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103031:	b8 07 00 00 00       	mov    $0x7,%eax
80103036:	ee                   	out    %al,(%dx)
80103037:	89 ca                	mov    %ecx,%edx
80103039:	ec                   	in     (%dx),%al
8010303a:	0f b6 c0             	movzbl %al,%eax
8010303d:	89 da                	mov    %ebx,%edx
8010303f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103042:	b8 08 00 00 00       	mov    $0x8,%eax
80103047:	ee                   	out    %al,(%dx)
80103048:	89 ca                	mov    %ecx,%edx
8010304a:	ec                   	in     (%dx),%al
8010304b:	0f b6 c0             	movzbl %al,%eax
8010304e:	89 da                	mov    %ebx,%edx
80103050:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103053:	b8 09 00 00 00       	mov    $0x9,%eax
80103058:	ee                   	out    %al,(%dx)
80103059:	89 ca                	mov    %ecx,%edx
8010305b:	ec                   	in     (%dx),%al
8010305c:	0f b6 c0             	movzbl %al,%eax
8010305f:	83 ec 04             	sub    $0x4,%esp
80103062:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103065:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103068:	6a 18                	push   $0x18
8010306a:	50                   	push   %eax
8010306b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010306e:	50                   	push   %eax
8010306f:	e8 fc 1b 00 00       	call   80104c70 <memcmp>
80103074:	83 c4 10             	add    $0x10,%esp
80103077:	85 c0                	test   %eax,%eax
80103079:	0f 85 f1 fe ff ff    	jne    80102f70 <cmostime+0x30>
8010307f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103083:	75 78                	jne    801030fd <cmostime+0x1bd>
80103085:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103088:	89 c2                	mov    %eax,%edx
8010308a:	83 e0 0f             	and    $0xf,%eax
8010308d:	c1 ea 04             	shr    $0x4,%edx
80103090:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103093:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103096:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103099:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010309c:	89 c2                	mov    %eax,%edx
8010309e:	83 e0 0f             	and    $0xf,%eax
801030a1:	c1 ea 04             	shr    $0x4,%edx
801030a4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030a7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030aa:	89 45 bc             	mov    %eax,-0x44(%ebp)
801030ad:	8b 45 c0             	mov    -0x40(%ebp),%eax
801030b0:	89 c2                	mov    %eax,%edx
801030b2:	83 e0 0f             	and    $0xf,%eax
801030b5:	c1 ea 04             	shr    $0x4,%edx
801030b8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030bb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030be:	89 45 c0             	mov    %eax,-0x40(%ebp)
801030c1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801030c4:	89 c2                	mov    %eax,%edx
801030c6:	83 e0 0f             	and    $0xf,%eax
801030c9:	c1 ea 04             	shr    $0x4,%edx
801030cc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030cf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030d2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801030d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
801030d8:	89 c2                	mov    %eax,%edx
801030da:	83 e0 0f             	and    $0xf,%eax
801030dd:	c1 ea 04             	shr    $0x4,%edx
801030e0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030e3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030e6:	89 45 c8             	mov    %eax,-0x38(%ebp)
801030e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801030ec:	89 c2                	mov    %eax,%edx
801030ee:	83 e0 0f             	and    $0xf,%eax
801030f1:	c1 ea 04             	shr    $0x4,%edx
801030f4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030f7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030fa:	89 45 cc             	mov    %eax,-0x34(%ebp)
801030fd:	8b 75 08             	mov    0x8(%ebp),%esi
80103100:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103103:	89 06                	mov    %eax,(%esi)
80103105:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103108:	89 46 04             	mov    %eax,0x4(%esi)
8010310b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010310e:	89 46 08             	mov    %eax,0x8(%esi)
80103111:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103114:	89 46 0c             	mov    %eax,0xc(%esi)
80103117:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010311a:	89 46 10             	mov    %eax,0x10(%esi)
8010311d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103120:	89 46 14             	mov    %eax,0x14(%esi)
80103123:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
8010312a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010312d:	5b                   	pop    %ebx
8010312e:	5e                   	pop    %esi
8010312f:	5f                   	pop    %edi
80103130:	5d                   	pop    %ebp
80103131:	c3                   	ret    
80103132:	66 90                	xchg   %ax,%ax
80103134:	66 90                	xchg   %ax,%ax
80103136:	66 90                	xchg   %ax,%ax
80103138:	66 90                	xchg   %ax,%ax
8010313a:	66 90                	xchg   %ax,%ax
8010313c:	66 90                	xchg   %ax,%ax
8010313e:	66 90                	xchg   %ax,%ax

80103140 <install_trans>:
80103140:	8b 0d 68 3c 11 80    	mov    0x80113c68,%ecx
80103146:	85 c9                	test   %ecx,%ecx
80103148:	0f 8e 8a 00 00 00    	jle    801031d8 <install_trans+0x98>
8010314e:	55                   	push   %ebp
8010314f:	89 e5                	mov    %esp,%ebp
80103151:	57                   	push   %edi
80103152:	31 ff                	xor    %edi,%edi
80103154:	56                   	push   %esi
80103155:	53                   	push   %ebx
80103156:	83 ec 0c             	sub    $0xc,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	a1 54 3c 11 80       	mov    0x80113c54,%eax
80103165:	83 ec 08             	sub    $0x8,%esp
80103168:	01 f8                	add    %edi,%eax
8010316a:	83 c0 01             	add    $0x1,%eax
8010316d:	50                   	push   %eax
8010316e:	ff 35 64 3c 11 80    	pushl  0x80113c64
80103174:	e8 57 cf ff ff       	call   801000d0 <bread>
80103179:	89 c6                	mov    %eax,%esi
8010317b:	58                   	pop    %eax
8010317c:	5a                   	pop    %edx
8010317d:	ff 34 bd 6c 3c 11 80 	pushl  -0x7feec394(,%edi,4)
80103184:	ff 35 64 3c 11 80    	pushl  0x80113c64
8010318a:	83 c7 01             	add    $0x1,%edi
8010318d:	e8 3e cf ff ff       	call   801000d0 <bread>
80103192:	83 c4 0c             	add    $0xc,%esp
80103195:	89 c3                	mov    %eax,%ebx
80103197:	8d 46 5c             	lea    0x5c(%esi),%eax
8010319a:	68 00 02 00 00       	push   $0x200
8010319f:	50                   	push   %eax
801031a0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801031a3:	50                   	push   %eax
801031a4:	e8 17 1b 00 00       	call   80104cc0 <memmove>
801031a9:	89 1c 24             	mov    %ebx,(%esp)
801031ac:	e8 ff cf ff ff       	call   801001b0 <bwrite>
801031b1:	89 34 24             	mov    %esi,(%esp)
801031b4:	e8 37 d0 ff ff       	call   801001f0 <brelse>
801031b9:	89 1c 24             	mov    %ebx,(%esp)
801031bc:	e8 2f d0 ff ff       	call   801001f0 <brelse>
801031c1:	83 c4 10             	add    $0x10,%esp
801031c4:	39 3d 68 3c 11 80    	cmp    %edi,0x80113c68
801031ca:	7f 94                	jg     80103160 <install_trans+0x20>
801031cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031cf:	5b                   	pop    %ebx
801031d0:	5e                   	pop    %esi
801031d1:	5f                   	pop    %edi
801031d2:	5d                   	pop    %ebp
801031d3:	c3                   	ret    
801031d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031d8:	c3                   	ret    
801031d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801031e0 <write_head>:
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	53                   	push   %ebx
801031e4:	83 ec 0c             	sub    $0xc,%esp
801031e7:	ff 35 54 3c 11 80    	pushl  0x80113c54
801031ed:	ff 35 64 3c 11 80    	pushl  0x80113c64
801031f3:	e8 d8 ce ff ff       	call   801000d0 <bread>
801031f8:	83 c4 10             	add    $0x10,%esp
801031fb:	89 c3                	mov    %eax,%ebx
801031fd:	a1 68 3c 11 80       	mov    0x80113c68,%eax
80103202:	89 43 5c             	mov    %eax,0x5c(%ebx)
80103205:	85 c0                	test   %eax,%eax
80103207:	7e 19                	jle    80103222 <write_head+0x42>
80103209:	31 d2                	xor    %edx,%edx
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop
80103210:	8b 0c 95 6c 3c 11 80 	mov    -0x7feec394(,%edx,4),%ecx
80103217:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
8010321b:	83 c2 01             	add    $0x1,%edx
8010321e:	39 d0                	cmp    %edx,%eax
80103220:	75 ee                	jne    80103210 <write_head+0x30>
80103222:	83 ec 0c             	sub    $0xc,%esp
80103225:	53                   	push   %ebx
80103226:	e8 85 cf ff ff       	call   801001b0 <bwrite>
8010322b:	89 1c 24             	mov    %ebx,(%esp)
8010322e:	e8 bd cf ff ff       	call   801001f0 <brelse>
80103233:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103236:	83 c4 10             	add    $0x10,%esp
80103239:	c9                   	leave  
8010323a:	c3                   	ret    
8010323b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010323f:	90                   	nop

80103240 <initlog>:
80103240:	f3 0f 1e fb          	endbr32 
80103244:	55                   	push   %ebp
80103245:	89 e5                	mov    %esp,%ebp
80103247:	53                   	push   %ebx
80103248:	83 ec 2c             	sub    $0x2c,%esp
8010324b:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010324e:	68 a0 7b 10 80       	push   $0x80107ba0
80103253:	68 20 3c 11 80       	push   $0x80113c20
80103258:	e8 33 17 00 00       	call   80104990 <initlock>
8010325d:	58                   	pop    %eax
8010325e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103261:	5a                   	pop    %edx
80103262:	50                   	push   %eax
80103263:	53                   	push   %ebx
80103264:	e8 47 e8 ff ff       	call   80101ab0 <readsb>
80103269:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010326c:	59                   	pop    %ecx
8010326d:	89 1d 64 3c 11 80    	mov    %ebx,0x80113c64
80103273:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103276:	a3 54 3c 11 80       	mov    %eax,0x80113c54
8010327b:	89 15 58 3c 11 80    	mov    %edx,0x80113c58
80103281:	5a                   	pop    %edx
80103282:	50                   	push   %eax
80103283:	53                   	push   %ebx
80103284:	e8 47 ce ff ff       	call   801000d0 <bread>
80103289:	83 c4 10             	add    $0x10,%esp
8010328c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010328f:	89 0d 68 3c 11 80    	mov    %ecx,0x80113c68
80103295:	85 c9                	test   %ecx,%ecx
80103297:	7e 19                	jle    801032b2 <initlog+0x72>
80103299:	31 d2                	xor    %edx,%edx
8010329b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010329f:	90                   	nop
801032a0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
801032a4:	89 1c 95 6c 3c 11 80 	mov    %ebx,-0x7feec394(,%edx,4)
801032ab:	83 c2 01             	add    $0x1,%edx
801032ae:	39 d1                	cmp    %edx,%ecx
801032b0:	75 ee                	jne    801032a0 <initlog+0x60>
801032b2:	83 ec 0c             	sub    $0xc,%esp
801032b5:	50                   	push   %eax
801032b6:	e8 35 cf ff ff       	call   801001f0 <brelse>
801032bb:	e8 80 fe ff ff       	call   80103140 <install_trans>
801032c0:	c7 05 68 3c 11 80 00 	movl   $0x0,0x80113c68
801032c7:	00 00 00 
801032ca:	e8 11 ff ff ff       	call   801031e0 <write_head>
801032cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032d2:	83 c4 10             	add    $0x10,%esp
801032d5:	c9                   	leave  
801032d6:	c3                   	ret    
801032d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032de:	66 90                	xchg   %ax,%ax

801032e0 <begin_op>:
801032e0:	f3 0f 1e fb          	endbr32 
801032e4:	55                   	push   %ebp
801032e5:	89 e5                	mov    %esp,%ebp
801032e7:	83 ec 14             	sub    $0x14,%esp
801032ea:	68 20 3c 11 80       	push   $0x80113c20
801032ef:	e8 1c 18 00 00       	call   80104b10 <acquire>
801032f4:	83 c4 10             	add    $0x10,%esp
801032f7:	eb 1c                	jmp    80103315 <begin_op+0x35>
801032f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103300:	83 ec 08             	sub    $0x8,%esp
80103303:	68 20 3c 11 80       	push   $0x80113c20
80103308:	68 20 3c 11 80       	push   $0x80113c20
8010330d:	e8 be 11 00 00       	call   801044d0 <sleep>
80103312:	83 c4 10             	add    $0x10,%esp
80103315:	a1 60 3c 11 80       	mov    0x80113c60,%eax
8010331a:	85 c0                	test   %eax,%eax
8010331c:	75 e2                	jne    80103300 <begin_op+0x20>
8010331e:	a1 5c 3c 11 80       	mov    0x80113c5c,%eax
80103323:	8b 15 68 3c 11 80    	mov    0x80113c68,%edx
80103329:	83 c0 01             	add    $0x1,%eax
8010332c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010332f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103332:	83 fa 1e             	cmp    $0x1e,%edx
80103335:	7f c9                	jg     80103300 <begin_op+0x20>
80103337:	83 ec 0c             	sub    $0xc,%esp
8010333a:	a3 5c 3c 11 80       	mov    %eax,0x80113c5c
8010333f:	68 20 3c 11 80       	push   $0x80113c20
80103344:	e8 87 18 00 00       	call   80104bd0 <release>
80103349:	83 c4 10             	add    $0x10,%esp
8010334c:	c9                   	leave  
8010334d:	c3                   	ret    
8010334e:	66 90                	xchg   %ax,%ax

80103350 <end_op>:
80103350:	f3 0f 1e fb          	endbr32 
80103354:	55                   	push   %ebp
80103355:	89 e5                	mov    %esp,%ebp
80103357:	57                   	push   %edi
80103358:	56                   	push   %esi
80103359:	53                   	push   %ebx
8010335a:	83 ec 18             	sub    $0x18,%esp
8010335d:	68 20 3c 11 80       	push   $0x80113c20
80103362:	e8 a9 17 00 00       	call   80104b10 <acquire>
80103367:	a1 5c 3c 11 80       	mov    0x80113c5c,%eax
8010336c:	8b 35 60 3c 11 80    	mov    0x80113c60,%esi
80103372:	83 c4 10             	add    $0x10,%esp
80103375:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103378:	89 1d 5c 3c 11 80    	mov    %ebx,0x80113c5c
8010337e:	85 f6                	test   %esi,%esi
80103380:	0f 85 1e 01 00 00    	jne    801034a4 <end_op+0x154>
80103386:	85 db                	test   %ebx,%ebx
80103388:	0f 85 f2 00 00 00    	jne    80103480 <end_op+0x130>
8010338e:	c7 05 60 3c 11 80 01 	movl   $0x1,0x80113c60
80103395:	00 00 00 
80103398:	83 ec 0c             	sub    $0xc,%esp
8010339b:	68 20 3c 11 80       	push   $0x80113c20
801033a0:	e8 2b 18 00 00       	call   80104bd0 <release>
801033a5:	8b 0d 68 3c 11 80    	mov    0x80113c68,%ecx
801033ab:	83 c4 10             	add    $0x10,%esp
801033ae:	85 c9                	test   %ecx,%ecx
801033b0:	7f 3e                	jg     801033f0 <end_op+0xa0>
801033b2:	83 ec 0c             	sub    $0xc,%esp
801033b5:	68 20 3c 11 80       	push   $0x80113c20
801033ba:	e8 51 17 00 00       	call   80104b10 <acquire>
801033bf:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
801033c6:	c7 05 60 3c 11 80 00 	movl   $0x0,0x80113c60
801033cd:	00 00 00 
801033d0:	e8 bb 12 00 00       	call   80104690 <wakeup>
801033d5:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
801033dc:	e8 ef 17 00 00       	call   80104bd0 <release>
801033e1:	83 c4 10             	add    $0x10,%esp
801033e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033e7:	5b                   	pop    %ebx
801033e8:	5e                   	pop    %esi
801033e9:	5f                   	pop    %edi
801033ea:	5d                   	pop    %ebp
801033eb:	c3                   	ret    
801033ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033f0:	a1 54 3c 11 80       	mov    0x80113c54,%eax
801033f5:	83 ec 08             	sub    $0x8,%esp
801033f8:	01 d8                	add    %ebx,%eax
801033fa:	83 c0 01             	add    $0x1,%eax
801033fd:	50                   	push   %eax
801033fe:	ff 35 64 3c 11 80    	pushl  0x80113c64
80103404:	e8 c7 cc ff ff       	call   801000d0 <bread>
80103409:	89 c6                	mov    %eax,%esi
8010340b:	58                   	pop    %eax
8010340c:	5a                   	pop    %edx
8010340d:	ff 34 9d 6c 3c 11 80 	pushl  -0x7feec394(,%ebx,4)
80103414:	ff 35 64 3c 11 80    	pushl  0x80113c64
8010341a:	83 c3 01             	add    $0x1,%ebx
8010341d:	e8 ae cc ff ff       	call   801000d0 <bread>
80103422:	83 c4 0c             	add    $0xc,%esp
80103425:	89 c7                	mov    %eax,%edi
80103427:	8d 40 5c             	lea    0x5c(%eax),%eax
8010342a:	68 00 02 00 00       	push   $0x200
8010342f:	50                   	push   %eax
80103430:	8d 46 5c             	lea    0x5c(%esi),%eax
80103433:	50                   	push   %eax
80103434:	e8 87 18 00 00       	call   80104cc0 <memmove>
80103439:	89 34 24             	mov    %esi,(%esp)
8010343c:	e8 6f cd ff ff       	call   801001b0 <bwrite>
80103441:	89 3c 24             	mov    %edi,(%esp)
80103444:	e8 a7 cd ff ff       	call   801001f0 <brelse>
80103449:	89 34 24             	mov    %esi,(%esp)
8010344c:	e8 9f cd ff ff       	call   801001f0 <brelse>
80103451:	83 c4 10             	add    $0x10,%esp
80103454:	3b 1d 68 3c 11 80    	cmp    0x80113c68,%ebx
8010345a:	7c 94                	jl     801033f0 <end_op+0xa0>
8010345c:	e8 7f fd ff ff       	call   801031e0 <write_head>
80103461:	e8 da fc ff ff       	call   80103140 <install_trans>
80103466:	c7 05 68 3c 11 80 00 	movl   $0x0,0x80113c68
8010346d:	00 00 00 
80103470:	e8 6b fd ff ff       	call   801031e0 <write_head>
80103475:	e9 38 ff ff ff       	jmp    801033b2 <end_op+0x62>
8010347a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103480:	83 ec 0c             	sub    $0xc,%esp
80103483:	68 20 3c 11 80       	push   $0x80113c20
80103488:	e8 03 12 00 00       	call   80104690 <wakeup>
8010348d:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80103494:	e8 37 17 00 00       	call   80104bd0 <release>
80103499:	83 c4 10             	add    $0x10,%esp
8010349c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010349f:	5b                   	pop    %ebx
801034a0:	5e                   	pop    %esi
801034a1:	5f                   	pop    %edi
801034a2:	5d                   	pop    %ebp
801034a3:	c3                   	ret    
801034a4:	83 ec 0c             	sub    $0xc,%esp
801034a7:	68 a4 7b 10 80       	push   $0x80107ba4
801034ac:	e8 df ce ff ff       	call   80100390 <panic>
801034b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034bf:	90                   	nop

801034c0 <log_write>:
801034c0:	f3 0f 1e fb          	endbr32 
801034c4:	55                   	push   %ebp
801034c5:	89 e5                	mov    %esp,%ebp
801034c7:	53                   	push   %ebx
801034c8:	83 ec 04             	sub    $0x4,%esp
801034cb:	8b 15 68 3c 11 80    	mov    0x80113c68,%edx
801034d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034d4:	83 fa 1d             	cmp    $0x1d,%edx
801034d7:	0f 8f 91 00 00 00    	jg     8010356e <log_write+0xae>
801034dd:	a1 58 3c 11 80       	mov    0x80113c58,%eax
801034e2:	83 e8 01             	sub    $0x1,%eax
801034e5:	39 c2                	cmp    %eax,%edx
801034e7:	0f 8d 81 00 00 00    	jge    8010356e <log_write+0xae>
801034ed:	a1 5c 3c 11 80       	mov    0x80113c5c,%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	0f 8e 81 00 00 00    	jle    8010357b <log_write+0xbb>
801034fa:	83 ec 0c             	sub    $0xc,%esp
801034fd:	68 20 3c 11 80       	push   $0x80113c20
80103502:	e8 09 16 00 00       	call   80104b10 <acquire>
80103507:	8b 15 68 3c 11 80    	mov    0x80113c68,%edx
8010350d:	83 c4 10             	add    $0x10,%esp
80103510:	85 d2                	test   %edx,%edx
80103512:	7e 4e                	jle    80103562 <log_write+0xa2>
80103514:	8b 4b 08             	mov    0x8(%ebx),%ecx
80103517:	31 c0                	xor    %eax,%eax
80103519:	eb 0c                	jmp    80103527 <log_write+0x67>
8010351b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010351f:	90                   	nop
80103520:	83 c0 01             	add    $0x1,%eax
80103523:	39 c2                	cmp    %eax,%edx
80103525:	74 29                	je     80103550 <log_write+0x90>
80103527:	39 0c 85 6c 3c 11 80 	cmp    %ecx,-0x7feec394(,%eax,4)
8010352e:	75 f0                	jne    80103520 <log_write+0x60>
80103530:	89 0c 85 6c 3c 11 80 	mov    %ecx,-0x7feec394(,%eax,4)
80103537:	83 0b 04             	orl    $0x4,(%ebx)
8010353a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010353d:	c7 45 08 20 3c 11 80 	movl   $0x80113c20,0x8(%ebp)
80103544:	c9                   	leave  
80103545:	e9 86 16 00 00       	jmp    80104bd0 <release>
8010354a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103550:	89 0c 95 6c 3c 11 80 	mov    %ecx,-0x7feec394(,%edx,4)
80103557:	83 c2 01             	add    $0x1,%edx
8010355a:	89 15 68 3c 11 80    	mov    %edx,0x80113c68
80103560:	eb d5                	jmp    80103537 <log_write+0x77>
80103562:	8b 43 08             	mov    0x8(%ebx),%eax
80103565:	a3 6c 3c 11 80       	mov    %eax,0x80113c6c
8010356a:	75 cb                	jne    80103537 <log_write+0x77>
8010356c:	eb e9                	jmp    80103557 <log_write+0x97>
8010356e:	83 ec 0c             	sub    $0xc,%esp
80103571:	68 b3 7b 10 80       	push   $0x80107bb3
80103576:	e8 15 ce ff ff       	call   80100390 <panic>
8010357b:	83 ec 0c             	sub    $0xc,%esp
8010357e:	68 c9 7b 10 80       	push   $0x80107bc9
80103583:	e8 08 ce ff ff       	call   80100390 <panic>
80103588:	66 90                	xchg   %ax,%ax
8010358a:	66 90                	xchg   %ax,%ax
8010358c:	66 90                	xchg   %ax,%ax
8010358e:	66 90                	xchg   %ax,%ax

80103590 <mpmain>:
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	53                   	push   %ebx
80103594:	83 ec 04             	sub    $0x4,%esp
80103597:	e8 54 09 00 00       	call   80103ef0 <cpuid>
8010359c:	89 c3                	mov    %eax,%ebx
8010359e:	e8 4d 09 00 00       	call   80103ef0 <cpuid>
801035a3:	83 ec 04             	sub    $0x4,%esp
801035a6:	53                   	push   %ebx
801035a7:	50                   	push   %eax
801035a8:	68 e4 7b 10 80       	push   $0x80107be4
801035ad:	e8 ce d3 ff ff       	call   80100980 <cprintf>
801035b2:	e8 19 29 00 00       	call   80105ed0 <idtinit>
801035b7:	e8 c4 08 00 00       	call   80103e80 <mycpu>
801035bc:	89 c2                	mov    %eax,%edx
801035be:	b8 01 00 00 00       	mov    $0x1,%eax
801035c3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
801035ca:	e8 11 0c 00 00       	call   801041e0 <scheduler>
801035cf:	90                   	nop

801035d0 <mpenter>:
801035d0:	f3 0f 1e fb          	endbr32 
801035d4:	55                   	push   %ebp
801035d5:	89 e5                	mov    %esp,%ebp
801035d7:	83 ec 08             	sub    $0x8,%esp
801035da:	e8 c1 39 00 00       	call   80106fa0 <switchkvm>
801035df:	e8 2c 39 00 00       	call   80106f10 <seginit>
801035e4:	e8 67 f7 ff ff       	call   80102d50 <lapicinit>
801035e9:	e8 a2 ff ff ff       	call   80103590 <mpmain>
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <main>:
801035f0:	f3 0f 1e fb          	endbr32 
801035f4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801035f8:	83 e4 f0             	and    $0xfffffff0,%esp
801035fb:	ff 71 fc             	pushl  -0x4(%ecx)
801035fe:	55                   	push   %ebp
801035ff:	89 e5                	mov    %esp,%ebp
80103601:	53                   	push   %ebx
80103602:	51                   	push   %ecx
80103603:	83 ec 08             	sub    $0x8,%esp
80103606:	68 00 00 40 80       	push   $0x80400000
8010360b:	68 48 6a 11 80       	push   $0x80116a48
80103610:	e8 fb f4 ff ff       	call   80102b10 <kinit1>
80103615:	e8 66 3e 00 00       	call   80107480 <kvmalloc>
8010361a:	e8 81 01 00 00       	call   801037a0 <mpinit>
8010361f:	e8 2c f7 ff ff       	call   80102d50 <lapicinit>
80103624:	e8 e7 38 00 00       	call   80106f10 <seginit>
80103629:	e8 52 03 00 00       	call   80103980 <picinit>
8010362e:	e8 fd f2 ff ff       	call   80102930 <ioapicinit>
80103633:	e8 a8 d9 ff ff       	call   80100fe0 <consoleinit>
80103638:	e8 93 2b 00 00       	call   801061d0 <uartinit>
8010363d:	e8 1e 08 00 00       	call   80103e60 <pinit>
80103642:	e8 09 28 00 00       	call   80105e50 <tvinit>
80103647:	e8 f4 c9 ff ff       	call   80100040 <binit>
8010364c:	e8 3f dd ff ff       	call   80101390 <fileinit>
80103651:	e8 aa f0 ff ff       	call   80102700 <ideinit>
80103656:	83 c4 0c             	add    $0xc,%esp
80103659:	68 8a 00 00 00       	push   $0x8a
8010365e:	68 8c b4 10 80       	push   $0x8010b48c
80103663:	68 00 70 00 80       	push   $0x80007000
80103668:	e8 53 16 00 00       	call   80104cc0 <memmove>
8010366d:	83 c4 10             	add    $0x10,%esp
80103670:	69 05 a0 42 11 80 b0 	imul   $0xb0,0x801142a0,%eax
80103677:	00 00 00 
8010367a:	05 20 3d 11 80       	add    $0x80113d20,%eax
8010367f:	3d 20 3d 11 80       	cmp    $0x80113d20,%eax
80103684:	76 7a                	jbe    80103700 <main+0x110>
80103686:	bb 20 3d 11 80       	mov    $0x80113d20,%ebx
8010368b:	eb 1c                	jmp    801036a9 <main+0xb9>
8010368d:	8d 76 00             	lea    0x0(%esi),%esi
80103690:	69 05 a0 42 11 80 b0 	imul   $0xb0,0x801142a0,%eax
80103697:	00 00 00 
8010369a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801036a0:	05 20 3d 11 80       	add    $0x80113d20,%eax
801036a5:	39 c3                	cmp    %eax,%ebx
801036a7:	73 57                	jae    80103700 <main+0x110>
801036a9:	e8 d2 07 00 00       	call   80103e80 <mycpu>
801036ae:	39 c3                	cmp    %eax,%ebx
801036b0:	74 de                	je     80103690 <main+0xa0>
801036b2:	e8 29 f5 ff ff       	call   80102be0 <kalloc>
801036b7:	83 ec 08             	sub    $0x8,%esp
801036ba:	c7 05 f8 6f 00 80 d0 	movl   $0x801035d0,0x80006ff8
801036c1:	35 10 80 
801036c4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801036cb:	a0 10 00 
801036ce:	05 00 10 00 00       	add    $0x1000,%eax
801036d3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
801036d8:	0f b6 03             	movzbl (%ebx),%eax
801036db:	68 00 70 00 00       	push   $0x7000
801036e0:	50                   	push   %eax
801036e1:	e8 ba f7 ff ff       	call   80102ea0 <lapicstartap>
801036e6:	83 c4 10             	add    $0x10,%esp
801036e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036f0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801036f6:	85 c0                	test   %eax,%eax
801036f8:	74 f6                	je     801036f0 <main+0x100>
801036fa:	eb 94                	jmp    80103690 <main+0xa0>
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103700:	83 ec 08             	sub    $0x8,%esp
80103703:	68 00 00 00 8e       	push   $0x8e000000
80103708:	68 00 00 40 80       	push   $0x80400000
8010370d:	e8 6e f4 ff ff       	call   80102b80 <kinit2>
80103712:	e8 29 08 00 00       	call   80103f40 <userinit>
80103717:	e8 74 fe ff ff       	call   80103590 <mpmain>
8010371c:	66 90                	xchg   %ax,%ax
8010371e:	66 90                	xchg   %ax,%ax

80103720 <mpsearch1>:
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	57                   	push   %edi
80103724:	56                   	push   %esi
80103725:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
8010372b:	53                   	push   %ebx
8010372c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
8010372f:	83 ec 0c             	sub    $0xc,%esp
80103732:	39 de                	cmp    %ebx,%esi
80103734:	72 10                	jb     80103746 <mpsearch1+0x26>
80103736:	eb 50                	jmp    80103788 <mpsearch1+0x68>
80103738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010373f:	90                   	nop
80103740:	89 fe                	mov    %edi,%esi
80103742:	39 fb                	cmp    %edi,%ebx
80103744:	76 42                	jbe    80103788 <mpsearch1+0x68>
80103746:	83 ec 04             	sub    $0x4,%esp
80103749:	8d 7e 10             	lea    0x10(%esi),%edi
8010374c:	6a 04                	push   $0x4
8010374e:	68 f8 7b 10 80       	push   $0x80107bf8
80103753:	56                   	push   %esi
80103754:	e8 17 15 00 00       	call   80104c70 <memcmp>
80103759:	83 c4 10             	add    $0x10,%esp
8010375c:	85 c0                	test   %eax,%eax
8010375e:	75 e0                	jne    80103740 <mpsearch1+0x20>
80103760:	89 f2                	mov    %esi,%edx
80103762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103768:	0f b6 0a             	movzbl (%edx),%ecx
8010376b:	83 c2 01             	add    $0x1,%edx
8010376e:	01 c8                	add    %ecx,%eax
80103770:	39 fa                	cmp    %edi,%edx
80103772:	75 f4                	jne    80103768 <mpsearch1+0x48>
80103774:	84 c0                	test   %al,%al
80103776:	75 c8                	jne    80103740 <mpsearch1+0x20>
80103778:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010377b:	89 f0                	mov    %esi,%eax
8010377d:	5b                   	pop    %ebx
8010377e:	5e                   	pop    %esi
8010377f:	5f                   	pop    %edi
80103780:	5d                   	pop    %ebp
80103781:	c3                   	ret    
80103782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103788:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010378b:	31 f6                	xor    %esi,%esi
8010378d:	5b                   	pop    %ebx
8010378e:	89 f0                	mov    %esi,%eax
80103790:	5e                   	pop    %esi
80103791:	5f                   	pop    %edi
80103792:	5d                   	pop    %ebp
80103793:	c3                   	ret    
80103794:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010379b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010379f:	90                   	nop

801037a0 <mpinit>:
801037a0:	f3 0f 1e fb          	endbr32 
801037a4:	55                   	push   %ebp
801037a5:	89 e5                	mov    %esp,%ebp
801037a7:	57                   	push   %edi
801037a8:	56                   	push   %esi
801037a9:	53                   	push   %ebx
801037aa:	83 ec 1c             	sub    $0x1c,%esp
801037ad:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801037b4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801037bb:	c1 e0 08             	shl    $0x8,%eax
801037be:	09 d0                	or     %edx,%eax
801037c0:	c1 e0 04             	shl    $0x4,%eax
801037c3:	75 1b                	jne    801037e0 <mpinit+0x40>
801037c5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801037cc:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801037d3:	c1 e0 08             	shl    $0x8,%eax
801037d6:	09 d0                	or     %edx,%eax
801037d8:	c1 e0 0a             	shl    $0xa,%eax
801037db:	2d 00 04 00 00       	sub    $0x400,%eax
801037e0:	ba 00 04 00 00       	mov    $0x400,%edx
801037e5:	e8 36 ff ff ff       	call   80103720 <mpsearch1>
801037ea:	89 c6                	mov    %eax,%esi
801037ec:	85 c0                	test   %eax,%eax
801037ee:	0f 84 4c 01 00 00    	je     80103940 <mpinit+0x1a0>
801037f4:	8b 5e 04             	mov    0x4(%esi),%ebx
801037f7:	85 db                	test   %ebx,%ebx
801037f9:	0f 84 61 01 00 00    	je     80103960 <mpinit+0x1c0>
801037ff:	83 ec 04             	sub    $0x4,%esp
80103802:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80103808:	6a 04                	push   $0x4
8010380a:	68 fd 7b 10 80       	push   $0x80107bfd
8010380f:	50                   	push   %eax
80103810:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103813:	e8 58 14 00 00       	call   80104c70 <memcmp>
80103818:	83 c4 10             	add    $0x10,%esp
8010381b:	85 c0                	test   %eax,%eax
8010381d:	0f 85 3d 01 00 00    	jne    80103960 <mpinit+0x1c0>
80103823:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010382a:	3c 01                	cmp    $0x1,%al
8010382c:	74 08                	je     80103836 <mpinit+0x96>
8010382e:	3c 04                	cmp    $0x4,%al
80103830:	0f 85 2a 01 00 00    	jne    80103960 <mpinit+0x1c0>
80103836:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010383d:	66 85 d2             	test   %dx,%dx
80103840:	74 26                	je     80103868 <mpinit+0xc8>
80103842:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103845:	89 d8                	mov    %ebx,%eax
80103847:	31 d2                	xor    %edx,%edx
80103849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103850:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103857:	83 c0 01             	add    $0x1,%eax
8010385a:	01 ca                	add    %ecx,%edx
8010385c:	39 f8                	cmp    %edi,%eax
8010385e:	75 f0                	jne    80103850 <mpinit+0xb0>
80103860:	84 d2                	test   %dl,%dl
80103862:	0f 85 f8 00 00 00    	jne    80103960 <mpinit+0x1c0>
80103868:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010386e:	a3 1c 3c 11 80       	mov    %eax,0x80113c1c
80103873:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103879:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103880:	bb 01 00 00 00       	mov    $0x1,%ebx
80103885:	03 55 e4             	add    -0x1c(%ebp),%edx
80103888:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010388b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010388f:	90                   	nop
80103890:	39 c2                	cmp    %eax,%edx
80103892:	76 15                	jbe    801038a9 <mpinit+0x109>
80103894:	0f b6 08             	movzbl (%eax),%ecx
80103897:	80 f9 02             	cmp    $0x2,%cl
8010389a:	74 5c                	je     801038f8 <mpinit+0x158>
8010389c:	77 42                	ja     801038e0 <mpinit+0x140>
8010389e:	84 c9                	test   %cl,%cl
801038a0:	74 6e                	je     80103910 <mpinit+0x170>
801038a2:	83 c0 08             	add    $0x8,%eax
801038a5:	39 c2                	cmp    %eax,%edx
801038a7:	77 eb                	ja     80103894 <mpinit+0xf4>
801038a9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801038ac:	85 db                	test   %ebx,%ebx
801038ae:	0f 84 b9 00 00 00    	je     8010396d <mpinit+0x1cd>
801038b4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
801038b8:	74 15                	je     801038cf <mpinit+0x12f>
801038ba:	b8 70 00 00 00       	mov    $0x70,%eax
801038bf:	ba 22 00 00 00       	mov    $0x22,%edx
801038c4:	ee                   	out    %al,(%dx)
801038c5:	ba 23 00 00 00       	mov    $0x23,%edx
801038ca:	ec                   	in     (%dx),%al
801038cb:	83 c8 01             	or     $0x1,%eax
801038ce:	ee                   	out    %al,(%dx)
801038cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038d2:	5b                   	pop    %ebx
801038d3:	5e                   	pop    %esi
801038d4:	5f                   	pop    %edi
801038d5:	5d                   	pop    %ebp
801038d6:	c3                   	ret    
801038d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038de:	66 90                	xchg   %ax,%ax
801038e0:	83 e9 03             	sub    $0x3,%ecx
801038e3:	80 f9 01             	cmp    $0x1,%cl
801038e6:	76 ba                	jbe    801038a2 <mpinit+0x102>
801038e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801038ef:	eb 9f                	jmp    80103890 <mpinit+0xf0>
801038f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038f8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801038fc:	83 c0 08             	add    $0x8,%eax
801038ff:	88 0d 00 3d 11 80    	mov    %cl,0x80113d00
80103905:	eb 89                	jmp    80103890 <mpinit+0xf0>
80103907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010390e:	66 90                	xchg   %ax,%ax
80103910:	8b 0d a0 42 11 80    	mov    0x801142a0,%ecx
80103916:	83 f9 07             	cmp    $0x7,%ecx
80103919:	7f 19                	jg     80103934 <mpinit+0x194>
8010391b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103921:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
80103925:	83 c1 01             	add    $0x1,%ecx
80103928:	89 0d a0 42 11 80    	mov    %ecx,0x801142a0
8010392e:	88 9f 20 3d 11 80    	mov    %bl,-0x7feec2e0(%edi)
80103934:	83 c0 14             	add    $0x14,%eax
80103937:	e9 54 ff ff ff       	jmp    80103890 <mpinit+0xf0>
8010393c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103940:	ba 00 00 01 00       	mov    $0x10000,%edx
80103945:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010394a:	e8 d1 fd ff ff       	call   80103720 <mpsearch1>
8010394f:	89 c6                	mov    %eax,%esi
80103951:	85 c0                	test   %eax,%eax
80103953:	0f 85 9b fe ff ff    	jne    801037f4 <mpinit+0x54>
80103959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103960:	83 ec 0c             	sub    $0xc,%esp
80103963:	68 02 7c 10 80       	push   $0x80107c02
80103968:	e8 23 ca ff ff       	call   80100390 <panic>
8010396d:	83 ec 0c             	sub    $0xc,%esp
80103970:	68 1c 7c 10 80       	push   $0x80107c1c
80103975:	e8 16 ca ff ff       	call   80100390 <panic>
8010397a:	66 90                	xchg   %ax,%ax
8010397c:	66 90                	xchg   %ax,%ax
8010397e:	66 90                	xchg   %ax,%ax

80103980 <picinit>:
80103980:	f3 0f 1e fb          	endbr32 
80103984:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103989:	ba 21 00 00 00       	mov    $0x21,%edx
8010398e:	ee                   	out    %al,(%dx)
8010398f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103994:	ee                   	out    %al,(%dx)
80103995:	c3                   	ret    
80103996:	66 90                	xchg   %ax,%ax
80103998:	66 90                	xchg   %ax,%ax
8010399a:	66 90                	xchg   %ax,%ax
8010399c:	66 90                	xchg   %ax,%ax
8010399e:	66 90                	xchg   %ax,%ax

801039a0 <pipealloc>:
801039a0:	f3 0f 1e fb          	endbr32 
801039a4:	55                   	push   %ebp
801039a5:	89 e5                	mov    %esp,%ebp
801039a7:	57                   	push   %edi
801039a8:	56                   	push   %esi
801039a9:	53                   	push   %ebx
801039aa:	83 ec 0c             	sub    $0xc,%esp
801039ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
801039b0:	8b 75 0c             	mov    0xc(%ebp),%esi
801039b3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801039b9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801039bf:	e8 ec d9 ff ff       	call   801013b0 <filealloc>
801039c4:	89 03                	mov    %eax,(%ebx)
801039c6:	85 c0                	test   %eax,%eax
801039c8:	0f 84 ac 00 00 00    	je     80103a7a <pipealloc+0xda>
801039ce:	e8 dd d9 ff ff       	call   801013b0 <filealloc>
801039d3:	89 06                	mov    %eax,(%esi)
801039d5:	85 c0                	test   %eax,%eax
801039d7:	0f 84 8b 00 00 00    	je     80103a68 <pipealloc+0xc8>
801039dd:	e8 fe f1 ff ff       	call   80102be0 <kalloc>
801039e2:	89 c7                	mov    %eax,%edi
801039e4:	85 c0                	test   %eax,%eax
801039e6:	0f 84 b4 00 00 00    	je     80103aa0 <pipealloc+0x100>
801039ec:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801039f3:	00 00 00 
801039f6:	83 ec 08             	sub    $0x8,%esp
801039f9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103a00:	00 00 00 
80103a03:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103a0a:	00 00 00 
80103a0d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103a14:	00 00 00 
80103a17:	68 3b 7c 10 80       	push   $0x80107c3b
80103a1c:	50                   	push   %eax
80103a1d:	e8 6e 0f 00 00       	call   80104990 <initlock>
80103a22:	8b 03                	mov    (%ebx),%eax
80103a24:	83 c4 10             	add    $0x10,%esp
80103a27:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103a2d:	8b 03                	mov    (%ebx),%eax
80103a2f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
80103a33:	8b 03                	mov    (%ebx),%eax
80103a35:	c6 40 09 00          	movb   $0x0,0x9(%eax)
80103a39:	8b 03                	mov    (%ebx),%eax
80103a3b:	89 78 0c             	mov    %edi,0xc(%eax)
80103a3e:	8b 06                	mov    (%esi),%eax
80103a40:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103a46:	8b 06                	mov    (%esi),%eax
80103a48:	c6 40 08 00          	movb   $0x0,0x8(%eax)
80103a4c:	8b 06                	mov    (%esi),%eax
80103a4e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
80103a52:	8b 06                	mov    (%esi),%eax
80103a54:	89 78 0c             	mov    %edi,0xc(%eax)
80103a57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a5a:	31 c0                	xor    %eax,%eax
80103a5c:	5b                   	pop    %ebx
80103a5d:	5e                   	pop    %esi
80103a5e:	5f                   	pop    %edi
80103a5f:	5d                   	pop    %ebp
80103a60:	c3                   	ret    
80103a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a68:	8b 03                	mov    (%ebx),%eax
80103a6a:	85 c0                	test   %eax,%eax
80103a6c:	74 1e                	je     80103a8c <pipealloc+0xec>
80103a6e:	83 ec 0c             	sub    $0xc,%esp
80103a71:	50                   	push   %eax
80103a72:	e8 f9 d9 ff ff       	call   80101470 <fileclose>
80103a77:	83 c4 10             	add    $0x10,%esp
80103a7a:	8b 06                	mov    (%esi),%eax
80103a7c:	85 c0                	test   %eax,%eax
80103a7e:	74 0c                	je     80103a8c <pipealloc+0xec>
80103a80:	83 ec 0c             	sub    $0xc,%esp
80103a83:	50                   	push   %eax
80103a84:	e8 e7 d9 ff ff       	call   80101470 <fileclose>
80103a89:	83 c4 10             	add    $0x10,%esp
80103a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a94:	5b                   	pop    %ebx
80103a95:	5e                   	pop    %esi
80103a96:	5f                   	pop    %edi
80103a97:	5d                   	pop    %ebp
80103a98:	c3                   	ret    
80103a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aa0:	8b 03                	mov    (%ebx),%eax
80103aa2:	85 c0                	test   %eax,%eax
80103aa4:	75 c8                	jne    80103a6e <pipealloc+0xce>
80103aa6:	eb d2                	jmp    80103a7a <pipealloc+0xda>
80103aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aaf:	90                   	nop

80103ab0 <pipeclose>:
80103ab0:	f3 0f 1e fb          	endbr32 
80103ab4:	55                   	push   %ebp
80103ab5:	89 e5                	mov    %esp,%ebp
80103ab7:	56                   	push   %esi
80103ab8:	53                   	push   %ebx
80103ab9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103abc:	8b 75 0c             	mov    0xc(%ebp),%esi
80103abf:	83 ec 0c             	sub    $0xc,%esp
80103ac2:	53                   	push   %ebx
80103ac3:	e8 48 10 00 00       	call   80104b10 <acquire>
80103ac8:	83 c4 10             	add    $0x10,%esp
80103acb:	85 f6                	test   %esi,%esi
80103acd:	74 41                	je     80103b10 <pipeclose+0x60>
80103acf:	83 ec 0c             	sub    $0xc,%esp
80103ad2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103ad8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103adf:	00 00 00 
80103ae2:	50                   	push   %eax
80103ae3:	e8 a8 0b 00 00       	call   80104690 <wakeup>
80103ae8:	83 c4 10             	add    $0x10,%esp
80103aeb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103af1:	85 d2                	test   %edx,%edx
80103af3:	75 0a                	jne    80103aff <pipeclose+0x4f>
80103af5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103afb:	85 c0                	test   %eax,%eax
80103afd:	74 31                	je     80103b30 <pipeclose+0x80>
80103aff:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b05:	5b                   	pop    %ebx
80103b06:	5e                   	pop    %esi
80103b07:	5d                   	pop    %ebp
80103b08:	e9 c3 10 00 00       	jmp    80104bd0 <release>
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
80103b10:	83 ec 0c             	sub    $0xc,%esp
80103b13:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103b19:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103b20:	00 00 00 
80103b23:	50                   	push   %eax
80103b24:	e8 67 0b 00 00       	call   80104690 <wakeup>
80103b29:	83 c4 10             	add    $0x10,%esp
80103b2c:	eb bd                	jmp    80103aeb <pipeclose+0x3b>
80103b2e:	66 90                	xchg   %ax,%ax
80103b30:	83 ec 0c             	sub    $0xc,%esp
80103b33:	53                   	push   %ebx
80103b34:	e8 97 10 00 00       	call   80104bd0 <release>
80103b39:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103b3c:	83 c4 10             	add    $0x10,%esp
80103b3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b42:	5b                   	pop    %ebx
80103b43:	5e                   	pop    %esi
80103b44:	5d                   	pop    %ebp
80103b45:	e9 d6 ee ff ff       	jmp    80102a20 <kfree>
80103b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b50 <pipewrite>:
80103b50:	f3 0f 1e fb          	endbr32 
80103b54:	55                   	push   %ebp
80103b55:	89 e5                	mov    %esp,%ebp
80103b57:	57                   	push   %edi
80103b58:	56                   	push   %esi
80103b59:	53                   	push   %ebx
80103b5a:	83 ec 28             	sub    $0x28,%esp
80103b5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b60:	53                   	push   %ebx
80103b61:	e8 aa 0f 00 00       	call   80104b10 <acquire>
80103b66:	8b 45 10             	mov    0x10(%ebp),%eax
80103b69:	83 c4 10             	add    $0x10,%esp
80103b6c:	85 c0                	test   %eax,%eax
80103b6e:	0f 8e bc 00 00 00    	jle    80103c30 <pipewrite+0xe0>
80103b74:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b77:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
80103b7d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103b83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b86:	03 45 10             	add    0x10(%ebp),%eax
80103b89:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103b8c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103b92:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103b98:	89 ca                	mov    %ecx,%edx
80103b9a:	05 00 02 00 00       	add    $0x200,%eax
80103b9f:	39 c1                	cmp    %eax,%ecx
80103ba1:	74 3b                	je     80103bde <pipewrite+0x8e>
80103ba3:	eb 63                	jmp    80103c08 <pipewrite+0xb8>
80103ba5:	8d 76 00             	lea    0x0(%esi),%esi
80103ba8:	e8 63 03 00 00       	call   80103f10 <myproc>
80103bad:	8b 48 24             	mov    0x24(%eax),%ecx
80103bb0:	85 c9                	test   %ecx,%ecx
80103bb2:	75 34                	jne    80103be8 <pipewrite+0x98>
80103bb4:	83 ec 0c             	sub    $0xc,%esp
80103bb7:	57                   	push   %edi
80103bb8:	e8 d3 0a 00 00       	call   80104690 <wakeup>
80103bbd:	58                   	pop    %eax
80103bbe:	5a                   	pop    %edx
80103bbf:	53                   	push   %ebx
80103bc0:	56                   	push   %esi
80103bc1:	e8 0a 09 00 00       	call   801044d0 <sleep>
80103bc6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103bcc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103bd2:	83 c4 10             	add    $0x10,%esp
80103bd5:	05 00 02 00 00       	add    $0x200,%eax
80103bda:	39 c2                	cmp    %eax,%edx
80103bdc:	75 2a                	jne    80103c08 <pipewrite+0xb8>
80103bde:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103be4:	85 c0                	test   %eax,%eax
80103be6:	75 c0                	jne    80103ba8 <pipewrite+0x58>
80103be8:	83 ec 0c             	sub    $0xc,%esp
80103beb:	53                   	push   %ebx
80103bec:	e8 df 0f 00 00       	call   80104bd0 <release>
80103bf1:	83 c4 10             	add    $0x10,%esp
80103bf4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bf9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bfc:	5b                   	pop    %ebx
80103bfd:	5e                   	pop    %esi
80103bfe:	5f                   	pop    %edi
80103bff:	5d                   	pop    %ebp
80103c00:	c3                   	ret    
80103c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c08:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103c0b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103c0e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103c14:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103c1a:	0f b6 06             	movzbl (%esi),%eax
80103c1d:	83 c6 01             	add    $0x1,%esi
80103c20:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103c23:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
80103c27:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103c2a:	0f 85 5c ff ff ff    	jne    80103b8c <pipewrite+0x3c>
80103c30:	83 ec 0c             	sub    $0xc,%esp
80103c33:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103c39:	50                   	push   %eax
80103c3a:	e8 51 0a 00 00       	call   80104690 <wakeup>
80103c3f:	89 1c 24             	mov    %ebx,(%esp)
80103c42:	e8 89 0f 00 00       	call   80104bd0 <release>
80103c47:	8b 45 10             	mov    0x10(%ebp),%eax
80103c4a:	83 c4 10             	add    $0x10,%esp
80103c4d:	eb aa                	jmp    80103bf9 <pipewrite+0xa9>
80103c4f:	90                   	nop

80103c50 <piperead>:
80103c50:	f3 0f 1e fb          	endbr32 
80103c54:	55                   	push   %ebp
80103c55:	89 e5                	mov    %esp,%ebp
80103c57:	57                   	push   %edi
80103c58:	56                   	push   %esi
80103c59:	53                   	push   %ebx
80103c5a:	83 ec 18             	sub    $0x18,%esp
80103c5d:	8b 75 08             	mov    0x8(%ebp),%esi
80103c60:	8b 7d 0c             	mov    0xc(%ebp),%edi
80103c63:	56                   	push   %esi
80103c64:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103c6a:	e8 a1 0e 00 00       	call   80104b10 <acquire>
80103c6f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103c75:	83 c4 10             	add    $0x10,%esp
80103c78:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103c7e:	74 33                	je     80103cb3 <piperead+0x63>
80103c80:	eb 3b                	jmp    80103cbd <piperead+0x6d>
80103c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c88:	e8 83 02 00 00       	call   80103f10 <myproc>
80103c8d:	8b 48 24             	mov    0x24(%eax),%ecx
80103c90:	85 c9                	test   %ecx,%ecx
80103c92:	0f 85 88 00 00 00    	jne    80103d20 <piperead+0xd0>
80103c98:	83 ec 08             	sub    $0x8,%esp
80103c9b:	56                   	push   %esi
80103c9c:	53                   	push   %ebx
80103c9d:	e8 2e 08 00 00       	call   801044d0 <sleep>
80103ca2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103ca8:	83 c4 10             	add    $0x10,%esp
80103cab:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103cb1:	75 0a                	jne    80103cbd <piperead+0x6d>
80103cb3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103cb9:	85 c0                	test   %eax,%eax
80103cbb:	75 cb                	jne    80103c88 <piperead+0x38>
80103cbd:	8b 55 10             	mov    0x10(%ebp),%edx
80103cc0:	31 db                	xor    %ebx,%ebx
80103cc2:	85 d2                	test   %edx,%edx
80103cc4:	7f 28                	jg     80103cee <piperead+0x9e>
80103cc6:	eb 34                	jmp    80103cfc <piperead+0xac>
80103cc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ccf:	90                   	nop
80103cd0:	8d 48 01             	lea    0x1(%eax),%ecx
80103cd3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103cd8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103cde:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103ce3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
80103ce6:	83 c3 01             	add    $0x1,%ebx
80103ce9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103cec:	74 0e                	je     80103cfc <piperead+0xac>
80103cee:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103cf4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103cfa:	75 d4                	jne    80103cd0 <piperead+0x80>
80103cfc:	83 ec 0c             	sub    $0xc,%esp
80103cff:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103d05:	50                   	push   %eax
80103d06:	e8 85 09 00 00       	call   80104690 <wakeup>
80103d0b:	89 34 24             	mov    %esi,(%esp)
80103d0e:	e8 bd 0e 00 00       	call   80104bd0 <release>
80103d13:	83 c4 10             	add    $0x10,%esp
80103d16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d19:	89 d8                	mov    %ebx,%eax
80103d1b:	5b                   	pop    %ebx
80103d1c:	5e                   	pop    %esi
80103d1d:	5f                   	pop    %edi
80103d1e:	5d                   	pop    %ebp
80103d1f:	c3                   	ret    
80103d20:	83 ec 0c             	sub    $0xc,%esp
80103d23:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d28:	56                   	push   %esi
80103d29:	e8 a2 0e 00 00       	call   80104bd0 <release>
80103d2e:	83 c4 10             	add    $0x10,%esp
80103d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d34:	89 d8                	mov    %ebx,%eax
80103d36:	5b                   	pop    %ebx
80103d37:	5e                   	pop    %esi
80103d38:	5f                   	pop    %edi
80103d39:	5d                   	pop    %ebp
80103d3a:	c3                   	ret    
80103d3b:	66 90                	xchg   %ax,%ax
80103d3d:	66 90                	xchg   %ax,%ax
80103d3f:	90                   	nop

80103d40 <allocproc>:
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	53                   	push   %ebx
80103d44:	bb f4 42 11 80       	mov    $0x801142f4,%ebx
80103d49:	83 ec 10             	sub    $0x10,%esp
80103d4c:	68 c0 42 11 80       	push   $0x801142c0
80103d51:	e8 ba 0d 00 00       	call   80104b10 <acquire>
80103d56:	83 c4 10             	add    $0x10,%esp
80103d59:	eb 10                	jmp    80103d6b <allocproc+0x2b>
80103d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d5f:	90                   	nop
80103d60:	83 c3 7c             	add    $0x7c,%ebx
80103d63:	81 fb f4 61 11 80    	cmp    $0x801161f4,%ebx
80103d69:	74 75                	je     80103de0 <allocproc+0xa0>
80103d6b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103d6e:	85 c0                	test   %eax,%eax
80103d70:	75 ee                	jne    80103d60 <allocproc+0x20>
80103d72:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80103d77:	83 ec 0c             	sub    $0xc,%esp
80103d7a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
80103d81:	89 43 10             	mov    %eax,0x10(%ebx)
80103d84:	8d 50 01             	lea    0x1(%eax),%edx
80103d87:	68 c0 42 11 80       	push   $0x801142c0
80103d8c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80103d92:	e8 39 0e 00 00       	call   80104bd0 <release>
80103d97:	e8 44 ee ff ff       	call   80102be0 <kalloc>
80103d9c:	83 c4 10             	add    $0x10,%esp
80103d9f:	89 43 08             	mov    %eax,0x8(%ebx)
80103da2:	85 c0                	test   %eax,%eax
80103da4:	74 53                	je     80103df9 <allocproc+0xb9>
80103da6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
80103dac:	83 ec 04             	sub    $0x4,%esp
80103daf:	05 9c 0f 00 00       	add    $0xf9c,%eax
80103db4:	89 53 18             	mov    %edx,0x18(%ebx)
80103db7:	c7 40 14 36 5e 10 80 	movl   $0x80105e36,0x14(%eax)
80103dbe:	89 43 1c             	mov    %eax,0x1c(%ebx)
80103dc1:	6a 14                	push   $0x14
80103dc3:	6a 00                	push   $0x0
80103dc5:	50                   	push   %eax
80103dc6:	e8 55 0e 00 00       	call   80104c20 <memset>
80103dcb:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103dce:	83 c4 10             	add    $0x10,%esp
80103dd1:	c7 40 10 10 3e 10 80 	movl   $0x80103e10,0x10(%eax)
80103dd8:	89 d8                	mov    %ebx,%eax
80103dda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ddd:	c9                   	leave  
80103dde:	c3                   	ret    
80103ddf:	90                   	nop
80103de0:	83 ec 0c             	sub    $0xc,%esp
80103de3:	31 db                	xor    %ebx,%ebx
80103de5:	68 c0 42 11 80       	push   $0x801142c0
80103dea:	e8 e1 0d 00 00       	call   80104bd0 <release>
80103def:	89 d8                	mov    %ebx,%eax
80103df1:	83 c4 10             	add    $0x10,%esp
80103df4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103df7:	c9                   	leave  
80103df8:	c3                   	ret    
80103df9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80103e00:	31 db                	xor    %ebx,%ebx
80103e02:	89 d8                	mov    %ebx,%eax
80103e04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e07:	c9                   	leave  
80103e08:	c3                   	ret    
80103e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e10 <forkret>:
80103e10:	f3 0f 1e fb          	endbr32 
80103e14:	55                   	push   %ebp
80103e15:	89 e5                	mov    %esp,%ebp
80103e17:	83 ec 14             	sub    $0x14,%esp
80103e1a:	68 c0 42 11 80       	push   $0x801142c0
80103e1f:	e8 ac 0d 00 00       	call   80104bd0 <release>
80103e24:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103e29:	83 c4 10             	add    $0x10,%esp
80103e2c:	85 c0                	test   %eax,%eax
80103e2e:	75 08                	jne    80103e38 <forkret+0x28>
80103e30:	c9                   	leave  
80103e31:	c3                   	ret    
80103e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e38:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103e3f:	00 00 00 
80103e42:	83 ec 0c             	sub    $0xc,%esp
80103e45:	6a 01                	push   $0x1
80103e47:	e8 a4 dc ff ff       	call   80101af0 <iinit>
80103e4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103e53:	e8 e8 f3 ff ff       	call   80103240 <initlog>
80103e58:	83 c4 10             	add    $0x10,%esp
80103e5b:	c9                   	leave  
80103e5c:	c3                   	ret    
80103e5d:	8d 76 00             	lea    0x0(%esi),%esi

80103e60 <pinit>:
80103e60:	f3 0f 1e fb          	endbr32 
80103e64:	55                   	push   %ebp
80103e65:	89 e5                	mov    %esp,%ebp
80103e67:	83 ec 10             	sub    $0x10,%esp
80103e6a:	68 40 7c 10 80       	push   $0x80107c40
80103e6f:	68 c0 42 11 80       	push   $0x801142c0
80103e74:	e8 17 0b 00 00       	call   80104990 <initlock>
80103e79:	83 c4 10             	add    $0x10,%esp
80103e7c:	c9                   	leave  
80103e7d:	c3                   	ret    
80103e7e:	66 90                	xchg   %ax,%ax

80103e80 <mycpu>:
80103e80:	f3 0f 1e fb          	endbr32 
80103e84:	55                   	push   %ebp
80103e85:	89 e5                	mov    %esp,%ebp
80103e87:	56                   	push   %esi
80103e88:	53                   	push   %ebx
80103e89:	9c                   	pushf  
80103e8a:	58                   	pop    %eax
80103e8b:	f6 c4 02             	test   $0x2,%ah
80103e8e:	75 4a                	jne    80103eda <mycpu+0x5a>
80103e90:	e8 bb ef ff ff       	call   80102e50 <lapicid>
80103e95:	8b 35 a0 42 11 80    	mov    0x801142a0,%esi
80103e9b:	89 c3                	mov    %eax,%ebx
80103e9d:	85 f6                	test   %esi,%esi
80103e9f:	7e 2c                	jle    80103ecd <mycpu+0x4d>
80103ea1:	31 d2                	xor    %edx,%edx
80103ea3:	eb 0a                	jmp    80103eaf <mycpu+0x2f>
80103ea5:	8d 76 00             	lea    0x0(%esi),%esi
80103ea8:	83 c2 01             	add    $0x1,%edx
80103eab:	39 f2                	cmp    %esi,%edx
80103ead:	74 1e                	je     80103ecd <mycpu+0x4d>
80103eaf:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103eb5:	0f b6 81 20 3d 11 80 	movzbl -0x7feec2e0(%ecx),%eax
80103ebc:	39 d8                	cmp    %ebx,%eax
80103ebe:	75 e8                	jne    80103ea8 <mycpu+0x28>
80103ec0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ec3:	8d 81 20 3d 11 80    	lea    -0x7feec2e0(%ecx),%eax
80103ec9:	5b                   	pop    %ebx
80103eca:	5e                   	pop    %esi
80103ecb:	5d                   	pop    %ebp
80103ecc:	c3                   	ret    
80103ecd:	83 ec 0c             	sub    $0xc,%esp
80103ed0:	68 47 7c 10 80       	push   $0x80107c47
80103ed5:	e8 b6 c4 ff ff       	call   80100390 <panic>
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	68 24 7d 10 80       	push   $0x80107d24
80103ee2:	e8 a9 c4 ff ff       	call   80100390 <panic>
80103ee7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eee:	66 90                	xchg   %ax,%ax

80103ef0 <cpuid>:
80103ef0:	f3 0f 1e fb          	endbr32 
80103ef4:	55                   	push   %ebp
80103ef5:	89 e5                	mov    %esp,%ebp
80103ef7:	83 ec 08             	sub    $0x8,%esp
80103efa:	e8 81 ff ff ff       	call   80103e80 <mycpu>
80103eff:	c9                   	leave  
80103f00:	2d 20 3d 11 80       	sub    $0x80113d20,%eax
80103f05:	c1 f8 04             	sar    $0x4,%eax
80103f08:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
80103f0e:	c3                   	ret    
80103f0f:	90                   	nop

80103f10 <myproc>:
80103f10:	f3 0f 1e fb          	endbr32 
80103f14:	55                   	push   %ebp
80103f15:	89 e5                	mov    %esp,%ebp
80103f17:	53                   	push   %ebx
80103f18:	83 ec 04             	sub    $0x4,%esp
80103f1b:	e8 f0 0a 00 00       	call   80104a10 <pushcli>
80103f20:	e8 5b ff ff ff       	call   80103e80 <mycpu>
80103f25:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
80103f2b:	e8 30 0b 00 00       	call   80104a60 <popcli>
80103f30:	83 c4 04             	add    $0x4,%esp
80103f33:	89 d8                	mov    %ebx,%eax
80103f35:	5b                   	pop    %ebx
80103f36:	5d                   	pop    %ebp
80103f37:	c3                   	ret    
80103f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f3f:	90                   	nop

80103f40 <userinit>:
80103f40:	f3 0f 1e fb          	endbr32 
80103f44:	55                   	push   %ebp
80103f45:	89 e5                	mov    %esp,%ebp
80103f47:	53                   	push   %ebx
80103f48:	83 ec 04             	sub    $0x4,%esp
80103f4b:	e8 f0 fd ff ff       	call   80103d40 <allocproc>
80103f50:	89 c3                	mov    %eax,%ebx
80103f52:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
80103f57:	e8 a4 34 00 00       	call   80107400 <setupkvm>
80103f5c:	89 43 04             	mov    %eax,0x4(%ebx)
80103f5f:	85 c0                	test   %eax,%eax
80103f61:	0f 84 bd 00 00 00    	je     80104024 <userinit+0xe4>
80103f67:	83 ec 04             	sub    $0x4,%esp
80103f6a:	68 2c 00 00 00       	push   $0x2c
80103f6f:	68 60 b4 10 80       	push   $0x8010b460
80103f74:	50                   	push   %eax
80103f75:	e8 56 31 00 00       	call   801070d0 <inituvm>
80103f7a:	83 c4 0c             	add    $0xc,%esp
80103f7d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
80103f83:	6a 4c                	push   $0x4c
80103f85:	6a 00                	push   $0x0
80103f87:	ff 73 18             	pushl  0x18(%ebx)
80103f8a:	e8 91 0c 00 00       	call   80104c20 <memset>
80103f8f:	8b 43 18             	mov    0x18(%ebx),%eax
80103f92:	ba 1b 00 00 00       	mov    $0x1b,%edx
80103f97:	83 c4 0c             	add    $0xc,%esp
80103f9a:	b9 23 00 00 00       	mov    $0x23,%ecx
80103f9f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
80103fa3:	8b 43 18             	mov    0x18(%ebx),%eax
80103fa6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
80103faa:	8b 43 18             	mov    0x18(%ebx),%eax
80103fad:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103fb1:	66 89 50 28          	mov    %dx,0x28(%eax)
80103fb5:	8b 43 18             	mov    0x18(%ebx),%eax
80103fb8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103fbc:	66 89 50 48          	mov    %dx,0x48(%eax)
80103fc0:	8b 43 18             	mov    0x18(%ebx),%eax
80103fc3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
80103fca:	8b 43 18             	mov    0x18(%ebx),%eax
80103fcd:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
80103fd4:	8b 43 18             	mov    0x18(%ebx),%eax
80103fd7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
80103fde:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103fe1:	6a 10                	push   $0x10
80103fe3:	68 70 7c 10 80       	push   $0x80107c70
80103fe8:	50                   	push   %eax
80103fe9:	e8 f2 0d 00 00       	call   80104de0 <safestrcpy>
80103fee:	c7 04 24 79 7c 10 80 	movl   $0x80107c79,(%esp)
80103ff5:	e8 e6 e5 ff ff       	call   801025e0 <namei>
80103ffa:	89 43 68             	mov    %eax,0x68(%ebx)
80103ffd:	c7 04 24 c0 42 11 80 	movl   $0x801142c0,(%esp)
80104004:	e8 07 0b 00 00       	call   80104b10 <acquire>
80104009:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
80104010:	c7 04 24 c0 42 11 80 	movl   $0x801142c0,(%esp)
80104017:	e8 b4 0b 00 00       	call   80104bd0 <release>
8010401c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010401f:	83 c4 10             	add    $0x10,%esp
80104022:	c9                   	leave  
80104023:	c3                   	ret    
80104024:	83 ec 0c             	sub    $0xc,%esp
80104027:	68 57 7c 10 80       	push   $0x80107c57
8010402c:	e8 5f c3 ff ff       	call   80100390 <panic>
80104031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010403f:	90                   	nop

80104040 <growproc>:
80104040:	f3 0f 1e fb          	endbr32 
80104044:	55                   	push   %ebp
80104045:	89 e5                	mov    %esp,%ebp
80104047:	56                   	push   %esi
80104048:	53                   	push   %ebx
80104049:	8b 75 08             	mov    0x8(%ebp),%esi
8010404c:	e8 bf 09 00 00       	call   80104a10 <pushcli>
80104051:	e8 2a fe ff ff       	call   80103e80 <mycpu>
80104056:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
8010405c:	e8 ff 09 00 00       	call   80104a60 <popcli>
80104061:	8b 03                	mov    (%ebx),%eax
80104063:	85 f6                	test   %esi,%esi
80104065:	7f 19                	jg     80104080 <growproc+0x40>
80104067:	75 37                	jne    801040a0 <growproc+0x60>
80104069:	83 ec 0c             	sub    $0xc,%esp
8010406c:	89 03                	mov    %eax,(%ebx)
8010406e:	53                   	push   %ebx
8010406f:	e8 4c 2f 00 00       	call   80106fc0 <switchuvm>
80104074:	83 c4 10             	add    $0x10,%esp
80104077:	31 c0                	xor    %eax,%eax
80104079:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010407c:	5b                   	pop    %ebx
8010407d:	5e                   	pop    %esi
8010407e:	5d                   	pop    %ebp
8010407f:	c3                   	ret    
80104080:	83 ec 04             	sub    $0x4,%esp
80104083:	01 c6                	add    %eax,%esi
80104085:	56                   	push   %esi
80104086:	50                   	push   %eax
80104087:	ff 73 04             	pushl  0x4(%ebx)
8010408a:	e8 91 31 00 00       	call   80107220 <allocuvm>
8010408f:	83 c4 10             	add    $0x10,%esp
80104092:	85 c0                	test   %eax,%eax
80104094:	75 d3                	jne    80104069 <growproc+0x29>
80104096:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010409b:	eb dc                	jmp    80104079 <growproc+0x39>
8010409d:	8d 76 00             	lea    0x0(%esi),%esi
801040a0:	83 ec 04             	sub    $0x4,%esp
801040a3:	01 c6                	add    %eax,%esi
801040a5:	56                   	push   %esi
801040a6:	50                   	push   %eax
801040a7:	ff 73 04             	pushl  0x4(%ebx)
801040aa:	e8 a1 32 00 00       	call   80107350 <deallocuvm>
801040af:	83 c4 10             	add    $0x10,%esp
801040b2:	85 c0                	test   %eax,%eax
801040b4:	75 b3                	jne    80104069 <growproc+0x29>
801040b6:	eb de                	jmp    80104096 <growproc+0x56>
801040b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040bf:	90                   	nop

801040c0 <fork>:
801040c0:	f3 0f 1e fb          	endbr32 
801040c4:	55                   	push   %ebp
801040c5:	89 e5                	mov    %esp,%ebp
801040c7:	57                   	push   %edi
801040c8:	56                   	push   %esi
801040c9:	53                   	push   %ebx
801040ca:	83 ec 1c             	sub    $0x1c,%esp
801040cd:	e8 3e 09 00 00       	call   80104a10 <pushcli>
801040d2:	e8 a9 fd ff ff       	call   80103e80 <mycpu>
801040d7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
801040dd:	e8 7e 09 00 00       	call   80104a60 <popcli>
801040e2:	e8 59 fc ff ff       	call   80103d40 <allocproc>
801040e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801040ea:	85 c0                	test   %eax,%eax
801040ec:	0f 84 bb 00 00 00    	je     801041ad <fork+0xed>
801040f2:	83 ec 08             	sub    $0x8,%esp
801040f5:	ff 33                	pushl  (%ebx)
801040f7:	89 c7                	mov    %eax,%edi
801040f9:	ff 73 04             	pushl  0x4(%ebx)
801040fc:	e8 cf 33 00 00       	call   801074d0 <copyuvm>
80104101:	83 c4 10             	add    $0x10,%esp
80104104:	89 47 04             	mov    %eax,0x4(%edi)
80104107:	85 c0                	test   %eax,%eax
80104109:	0f 84 a5 00 00 00    	je     801041b4 <fork+0xf4>
8010410f:	8b 03                	mov    (%ebx),%eax
80104111:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104114:	89 01                	mov    %eax,(%ecx)
80104116:	8b 79 18             	mov    0x18(%ecx),%edi
80104119:	89 c8                	mov    %ecx,%eax
8010411b:	89 59 14             	mov    %ebx,0x14(%ecx)
8010411e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104123:	8b 73 18             	mov    0x18(%ebx),%esi
80104126:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
80104128:	31 f6                	xor    %esi,%esi
8010412a:	8b 40 18             	mov    0x18(%eax),%eax
8010412d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80104134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104138:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010413c:	85 c0                	test   %eax,%eax
8010413e:	74 13                	je     80104153 <fork+0x93>
80104140:	83 ec 0c             	sub    $0xc,%esp
80104143:	50                   	push   %eax
80104144:	e8 d7 d2 ff ff       	call   80101420 <filedup>
80104149:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010414c:	83 c4 10             	add    $0x10,%esp
8010414f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
80104153:	83 c6 01             	add    $0x1,%esi
80104156:	83 fe 10             	cmp    $0x10,%esi
80104159:	75 dd                	jne    80104138 <fork+0x78>
8010415b:	83 ec 0c             	sub    $0xc,%esp
8010415e:	ff 73 68             	pushl  0x68(%ebx)
80104161:	83 c3 6c             	add    $0x6c,%ebx
80104164:	e8 77 db ff ff       	call   80101ce0 <idup>
80104169:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010416c:	83 c4 0c             	add    $0xc,%esp
8010416f:	89 47 68             	mov    %eax,0x68(%edi)
80104172:	8d 47 6c             	lea    0x6c(%edi),%eax
80104175:	6a 10                	push   $0x10
80104177:	53                   	push   %ebx
80104178:	50                   	push   %eax
80104179:	e8 62 0c 00 00       	call   80104de0 <safestrcpy>
8010417e:	8b 5f 10             	mov    0x10(%edi),%ebx
80104181:	c7 04 24 c0 42 11 80 	movl   $0x801142c0,(%esp)
80104188:	e8 83 09 00 00       	call   80104b10 <acquire>
8010418d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
80104194:	c7 04 24 c0 42 11 80 	movl   $0x801142c0,(%esp)
8010419b:	e8 30 0a 00 00       	call   80104bd0 <release>
801041a0:	83 c4 10             	add    $0x10,%esp
801041a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041a6:	89 d8                	mov    %ebx,%eax
801041a8:	5b                   	pop    %ebx
801041a9:	5e                   	pop    %esi
801041aa:	5f                   	pop    %edi
801041ab:	5d                   	pop    %ebp
801041ac:	c3                   	ret    
801041ad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801041b2:	eb ef                	jmp    801041a3 <fork+0xe3>
801041b4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801041b7:	83 ec 0c             	sub    $0xc,%esp
801041ba:	ff 73 08             	pushl  0x8(%ebx)
801041bd:	e8 5e e8 ff ff       	call   80102a20 <kfree>
801041c2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
801041c9:	83 c4 10             	add    $0x10,%esp
801041cc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
801041d3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801041d8:	eb c9                	jmp    801041a3 <fork+0xe3>
801041da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041e0 <scheduler>:
801041e0:	f3 0f 1e fb          	endbr32 
801041e4:	55                   	push   %ebp
801041e5:	89 e5                	mov    %esp,%ebp
801041e7:	57                   	push   %edi
801041e8:	56                   	push   %esi
801041e9:	53                   	push   %ebx
801041ea:	83 ec 0c             	sub    $0xc,%esp
801041ed:	e8 8e fc ff ff       	call   80103e80 <mycpu>
801041f2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801041f9:	00 00 00 
801041fc:	89 c6                	mov    %eax,%esi
801041fe:	8d 78 04             	lea    0x4(%eax),%edi
80104201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104208:	fb                   	sti    
80104209:	83 ec 0c             	sub    $0xc,%esp
8010420c:	bb f4 42 11 80       	mov    $0x801142f4,%ebx
80104211:	68 c0 42 11 80       	push   $0x801142c0
80104216:	e8 f5 08 00 00       	call   80104b10 <acquire>
8010421b:	83 c4 10             	add    $0x10,%esp
8010421e:	66 90                	xchg   %ax,%ax
80104220:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104224:	75 33                	jne    80104259 <scheduler+0x79>
80104226:	83 ec 0c             	sub    $0xc,%esp
80104229:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
8010422f:	53                   	push   %ebx
80104230:	e8 8b 2d 00 00       	call   80106fc0 <switchuvm>
80104235:	58                   	pop    %eax
80104236:	5a                   	pop    %edx
80104237:	ff 73 1c             	pushl  0x1c(%ebx)
8010423a:	57                   	push   %edi
8010423b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
80104242:	e8 fc 0b 00 00       	call   80104e43 <swtch>
80104247:	e8 54 2d 00 00       	call   80106fa0 <switchkvm>
8010424c:	83 c4 10             	add    $0x10,%esp
8010424f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104256:	00 00 00 
80104259:	83 c3 7c             	add    $0x7c,%ebx
8010425c:	81 fb f4 61 11 80    	cmp    $0x801161f4,%ebx
80104262:	75 bc                	jne    80104220 <scheduler+0x40>
80104264:	83 ec 0c             	sub    $0xc,%esp
80104267:	68 c0 42 11 80       	push   $0x801142c0
8010426c:	e8 5f 09 00 00       	call   80104bd0 <release>
80104271:	83 c4 10             	add    $0x10,%esp
80104274:	eb 92                	jmp    80104208 <scheduler+0x28>
80104276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010427d:	8d 76 00             	lea    0x0(%esi),%esi

80104280 <sched>:
80104280:	f3 0f 1e fb          	endbr32 
80104284:	55                   	push   %ebp
80104285:	89 e5                	mov    %esp,%ebp
80104287:	56                   	push   %esi
80104288:	53                   	push   %ebx
80104289:	e8 82 07 00 00       	call   80104a10 <pushcli>
8010428e:	e8 ed fb ff ff       	call   80103e80 <mycpu>
80104293:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
80104299:	e8 c2 07 00 00       	call   80104a60 <popcli>
8010429e:	83 ec 0c             	sub    $0xc,%esp
801042a1:	68 c0 42 11 80       	push   $0x801142c0
801042a6:	e8 15 08 00 00       	call   80104ac0 <holding>
801042ab:	83 c4 10             	add    $0x10,%esp
801042ae:	85 c0                	test   %eax,%eax
801042b0:	74 4f                	je     80104301 <sched+0x81>
801042b2:	e8 c9 fb ff ff       	call   80103e80 <mycpu>
801042b7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801042be:	75 68                	jne    80104328 <sched+0xa8>
801042c0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801042c4:	74 55                	je     8010431b <sched+0x9b>
801042c6:	9c                   	pushf  
801042c7:	58                   	pop    %eax
801042c8:	f6 c4 02             	test   $0x2,%ah
801042cb:	75 41                	jne    8010430e <sched+0x8e>
801042cd:	e8 ae fb ff ff       	call   80103e80 <mycpu>
801042d2:	83 c3 1c             	add    $0x1c,%ebx
801042d5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
801042db:	e8 a0 fb ff ff       	call   80103e80 <mycpu>
801042e0:	83 ec 08             	sub    $0x8,%esp
801042e3:	ff 70 04             	pushl  0x4(%eax)
801042e6:	53                   	push   %ebx
801042e7:	e8 57 0b 00 00       	call   80104e43 <swtch>
801042ec:	e8 8f fb ff ff       	call   80103e80 <mycpu>
801042f1:	83 c4 10             	add    $0x10,%esp
801042f4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
801042fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042fd:	5b                   	pop    %ebx
801042fe:	5e                   	pop    %esi
801042ff:	5d                   	pop    %ebp
80104300:	c3                   	ret    
80104301:	83 ec 0c             	sub    $0xc,%esp
80104304:	68 7b 7c 10 80       	push   $0x80107c7b
80104309:	e8 82 c0 ff ff       	call   80100390 <panic>
8010430e:	83 ec 0c             	sub    $0xc,%esp
80104311:	68 a7 7c 10 80       	push   $0x80107ca7
80104316:	e8 75 c0 ff ff       	call   80100390 <panic>
8010431b:	83 ec 0c             	sub    $0xc,%esp
8010431e:	68 99 7c 10 80       	push   $0x80107c99
80104323:	e8 68 c0 ff ff       	call   80100390 <panic>
80104328:	83 ec 0c             	sub    $0xc,%esp
8010432b:	68 8d 7c 10 80       	push   $0x80107c8d
80104330:	e8 5b c0 ff ff       	call   80100390 <panic>
80104335:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010433c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104340 <exit>:
80104340:	f3 0f 1e fb          	endbr32 
80104344:	55                   	push   %ebp
80104345:	89 e5                	mov    %esp,%ebp
80104347:	57                   	push   %edi
80104348:	56                   	push   %esi
80104349:	53                   	push   %ebx
8010434a:	83 ec 0c             	sub    $0xc,%esp
8010434d:	e8 be 06 00 00       	call   80104a10 <pushcli>
80104352:	e8 29 fb ff ff       	call   80103e80 <mycpu>
80104357:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
8010435d:	e8 fe 06 00 00       	call   80104a60 <popcli>
80104362:	8d 5e 28             	lea    0x28(%esi),%ebx
80104365:	8d 7e 68             	lea    0x68(%esi),%edi
80104368:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
8010436e:	0f 84 f3 00 00 00    	je     80104467 <exit+0x127>
80104374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104378:	8b 03                	mov    (%ebx),%eax
8010437a:	85 c0                	test   %eax,%eax
8010437c:	74 12                	je     80104390 <exit+0x50>
8010437e:	83 ec 0c             	sub    $0xc,%esp
80104381:	50                   	push   %eax
80104382:	e8 e9 d0 ff ff       	call   80101470 <fileclose>
80104387:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010438d:	83 c4 10             	add    $0x10,%esp
80104390:	83 c3 04             	add    $0x4,%ebx
80104393:	39 df                	cmp    %ebx,%edi
80104395:	75 e1                	jne    80104378 <exit+0x38>
80104397:	e8 44 ef ff ff       	call   801032e0 <begin_op>
8010439c:	83 ec 0c             	sub    $0xc,%esp
8010439f:	ff 76 68             	pushl  0x68(%esi)
801043a2:	e8 99 da ff ff       	call   80101e40 <iput>
801043a7:	e8 a4 ef ff ff       	call   80103350 <end_op>
801043ac:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
801043b3:	c7 04 24 c0 42 11 80 	movl   $0x801142c0,(%esp)
801043ba:	e8 51 07 00 00       	call   80104b10 <acquire>
801043bf:	8b 56 14             	mov    0x14(%esi),%edx
801043c2:	83 c4 10             	add    $0x10,%esp
801043c5:	b8 f4 42 11 80       	mov    $0x801142f4,%eax
801043ca:	eb 0e                	jmp    801043da <exit+0x9a>
801043cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043d0:	83 c0 7c             	add    $0x7c,%eax
801043d3:	3d f4 61 11 80       	cmp    $0x801161f4,%eax
801043d8:	74 1c                	je     801043f6 <exit+0xb6>
801043da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043de:	75 f0                	jne    801043d0 <exit+0x90>
801043e0:	3b 50 20             	cmp    0x20(%eax),%edx
801043e3:	75 eb                	jne    801043d0 <exit+0x90>
801043e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801043ec:	83 c0 7c             	add    $0x7c,%eax
801043ef:	3d f4 61 11 80       	cmp    $0x801161f4,%eax
801043f4:	75 e4                	jne    801043da <exit+0x9a>
801043f6:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
801043fc:	ba f4 42 11 80       	mov    $0x801142f4,%edx
80104401:	eb 10                	jmp    80104413 <exit+0xd3>
80104403:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104407:	90                   	nop
80104408:	83 c2 7c             	add    $0x7c,%edx
8010440b:	81 fa f4 61 11 80    	cmp    $0x801161f4,%edx
80104411:	74 3b                	je     8010444e <exit+0x10e>
80104413:	39 72 14             	cmp    %esi,0x14(%edx)
80104416:	75 f0                	jne    80104408 <exit+0xc8>
80104418:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
8010441c:	89 4a 14             	mov    %ecx,0x14(%edx)
8010441f:	75 e7                	jne    80104408 <exit+0xc8>
80104421:	b8 f4 42 11 80       	mov    $0x801142f4,%eax
80104426:	eb 12                	jmp    8010443a <exit+0xfa>
80104428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010442f:	90                   	nop
80104430:	83 c0 7c             	add    $0x7c,%eax
80104433:	3d f4 61 11 80       	cmp    $0x801161f4,%eax
80104438:	74 ce                	je     80104408 <exit+0xc8>
8010443a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010443e:	75 f0                	jne    80104430 <exit+0xf0>
80104440:	3b 48 20             	cmp    0x20(%eax),%ecx
80104443:	75 eb                	jne    80104430 <exit+0xf0>
80104445:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010444c:	eb e2                	jmp    80104430 <exit+0xf0>
8010444e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
80104455:	e8 26 fe ff ff       	call   80104280 <sched>
8010445a:	83 ec 0c             	sub    $0xc,%esp
8010445d:	68 c8 7c 10 80       	push   $0x80107cc8
80104462:	e8 29 bf ff ff       	call   80100390 <panic>
80104467:	83 ec 0c             	sub    $0xc,%esp
8010446a:	68 bb 7c 10 80       	push   $0x80107cbb
8010446f:	e8 1c bf ff ff       	call   80100390 <panic>
80104474:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010447b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010447f:	90                   	nop

80104480 <yield>:
80104480:	f3 0f 1e fb          	endbr32 
80104484:	55                   	push   %ebp
80104485:	89 e5                	mov    %esp,%ebp
80104487:	53                   	push   %ebx
80104488:	83 ec 10             	sub    $0x10,%esp
8010448b:	68 c0 42 11 80       	push   $0x801142c0
80104490:	e8 7b 06 00 00       	call   80104b10 <acquire>
80104495:	e8 76 05 00 00       	call   80104a10 <pushcli>
8010449a:	e8 e1 f9 ff ff       	call   80103e80 <mycpu>
8010449f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
801044a5:	e8 b6 05 00 00       	call   80104a60 <popcli>
801044aa:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
801044b1:	e8 ca fd ff ff       	call   80104280 <sched>
801044b6:	c7 04 24 c0 42 11 80 	movl   $0x801142c0,(%esp)
801044bd:	e8 0e 07 00 00       	call   80104bd0 <release>
801044c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044c5:	83 c4 10             	add    $0x10,%esp
801044c8:	c9                   	leave  
801044c9:	c3                   	ret    
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044d0 <sleep>:
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	57                   	push   %edi
801044d8:	56                   	push   %esi
801044d9:	53                   	push   %ebx
801044da:	83 ec 0c             	sub    $0xc,%esp
801044dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801044e0:	8b 75 0c             	mov    0xc(%ebp),%esi
801044e3:	e8 28 05 00 00       	call   80104a10 <pushcli>
801044e8:	e8 93 f9 ff ff       	call   80103e80 <mycpu>
801044ed:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
801044f3:	e8 68 05 00 00       	call   80104a60 <popcli>
801044f8:	85 db                	test   %ebx,%ebx
801044fa:	0f 84 83 00 00 00    	je     80104583 <sleep+0xb3>
80104500:	85 f6                	test   %esi,%esi
80104502:	74 72                	je     80104576 <sleep+0xa6>
80104504:	81 fe c0 42 11 80    	cmp    $0x801142c0,%esi
8010450a:	74 4c                	je     80104558 <sleep+0x88>
8010450c:	83 ec 0c             	sub    $0xc,%esp
8010450f:	68 c0 42 11 80       	push   $0x801142c0
80104514:	e8 f7 05 00 00       	call   80104b10 <acquire>
80104519:	89 34 24             	mov    %esi,(%esp)
8010451c:	e8 af 06 00 00       	call   80104bd0 <release>
80104521:	89 7b 20             	mov    %edi,0x20(%ebx)
80104524:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
8010452b:	e8 50 fd ff ff       	call   80104280 <sched>
80104530:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
80104537:	c7 04 24 c0 42 11 80 	movl   $0x801142c0,(%esp)
8010453e:	e8 8d 06 00 00       	call   80104bd0 <release>
80104543:	89 75 08             	mov    %esi,0x8(%ebp)
80104546:	83 c4 10             	add    $0x10,%esp
80104549:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010454c:	5b                   	pop    %ebx
8010454d:	5e                   	pop    %esi
8010454e:	5f                   	pop    %edi
8010454f:	5d                   	pop    %ebp
80104550:	e9 bb 05 00 00       	jmp    80104b10 <acquire>
80104555:	8d 76 00             	lea    0x0(%esi),%esi
80104558:	89 7b 20             	mov    %edi,0x20(%ebx)
8010455b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
80104562:	e8 19 fd ff ff       	call   80104280 <sched>
80104567:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
8010456e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104571:	5b                   	pop    %ebx
80104572:	5e                   	pop    %esi
80104573:	5f                   	pop    %edi
80104574:	5d                   	pop    %ebp
80104575:	c3                   	ret    
80104576:	83 ec 0c             	sub    $0xc,%esp
80104579:	68 da 7c 10 80       	push   $0x80107cda
8010457e:	e8 0d be ff ff       	call   80100390 <panic>
80104583:	83 ec 0c             	sub    $0xc,%esp
80104586:	68 d4 7c 10 80       	push   $0x80107cd4
8010458b:	e8 00 be ff ff       	call   80100390 <panic>

80104590 <wait>:
80104590:	f3 0f 1e fb          	endbr32 
80104594:	55                   	push   %ebp
80104595:	89 e5                	mov    %esp,%ebp
80104597:	56                   	push   %esi
80104598:	53                   	push   %ebx
80104599:	e8 72 04 00 00       	call   80104a10 <pushcli>
8010459e:	e8 dd f8 ff ff       	call   80103e80 <mycpu>
801045a3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
801045a9:	e8 b2 04 00 00       	call   80104a60 <popcli>
801045ae:	83 ec 0c             	sub    $0xc,%esp
801045b1:	68 c0 42 11 80       	push   $0x801142c0
801045b6:	e8 55 05 00 00       	call   80104b10 <acquire>
801045bb:	83 c4 10             	add    $0x10,%esp
801045be:	31 c0                	xor    %eax,%eax
801045c0:	bb f4 42 11 80       	mov    $0x801142f4,%ebx
801045c5:	eb 14                	jmp    801045db <wait+0x4b>
801045c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ce:	66 90                	xchg   %ax,%ax
801045d0:	83 c3 7c             	add    $0x7c,%ebx
801045d3:	81 fb f4 61 11 80    	cmp    $0x801161f4,%ebx
801045d9:	74 1b                	je     801045f6 <wait+0x66>
801045db:	39 73 14             	cmp    %esi,0x14(%ebx)
801045de:	75 f0                	jne    801045d0 <wait+0x40>
801045e0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801045e4:	74 32                	je     80104618 <wait+0x88>
801045e6:	83 c3 7c             	add    $0x7c,%ebx
801045e9:	b8 01 00 00 00       	mov    $0x1,%eax
801045ee:	81 fb f4 61 11 80    	cmp    $0x801161f4,%ebx
801045f4:	75 e5                	jne    801045db <wait+0x4b>
801045f6:	85 c0                	test   %eax,%eax
801045f8:	74 74                	je     8010466e <wait+0xde>
801045fa:	8b 46 24             	mov    0x24(%esi),%eax
801045fd:	85 c0                	test   %eax,%eax
801045ff:	75 6d                	jne    8010466e <wait+0xde>
80104601:	83 ec 08             	sub    $0x8,%esp
80104604:	68 c0 42 11 80       	push   $0x801142c0
80104609:	56                   	push   %esi
8010460a:	e8 c1 fe ff ff       	call   801044d0 <sleep>
8010460f:	83 c4 10             	add    $0x10,%esp
80104612:	eb aa                	jmp    801045be <wait+0x2e>
80104614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104618:	83 ec 0c             	sub    $0xc,%esp
8010461b:	ff 73 08             	pushl  0x8(%ebx)
8010461e:	8b 73 10             	mov    0x10(%ebx),%esi
80104621:	e8 fa e3 ff ff       	call   80102a20 <kfree>
80104626:	5a                   	pop    %edx
80104627:	ff 73 04             	pushl  0x4(%ebx)
8010462a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
80104631:	e8 4a 2d 00 00       	call   80107380 <freevm>
80104636:	c7 04 24 c0 42 11 80 	movl   $0x801142c0,(%esp)
8010463d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
80104644:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
8010464b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
8010464f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
80104656:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
8010465d:	e8 6e 05 00 00       	call   80104bd0 <release>
80104662:	83 c4 10             	add    $0x10,%esp
80104665:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104668:	89 f0                	mov    %esi,%eax
8010466a:	5b                   	pop    %ebx
8010466b:	5e                   	pop    %esi
8010466c:	5d                   	pop    %ebp
8010466d:	c3                   	ret    
8010466e:	83 ec 0c             	sub    $0xc,%esp
80104671:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104676:	68 c0 42 11 80       	push   $0x801142c0
8010467b:	e8 50 05 00 00       	call   80104bd0 <release>
80104680:	83 c4 10             	add    $0x10,%esp
80104683:	eb e0                	jmp    80104665 <wait+0xd5>
80104685:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104690 <wakeup>:
80104690:	f3 0f 1e fb          	endbr32 
80104694:	55                   	push   %ebp
80104695:	89 e5                	mov    %esp,%ebp
80104697:	53                   	push   %ebx
80104698:	83 ec 10             	sub    $0x10,%esp
8010469b:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010469e:	68 c0 42 11 80       	push   $0x801142c0
801046a3:	e8 68 04 00 00       	call   80104b10 <acquire>
801046a8:	83 c4 10             	add    $0x10,%esp
801046ab:	b8 f4 42 11 80       	mov    $0x801142f4,%eax
801046b0:	eb 10                	jmp    801046c2 <wakeup+0x32>
801046b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046b8:	83 c0 7c             	add    $0x7c,%eax
801046bb:	3d f4 61 11 80       	cmp    $0x801161f4,%eax
801046c0:	74 1c                	je     801046de <wakeup+0x4e>
801046c2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046c6:	75 f0                	jne    801046b8 <wakeup+0x28>
801046c8:	3b 58 20             	cmp    0x20(%eax),%ebx
801046cb:	75 eb                	jne    801046b8 <wakeup+0x28>
801046cd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801046d4:	83 c0 7c             	add    $0x7c,%eax
801046d7:	3d f4 61 11 80       	cmp    $0x801161f4,%eax
801046dc:	75 e4                	jne    801046c2 <wakeup+0x32>
801046de:	c7 45 08 c0 42 11 80 	movl   $0x801142c0,0x8(%ebp)
801046e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046e8:	c9                   	leave  
801046e9:	e9 e2 04 00 00       	jmp    80104bd0 <release>
801046ee:	66 90                	xchg   %ax,%ax

801046f0 <kill>:
801046f0:	f3 0f 1e fb          	endbr32 
801046f4:	55                   	push   %ebp
801046f5:	89 e5                	mov    %esp,%ebp
801046f7:	53                   	push   %ebx
801046f8:	83 ec 10             	sub    $0x10,%esp
801046fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046fe:	68 c0 42 11 80       	push   $0x801142c0
80104703:	e8 08 04 00 00       	call   80104b10 <acquire>
80104708:	83 c4 10             	add    $0x10,%esp
8010470b:	b8 f4 42 11 80       	mov    $0x801142f4,%eax
80104710:	eb 10                	jmp    80104722 <kill+0x32>
80104712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104718:	83 c0 7c             	add    $0x7c,%eax
8010471b:	3d f4 61 11 80       	cmp    $0x801161f4,%eax
80104720:	74 36                	je     80104758 <kill+0x68>
80104722:	39 58 10             	cmp    %ebx,0x10(%eax)
80104725:	75 f1                	jne    80104718 <kill+0x28>
80104727:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010472b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80104732:	75 07                	jne    8010473b <kill+0x4b>
80104734:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010473b:	83 ec 0c             	sub    $0xc,%esp
8010473e:	68 c0 42 11 80       	push   $0x801142c0
80104743:	e8 88 04 00 00       	call   80104bd0 <release>
80104748:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010474b:	83 c4 10             	add    $0x10,%esp
8010474e:	31 c0                	xor    %eax,%eax
80104750:	c9                   	leave  
80104751:	c3                   	ret    
80104752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104758:	83 ec 0c             	sub    $0xc,%esp
8010475b:	68 c0 42 11 80       	push   $0x801142c0
80104760:	e8 6b 04 00 00       	call   80104bd0 <release>
80104765:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104768:	83 c4 10             	add    $0x10,%esp
8010476b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104770:	c9                   	leave  
80104771:	c3                   	ret    
80104772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104780 <procdump>:
80104780:	f3 0f 1e fb          	endbr32 
80104784:	55                   	push   %ebp
80104785:	89 e5                	mov    %esp,%ebp
80104787:	57                   	push   %edi
80104788:	56                   	push   %esi
80104789:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010478c:	53                   	push   %ebx
8010478d:	bb 60 43 11 80       	mov    $0x80114360,%ebx
80104792:	83 ec 3c             	sub    $0x3c,%esp
80104795:	eb 28                	jmp    801047bf <procdump+0x3f>
80104797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479e:	66 90                	xchg   %ax,%ax
801047a0:	83 ec 0c             	sub    $0xc,%esp
801047a3:	68 57 80 10 80       	push   $0x80108057
801047a8:	e8 d3 c1 ff ff       	call   80100980 <cprintf>
801047ad:	83 c4 10             	add    $0x10,%esp
801047b0:	83 c3 7c             	add    $0x7c,%ebx
801047b3:	81 fb 60 62 11 80    	cmp    $0x80116260,%ebx
801047b9:	0f 84 81 00 00 00    	je     80104840 <procdump+0xc0>
801047bf:	8b 43 a0             	mov    -0x60(%ebx),%eax
801047c2:	85 c0                	test   %eax,%eax
801047c4:	74 ea                	je     801047b0 <procdump+0x30>
801047c6:	ba eb 7c 10 80       	mov    $0x80107ceb,%edx
801047cb:	83 f8 05             	cmp    $0x5,%eax
801047ce:	77 11                	ja     801047e1 <procdump+0x61>
801047d0:	8b 14 85 4c 7d 10 80 	mov    -0x7fef82b4(,%eax,4),%edx
801047d7:	b8 eb 7c 10 80       	mov    $0x80107ceb,%eax
801047dc:	85 d2                	test   %edx,%edx
801047de:	0f 44 d0             	cmove  %eax,%edx
801047e1:	53                   	push   %ebx
801047e2:	52                   	push   %edx
801047e3:	ff 73 a4             	pushl  -0x5c(%ebx)
801047e6:	68 ef 7c 10 80       	push   $0x80107cef
801047eb:	e8 90 c1 ff ff       	call   80100980 <cprintf>
801047f0:	83 c4 10             	add    $0x10,%esp
801047f3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801047f7:	75 a7                	jne    801047a0 <procdump+0x20>
801047f9:	83 ec 08             	sub    $0x8,%esp
801047fc:	8d 45 c0             	lea    -0x40(%ebp),%eax
801047ff:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104802:	50                   	push   %eax
80104803:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104806:	8b 40 0c             	mov    0xc(%eax),%eax
80104809:	83 c0 08             	add    $0x8,%eax
8010480c:	50                   	push   %eax
8010480d:	e8 9e 01 00 00       	call   801049b0 <getcallerpcs>
80104812:	83 c4 10             	add    $0x10,%esp
80104815:	8d 76 00             	lea    0x0(%esi),%esi
80104818:	8b 17                	mov    (%edi),%edx
8010481a:	85 d2                	test   %edx,%edx
8010481c:	74 82                	je     801047a0 <procdump+0x20>
8010481e:	83 ec 08             	sub    $0x8,%esp
80104821:	83 c7 04             	add    $0x4,%edi
80104824:	52                   	push   %edx
80104825:	68 e1 76 10 80       	push   $0x801076e1
8010482a:	e8 51 c1 ff ff       	call   80100980 <cprintf>
8010482f:	83 c4 10             	add    $0x10,%esp
80104832:	39 fe                	cmp    %edi,%esi
80104834:	75 e2                	jne    80104818 <procdump+0x98>
80104836:	e9 65 ff ff ff       	jmp    801047a0 <procdump+0x20>
8010483b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010483f:	90                   	nop
80104840:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104843:	5b                   	pop    %ebx
80104844:	5e                   	pop    %esi
80104845:	5f                   	pop    %edi
80104846:	5d                   	pop    %ebp
80104847:	c3                   	ret    
80104848:	66 90                	xchg   %ax,%ax
8010484a:	66 90                	xchg   %ax,%ax
8010484c:	66 90                	xchg   %ax,%ax
8010484e:	66 90                	xchg   %ax,%ax

80104850 <initsleeplock>:
80104850:	f3 0f 1e fb          	endbr32 
80104854:	55                   	push   %ebp
80104855:	89 e5                	mov    %esp,%ebp
80104857:	53                   	push   %ebx
80104858:	83 ec 0c             	sub    $0xc,%esp
8010485b:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010485e:	68 64 7d 10 80       	push   $0x80107d64
80104863:	8d 43 04             	lea    0x4(%ebx),%eax
80104866:	50                   	push   %eax
80104867:	e8 24 01 00 00       	call   80104990 <initlock>
8010486c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010486f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104875:	83 c4 10             	add    $0x10,%esp
80104878:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
8010487f:	89 43 38             	mov    %eax,0x38(%ebx)
80104882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104885:	c9                   	leave  
80104886:	c3                   	ret    
80104887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488e:	66 90                	xchg   %ax,%ax

80104890 <acquiresleep>:
80104890:	f3 0f 1e fb          	endbr32 
80104894:	55                   	push   %ebp
80104895:	89 e5                	mov    %esp,%ebp
80104897:	56                   	push   %esi
80104898:	53                   	push   %ebx
80104899:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010489c:	8d 73 04             	lea    0x4(%ebx),%esi
8010489f:	83 ec 0c             	sub    $0xc,%esp
801048a2:	56                   	push   %esi
801048a3:	e8 68 02 00 00       	call   80104b10 <acquire>
801048a8:	8b 13                	mov    (%ebx),%edx
801048aa:	83 c4 10             	add    $0x10,%esp
801048ad:	85 d2                	test   %edx,%edx
801048af:	74 1a                	je     801048cb <acquiresleep+0x3b>
801048b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048b8:	83 ec 08             	sub    $0x8,%esp
801048bb:	56                   	push   %esi
801048bc:	53                   	push   %ebx
801048bd:	e8 0e fc ff ff       	call   801044d0 <sleep>
801048c2:	8b 03                	mov    (%ebx),%eax
801048c4:	83 c4 10             	add    $0x10,%esp
801048c7:	85 c0                	test   %eax,%eax
801048c9:	75 ed                	jne    801048b8 <acquiresleep+0x28>
801048cb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
801048d1:	e8 3a f6 ff ff       	call   80103f10 <myproc>
801048d6:	8b 40 10             	mov    0x10(%eax),%eax
801048d9:	89 43 3c             	mov    %eax,0x3c(%ebx)
801048dc:	89 75 08             	mov    %esi,0x8(%ebp)
801048df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048e2:	5b                   	pop    %ebx
801048e3:	5e                   	pop    %esi
801048e4:	5d                   	pop    %ebp
801048e5:	e9 e6 02 00 00       	jmp    80104bd0 <release>
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048f0 <releasesleep>:
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	56                   	push   %esi
801048f8:	53                   	push   %ebx
801048f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048fc:	8d 73 04             	lea    0x4(%ebx),%esi
801048ff:	83 ec 0c             	sub    $0xc,%esp
80104902:	56                   	push   %esi
80104903:	e8 08 02 00 00       	call   80104b10 <acquire>
80104908:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010490e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
80104915:	89 1c 24             	mov    %ebx,(%esp)
80104918:	e8 73 fd ff ff       	call   80104690 <wakeup>
8010491d:	89 75 08             	mov    %esi,0x8(%ebp)
80104920:	83 c4 10             	add    $0x10,%esp
80104923:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104926:	5b                   	pop    %ebx
80104927:	5e                   	pop    %esi
80104928:	5d                   	pop    %ebp
80104929:	e9 a2 02 00 00       	jmp    80104bd0 <release>
8010492e:	66 90                	xchg   %ax,%ax

80104930 <holdingsleep>:
80104930:	f3 0f 1e fb          	endbr32 
80104934:	55                   	push   %ebp
80104935:	89 e5                	mov    %esp,%ebp
80104937:	57                   	push   %edi
80104938:	31 ff                	xor    %edi,%edi
8010493a:	56                   	push   %esi
8010493b:	53                   	push   %ebx
8010493c:	83 ec 18             	sub    $0x18,%esp
8010493f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104942:	8d 73 04             	lea    0x4(%ebx),%esi
80104945:	56                   	push   %esi
80104946:	e8 c5 01 00 00       	call   80104b10 <acquire>
8010494b:	8b 03                	mov    (%ebx),%eax
8010494d:	83 c4 10             	add    $0x10,%esp
80104950:	85 c0                	test   %eax,%eax
80104952:	75 1c                	jne    80104970 <holdingsleep+0x40>
80104954:	83 ec 0c             	sub    $0xc,%esp
80104957:	56                   	push   %esi
80104958:	e8 73 02 00 00       	call   80104bd0 <release>
8010495d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104960:	89 f8                	mov    %edi,%eax
80104962:	5b                   	pop    %ebx
80104963:	5e                   	pop    %esi
80104964:	5f                   	pop    %edi
80104965:	5d                   	pop    %ebp
80104966:	c3                   	ret    
80104967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496e:	66 90                	xchg   %ax,%ax
80104970:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104973:	e8 98 f5 ff ff       	call   80103f10 <myproc>
80104978:	39 58 10             	cmp    %ebx,0x10(%eax)
8010497b:	0f 94 c0             	sete   %al
8010497e:	0f b6 c0             	movzbl %al,%eax
80104981:	89 c7                	mov    %eax,%edi
80104983:	eb cf                	jmp    80104954 <holdingsleep+0x24>
80104985:	66 90                	xchg   %ax,%ax
80104987:	66 90                	xchg   %ax,%ax
80104989:	66 90                	xchg   %ax,%ax
8010498b:	66 90                	xchg   %ax,%ax
8010498d:	66 90                	xchg   %ax,%ax
8010498f:	90                   	nop

80104990 <initlock>:
80104990:	f3 0f 1e fb          	endbr32 
80104994:	55                   	push   %ebp
80104995:	89 e5                	mov    %esp,%ebp
80104997:	8b 45 08             	mov    0x8(%ebp),%eax
8010499a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010499d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801049a3:	89 50 04             	mov    %edx,0x4(%eax)
801049a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
801049ad:	5d                   	pop    %ebp
801049ae:	c3                   	ret    
801049af:	90                   	nop

801049b0 <getcallerpcs>:
801049b0:	f3 0f 1e fb          	endbr32 
801049b4:	55                   	push   %ebp
801049b5:	31 d2                	xor    %edx,%edx
801049b7:	89 e5                	mov    %esp,%ebp
801049b9:	53                   	push   %ebx
801049ba:	8b 45 08             	mov    0x8(%ebp),%eax
801049bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801049c0:	83 e8 08             	sub    $0x8,%eax
801049c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049c7:	90                   	nop
801049c8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801049ce:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801049d4:	77 1a                	ja     801049f0 <getcallerpcs+0x40>
801049d6:	8b 58 04             	mov    0x4(%eax),%ebx
801049d9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
801049dc:	83 c2 01             	add    $0x1,%edx
801049df:	8b 00                	mov    (%eax),%eax
801049e1:	83 fa 0a             	cmp    $0xa,%edx
801049e4:	75 e2                	jne    801049c8 <getcallerpcs+0x18>
801049e6:	5b                   	pop    %ebx
801049e7:	5d                   	pop    %ebp
801049e8:	c3                   	ret    
801049e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049f0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801049f3:	8d 51 28             	lea    0x28(%ecx),%edx
801049f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fd:	8d 76 00             	lea    0x0(%esi),%esi
80104a00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a06:	83 c0 04             	add    $0x4,%eax
80104a09:	39 d0                	cmp    %edx,%eax
80104a0b:	75 f3                	jne    80104a00 <getcallerpcs+0x50>
80104a0d:	5b                   	pop    %ebx
80104a0e:	5d                   	pop    %ebp
80104a0f:	c3                   	ret    

80104a10 <pushcli>:
80104a10:	f3 0f 1e fb          	endbr32 
80104a14:	55                   	push   %ebp
80104a15:	89 e5                	mov    %esp,%ebp
80104a17:	53                   	push   %ebx
80104a18:	83 ec 04             	sub    $0x4,%esp
80104a1b:	9c                   	pushf  
80104a1c:	5b                   	pop    %ebx
80104a1d:	fa                   	cli    
80104a1e:	e8 5d f4 ff ff       	call   80103e80 <mycpu>
80104a23:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a29:	85 c0                	test   %eax,%eax
80104a2b:	74 13                	je     80104a40 <pushcli+0x30>
80104a2d:	e8 4e f4 ff ff       	call   80103e80 <mycpu>
80104a32:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
80104a39:	83 c4 04             	add    $0x4,%esp
80104a3c:	5b                   	pop    %ebx
80104a3d:	5d                   	pop    %ebp
80104a3e:	c3                   	ret    
80104a3f:	90                   	nop
80104a40:	e8 3b f4 ff ff       	call   80103e80 <mycpu>
80104a45:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104a4b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104a51:	eb da                	jmp    80104a2d <pushcli+0x1d>
80104a53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a60 <popcli>:
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	83 ec 08             	sub    $0x8,%esp
80104a6a:	9c                   	pushf  
80104a6b:	58                   	pop    %eax
80104a6c:	f6 c4 02             	test   $0x2,%ah
80104a6f:	75 31                	jne    80104aa2 <popcli+0x42>
80104a71:	e8 0a f4 ff ff       	call   80103e80 <mycpu>
80104a76:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104a7d:	78 30                	js     80104aaf <popcli+0x4f>
80104a7f:	e8 fc f3 ff ff       	call   80103e80 <mycpu>
80104a84:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a8a:	85 d2                	test   %edx,%edx
80104a8c:	74 02                	je     80104a90 <popcli+0x30>
80104a8e:	c9                   	leave  
80104a8f:	c3                   	ret    
80104a90:	e8 eb f3 ff ff       	call   80103e80 <mycpu>
80104a95:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a9b:	85 c0                	test   %eax,%eax
80104a9d:	74 ef                	je     80104a8e <popcli+0x2e>
80104a9f:	fb                   	sti    
80104aa0:	c9                   	leave  
80104aa1:	c3                   	ret    
80104aa2:	83 ec 0c             	sub    $0xc,%esp
80104aa5:	68 6f 7d 10 80       	push   $0x80107d6f
80104aaa:	e8 e1 b8 ff ff       	call   80100390 <panic>
80104aaf:	83 ec 0c             	sub    $0xc,%esp
80104ab2:	68 86 7d 10 80       	push   $0x80107d86
80104ab7:	e8 d4 b8 ff ff       	call   80100390 <panic>
80104abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ac0 <holding>:
80104ac0:	f3 0f 1e fb          	endbr32 
80104ac4:	55                   	push   %ebp
80104ac5:	89 e5                	mov    %esp,%ebp
80104ac7:	56                   	push   %esi
80104ac8:	53                   	push   %ebx
80104ac9:	8b 75 08             	mov    0x8(%ebp),%esi
80104acc:	31 db                	xor    %ebx,%ebx
80104ace:	e8 3d ff ff ff       	call   80104a10 <pushcli>
80104ad3:	8b 06                	mov    (%esi),%eax
80104ad5:	85 c0                	test   %eax,%eax
80104ad7:	75 0f                	jne    80104ae8 <holding+0x28>
80104ad9:	e8 82 ff ff ff       	call   80104a60 <popcli>
80104ade:	89 d8                	mov    %ebx,%eax
80104ae0:	5b                   	pop    %ebx
80104ae1:	5e                   	pop    %esi
80104ae2:	5d                   	pop    %ebp
80104ae3:	c3                   	ret    
80104ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ae8:	8b 5e 08             	mov    0x8(%esi),%ebx
80104aeb:	e8 90 f3 ff ff       	call   80103e80 <mycpu>
80104af0:	39 c3                	cmp    %eax,%ebx
80104af2:	0f 94 c3             	sete   %bl
80104af5:	e8 66 ff ff ff       	call   80104a60 <popcli>
80104afa:	0f b6 db             	movzbl %bl,%ebx
80104afd:	89 d8                	mov    %ebx,%eax
80104aff:	5b                   	pop    %ebx
80104b00:	5e                   	pop    %esi
80104b01:	5d                   	pop    %ebp
80104b02:	c3                   	ret    
80104b03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b10 <acquire>:
80104b10:	f3 0f 1e fb          	endbr32 
80104b14:	55                   	push   %ebp
80104b15:	89 e5                	mov    %esp,%ebp
80104b17:	56                   	push   %esi
80104b18:	53                   	push   %ebx
80104b19:	e8 f2 fe ff ff       	call   80104a10 <pushcli>
80104b1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b21:	83 ec 0c             	sub    $0xc,%esp
80104b24:	53                   	push   %ebx
80104b25:	e8 96 ff ff ff       	call   80104ac0 <holding>
80104b2a:	83 c4 10             	add    $0x10,%esp
80104b2d:	85 c0                	test   %eax,%eax
80104b2f:	0f 85 7f 00 00 00    	jne    80104bb4 <acquire+0xa4>
80104b35:	89 c6                	mov    %eax,%esi
80104b37:	ba 01 00 00 00       	mov    $0x1,%edx
80104b3c:	eb 05                	jmp    80104b43 <acquire+0x33>
80104b3e:	66 90                	xchg   %ax,%ax
80104b40:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b43:	89 d0                	mov    %edx,%eax
80104b45:	f0 87 03             	lock xchg %eax,(%ebx)
80104b48:	85 c0                	test   %eax,%eax
80104b4a:	75 f4                	jne    80104b40 <acquire+0x30>
80104b4c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
80104b51:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b54:	e8 27 f3 ff ff       	call   80103e80 <mycpu>
80104b59:	89 43 08             	mov    %eax,0x8(%ebx)
80104b5c:	89 e8                	mov    %ebp,%eax
80104b5e:	66 90                	xchg   %ax,%ax
80104b60:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104b66:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104b6c:	77 22                	ja     80104b90 <acquire+0x80>
80104b6e:	8b 50 04             	mov    0x4(%eax),%edx
80104b71:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
80104b75:	83 c6 01             	add    $0x1,%esi
80104b78:	8b 00                	mov    (%eax),%eax
80104b7a:	83 fe 0a             	cmp    $0xa,%esi
80104b7d:	75 e1                	jne    80104b60 <acquire+0x50>
80104b7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b82:	5b                   	pop    %ebx
80104b83:	5e                   	pop    %esi
80104b84:	5d                   	pop    %ebp
80104b85:	c3                   	ret    
80104b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
80104b90:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104b94:	83 c3 34             	add    $0x34,%ebx
80104b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b9e:	66 90                	xchg   %ax,%ax
80104ba0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ba6:	83 c0 04             	add    $0x4,%eax
80104ba9:	39 d8                	cmp    %ebx,%eax
80104bab:	75 f3                	jne    80104ba0 <acquire+0x90>
80104bad:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bb0:	5b                   	pop    %ebx
80104bb1:	5e                   	pop    %esi
80104bb2:	5d                   	pop    %ebp
80104bb3:	c3                   	ret    
80104bb4:	83 ec 0c             	sub    $0xc,%esp
80104bb7:	68 8d 7d 10 80       	push   $0x80107d8d
80104bbc:	e8 cf b7 ff ff       	call   80100390 <panic>
80104bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bcf:	90                   	nop

80104bd0 <release>:
80104bd0:	f3 0f 1e fb          	endbr32 
80104bd4:	55                   	push   %ebp
80104bd5:	89 e5                	mov    %esp,%ebp
80104bd7:	53                   	push   %ebx
80104bd8:	83 ec 10             	sub    $0x10,%esp
80104bdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bde:	53                   	push   %ebx
80104bdf:	e8 dc fe ff ff       	call   80104ac0 <holding>
80104be4:	83 c4 10             	add    $0x10,%esp
80104be7:	85 c0                	test   %eax,%eax
80104be9:	74 22                	je     80104c0d <release+0x3d>
80104beb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80104bf2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
80104bf9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
80104bfe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104c04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c07:	c9                   	leave  
80104c08:	e9 53 fe ff ff       	jmp    80104a60 <popcli>
80104c0d:	83 ec 0c             	sub    $0xc,%esp
80104c10:	68 95 7d 10 80       	push   $0x80107d95
80104c15:	e8 76 b7 ff ff       	call   80100390 <panic>
80104c1a:	66 90                	xchg   %ax,%ax
80104c1c:	66 90                	xchg   %ax,%ax
80104c1e:	66 90                	xchg   %ax,%ax

80104c20 <memset>:
80104c20:	f3 0f 1e fb          	endbr32 
80104c24:	55                   	push   %ebp
80104c25:	89 e5                	mov    %esp,%ebp
80104c27:	57                   	push   %edi
80104c28:	8b 55 08             	mov    0x8(%ebp),%edx
80104c2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c2e:	53                   	push   %ebx
80104c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c32:	89 d7                	mov    %edx,%edi
80104c34:	09 cf                	or     %ecx,%edi
80104c36:	83 e7 03             	and    $0x3,%edi
80104c39:	75 25                	jne    80104c60 <memset+0x40>
80104c3b:	0f b6 f8             	movzbl %al,%edi
80104c3e:	c1 e0 18             	shl    $0x18,%eax
80104c41:	89 fb                	mov    %edi,%ebx
80104c43:	c1 e9 02             	shr    $0x2,%ecx
80104c46:	c1 e3 10             	shl    $0x10,%ebx
80104c49:	09 d8                	or     %ebx,%eax
80104c4b:	09 f8                	or     %edi,%eax
80104c4d:	c1 e7 08             	shl    $0x8,%edi
80104c50:	09 f8                	or     %edi,%eax
80104c52:	89 d7                	mov    %edx,%edi
80104c54:	fc                   	cld    
80104c55:	f3 ab                	rep stos %eax,%es:(%edi)
80104c57:	5b                   	pop    %ebx
80104c58:	89 d0                	mov    %edx,%eax
80104c5a:	5f                   	pop    %edi
80104c5b:	5d                   	pop    %ebp
80104c5c:	c3                   	ret    
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi
80104c60:	89 d7                	mov    %edx,%edi
80104c62:	fc                   	cld    
80104c63:	f3 aa                	rep stos %al,%es:(%edi)
80104c65:	5b                   	pop    %ebx
80104c66:	89 d0                	mov    %edx,%eax
80104c68:	5f                   	pop    %edi
80104c69:	5d                   	pop    %ebp
80104c6a:	c3                   	ret    
80104c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c6f:	90                   	nop

80104c70 <memcmp>:
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	56                   	push   %esi
80104c78:	8b 75 10             	mov    0x10(%ebp),%esi
80104c7b:	8b 55 08             	mov    0x8(%ebp),%edx
80104c7e:	53                   	push   %ebx
80104c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c82:	85 f6                	test   %esi,%esi
80104c84:	74 2a                	je     80104cb0 <memcmp+0x40>
80104c86:	01 c6                	add    %eax,%esi
80104c88:	eb 10                	jmp    80104c9a <memcmp+0x2a>
80104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c90:	83 c0 01             	add    $0x1,%eax
80104c93:	83 c2 01             	add    $0x1,%edx
80104c96:	39 f0                	cmp    %esi,%eax
80104c98:	74 16                	je     80104cb0 <memcmp+0x40>
80104c9a:	0f b6 0a             	movzbl (%edx),%ecx
80104c9d:	0f b6 18             	movzbl (%eax),%ebx
80104ca0:	38 d9                	cmp    %bl,%cl
80104ca2:	74 ec                	je     80104c90 <memcmp+0x20>
80104ca4:	0f b6 c1             	movzbl %cl,%eax
80104ca7:	29 d8                	sub    %ebx,%eax
80104ca9:	5b                   	pop    %ebx
80104caa:	5e                   	pop    %esi
80104cab:	5d                   	pop    %ebp
80104cac:	c3                   	ret    
80104cad:	8d 76 00             	lea    0x0(%esi),%esi
80104cb0:	5b                   	pop    %ebx
80104cb1:	31 c0                	xor    %eax,%eax
80104cb3:	5e                   	pop    %esi
80104cb4:	5d                   	pop    %ebp
80104cb5:	c3                   	ret    
80104cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbd:	8d 76 00             	lea    0x0(%esi),%esi

80104cc0 <memmove>:
80104cc0:	f3 0f 1e fb          	endbr32 
80104cc4:	55                   	push   %ebp
80104cc5:	89 e5                	mov    %esp,%ebp
80104cc7:	57                   	push   %edi
80104cc8:	8b 55 08             	mov    0x8(%ebp),%edx
80104ccb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104cce:	56                   	push   %esi
80104ccf:	8b 75 0c             	mov    0xc(%ebp),%esi
80104cd2:	39 d6                	cmp    %edx,%esi
80104cd4:	73 2a                	jae    80104d00 <memmove+0x40>
80104cd6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104cd9:	39 fa                	cmp    %edi,%edx
80104cdb:	73 23                	jae    80104d00 <memmove+0x40>
80104cdd:	8d 41 ff             	lea    -0x1(%ecx),%eax
80104ce0:	85 c9                	test   %ecx,%ecx
80104ce2:	74 13                	je     80104cf7 <memmove+0x37>
80104ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ce8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104cec:	88 0c 02             	mov    %cl,(%edx,%eax,1)
80104cef:	83 e8 01             	sub    $0x1,%eax
80104cf2:	83 f8 ff             	cmp    $0xffffffff,%eax
80104cf5:	75 f1                	jne    80104ce8 <memmove+0x28>
80104cf7:	5e                   	pop    %esi
80104cf8:	89 d0                	mov    %edx,%eax
80104cfa:	5f                   	pop    %edi
80104cfb:	5d                   	pop    %ebp
80104cfc:	c3                   	ret    
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi
80104d00:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104d03:	89 d7                	mov    %edx,%edi
80104d05:	85 c9                	test   %ecx,%ecx
80104d07:	74 ee                	je     80104cf7 <memmove+0x37>
80104d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d10:	a4                   	movsb  %ds:(%esi),%es:(%edi)
80104d11:	39 f0                	cmp    %esi,%eax
80104d13:	75 fb                	jne    80104d10 <memmove+0x50>
80104d15:	5e                   	pop    %esi
80104d16:	89 d0                	mov    %edx,%eax
80104d18:	5f                   	pop    %edi
80104d19:	5d                   	pop    %ebp
80104d1a:	c3                   	ret    
80104d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d1f:	90                   	nop

80104d20 <memcpy>:
80104d20:	f3 0f 1e fb          	endbr32 
80104d24:	eb 9a                	jmp    80104cc0 <memmove>
80104d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2d:	8d 76 00             	lea    0x0(%esi),%esi

80104d30 <strncmp>:
80104d30:	f3 0f 1e fb          	endbr32 
80104d34:	55                   	push   %ebp
80104d35:	89 e5                	mov    %esp,%ebp
80104d37:	56                   	push   %esi
80104d38:	8b 75 10             	mov    0x10(%ebp),%esi
80104d3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d3e:	53                   	push   %ebx
80104d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d42:	85 f6                	test   %esi,%esi
80104d44:	74 32                	je     80104d78 <strncmp+0x48>
80104d46:	01 c6                	add    %eax,%esi
80104d48:	eb 14                	jmp    80104d5e <strncmp+0x2e>
80104d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d50:	38 da                	cmp    %bl,%dl
80104d52:	75 14                	jne    80104d68 <strncmp+0x38>
80104d54:	83 c0 01             	add    $0x1,%eax
80104d57:	83 c1 01             	add    $0x1,%ecx
80104d5a:	39 f0                	cmp    %esi,%eax
80104d5c:	74 1a                	je     80104d78 <strncmp+0x48>
80104d5e:	0f b6 11             	movzbl (%ecx),%edx
80104d61:	0f b6 18             	movzbl (%eax),%ebx
80104d64:	84 d2                	test   %dl,%dl
80104d66:	75 e8                	jne    80104d50 <strncmp+0x20>
80104d68:	0f b6 c2             	movzbl %dl,%eax
80104d6b:	29 d8                	sub    %ebx,%eax
80104d6d:	5b                   	pop    %ebx
80104d6e:	5e                   	pop    %esi
80104d6f:	5d                   	pop    %ebp
80104d70:	c3                   	ret    
80104d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d78:	5b                   	pop    %ebx
80104d79:	31 c0                	xor    %eax,%eax
80104d7b:	5e                   	pop    %esi
80104d7c:	5d                   	pop    %ebp
80104d7d:	c3                   	ret    
80104d7e:	66 90                	xchg   %ax,%ax

80104d80 <strncpy>:
80104d80:	f3 0f 1e fb          	endbr32 
80104d84:	55                   	push   %ebp
80104d85:	89 e5                	mov    %esp,%ebp
80104d87:	57                   	push   %edi
80104d88:	56                   	push   %esi
80104d89:	8b 75 08             	mov    0x8(%ebp),%esi
80104d8c:	53                   	push   %ebx
80104d8d:	8b 45 10             	mov    0x10(%ebp),%eax
80104d90:	89 f2                	mov    %esi,%edx
80104d92:	eb 1b                	jmp    80104daf <strncpy+0x2f>
80104d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d98:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104d9c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104d9f:	83 c2 01             	add    $0x1,%edx
80104da2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104da6:	89 f9                	mov    %edi,%ecx
80104da8:	88 4a ff             	mov    %cl,-0x1(%edx)
80104dab:	84 c9                	test   %cl,%cl
80104dad:	74 09                	je     80104db8 <strncpy+0x38>
80104daf:	89 c3                	mov    %eax,%ebx
80104db1:	83 e8 01             	sub    $0x1,%eax
80104db4:	85 db                	test   %ebx,%ebx
80104db6:	7f e0                	jg     80104d98 <strncpy+0x18>
80104db8:	89 d1                	mov    %edx,%ecx
80104dba:	85 c0                	test   %eax,%eax
80104dbc:	7e 15                	jle    80104dd3 <strncpy+0x53>
80104dbe:	66 90                	xchg   %ax,%ax
80104dc0:	83 c1 01             	add    $0x1,%ecx
80104dc3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
80104dc7:	89 c8                	mov    %ecx,%eax
80104dc9:	f7 d0                	not    %eax
80104dcb:	01 d0                	add    %edx,%eax
80104dcd:	01 d8                	add    %ebx,%eax
80104dcf:	85 c0                	test   %eax,%eax
80104dd1:	7f ed                	jg     80104dc0 <strncpy+0x40>
80104dd3:	5b                   	pop    %ebx
80104dd4:	89 f0                	mov    %esi,%eax
80104dd6:	5e                   	pop    %esi
80104dd7:	5f                   	pop    %edi
80104dd8:	5d                   	pop    %ebp
80104dd9:	c3                   	ret    
80104dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104de0 <safestrcpy>:
80104de0:	f3 0f 1e fb          	endbr32 
80104de4:	55                   	push   %ebp
80104de5:	89 e5                	mov    %esp,%ebp
80104de7:	56                   	push   %esi
80104de8:	8b 55 10             	mov    0x10(%ebp),%edx
80104deb:	8b 75 08             	mov    0x8(%ebp),%esi
80104dee:	53                   	push   %ebx
80104def:	8b 45 0c             	mov    0xc(%ebp),%eax
80104df2:	85 d2                	test   %edx,%edx
80104df4:	7e 21                	jle    80104e17 <safestrcpy+0x37>
80104df6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104dfa:	89 f2                	mov    %esi,%edx
80104dfc:	eb 12                	jmp    80104e10 <safestrcpy+0x30>
80104dfe:	66 90                	xchg   %ax,%ax
80104e00:	0f b6 08             	movzbl (%eax),%ecx
80104e03:	83 c0 01             	add    $0x1,%eax
80104e06:	83 c2 01             	add    $0x1,%edx
80104e09:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e0c:	84 c9                	test   %cl,%cl
80104e0e:	74 04                	je     80104e14 <safestrcpy+0x34>
80104e10:	39 d8                	cmp    %ebx,%eax
80104e12:	75 ec                	jne    80104e00 <safestrcpy+0x20>
80104e14:	c6 02 00             	movb   $0x0,(%edx)
80104e17:	89 f0                	mov    %esi,%eax
80104e19:	5b                   	pop    %ebx
80104e1a:	5e                   	pop    %esi
80104e1b:	5d                   	pop    %ebp
80104e1c:	c3                   	ret    
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi

80104e20 <strlen>:
80104e20:	f3 0f 1e fb          	endbr32 
80104e24:	55                   	push   %ebp
80104e25:	31 c0                	xor    %eax,%eax
80104e27:	89 e5                	mov    %esp,%ebp
80104e29:	8b 55 08             	mov    0x8(%ebp),%edx
80104e2c:	80 3a 00             	cmpb   $0x0,(%edx)
80104e2f:	74 10                	je     80104e41 <strlen+0x21>
80104e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e38:	83 c0 01             	add    $0x1,%eax
80104e3b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104e3f:	75 f7                	jne    80104e38 <strlen+0x18>
80104e41:	5d                   	pop    %ebp
80104e42:	c3                   	ret    

80104e43 <swtch>:
80104e43:	8b 44 24 04          	mov    0x4(%esp),%eax
80104e47:	8b 54 24 08          	mov    0x8(%esp),%edx
80104e4b:	55                   	push   %ebp
80104e4c:	53                   	push   %ebx
80104e4d:	56                   	push   %esi
80104e4e:	57                   	push   %edi
80104e4f:	89 20                	mov    %esp,(%eax)
80104e51:	89 d4                	mov    %edx,%esp
80104e53:	5f                   	pop    %edi
80104e54:	5e                   	pop    %esi
80104e55:	5b                   	pop    %ebx
80104e56:	5d                   	pop    %ebp
80104e57:	c3                   	ret    
80104e58:	66 90                	xchg   %ax,%ax
80104e5a:	66 90                	xchg   %ax,%ax
80104e5c:	66 90                	xchg   %ax,%ax
80104e5e:	66 90                	xchg   %ax,%ax

80104e60 <fetchint>:
80104e60:	f3 0f 1e fb          	endbr32 
80104e64:	55                   	push   %ebp
80104e65:	89 e5                	mov    %esp,%ebp
80104e67:	53                   	push   %ebx
80104e68:	83 ec 04             	sub    $0x4,%esp
80104e6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e6e:	e8 9d f0 ff ff       	call   80103f10 <myproc>
80104e73:	8b 00                	mov    (%eax),%eax
80104e75:	39 d8                	cmp    %ebx,%eax
80104e77:	76 17                	jbe    80104e90 <fetchint+0x30>
80104e79:	8d 53 04             	lea    0x4(%ebx),%edx
80104e7c:	39 d0                	cmp    %edx,%eax
80104e7e:	72 10                	jb     80104e90 <fetchint+0x30>
80104e80:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e83:	8b 13                	mov    (%ebx),%edx
80104e85:	89 10                	mov    %edx,(%eax)
80104e87:	31 c0                	xor    %eax,%eax
80104e89:	83 c4 04             	add    $0x4,%esp
80104e8c:	5b                   	pop    %ebx
80104e8d:	5d                   	pop    %ebp
80104e8e:	c3                   	ret    
80104e8f:	90                   	nop
80104e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e95:	eb f2                	jmp    80104e89 <fetchint+0x29>
80104e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9e:	66 90                	xchg   %ax,%ax

80104ea0 <fetchstr>:
80104ea0:	f3 0f 1e fb          	endbr32 
80104ea4:	55                   	push   %ebp
80104ea5:	89 e5                	mov    %esp,%ebp
80104ea7:	53                   	push   %ebx
80104ea8:	83 ec 04             	sub    $0x4,%esp
80104eab:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104eae:	e8 5d f0 ff ff       	call   80103f10 <myproc>
80104eb3:	39 18                	cmp    %ebx,(%eax)
80104eb5:	76 31                	jbe    80104ee8 <fetchstr+0x48>
80104eb7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104eba:	89 1a                	mov    %ebx,(%edx)
80104ebc:	8b 10                	mov    (%eax),%edx
80104ebe:	39 d3                	cmp    %edx,%ebx
80104ec0:	73 26                	jae    80104ee8 <fetchstr+0x48>
80104ec2:	89 d8                	mov    %ebx,%eax
80104ec4:	eb 11                	jmp    80104ed7 <fetchstr+0x37>
80104ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi
80104ed0:	83 c0 01             	add    $0x1,%eax
80104ed3:	39 c2                	cmp    %eax,%edx
80104ed5:	76 11                	jbe    80104ee8 <fetchstr+0x48>
80104ed7:	80 38 00             	cmpb   $0x0,(%eax)
80104eda:	75 f4                	jne    80104ed0 <fetchstr+0x30>
80104edc:	83 c4 04             	add    $0x4,%esp
80104edf:	29 d8                	sub    %ebx,%eax
80104ee1:	5b                   	pop    %ebx
80104ee2:	5d                   	pop    %ebp
80104ee3:	c3                   	ret    
80104ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ee8:	83 c4 04             	add    $0x4,%esp
80104eeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ef0:	5b                   	pop    %ebx
80104ef1:	5d                   	pop    %ebp
80104ef2:	c3                   	ret    
80104ef3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f00 <argint>:
80104f00:	f3 0f 1e fb          	endbr32 
80104f04:	55                   	push   %ebp
80104f05:	89 e5                	mov    %esp,%ebp
80104f07:	56                   	push   %esi
80104f08:	53                   	push   %ebx
80104f09:	e8 02 f0 ff ff       	call   80103f10 <myproc>
80104f0e:	8b 55 08             	mov    0x8(%ebp),%edx
80104f11:	8b 40 18             	mov    0x18(%eax),%eax
80104f14:	8b 40 44             	mov    0x44(%eax),%eax
80104f17:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
80104f1a:	e8 f1 ef ff ff       	call   80103f10 <myproc>
80104f1f:	8d 73 04             	lea    0x4(%ebx),%esi
80104f22:	8b 00                	mov    (%eax),%eax
80104f24:	39 c6                	cmp    %eax,%esi
80104f26:	73 18                	jae    80104f40 <argint+0x40>
80104f28:	8d 53 08             	lea    0x8(%ebx),%edx
80104f2b:	39 d0                	cmp    %edx,%eax
80104f2d:	72 11                	jb     80104f40 <argint+0x40>
80104f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f32:	8b 53 04             	mov    0x4(%ebx),%edx
80104f35:	89 10                	mov    %edx,(%eax)
80104f37:	31 c0                	xor    %eax,%eax
80104f39:	5b                   	pop    %ebx
80104f3a:	5e                   	pop    %esi
80104f3b:	5d                   	pop    %ebp
80104f3c:	c3                   	ret    
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi
80104f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f45:	eb f2                	jmp    80104f39 <argint+0x39>
80104f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f4e:	66 90                	xchg   %ax,%ax

80104f50 <argptr>:
80104f50:	f3 0f 1e fb          	endbr32 
80104f54:	55                   	push   %ebp
80104f55:	89 e5                	mov    %esp,%ebp
80104f57:	56                   	push   %esi
80104f58:	53                   	push   %ebx
80104f59:	83 ec 10             	sub    $0x10,%esp
80104f5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104f5f:	e8 ac ef ff ff       	call   80103f10 <myproc>
80104f64:	83 ec 08             	sub    $0x8,%esp
80104f67:	89 c6                	mov    %eax,%esi
80104f69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f6c:	50                   	push   %eax
80104f6d:	ff 75 08             	pushl  0x8(%ebp)
80104f70:	e8 8b ff ff ff       	call   80104f00 <argint>
80104f75:	83 c4 10             	add    $0x10,%esp
80104f78:	85 c0                	test   %eax,%eax
80104f7a:	78 24                	js     80104fa0 <argptr+0x50>
80104f7c:	85 db                	test   %ebx,%ebx
80104f7e:	78 20                	js     80104fa0 <argptr+0x50>
80104f80:	8b 16                	mov    (%esi),%edx
80104f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f85:	39 c2                	cmp    %eax,%edx
80104f87:	76 17                	jbe    80104fa0 <argptr+0x50>
80104f89:	01 c3                	add    %eax,%ebx
80104f8b:	39 da                	cmp    %ebx,%edx
80104f8d:	72 11                	jb     80104fa0 <argptr+0x50>
80104f8f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f92:	89 02                	mov    %eax,(%edx)
80104f94:	31 c0                	xor    %eax,%eax
80104f96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f99:	5b                   	pop    %ebx
80104f9a:	5e                   	pop    %esi
80104f9b:	5d                   	pop    %ebp
80104f9c:	c3                   	ret    
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi
80104fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fa5:	eb ef                	jmp    80104f96 <argptr+0x46>
80104fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fae:	66 90                	xchg   %ax,%ax

80104fb0 <argstr>:
80104fb0:	f3 0f 1e fb          	endbr32 
80104fb4:	55                   	push   %ebp
80104fb5:	89 e5                	mov    %esp,%ebp
80104fb7:	83 ec 20             	sub    $0x20,%esp
80104fba:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fbd:	50                   	push   %eax
80104fbe:	ff 75 08             	pushl  0x8(%ebp)
80104fc1:	e8 3a ff ff ff       	call   80104f00 <argint>
80104fc6:	83 c4 10             	add    $0x10,%esp
80104fc9:	85 c0                	test   %eax,%eax
80104fcb:	78 13                	js     80104fe0 <argstr+0x30>
80104fcd:	83 ec 08             	sub    $0x8,%esp
80104fd0:	ff 75 0c             	pushl  0xc(%ebp)
80104fd3:	ff 75 f4             	pushl  -0xc(%ebp)
80104fd6:	e8 c5 fe ff ff       	call   80104ea0 <fetchstr>
80104fdb:	83 c4 10             	add    $0x10,%esp
80104fde:	c9                   	leave  
80104fdf:	c3                   	ret    
80104fe0:	c9                   	leave  
80104fe1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fe6:	c3                   	ret    
80104fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fee:	66 90                	xchg   %ax,%ax

80104ff0 <syscall>:
80104ff0:	f3 0f 1e fb          	endbr32 
80104ff4:	55                   	push   %ebp
80104ff5:	89 e5                	mov    %esp,%ebp
80104ff7:	53                   	push   %ebx
80104ff8:	83 ec 04             	sub    $0x4,%esp
80104ffb:	e8 10 ef ff ff       	call   80103f10 <myproc>
80105000:	89 c3                	mov    %eax,%ebx
80105002:	8b 40 18             	mov    0x18(%eax),%eax
80105005:	8b 40 1c             	mov    0x1c(%eax),%eax
80105008:	8d 50 ff             	lea    -0x1(%eax),%edx
8010500b:	83 fa 14             	cmp    $0x14,%edx
8010500e:	77 20                	ja     80105030 <syscall+0x40>
80105010:	8b 14 85 c0 7d 10 80 	mov    -0x7fef8240(,%eax,4),%edx
80105017:	85 d2                	test   %edx,%edx
80105019:	74 15                	je     80105030 <syscall+0x40>
8010501b:	ff d2                	call   *%edx
8010501d:	89 c2                	mov    %eax,%edx
8010501f:	8b 43 18             	mov    0x18(%ebx),%eax
80105022:	89 50 1c             	mov    %edx,0x1c(%eax)
80105025:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105028:	c9                   	leave  
80105029:	c3                   	ret    
8010502a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105030:	50                   	push   %eax
80105031:	8d 43 6c             	lea    0x6c(%ebx),%eax
80105034:	50                   	push   %eax
80105035:	ff 73 10             	pushl  0x10(%ebx)
80105038:	68 9d 7d 10 80       	push   $0x80107d9d
8010503d:	e8 3e b9 ff ff       	call   80100980 <cprintf>
80105042:	8b 43 18             	mov    0x18(%ebx),%eax
80105045:	83 c4 10             	add    $0x10,%esp
80105048:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
8010504f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105052:	c9                   	leave  
80105053:	c3                   	ret    
80105054:	66 90                	xchg   %ax,%ax
80105056:	66 90                	xchg   %ax,%ax
80105058:	66 90                	xchg   %ax,%ax
8010505a:	66 90                	xchg   %ax,%ax
8010505c:	66 90                	xchg   %ax,%ax
8010505e:	66 90                	xchg   %ax,%ax

80105060 <create>:
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
80105065:	8d 7d da             	lea    -0x26(%ebp),%edi
80105068:	53                   	push   %ebx
80105069:	83 ec 34             	sub    $0x34,%esp
8010506c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010506f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105072:	57                   	push   %edi
80105073:	50                   	push   %eax
80105074:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105077:	89 4d cc             	mov    %ecx,-0x34(%ebp)
8010507a:	e8 81 d5 ff ff       	call   80102600 <nameiparent>
8010507f:	83 c4 10             	add    $0x10,%esp
80105082:	85 c0                	test   %eax,%eax
80105084:	0f 84 46 01 00 00    	je     801051d0 <create+0x170>
8010508a:	83 ec 0c             	sub    $0xc,%esp
8010508d:	89 c3                	mov    %eax,%ebx
8010508f:	50                   	push   %eax
80105090:	e8 7b cc ff ff       	call   80101d10 <ilock>
80105095:	83 c4 0c             	add    $0xc,%esp
80105098:	6a 00                	push   $0x0
8010509a:	57                   	push   %edi
8010509b:	53                   	push   %ebx
8010509c:	e8 bf d1 ff ff       	call   80102260 <dirlookup>
801050a1:	83 c4 10             	add    $0x10,%esp
801050a4:	89 c6                	mov    %eax,%esi
801050a6:	85 c0                	test   %eax,%eax
801050a8:	74 56                	je     80105100 <create+0xa0>
801050aa:	83 ec 0c             	sub    $0xc,%esp
801050ad:	53                   	push   %ebx
801050ae:	e8 fd ce ff ff       	call   80101fb0 <iunlockput>
801050b3:	89 34 24             	mov    %esi,(%esp)
801050b6:	e8 55 cc ff ff       	call   80101d10 <ilock>
801050bb:	83 c4 10             	add    $0x10,%esp
801050be:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801050c3:	75 1b                	jne    801050e0 <create+0x80>
801050c5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801050ca:	75 14                	jne    801050e0 <create+0x80>
801050cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050cf:	89 f0                	mov    %esi,%eax
801050d1:	5b                   	pop    %ebx
801050d2:	5e                   	pop    %esi
801050d3:	5f                   	pop    %edi
801050d4:	5d                   	pop    %ebp
801050d5:	c3                   	ret    
801050d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050dd:	8d 76 00             	lea    0x0(%esi),%esi
801050e0:	83 ec 0c             	sub    $0xc,%esp
801050e3:	56                   	push   %esi
801050e4:	31 f6                	xor    %esi,%esi
801050e6:	e8 c5 ce ff ff       	call   80101fb0 <iunlockput>
801050eb:	83 c4 10             	add    $0x10,%esp
801050ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050f1:	89 f0                	mov    %esi,%eax
801050f3:	5b                   	pop    %ebx
801050f4:	5e                   	pop    %esi
801050f5:	5f                   	pop    %edi
801050f6:	5d                   	pop    %ebp
801050f7:	c3                   	ret    
801050f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ff:	90                   	nop
80105100:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105104:	83 ec 08             	sub    $0x8,%esp
80105107:	50                   	push   %eax
80105108:	ff 33                	pushl  (%ebx)
8010510a:	e8 81 ca ff ff       	call   80101b90 <ialloc>
8010510f:	83 c4 10             	add    $0x10,%esp
80105112:	89 c6                	mov    %eax,%esi
80105114:	85 c0                	test   %eax,%eax
80105116:	0f 84 cd 00 00 00    	je     801051e9 <create+0x189>
8010511c:	83 ec 0c             	sub    $0xc,%esp
8010511f:	50                   	push   %eax
80105120:	e8 eb cb ff ff       	call   80101d10 <ilock>
80105125:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105129:	66 89 46 52          	mov    %ax,0x52(%esi)
8010512d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105131:	66 89 46 54          	mov    %ax,0x54(%esi)
80105135:	b8 01 00 00 00       	mov    $0x1,%eax
8010513a:	66 89 46 56          	mov    %ax,0x56(%esi)
8010513e:	89 34 24             	mov    %esi,(%esp)
80105141:	e8 0a cb ff ff       	call   80101c50 <iupdate>
80105146:	83 c4 10             	add    $0x10,%esp
80105149:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010514e:	74 30                	je     80105180 <create+0x120>
80105150:	83 ec 04             	sub    $0x4,%esp
80105153:	ff 76 04             	pushl  0x4(%esi)
80105156:	57                   	push   %edi
80105157:	53                   	push   %ebx
80105158:	e8 c3 d3 ff ff       	call   80102520 <dirlink>
8010515d:	83 c4 10             	add    $0x10,%esp
80105160:	85 c0                	test   %eax,%eax
80105162:	78 78                	js     801051dc <create+0x17c>
80105164:	83 ec 0c             	sub    $0xc,%esp
80105167:	53                   	push   %ebx
80105168:	e8 43 ce ff ff       	call   80101fb0 <iunlockput>
8010516d:	83 c4 10             	add    $0x10,%esp
80105170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105173:	89 f0                	mov    %esi,%eax
80105175:	5b                   	pop    %ebx
80105176:	5e                   	pop    %esi
80105177:	5f                   	pop    %edi
80105178:	5d                   	pop    %ebp
80105179:	c3                   	ret    
8010517a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105180:	83 ec 0c             	sub    $0xc,%esp
80105183:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
80105188:	53                   	push   %ebx
80105189:	e8 c2 ca ff ff       	call   80101c50 <iupdate>
8010518e:	83 c4 0c             	add    $0xc,%esp
80105191:	ff 76 04             	pushl  0x4(%esi)
80105194:	68 34 7e 10 80       	push   $0x80107e34
80105199:	56                   	push   %esi
8010519a:	e8 81 d3 ff ff       	call   80102520 <dirlink>
8010519f:	83 c4 10             	add    $0x10,%esp
801051a2:	85 c0                	test   %eax,%eax
801051a4:	78 18                	js     801051be <create+0x15e>
801051a6:	83 ec 04             	sub    $0x4,%esp
801051a9:	ff 73 04             	pushl  0x4(%ebx)
801051ac:	68 33 7e 10 80       	push   $0x80107e33
801051b1:	56                   	push   %esi
801051b2:	e8 69 d3 ff ff       	call   80102520 <dirlink>
801051b7:	83 c4 10             	add    $0x10,%esp
801051ba:	85 c0                	test   %eax,%eax
801051bc:	79 92                	jns    80105150 <create+0xf0>
801051be:	83 ec 0c             	sub    $0xc,%esp
801051c1:	68 27 7e 10 80       	push   $0x80107e27
801051c6:	e8 c5 b1 ff ff       	call   80100390 <panic>
801051cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051cf:	90                   	nop
801051d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051d3:	31 f6                	xor    %esi,%esi
801051d5:	5b                   	pop    %ebx
801051d6:	89 f0                	mov    %esi,%eax
801051d8:	5e                   	pop    %esi
801051d9:	5f                   	pop    %edi
801051da:	5d                   	pop    %ebp
801051db:	c3                   	ret    
801051dc:	83 ec 0c             	sub    $0xc,%esp
801051df:	68 36 7e 10 80       	push   $0x80107e36
801051e4:	e8 a7 b1 ff ff       	call   80100390 <panic>
801051e9:	83 ec 0c             	sub    $0xc,%esp
801051ec:	68 18 7e 10 80       	push   $0x80107e18
801051f1:	e8 9a b1 ff ff       	call   80100390 <panic>
801051f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051fd:	8d 76 00             	lea    0x0(%esi),%esi

80105200 <argfd.constprop.0>:
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	56                   	push   %esi
80105204:	89 d6                	mov    %edx,%esi
80105206:	53                   	push   %ebx
80105207:	89 c3                	mov    %eax,%ebx
80105209:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010520c:	83 ec 18             	sub    $0x18,%esp
8010520f:	50                   	push   %eax
80105210:	6a 00                	push   $0x0
80105212:	e8 e9 fc ff ff       	call   80104f00 <argint>
80105217:	83 c4 10             	add    $0x10,%esp
8010521a:	85 c0                	test   %eax,%eax
8010521c:	78 2a                	js     80105248 <argfd.constprop.0+0x48>
8010521e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105222:	77 24                	ja     80105248 <argfd.constprop.0+0x48>
80105224:	e8 e7 ec ff ff       	call   80103f10 <myproc>
80105229:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010522c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105230:	85 c0                	test   %eax,%eax
80105232:	74 14                	je     80105248 <argfd.constprop.0+0x48>
80105234:	85 db                	test   %ebx,%ebx
80105236:	74 02                	je     8010523a <argfd.constprop.0+0x3a>
80105238:	89 13                	mov    %edx,(%ebx)
8010523a:	89 06                	mov    %eax,(%esi)
8010523c:	31 c0                	xor    %eax,%eax
8010523e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105241:	5b                   	pop    %ebx
80105242:	5e                   	pop    %esi
80105243:	5d                   	pop    %ebp
80105244:	c3                   	ret    
80105245:	8d 76 00             	lea    0x0(%esi),%esi
80105248:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010524d:	eb ef                	jmp    8010523e <argfd.constprop.0+0x3e>
8010524f:	90                   	nop

80105250 <sys_dup>:
80105250:	f3 0f 1e fb          	endbr32 
80105254:	55                   	push   %ebp
80105255:	31 c0                	xor    %eax,%eax
80105257:	89 e5                	mov    %esp,%ebp
80105259:	56                   	push   %esi
8010525a:	53                   	push   %ebx
8010525b:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010525e:	83 ec 10             	sub    $0x10,%esp
80105261:	e8 9a ff ff ff       	call   80105200 <argfd.constprop.0>
80105266:	85 c0                	test   %eax,%eax
80105268:	78 1e                	js     80105288 <sys_dup+0x38>
8010526a:	8b 75 f4             	mov    -0xc(%ebp),%esi
8010526d:	31 db                	xor    %ebx,%ebx
8010526f:	e8 9c ec ff ff       	call   80103f10 <myproc>
80105274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105278:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010527c:	85 d2                	test   %edx,%edx
8010527e:	74 20                	je     801052a0 <sys_dup+0x50>
80105280:	83 c3 01             	add    $0x1,%ebx
80105283:	83 fb 10             	cmp    $0x10,%ebx
80105286:	75 f0                	jne    80105278 <sys_dup+0x28>
80105288:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010528b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105290:	89 d8                	mov    %ebx,%eax
80105292:	5b                   	pop    %ebx
80105293:	5e                   	pop    %esi
80105294:	5d                   	pop    %ebp
80105295:	c3                   	ret    
80105296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010529d:	8d 76 00             	lea    0x0(%esi),%esi
801052a0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
801052a4:	83 ec 0c             	sub    $0xc,%esp
801052a7:	ff 75 f4             	pushl  -0xc(%ebp)
801052aa:	e8 71 c1 ff ff       	call   80101420 <filedup>
801052af:	83 c4 10             	add    $0x10,%esp
801052b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052b5:	89 d8                	mov    %ebx,%eax
801052b7:	5b                   	pop    %ebx
801052b8:	5e                   	pop    %esi
801052b9:	5d                   	pop    %ebp
801052ba:	c3                   	ret    
801052bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052bf:	90                   	nop

801052c0 <sys_read>:
801052c0:	f3 0f 1e fb          	endbr32 
801052c4:	55                   	push   %ebp
801052c5:	31 c0                	xor    %eax,%eax
801052c7:	89 e5                	mov    %esp,%ebp
801052c9:	83 ec 18             	sub    $0x18,%esp
801052cc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801052cf:	e8 2c ff ff ff       	call   80105200 <argfd.constprop.0>
801052d4:	85 c0                	test   %eax,%eax
801052d6:	78 48                	js     80105320 <sys_read+0x60>
801052d8:	83 ec 08             	sub    $0x8,%esp
801052db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052de:	50                   	push   %eax
801052df:	6a 02                	push   $0x2
801052e1:	e8 1a fc ff ff       	call   80104f00 <argint>
801052e6:	83 c4 10             	add    $0x10,%esp
801052e9:	85 c0                	test   %eax,%eax
801052eb:	78 33                	js     80105320 <sys_read+0x60>
801052ed:	83 ec 04             	sub    $0x4,%esp
801052f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052f3:	ff 75 f0             	pushl  -0x10(%ebp)
801052f6:	50                   	push   %eax
801052f7:	6a 01                	push   $0x1
801052f9:	e8 52 fc ff ff       	call   80104f50 <argptr>
801052fe:	83 c4 10             	add    $0x10,%esp
80105301:	85 c0                	test   %eax,%eax
80105303:	78 1b                	js     80105320 <sys_read+0x60>
80105305:	83 ec 04             	sub    $0x4,%esp
80105308:	ff 75 f0             	pushl  -0x10(%ebp)
8010530b:	ff 75 f4             	pushl  -0xc(%ebp)
8010530e:	ff 75 ec             	pushl  -0x14(%ebp)
80105311:	e8 8a c2 ff ff       	call   801015a0 <fileread>
80105316:	83 c4 10             	add    $0x10,%esp
80105319:	c9                   	leave  
8010531a:	c3                   	ret    
8010531b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010531f:	90                   	nop
80105320:	c9                   	leave  
80105321:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105326:	c3                   	ret    
80105327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532e:	66 90                	xchg   %ax,%ax

80105330 <sys_write>:
80105330:	f3 0f 1e fb          	endbr32 
80105334:	55                   	push   %ebp
80105335:	31 c0                	xor    %eax,%eax
80105337:	89 e5                	mov    %esp,%ebp
80105339:	83 ec 18             	sub    $0x18,%esp
8010533c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010533f:	e8 bc fe ff ff       	call   80105200 <argfd.constprop.0>
80105344:	85 c0                	test   %eax,%eax
80105346:	78 48                	js     80105390 <sys_write+0x60>
80105348:	83 ec 08             	sub    $0x8,%esp
8010534b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010534e:	50                   	push   %eax
8010534f:	6a 02                	push   $0x2
80105351:	e8 aa fb ff ff       	call   80104f00 <argint>
80105356:	83 c4 10             	add    $0x10,%esp
80105359:	85 c0                	test   %eax,%eax
8010535b:	78 33                	js     80105390 <sys_write+0x60>
8010535d:	83 ec 04             	sub    $0x4,%esp
80105360:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105363:	ff 75 f0             	pushl  -0x10(%ebp)
80105366:	50                   	push   %eax
80105367:	6a 01                	push   $0x1
80105369:	e8 e2 fb ff ff       	call   80104f50 <argptr>
8010536e:	83 c4 10             	add    $0x10,%esp
80105371:	85 c0                	test   %eax,%eax
80105373:	78 1b                	js     80105390 <sys_write+0x60>
80105375:	83 ec 04             	sub    $0x4,%esp
80105378:	ff 75 f0             	pushl  -0x10(%ebp)
8010537b:	ff 75 f4             	pushl  -0xc(%ebp)
8010537e:	ff 75 ec             	pushl  -0x14(%ebp)
80105381:	e8 ba c2 ff ff       	call   80101640 <filewrite>
80105386:	83 c4 10             	add    $0x10,%esp
80105389:	c9                   	leave  
8010538a:	c3                   	ret    
8010538b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010538f:	90                   	nop
80105390:	c9                   	leave  
80105391:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105396:	c3                   	ret    
80105397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010539e:	66 90                	xchg   %ax,%ax

801053a0 <sys_close>:
801053a0:	f3 0f 1e fb          	endbr32 
801053a4:	55                   	push   %ebp
801053a5:	89 e5                	mov    %esp,%ebp
801053a7:	83 ec 18             	sub    $0x18,%esp
801053aa:	8d 55 f4             	lea    -0xc(%ebp),%edx
801053ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053b0:	e8 4b fe ff ff       	call   80105200 <argfd.constprop.0>
801053b5:	85 c0                	test   %eax,%eax
801053b7:	78 27                	js     801053e0 <sys_close+0x40>
801053b9:	e8 52 eb ff ff       	call   80103f10 <myproc>
801053be:	8b 55 f0             	mov    -0x10(%ebp),%edx
801053c1:	83 ec 0c             	sub    $0xc,%esp
801053c4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801053cb:	00 
801053cc:	ff 75 f4             	pushl  -0xc(%ebp)
801053cf:	e8 9c c0 ff ff       	call   80101470 <fileclose>
801053d4:	83 c4 10             	add    $0x10,%esp
801053d7:	31 c0                	xor    %eax,%eax
801053d9:	c9                   	leave  
801053da:	c3                   	ret    
801053db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053df:	90                   	nop
801053e0:	c9                   	leave  
801053e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e6:	c3                   	ret    
801053e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ee:	66 90                	xchg   %ax,%ax

801053f0 <sys_fstat>:
801053f0:	f3 0f 1e fb          	endbr32 
801053f4:	55                   	push   %ebp
801053f5:	31 c0                	xor    %eax,%eax
801053f7:	89 e5                	mov    %esp,%ebp
801053f9:	83 ec 18             	sub    $0x18,%esp
801053fc:	8d 55 f0             	lea    -0x10(%ebp),%edx
801053ff:	e8 fc fd ff ff       	call   80105200 <argfd.constprop.0>
80105404:	85 c0                	test   %eax,%eax
80105406:	78 30                	js     80105438 <sys_fstat+0x48>
80105408:	83 ec 04             	sub    $0x4,%esp
8010540b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010540e:	6a 14                	push   $0x14
80105410:	50                   	push   %eax
80105411:	6a 01                	push   $0x1
80105413:	e8 38 fb ff ff       	call   80104f50 <argptr>
80105418:	83 c4 10             	add    $0x10,%esp
8010541b:	85 c0                	test   %eax,%eax
8010541d:	78 19                	js     80105438 <sys_fstat+0x48>
8010541f:	83 ec 08             	sub    $0x8,%esp
80105422:	ff 75 f4             	pushl  -0xc(%ebp)
80105425:	ff 75 f0             	pushl  -0x10(%ebp)
80105428:	e8 23 c1 ff ff       	call   80101550 <filestat>
8010542d:	83 c4 10             	add    $0x10,%esp
80105430:	c9                   	leave  
80105431:	c3                   	ret    
80105432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105438:	c9                   	leave  
80105439:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543e:	c3                   	ret    
8010543f:	90                   	nop

80105440 <sys_link>:
80105440:	f3 0f 1e fb          	endbr32 
80105444:	55                   	push   %ebp
80105445:	89 e5                	mov    %esp,%ebp
80105447:	57                   	push   %edi
80105448:	56                   	push   %esi
80105449:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010544c:	53                   	push   %ebx
8010544d:	83 ec 34             	sub    $0x34,%esp
80105450:	50                   	push   %eax
80105451:	6a 00                	push   $0x0
80105453:	e8 58 fb ff ff       	call   80104fb0 <argstr>
80105458:	83 c4 10             	add    $0x10,%esp
8010545b:	85 c0                	test   %eax,%eax
8010545d:	0f 88 ff 00 00 00    	js     80105562 <sys_link+0x122>
80105463:	83 ec 08             	sub    $0x8,%esp
80105466:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105469:	50                   	push   %eax
8010546a:	6a 01                	push   $0x1
8010546c:	e8 3f fb ff ff       	call   80104fb0 <argstr>
80105471:	83 c4 10             	add    $0x10,%esp
80105474:	85 c0                	test   %eax,%eax
80105476:	0f 88 e6 00 00 00    	js     80105562 <sys_link+0x122>
8010547c:	e8 5f de ff ff       	call   801032e0 <begin_op>
80105481:	83 ec 0c             	sub    $0xc,%esp
80105484:	ff 75 d4             	pushl  -0x2c(%ebp)
80105487:	e8 54 d1 ff ff       	call   801025e0 <namei>
8010548c:	83 c4 10             	add    $0x10,%esp
8010548f:	89 c3                	mov    %eax,%ebx
80105491:	85 c0                	test   %eax,%eax
80105493:	0f 84 e8 00 00 00    	je     80105581 <sys_link+0x141>
80105499:	83 ec 0c             	sub    $0xc,%esp
8010549c:	50                   	push   %eax
8010549d:	e8 6e c8 ff ff       	call   80101d10 <ilock>
801054a2:	83 c4 10             	add    $0x10,%esp
801054a5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054aa:	0f 84 b9 00 00 00    	je     80105569 <sys_link+0x129>
801054b0:	83 ec 0c             	sub    $0xc,%esp
801054b3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
801054b8:	8d 7d da             	lea    -0x26(%ebp),%edi
801054bb:	53                   	push   %ebx
801054bc:	e8 8f c7 ff ff       	call   80101c50 <iupdate>
801054c1:	89 1c 24             	mov    %ebx,(%esp)
801054c4:	e8 27 c9 ff ff       	call   80101df0 <iunlock>
801054c9:	58                   	pop    %eax
801054ca:	5a                   	pop    %edx
801054cb:	57                   	push   %edi
801054cc:	ff 75 d0             	pushl  -0x30(%ebp)
801054cf:	e8 2c d1 ff ff       	call   80102600 <nameiparent>
801054d4:	83 c4 10             	add    $0x10,%esp
801054d7:	89 c6                	mov    %eax,%esi
801054d9:	85 c0                	test   %eax,%eax
801054db:	74 5f                	je     8010553c <sys_link+0xfc>
801054dd:	83 ec 0c             	sub    $0xc,%esp
801054e0:	50                   	push   %eax
801054e1:	e8 2a c8 ff ff       	call   80101d10 <ilock>
801054e6:	8b 03                	mov    (%ebx),%eax
801054e8:	83 c4 10             	add    $0x10,%esp
801054eb:	39 06                	cmp    %eax,(%esi)
801054ed:	75 41                	jne    80105530 <sys_link+0xf0>
801054ef:	83 ec 04             	sub    $0x4,%esp
801054f2:	ff 73 04             	pushl  0x4(%ebx)
801054f5:	57                   	push   %edi
801054f6:	56                   	push   %esi
801054f7:	e8 24 d0 ff ff       	call   80102520 <dirlink>
801054fc:	83 c4 10             	add    $0x10,%esp
801054ff:	85 c0                	test   %eax,%eax
80105501:	78 2d                	js     80105530 <sys_link+0xf0>
80105503:	83 ec 0c             	sub    $0xc,%esp
80105506:	56                   	push   %esi
80105507:	e8 a4 ca ff ff       	call   80101fb0 <iunlockput>
8010550c:	89 1c 24             	mov    %ebx,(%esp)
8010550f:	e8 2c c9 ff ff       	call   80101e40 <iput>
80105514:	e8 37 de ff ff       	call   80103350 <end_op>
80105519:	83 c4 10             	add    $0x10,%esp
8010551c:	31 c0                	xor    %eax,%eax
8010551e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105521:	5b                   	pop    %ebx
80105522:	5e                   	pop    %esi
80105523:	5f                   	pop    %edi
80105524:	5d                   	pop    %ebp
80105525:	c3                   	ret    
80105526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552d:	8d 76 00             	lea    0x0(%esi),%esi
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	56                   	push   %esi
80105534:	e8 77 ca ff ff       	call   80101fb0 <iunlockput>
80105539:	83 c4 10             	add    $0x10,%esp
8010553c:	83 ec 0c             	sub    $0xc,%esp
8010553f:	53                   	push   %ebx
80105540:	e8 cb c7 ff ff       	call   80101d10 <ilock>
80105545:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
8010554a:	89 1c 24             	mov    %ebx,(%esp)
8010554d:	e8 fe c6 ff ff       	call   80101c50 <iupdate>
80105552:	89 1c 24             	mov    %ebx,(%esp)
80105555:	e8 56 ca ff ff       	call   80101fb0 <iunlockput>
8010555a:	e8 f1 dd ff ff       	call   80103350 <end_op>
8010555f:	83 c4 10             	add    $0x10,%esp
80105562:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105567:	eb b5                	jmp    8010551e <sys_link+0xde>
80105569:	83 ec 0c             	sub    $0xc,%esp
8010556c:	53                   	push   %ebx
8010556d:	e8 3e ca ff ff       	call   80101fb0 <iunlockput>
80105572:	e8 d9 dd ff ff       	call   80103350 <end_op>
80105577:	83 c4 10             	add    $0x10,%esp
8010557a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557f:	eb 9d                	jmp    8010551e <sys_link+0xde>
80105581:	e8 ca dd ff ff       	call   80103350 <end_op>
80105586:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010558b:	eb 91                	jmp    8010551e <sys_link+0xde>
8010558d:	8d 76 00             	lea    0x0(%esi),%esi

80105590 <sys_unlink>:
80105590:	f3 0f 1e fb          	endbr32 
80105594:	55                   	push   %ebp
80105595:	89 e5                	mov    %esp,%ebp
80105597:	57                   	push   %edi
80105598:	56                   	push   %esi
80105599:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010559c:	53                   	push   %ebx
8010559d:	83 ec 54             	sub    $0x54,%esp
801055a0:	50                   	push   %eax
801055a1:	6a 00                	push   $0x0
801055a3:	e8 08 fa ff ff       	call   80104fb0 <argstr>
801055a8:	83 c4 10             	add    $0x10,%esp
801055ab:	85 c0                	test   %eax,%eax
801055ad:	0f 88 7d 01 00 00    	js     80105730 <sys_unlink+0x1a0>
801055b3:	e8 28 dd ff ff       	call   801032e0 <begin_op>
801055b8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801055bb:	83 ec 08             	sub    $0x8,%esp
801055be:	53                   	push   %ebx
801055bf:	ff 75 c0             	pushl  -0x40(%ebp)
801055c2:	e8 39 d0 ff ff       	call   80102600 <nameiparent>
801055c7:	83 c4 10             	add    $0x10,%esp
801055ca:	89 c6                	mov    %eax,%esi
801055cc:	85 c0                	test   %eax,%eax
801055ce:	0f 84 66 01 00 00    	je     8010573a <sys_unlink+0x1aa>
801055d4:	83 ec 0c             	sub    $0xc,%esp
801055d7:	50                   	push   %eax
801055d8:	e8 33 c7 ff ff       	call   80101d10 <ilock>
801055dd:	58                   	pop    %eax
801055de:	5a                   	pop    %edx
801055df:	68 34 7e 10 80       	push   $0x80107e34
801055e4:	53                   	push   %ebx
801055e5:	e8 56 cc ff ff       	call   80102240 <namecmp>
801055ea:	83 c4 10             	add    $0x10,%esp
801055ed:	85 c0                	test   %eax,%eax
801055ef:	0f 84 03 01 00 00    	je     801056f8 <sys_unlink+0x168>
801055f5:	83 ec 08             	sub    $0x8,%esp
801055f8:	68 33 7e 10 80       	push   $0x80107e33
801055fd:	53                   	push   %ebx
801055fe:	e8 3d cc ff ff       	call   80102240 <namecmp>
80105603:	83 c4 10             	add    $0x10,%esp
80105606:	85 c0                	test   %eax,%eax
80105608:	0f 84 ea 00 00 00    	je     801056f8 <sys_unlink+0x168>
8010560e:	83 ec 04             	sub    $0x4,%esp
80105611:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105614:	50                   	push   %eax
80105615:	53                   	push   %ebx
80105616:	56                   	push   %esi
80105617:	e8 44 cc ff ff       	call   80102260 <dirlookup>
8010561c:	83 c4 10             	add    $0x10,%esp
8010561f:	89 c3                	mov    %eax,%ebx
80105621:	85 c0                	test   %eax,%eax
80105623:	0f 84 cf 00 00 00    	je     801056f8 <sys_unlink+0x168>
80105629:	83 ec 0c             	sub    $0xc,%esp
8010562c:	50                   	push   %eax
8010562d:	e8 de c6 ff ff       	call   80101d10 <ilock>
80105632:	83 c4 10             	add    $0x10,%esp
80105635:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010563a:	0f 8e 23 01 00 00    	jle    80105763 <sys_unlink+0x1d3>
80105640:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105645:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105648:	74 66                	je     801056b0 <sys_unlink+0x120>
8010564a:	83 ec 04             	sub    $0x4,%esp
8010564d:	6a 10                	push   $0x10
8010564f:	6a 00                	push   $0x0
80105651:	57                   	push   %edi
80105652:	e8 c9 f5 ff ff       	call   80104c20 <memset>
80105657:	6a 10                	push   $0x10
80105659:	ff 75 c4             	pushl  -0x3c(%ebp)
8010565c:	57                   	push   %edi
8010565d:	56                   	push   %esi
8010565e:	e8 ad ca ff ff       	call   80102110 <writei>
80105663:	83 c4 20             	add    $0x20,%esp
80105666:	83 f8 10             	cmp    $0x10,%eax
80105669:	0f 85 e7 00 00 00    	jne    80105756 <sys_unlink+0x1c6>
8010566f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105674:	0f 84 96 00 00 00    	je     80105710 <sys_unlink+0x180>
8010567a:	83 ec 0c             	sub    $0xc,%esp
8010567d:	56                   	push   %esi
8010567e:	e8 2d c9 ff ff       	call   80101fb0 <iunlockput>
80105683:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
80105688:	89 1c 24             	mov    %ebx,(%esp)
8010568b:	e8 c0 c5 ff ff       	call   80101c50 <iupdate>
80105690:	89 1c 24             	mov    %ebx,(%esp)
80105693:	e8 18 c9 ff ff       	call   80101fb0 <iunlockput>
80105698:	e8 b3 dc ff ff       	call   80103350 <end_op>
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	31 c0                	xor    %eax,%eax
801056a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056a5:	5b                   	pop    %ebx
801056a6:	5e                   	pop    %esi
801056a7:	5f                   	pop    %edi
801056a8:	5d                   	pop    %ebp
801056a9:	c3                   	ret    
801056aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801056b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801056b4:	76 94                	jbe    8010564a <sys_unlink+0xba>
801056b6:	ba 20 00 00 00       	mov    $0x20,%edx
801056bb:	eb 0b                	jmp    801056c8 <sys_unlink+0x138>
801056bd:	8d 76 00             	lea    0x0(%esi),%esi
801056c0:	83 c2 10             	add    $0x10,%edx
801056c3:	39 53 58             	cmp    %edx,0x58(%ebx)
801056c6:	76 82                	jbe    8010564a <sys_unlink+0xba>
801056c8:	6a 10                	push   $0x10
801056ca:	52                   	push   %edx
801056cb:	57                   	push   %edi
801056cc:	53                   	push   %ebx
801056cd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801056d0:	e8 3b c9 ff ff       	call   80102010 <readi>
801056d5:	83 c4 10             	add    $0x10,%esp
801056d8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801056db:	83 f8 10             	cmp    $0x10,%eax
801056de:	75 69                	jne    80105749 <sys_unlink+0x1b9>
801056e0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801056e5:	74 d9                	je     801056c0 <sys_unlink+0x130>
801056e7:	83 ec 0c             	sub    $0xc,%esp
801056ea:	53                   	push   %ebx
801056eb:	e8 c0 c8 ff ff       	call   80101fb0 <iunlockput>
801056f0:	83 c4 10             	add    $0x10,%esp
801056f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056f7:	90                   	nop
801056f8:	83 ec 0c             	sub    $0xc,%esp
801056fb:	56                   	push   %esi
801056fc:	e8 af c8 ff ff       	call   80101fb0 <iunlockput>
80105701:	e8 4a dc ff ff       	call   80103350 <end_op>
80105706:	83 c4 10             	add    $0x10,%esp
80105709:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010570e:	eb 92                	jmp    801056a2 <sys_unlink+0x112>
80105710:	83 ec 0c             	sub    $0xc,%esp
80105713:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
80105718:	56                   	push   %esi
80105719:	e8 32 c5 ff ff       	call   80101c50 <iupdate>
8010571e:	83 c4 10             	add    $0x10,%esp
80105721:	e9 54 ff ff ff       	jmp    8010567a <sys_unlink+0xea>
80105726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010572d:	8d 76 00             	lea    0x0(%esi),%esi
80105730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105735:	e9 68 ff ff ff       	jmp    801056a2 <sys_unlink+0x112>
8010573a:	e8 11 dc ff ff       	call   80103350 <end_op>
8010573f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105744:	e9 59 ff ff ff       	jmp    801056a2 <sys_unlink+0x112>
80105749:	83 ec 0c             	sub    $0xc,%esp
8010574c:	68 58 7e 10 80       	push   $0x80107e58
80105751:	e8 3a ac ff ff       	call   80100390 <panic>
80105756:	83 ec 0c             	sub    $0xc,%esp
80105759:	68 6a 7e 10 80       	push   $0x80107e6a
8010575e:	e8 2d ac ff ff       	call   80100390 <panic>
80105763:	83 ec 0c             	sub    $0xc,%esp
80105766:	68 46 7e 10 80       	push   $0x80107e46
8010576b:	e8 20 ac ff ff       	call   80100390 <panic>

80105770 <sys_open>:
80105770:	f3 0f 1e fb          	endbr32 
80105774:	55                   	push   %ebp
80105775:	89 e5                	mov    %esp,%ebp
80105777:	57                   	push   %edi
80105778:	56                   	push   %esi
80105779:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010577c:	53                   	push   %ebx
8010577d:	83 ec 24             	sub    $0x24,%esp
80105780:	50                   	push   %eax
80105781:	6a 00                	push   $0x0
80105783:	e8 28 f8 ff ff       	call   80104fb0 <argstr>
80105788:	83 c4 10             	add    $0x10,%esp
8010578b:	85 c0                	test   %eax,%eax
8010578d:	0f 88 8a 00 00 00    	js     8010581d <sys_open+0xad>
80105793:	83 ec 08             	sub    $0x8,%esp
80105796:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105799:	50                   	push   %eax
8010579a:	6a 01                	push   $0x1
8010579c:	e8 5f f7 ff ff       	call   80104f00 <argint>
801057a1:	83 c4 10             	add    $0x10,%esp
801057a4:	85 c0                	test   %eax,%eax
801057a6:	78 75                	js     8010581d <sys_open+0xad>
801057a8:	e8 33 db ff ff       	call   801032e0 <begin_op>
801057ad:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801057b1:	75 75                	jne    80105828 <sys_open+0xb8>
801057b3:	83 ec 0c             	sub    $0xc,%esp
801057b6:	ff 75 e0             	pushl  -0x20(%ebp)
801057b9:	e8 22 ce ff ff       	call   801025e0 <namei>
801057be:	83 c4 10             	add    $0x10,%esp
801057c1:	89 c6                	mov    %eax,%esi
801057c3:	85 c0                	test   %eax,%eax
801057c5:	74 7e                	je     80105845 <sys_open+0xd5>
801057c7:	83 ec 0c             	sub    $0xc,%esp
801057ca:	50                   	push   %eax
801057cb:	e8 40 c5 ff ff       	call   80101d10 <ilock>
801057d0:	83 c4 10             	add    $0x10,%esp
801057d3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801057d8:	0f 84 c2 00 00 00    	je     801058a0 <sys_open+0x130>
801057de:	e8 cd bb ff ff       	call   801013b0 <filealloc>
801057e3:	89 c7                	mov    %eax,%edi
801057e5:	85 c0                	test   %eax,%eax
801057e7:	74 23                	je     8010580c <sys_open+0x9c>
801057e9:	e8 22 e7 ff ff       	call   80103f10 <myproc>
801057ee:	31 db                	xor    %ebx,%ebx
801057f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801057f4:	85 d2                	test   %edx,%edx
801057f6:	74 60                	je     80105858 <sys_open+0xe8>
801057f8:	83 c3 01             	add    $0x1,%ebx
801057fb:	83 fb 10             	cmp    $0x10,%ebx
801057fe:	75 f0                	jne    801057f0 <sys_open+0x80>
80105800:	83 ec 0c             	sub    $0xc,%esp
80105803:	57                   	push   %edi
80105804:	e8 67 bc ff ff       	call   80101470 <fileclose>
80105809:	83 c4 10             	add    $0x10,%esp
8010580c:	83 ec 0c             	sub    $0xc,%esp
8010580f:	56                   	push   %esi
80105810:	e8 9b c7 ff ff       	call   80101fb0 <iunlockput>
80105815:	e8 36 db ff ff       	call   80103350 <end_op>
8010581a:	83 c4 10             	add    $0x10,%esp
8010581d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105822:	eb 6d                	jmp    80105891 <sys_open+0x121>
80105824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105828:	83 ec 0c             	sub    $0xc,%esp
8010582b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010582e:	31 c9                	xor    %ecx,%ecx
80105830:	ba 02 00 00 00       	mov    $0x2,%edx
80105835:	6a 00                	push   $0x0
80105837:	e8 24 f8 ff ff       	call   80105060 <create>
8010583c:	83 c4 10             	add    $0x10,%esp
8010583f:	89 c6                	mov    %eax,%esi
80105841:	85 c0                	test   %eax,%eax
80105843:	75 99                	jne    801057de <sys_open+0x6e>
80105845:	e8 06 db ff ff       	call   80103350 <end_op>
8010584a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010584f:	eb 40                	jmp    80105891 <sys_open+0x121>
80105851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105858:	83 ec 0c             	sub    $0xc,%esp
8010585b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
8010585f:	56                   	push   %esi
80105860:	e8 8b c5 ff ff       	call   80101df0 <iunlock>
80105865:	e8 e6 da ff ff       	call   80103350 <end_op>
8010586a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
80105870:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105873:	83 c4 10             	add    $0x10,%esp
80105876:	89 77 10             	mov    %esi,0x10(%edi)
80105879:	89 d0                	mov    %edx,%eax
8010587b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
80105882:	f7 d0                	not    %eax
80105884:	83 e0 01             	and    $0x1,%eax
80105887:	83 e2 03             	and    $0x3,%edx
8010588a:	88 47 08             	mov    %al,0x8(%edi)
8010588d:	0f 95 47 09          	setne  0x9(%edi)
80105891:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105894:	89 d8                	mov    %ebx,%eax
80105896:	5b                   	pop    %ebx
80105897:	5e                   	pop    %esi
80105898:	5f                   	pop    %edi
80105899:	5d                   	pop    %ebp
8010589a:	c3                   	ret    
8010589b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010589f:	90                   	nop
801058a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801058a3:	85 c9                	test   %ecx,%ecx
801058a5:	0f 84 33 ff ff ff    	je     801057de <sys_open+0x6e>
801058ab:	e9 5c ff ff ff       	jmp    8010580c <sys_open+0x9c>

801058b0 <sys_mkdir>:
801058b0:	f3 0f 1e fb          	endbr32 
801058b4:	55                   	push   %ebp
801058b5:	89 e5                	mov    %esp,%ebp
801058b7:	83 ec 18             	sub    $0x18,%esp
801058ba:	e8 21 da ff ff       	call   801032e0 <begin_op>
801058bf:	83 ec 08             	sub    $0x8,%esp
801058c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058c5:	50                   	push   %eax
801058c6:	6a 00                	push   $0x0
801058c8:	e8 e3 f6 ff ff       	call   80104fb0 <argstr>
801058cd:	83 c4 10             	add    $0x10,%esp
801058d0:	85 c0                	test   %eax,%eax
801058d2:	78 34                	js     80105908 <sys_mkdir+0x58>
801058d4:	83 ec 0c             	sub    $0xc,%esp
801058d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058da:	31 c9                	xor    %ecx,%ecx
801058dc:	ba 01 00 00 00       	mov    $0x1,%edx
801058e1:	6a 00                	push   $0x0
801058e3:	e8 78 f7 ff ff       	call   80105060 <create>
801058e8:	83 c4 10             	add    $0x10,%esp
801058eb:	85 c0                	test   %eax,%eax
801058ed:	74 19                	je     80105908 <sys_mkdir+0x58>
801058ef:	83 ec 0c             	sub    $0xc,%esp
801058f2:	50                   	push   %eax
801058f3:	e8 b8 c6 ff ff       	call   80101fb0 <iunlockput>
801058f8:	e8 53 da ff ff       	call   80103350 <end_op>
801058fd:	83 c4 10             	add    $0x10,%esp
80105900:	31 c0                	xor    %eax,%eax
80105902:	c9                   	leave  
80105903:	c3                   	ret    
80105904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105908:	e8 43 da ff ff       	call   80103350 <end_op>
8010590d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105912:	c9                   	leave  
80105913:	c3                   	ret    
80105914:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010591f:	90                   	nop

80105920 <sys_mknod>:
80105920:	f3 0f 1e fb          	endbr32 
80105924:	55                   	push   %ebp
80105925:	89 e5                	mov    %esp,%ebp
80105927:	83 ec 18             	sub    $0x18,%esp
8010592a:	e8 b1 d9 ff ff       	call   801032e0 <begin_op>
8010592f:	83 ec 08             	sub    $0x8,%esp
80105932:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105935:	50                   	push   %eax
80105936:	6a 00                	push   $0x0
80105938:	e8 73 f6 ff ff       	call   80104fb0 <argstr>
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	85 c0                	test   %eax,%eax
80105942:	78 64                	js     801059a8 <sys_mknod+0x88>
80105944:	83 ec 08             	sub    $0x8,%esp
80105947:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010594a:	50                   	push   %eax
8010594b:	6a 01                	push   $0x1
8010594d:	e8 ae f5 ff ff       	call   80104f00 <argint>
80105952:	83 c4 10             	add    $0x10,%esp
80105955:	85 c0                	test   %eax,%eax
80105957:	78 4f                	js     801059a8 <sys_mknod+0x88>
80105959:	83 ec 08             	sub    $0x8,%esp
8010595c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010595f:	50                   	push   %eax
80105960:	6a 02                	push   $0x2
80105962:	e8 99 f5 ff ff       	call   80104f00 <argint>
80105967:	83 c4 10             	add    $0x10,%esp
8010596a:	85 c0                	test   %eax,%eax
8010596c:	78 3a                	js     801059a8 <sys_mknod+0x88>
8010596e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105972:	83 ec 0c             	sub    $0xc,%esp
80105975:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105979:	ba 03 00 00 00       	mov    $0x3,%edx
8010597e:	50                   	push   %eax
8010597f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105982:	e8 d9 f6 ff ff       	call   80105060 <create>
80105987:	83 c4 10             	add    $0x10,%esp
8010598a:	85 c0                	test   %eax,%eax
8010598c:	74 1a                	je     801059a8 <sys_mknod+0x88>
8010598e:	83 ec 0c             	sub    $0xc,%esp
80105991:	50                   	push   %eax
80105992:	e8 19 c6 ff ff       	call   80101fb0 <iunlockput>
80105997:	e8 b4 d9 ff ff       	call   80103350 <end_op>
8010599c:	83 c4 10             	add    $0x10,%esp
8010599f:	31 c0                	xor    %eax,%eax
801059a1:	c9                   	leave  
801059a2:	c3                   	ret    
801059a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059a7:	90                   	nop
801059a8:	e8 a3 d9 ff ff       	call   80103350 <end_op>
801059ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059b2:	c9                   	leave  
801059b3:	c3                   	ret    
801059b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059bf:	90                   	nop

801059c0 <sys_chdir>:
801059c0:	f3 0f 1e fb          	endbr32 
801059c4:	55                   	push   %ebp
801059c5:	89 e5                	mov    %esp,%ebp
801059c7:	56                   	push   %esi
801059c8:	53                   	push   %ebx
801059c9:	83 ec 10             	sub    $0x10,%esp
801059cc:	e8 3f e5 ff ff       	call   80103f10 <myproc>
801059d1:	89 c6                	mov    %eax,%esi
801059d3:	e8 08 d9 ff ff       	call   801032e0 <begin_op>
801059d8:	83 ec 08             	sub    $0x8,%esp
801059db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059de:	50                   	push   %eax
801059df:	6a 00                	push   $0x0
801059e1:	e8 ca f5 ff ff       	call   80104fb0 <argstr>
801059e6:	83 c4 10             	add    $0x10,%esp
801059e9:	85 c0                	test   %eax,%eax
801059eb:	78 73                	js     80105a60 <sys_chdir+0xa0>
801059ed:	83 ec 0c             	sub    $0xc,%esp
801059f0:	ff 75 f4             	pushl  -0xc(%ebp)
801059f3:	e8 e8 cb ff ff       	call   801025e0 <namei>
801059f8:	83 c4 10             	add    $0x10,%esp
801059fb:	89 c3                	mov    %eax,%ebx
801059fd:	85 c0                	test   %eax,%eax
801059ff:	74 5f                	je     80105a60 <sys_chdir+0xa0>
80105a01:	83 ec 0c             	sub    $0xc,%esp
80105a04:	50                   	push   %eax
80105a05:	e8 06 c3 ff ff       	call   80101d10 <ilock>
80105a0a:	83 c4 10             	add    $0x10,%esp
80105a0d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a12:	75 2c                	jne    80105a40 <sys_chdir+0x80>
80105a14:	83 ec 0c             	sub    $0xc,%esp
80105a17:	53                   	push   %ebx
80105a18:	e8 d3 c3 ff ff       	call   80101df0 <iunlock>
80105a1d:	58                   	pop    %eax
80105a1e:	ff 76 68             	pushl  0x68(%esi)
80105a21:	e8 1a c4 ff ff       	call   80101e40 <iput>
80105a26:	e8 25 d9 ff ff       	call   80103350 <end_op>
80105a2b:	89 5e 68             	mov    %ebx,0x68(%esi)
80105a2e:	83 c4 10             	add    $0x10,%esp
80105a31:	31 c0                	xor    %eax,%eax
80105a33:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a36:	5b                   	pop    %ebx
80105a37:	5e                   	pop    %esi
80105a38:	5d                   	pop    %ebp
80105a39:	c3                   	ret    
80105a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a40:	83 ec 0c             	sub    $0xc,%esp
80105a43:	53                   	push   %ebx
80105a44:	e8 67 c5 ff ff       	call   80101fb0 <iunlockput>
80105a49:	e8 02 d9 ff ff       	call   80103350 <end_op>
80105a4e:	83 c4 10             	add    $0x10,%esp
80105a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a56:	eb db                	jmp    80105a33 <sys_chdir+0x73>
80105a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5f:	90                   	nop
80105a60:	e8 eb d8 ff ff       	call   80103350 <end_op>
80105a65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a6a:	eb c7                	jmp    80105a33 <sys_chdir+0x73>
80105a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a70 <sys_exec>:
80105a70:	f3 0f 1e fb          	endbr32 
80105a74:	55                   	push   %ebp
80105a75:	89 e5                	mov    %esp,%ebp
80105a77:	57                   	push   %edi
80105a78:	56                   	push   %esi
80105a79:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105a7f:	53                   	push   %ebx
80105a80:	81 ec a4 00 00 00    	sub    $0xa4,%esp
80105a86:	50                   	push   %eax
80105a87:	6a 00                	push   $0x0
80105a89:	e8 22 f5 ff ff       	call   80104fb0 <argstr>
80105a8e:	83 c4 10             	add    $0x10,%esp
80105a91:	85 c0                	test   %eax,%eax
80105a93:	0f 88 8b 00 00 00    	js     80105b24 <sys_exec+0xb4>
80105a99:	83 ec 08             	sub    $0x8,%esp
80105a9c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105aa2:	50                   	push   %eax
80105aa3:	6a 01                	push   $0x1
80105aa5:	e8 56 f4 ff ff       	call   80104f00 <argint>
80105aaa:	83 c4 10             	add    $0x10,%esp
80105aad:	85 c0                	test   %eax,%eax
80105aaf:	78 73                	js     80105b24 <sys_exec+0xb4>
80105ab1:	83 ec 04             	sub    $0x4,%esp
80105ab4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105aba:	31 db                	xor    %ebx,%ebx
80105abc:	68 80 00 00 00       	push   $0x80
80105ac1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105ac7:	6a 00                	push   $0x0
80105ac9:	50                   	push   %eax
80105aca:	e8 51 f1 ff ff       	call   80104c20 <memset>
80105acf:	83 c4 10             	add    $0x10,%esp
80105ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105ad8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105ade:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105ae5:	83 ec 08             	sub    $0x8,%esp
80105ae8:	57                   	push   %edi
80105ae9:	01 f0                	add    %esi,%eax
80105aeb:	50                   	push   %eax
80105aec:	e8 6f f3 ff ff       	call   80104e60 <fetchint>
80105af1:	83 c4 10             	add    $0x10,%esp
80105af4:	85 c0                	test   %eax,%eax
80105af6:	78 2c                	js     80105b24 <sys_exec+0xb4>
80105af8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105afe:	85 c0                	test   %eax,%eax
80105b00:	74 36                	je     80105b38 <sys_exec+0xc8>
80105b02:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105b08:	83 ec 08             	sub    $0x8,%esp
80105b0b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105b0e:	52                   	push   %edx
80105b0f:	50                   	push   %eax
80105b10:	e8 8b f3 ff ff       	call   80104ea0 <fetchstr>
80105b15:	83 c4 10             	add    $0x10,%esp
80105b18:	85 c0                	test   %eax,%eax
80105b1a:	78 08                	js     80105b24 <sys_exec+0xb4>
80105b1c:	83 c3 01             	add    $0x1,%ebx
80105b1f:	83 fb 20             	cmp    $0x20,%ebx
80105b22:	75 b4                	jne    80105ad8 <sys_exec+0x68>
80105b24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b2c:	5b                   	pop    %ebx
80105b2d:	5e                   	pop    %esi
80105b2e:	5f                   	pop    %edi
80105b2f:	5d                   	pop    %ebp
80105b30:	c3                   	ret    
80105b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b38:	83 ec 08             	sub    $0x8,%esp
80105b3b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b41:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105b48:	00 00 00 00 
80105b4c:	50                   	push   %eax
80105b4d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105b53:	e8 d8 b4 ff ff       	call   80101030 <exec>
80105b58:	83 c4 10             	add    $0x10,%esp
80105b5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b5e:	5b                   	pop    %ebx
80105b5f:	5e                   	pop    %esi
80105b60:	5f                   	pop    %edi
80105b61:	5d                   	pop    %ebp
80105b62:	c3                   	ret    
80105b63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b70 <sys_pipe>:
80105b70:	f3 0f 1e fb          	endbr32 
80105b74:	55                   	push   %ebp
80105b75:	89 e5                	mov    %esp,%ebp
80105b77:	57                   	push   %edi
80105b78:	56                   	push   %esi
80105b79:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105b7c:	53                   	push   %ebx
80105b7d:	83 ec 20             	sub    $0x20,%esp
80105b80:	6a 08                	push   $0x8
80105b82:	50                   	push   %eax
80105b83:	6a 00                	push   $0x0
80105b85:	e8 c6 f3 ff ff       	call   80104f50 <argptr>
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	85 c0                	test   %eax,%eax
80105b8f:	78 4e                	js     80105bdf <sys_pipe+0x6f>
80105b91:	83 ec 08             	sub    $0x8,%esp
80105b94:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b97:	50                   	push   %eax
80105b98:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b9b:	50                   	push   %eax
80105b9c:	e8 ff dd ff ff       	call   801039a0 <pipealloc>
80105ba1:	83 c4 10             	add    $0x10,%esp
80105ba4:	85 c0                	test   %eax,%eax
80105ba6:	78 37                	js     80105bdf <sys_pipe+0x6f>
80105ba8:	8b 7d e0             	mov    -0x20(%ebp),%edi
80105bab:	31 db                	xor    %ebx,%ebx
80105bad:	e8 5e e3 ff ff       	call   80103f10 <myproc>
80105bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105bb8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105bbc:	85 f6                	test   %esi,%esi
80105bbe:	74 30                	je     80105bf0 <sys_pipe+0x80>
80105bc0:	83 c3 01             	add    $0x1,%ebx
80105bc3:	83 fb 10             	cmp    $0x10,%ebx
80105bc6:	75 f0                	jne    80105bb8 <sys_pipe+0x48>
80105bc8:	83 ec 0c             	sub    $0xc,%esp
80105bcb:	ff 75 e0             	pushl  -0x20(%ebp)
80105bce:	e8 9d b8 ff ff       	call   80101470 <fileclose>
80105bd3:	58                   	pop    %eax
80105bd4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105bd7:	e8 94 b8 ff ff       	call   80101470 <fileclose>
80105bdc:	83 c4 10             	add    $0x10,%esp
80105bdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be4:	eb 5b                	jmp    80105c41 <sys_pipe+0xd1>
80105be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bed:	8d 76 00             	lea    0x0(%esi),%esi
80105bf0:	8d 73 08             	lea    0x8(%ebx),%esi
80105bf3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
80105bf7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80105bfa:	e8 11 e3 ff ff       	call   80103f10 <myproc>
80105bff:	31 d2                	xor    %edx,%edx
80105c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c08:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105c0c:	85 c9                	test   %ecx,%ecx
80105c0e:	74 20                	je     80105c30 <sys_pipe+0xc0>
80105c10:	83 c2 01             	add    $0x1,%edx
80105c13:	83 fa 10             	cmp    $0x10,%edx
80105c16:	75 f0                	jne    80105c08 <sys_pipe+0x98>
80105c18:	e8 f3 e2 ff ff       	call   80103f10 <myproc>
80105c1d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105c24:	00 
80105c25:	eb a1                	jmp    80105bc8 <sys_pipe+0x58>
80105c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2e:	66 90                	xchg   %ax,%ax
80105c30:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
80105c34:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c37:	89 18                	mov    %ebx,(%eax)
80105c39:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c3c:	89 50 04             	mov    %edx,0x4(%eax)
80105c3f:	31 c0                	xor    %eax,%eax
80105c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c44:	5b                   	pop    %ebx
80105c45:	5e                   	pop    %esi
80105c46:	5f                   	pop    %edi
80105c47:	5d                   	pop    %ebp
80105c48:	c3                   	ret    
80105c49:	66 90                	xchg   %ax,%ax
80105c4b:	66 90                	xchg   %ax,%ax
80105c4d:	66 90                	xchg   %ax,%ax
80105c4f:	90                   	nop

80105c50 <sys_fork>:
80105c50:	f3 0f 1e fb          	endbr32 
80105c54:	e9 67 e4 ff ff       	jmp    801040c0 <fork>
80105c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c60 <sys_exit>:
80105c60:	f3 0f 1e fb          	endbr32 
80105c64:	55                   	push   %ebp
80105c65:	89 e5                	mov    %esp,%ebp
80105c67:	83 ec 08             	sub    $0x8,%esp
80105c6a:	e8 d1 e6 ff ff       	call   80104340 <exit>
80105c6f:	31 c0                	xor    %eax,%eax
80105c71:	c9                   	leave  
80105c72:	c3                   	ret    
80105c73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c80 <sys_wait>:
80105c80:	f3 0f 1e fb          	endbr32 
80105c84:	e9 07 e9 ff ff       	jmp    80104590 <wait>
80105c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c90 <sys_kill>:
80105c90:	f3 0f 1e fb          	endbr32 
80105c94:	55                   	push   %ebp
80105c95:	89 e5                	mov    %esp,%ebp
80105c97:	83 ec 20             	sub    $0x20,%esp
80105c9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c9d:	50                   	push   %eax
80105c9e:	6a 00                	push   $0x0
80105ca0:	e8 5b f2 ff ff       	call   80104f00 <argint>
80105ca5:	83 c4 10             	add    $0x10,%esp
80105ca8:	85 c0                	test   %eax,%eax
80105caa:	78 14                	js     80105cc0 <sys_kill+0x30>
80105cac:	83 ec 0c             	sub    $0xc,%esp
80105caf:	ff 75 f4             	pushl  -0xc(%ebp)
80105cb2:	e8 39 ea ff ff       	call   801046f0 <kill>
80105cb7:	83 c4 10             	add    $0x10,%esp
80105cba:	c9                   	leave  
80105cbb:	c3                   	ret    
80105cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cc0:	c9                   	leave  
80105cc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cc6:	c3                   	ret    
80105cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cce:	66 90                	xchg   %ax,%ax

80105cd0 <sys_getpid>:
80105cd0:	f3 0f 1e fb          	endbr32 
80105cd4:	55                   	push   %ebp
80105cd5:	89 e5                	mov    %esp,%ebp
80105cd7:	83 ec 08             	sub    $0x8,%esp
80105cda:	e8 31 e2 ff ff       	call   80103f10 <myproc>
80105cdf:	8b 40 10             	mov    0x10(%eax),%eax
80105ce2:	c9                   	leave  
80105ce3:	c3                   	ret    
80105ce4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cef:	90                   	nop

80105cf0 <sys_sbrk>:
80105cf0:	f3 0f 1e fb          	endbr32 
80105cf4:	55                   	push   %ebp
80105cf5:	89 e5                	mov    %esp,%ebp
80105cf7:	53                   	push   %ebx
80105cf8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cfb:	83 ec 1c             	sub    $0x1c,%esp
80105cfe:	50                   	push   %eax
80105cff:	6a 00                	push   $0x0
80105d01:	e8 fa f1 ff ff       	call   80104f00 <argint>
80105d06:	83 c4 10             	add    $0x10,%esp
80105d09:	85 c0                	test   %eax,%eax
80105d0b:	78 23                	js     80105d30 <sys_sbrk+0x40>
80105d0d:	e8 fe e1 ff ff       	call   80103f10 <myproc>
80105d12:	83 ec 0c             	sub    $0xc,%esp
80105d15:	8b 18                	mov    (%eax),%ebx
80105d17:	ff 75 f4             	pushl  -0xc(%ebp)
80105d1a:	e8 21 e3 ff ff       	call   80104040 <growproc>
80105d1f:	83 c4 10             	add    $0x10,%esp
80105d22:	85 c0                	test   %eax,%eax
80105d24:	78 0a                	js     80105d30 <sys_sbrk+0x40>
80105d26:	89 d8                	mov    %ebx,%eax
80105d28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d2b:	c9                   	leave  
80105d2c:	c3                   	ret    
80105d2d:	8d 76 00             	lea    0x0(%esi),%esi
80105d30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d35:	eb ef                	jmp    80105d26 <sys_sbrk+0x36>
80105d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d3e:	66 90                	xchg   %ax,%ax

80105d40 <sys_sleep>:
80105d40:	f3 0f 1e fb          	endbr32 
80105d44:	55                   	push   %ebp
80105d45:	89 e5                	mov    %esp,%ebp
80105d47:	53                   	push   %ebx
80105d48:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d4b:	83 ec 1c             	sub    $0x1c,%esp
80105d4e:	50                   	push   %eax
80105d4f:	6a 00                	push   $0x0
80105d51:	e8 aa f1 ff ff       	call   80104f00 <argint>
80105d56:	83 c4 10             	add    $0x10,%esp
80105d59:	85 c0                	test   %eax,%eax
80105d5b:	0f 88 86 00 00 00    	js     80105de7 <sys_sleep+0xa7>
80105d61:	83 ec 0c             	sub    $0xc,%esp
80105d64:	68 00 62 11 80       	push   $0x80116200
80105d69:	e8 a2 ed ff ff       	call   80104b10 <acquire>
80105d6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d71:	8b 1d 40 6a 11 80    	mov    0x80116a40,%ebx
80105d77:	83 c4 10             	add    $0x10,%esp
80105d7a:	85 d2                	test   %edx,%edx
80105d7c:	75 23                	jne    80105da1 <sys_sleep+0x61>
80105d7e:	eb 50                	jmp    80105dd0 <sys_sleep+0x90>
80105d80:	83 ec 08             	sub    $0x8,%esp
80105d83:	68 00 62 11 80       	push   $0x80116200
80105d88:	68 40 6a 11 80       	push   $0x80116a40
80105d8d:	e8 3e e7 ff ff       	call   801044d0 <sleep>
80105d92:	a1 40 6a 11 80       	mov    0x80116a40,%eax
80105d97:	83 c4 10             	add    $0x10,%esp
80105d9a:	29 d8                	sub    %ebx,%eax
80105d9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d9f:	73 2f                	jae    80105dd0 <sys_sleep+0x90>
80105da1:	e8 6a e1 ff ff       	call   80103f10 <myproc>
80105da6:	8b 40 24             	mov    0x24(%eax),%eax
80105da9:	85 c0                	test   %eax,%eax
80105dab:	74 d3                	je     80105d80 <sys_sleep+0x40>
80105dad:	83 ec 0c             	sub    $0xc,%esp
80105db0:	68 00 62 11 80       	push   $0x80116200
80105db5:	e8 16 ee ff ff       	call   80104bd0 <release>
80105dba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105dbd:	83 c4 10             	add    $0x10,%esp
80105dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dc5:	c9                   	leave  
80105dc6:	c3                   	ret    
80105dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dce:	66 90                	xchg   %ax,%ax
80105dd0:	83 ec 0c             	sub    $0xc,%esp
80105dd3:	68 00 62 11 80       	push   $0x80116200
80105dd8:	e8 f3 ed ff ff       	call   80104bd0 <release>
80105ddd:	83 c4 10             	add    $0x10,%esp
80105de0:	31 c0                	xor    %eax,%eax
80105de2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105de5:	c9                   	leave  
80105de6:	c3                   	ret    
80105de7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dec:	eb f4                	jmp    80105de2 <sys_sleep+0xa2>
80105dee:	66 90                	xchg   %ax,%ax

80105df0 <sys_uptime>:
80105df0:	f3 0f 1e fb          	endbr32 
80105df4:	55                   	push   %ebp
80105df5:	89 e5                	mov    %esp,%ebp
80105df7:	53                   	push   %ebx
80105df8:	83 ec 10             	sub    $0x10,%esp
80105dfb:	68 00 62 11 80       	push   $0x80116200
80105e00:	e8 0b ed ff ff       	call   80104b10 <acquire>
80105e05:	8b 1d 40 6a 11 80    	mov    0x80116a40,%ebx
80105e0b:	c7 04 24 00 62 11 80 	movl   $0x80116200,(%esp)
80105e12:	e8 b9 ed ff ff       	call   80104bd0 <release>
80105e17:	89 d8                	mov    %ebx,%eax
80105e19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e1c:	c9                   	leave  
80105e1d:	c3                   	ret    

80105e1e <alltraps>:
80105e1e:	1e                   	push   %ds
80105e1f:	06                   	push   %es
80105e20:	0f a0                	push   %fs
80105e22:	0f a8                	push   %gs
80105e24:	60                   	pusha  
80105e25:	66 b8 10 00          	mov    $0x10,%ax
80105e29:	8e d8                	mov    %eax,%ds
80105e2b:	8e c0                	mov    %eax,%es
80105e2d:	54                   	push   %esp
80105e2e:	e8 cd 00 00 00       	call   80105f00 <trap>
80105e33:	83 c4 04             	add    $0x4,%esp

80105e36 <trapret>:
80105e36:	61                   	popa   
80105e37:	0f a9                	pop    %gs
80105e39:	0f a1                	pop    %fs
80105e3b:	07                   	pop    %es
80105e3c:	1f                   	pop    %ds
80105e3d:	83 c4 08             	add    $0x8,%esp
80105e40:	cf                   	iret   
80105e41:	66 90                	xchg   %ax,%ax
80105e43:	66 90                	xchg   %ax,%ax
80105e45:	66 90                	xchg   %ax,%ax
80105e47:	66 90                	xchg   %ax,%ax
80105e49:	66 90                	xchg   %ax,%ax
80105e4b:	66 90                	xchg   %ax,%ax
80105e4d:	66 90                	xchg   %ax,%ax
80105e4f:	90                   	nop

80105e50 <tvinit>:
80105e50:	f3 0f 1e fb          	endbr32 
80105e54:	55                   	push   %ebp
80105e55:	31 c0                	xor    %eax,%eax
80105e57:	89 e5                	mov    %esp,%ebp
80105e59:	83 ec 08             	sub    $0x8,%esp
80105e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e60:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105e67:	c7 04 c5 42 62 11 80 	movl   $0x8e000008,-0x7fee9dbe(,%eax,8)
80105e6e:	08 00 00 8e 
80105e72:	66 89 14 c5 40 62 11 	mov    %dx,-0x7fee9dc0(,%eax,8)
80105e79:	80 
80105e7a:	c1 ea 10             	shr    $0x10,%edx
80105e7d:	66 89 14 c5 46 62 11 	mov    %dx,-0x7fee9dba(,%eax,8)
80105e84:	80 
80105e85:	83 c0 01             	add    $0x1,%eax
80105e88:	3d 00 01 00 00       	cmp    $0x100,%eax
80105e8d:	75 d1                	jne    80105e60 <tvinit+0x10>
80105e8f:	83 ec 08             	sub    $0x8,%esp
80105e92:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105e97:	c7 05 42 64 11 80 08 	movl   $0xef000008,0x80116442
80105e9e:	00 00 ef 
80105ea1:	68 79 7e 10 80       	push   $0x80107e79
80105ea6:	68 00 62 11 80       	push   $0x80116200
80105eab:	66 a3 40 64 11 80    	mov    %ax,0x80116440
80105eb1:	c1 e8 10             	shr    $0x10,%eax
80105eb4:	66 a3 46 64 11 80    	mov    %ax,0x80116446
80105eba:	e8 d1 ea ff ff       	call   80104990 <initlock>
80105ebf:	83 c4 10             	add    $0x10,%esp
80105ec2:	c9                   	leave  
80105ec3:	c3                   	ret    
80105ec4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ecf:	90                   	nop

80105ed0 <idtinit>:
80105ed0:	f3 0f 1e fb          	endbr32 
80105ed4:	55                   	push   %ebp
80105ed5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105eda:	89 e5                	mov    %esp,%ebp
80105edc:	83 ec 10             	sub    $0x10,%esp
80105edf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
80105ee3:	b8 40 62 11 80       	mov    $0x80116240,%eax
80105ee8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80105eec:	c1 e8 10             	shr    $0x10,%eax
80105eef:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
80105ef3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ef6:	0f 01 18             	lidtl  (%eax)
80105ef9:	c9                   	leave  
80105efa:	c3                   	ret    
80105efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105eff:	90                   	nop

80105f00 <trap>:
80105f00:	f3 0f 1e fb          	endbr32 
80105f04:	55                   	push   %ebp
80105f05:	89 e5                	mov    %esp,%ebp
80105f07:	57                   	push   %edi
80105f08:	56                   	push   %esi
80105f09:	53                   	push   %ebx
80105f0a:	83 ec 1c             	sub    $0x1c,%esp
80105f0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105f10:	8b 43 30             	mov    0x30(%ebx),%eax
80105f13:	83 f8 40             	cmp    $0x40,%eax
80105f16:	0f 84 bc 01 00 00    	je     801060d8 <trap+0x1d8>
80105f1c:	83 e8 20             	sub    $0x20,%eax
80105f1f:	83 f8 1f             	cmp    $0x1f,%eax
80105f22:	77 08                	ja     80105f2c <trap+0x2c>
80105f24:	3e ff 24 85 20 7f 10 	notrack jmp *-0x7fef80e0(,%eax,4)
80105f2b:	80 
80105f2c:	e8 df df ff ff       	call   80103f10 <myproc>
80105f31:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f34:	85 c0                	test   %eax,%eax
80105f36:	0f 84 eb 01 00 00    	je     80106127 <trap+0x227>
80105f3c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105f40:	0f 84 e1 01 00 00    	je     80106127 <trap+0x227>
80105f46:	0f 20 d1             	mov    %cr2,%ecx
80105f49:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105f4c:	e8 9f df ff ff       	call   80103ef0 <cpuid>
80105f51:	8b 73 30             	mov    0x30(%ebx),%esi
80105f54:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105f57:	8b 43 34             	mov    0x34(%ebx),%eax
80105f5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105f5d:	e8 ae df ff ff       	call   80103f10 <myproc>
80105f62:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f65:	e8 a6 df ff ff       	call   80103f10 <myproc>
80105f6a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105f6d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105f70:	51                   	push   %ecx
80105f71:	57                   	push   %edi
80105f72:	52                   	push   %edx
80105f73:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f76:	56                   	push   %esi
80105f77:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105f7a:	83 c6 6c             	add    $0x6c,%esi
80105f7d:	56                   	push   %esi
80105f7e:	ff 70 10             	pushl  0x10(%eax)
80105f81:	68 dc 7e 10 80       	push   $0x80107edc
80105f86:	e8 f5 a9 ff ff       	call   80100980 <cprintf>
80105f8b:	83 c4 20             	add    $0x20,%esp
80105f8e:	e8 7d df ff ff       	call   80103f10 <myproc>
80105f93:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105f9a:	e8 71 df ff ff       	call   80103f10 <myproc>
80105f9f:	85 c0                	test   %eax,%eax
80105fa1:	74 1d                	je     80105fc0 <trap+0xc0>
80105fa3:	e8 68 df ff ff       	call   80103f10 <myproc>
80105fa8:	8b 50 24             	mov    0x24(%eax),%edx
80105fab:	85 d2                	test   %edx,%edx
80105fad:	74 11                	je     80105fc0 <trap+0xc0>
80105faf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105fb3:	83 e0 03             	and    $0x3,%eax
80105fb6:	66 83 f8 03          	cmp    $0x3,%ax
80105fba:	0f 84 50 01 00 00    	je     80106110 <trap+0x210>
80105fc0:	e8 4b df ff ff       	call   80103f10 <myproc>
80105fc5:	85 c0                	test   %eax,%eax
80105fc7:	74 0f                	je     80105fd8 <trap+0xd8>
80105fc9:	e8 42 df ff ff       	call   80103f10 <myproc>
80105fce:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105fd2:	0f 84 e8 00 00 00    	je     801060c0 <trap+0x1c0>
80105fd8:	e8 33 df ff ff       	call   80103f10 <myproc>
80105fdd:	85 c0                	test   %eax,%eax
80105fdf:	74 1d                	je     80105ffe <trap+0xfe>
80105fe1:	e8 2a df ff ff       	call   80103f10 <myproc>
80105fe6:	8b 40 24             	mov    0x24(%eax),%eax
80105fe9:	85 c0                	test   %eax,%eax
80105feb:	74 11                	je     80105ffe <trap+0xfe>
80105fed:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ff1:	83 e0 03             	and    $0x3,%eax
80105ff4:	66 83 f8 03          	cmp    $0x3,%ax
80105ff8:	0f 84 03 01 00 00    	je     80106101 <trap+0x201>
80105ffe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106001:	5b                   	pop    %ebx
80106002:	5e                   	pop    %esi
80106003:	5f                   	pop    %edi
80106004:	5d                   	pop    %ebp
80106005:	c3                   	ret    
80106006:	e8 85 c7 ff ff       	call   80102790 <ideintr>
8010600b:	e8 60 ce ff ff       	call   80102e70 <lapiceoi>
80106010:	e8 fb de ff ff       	call   80103f10 <myproc>
80106015:	85 c0                	test   %eax,%eax
80106017:	75 8a                	jne    80105fa3 <trap+0xa3>
80106019:	eb a5                	jmp    80105fc0 <trap+0xc0>
8010601b:	e8 d0 de ff ff       	call   80103ef0 <cpuid>
80106020:	85 c0                	test   %eax,%eax
80106022:	75 e7                	jne    8010600b <trap+0x10b>
80106024:	83 ec 0c             	sub    $0xc,%esp
80106027:	68 00 62 11 80       	push   $0x80116200
8010602c:	e8 df ea ff ff       	call   80104b10 <acquire>
80106031:	c7 04 24 40 6a 11 80 	movl   $0x80116a40,(%esp)
80106038:	83 05 40 6a 11 80 01 	addl   $0x1,0x80116a40
8010603f:	e8 4c e6 ff ff       	call   80104690 <wakeup>
80106044:	c7 04 24 00 62 11 80 	movl   $0x80116200,(%esp)
8010604b:	e8 80 eb ff ff       	call   80104bd0 <release>
80106050:	83 c4 10             	add    $0x10,%esp
80106053:	eb b6                	jmp    8010600b <trap+0x10b>
80106055:	e8 d6 cc ff ff       	call   80102d30 <kbdintr>
8010605a:	e8 11 ce ff ff       	call   80102e70 <lapiceoi>
8010605f:	e8 ac de ff ff       	call   80103f10 <myproc>
80106064:	85 c0                	test   %eax,%eax
80106066:	0f 85 37 ff ff ff    	jne    80105fa3 <trap+0xa3>
8010606c:	e9 4f ff ff ff       	jmp    80105fc0 <trap+0xc0>
80106071:	e8 4a 02 00 00       	call   801062c0 <uartintr>
80106076:	e8 f5 cd ff ff       	call   80102e70 <lapiceoi>
8010607b:	e8 90 de ff ff       	call   80103f10 <myproc>
80106080:	85 c0                	test   %eax,%eax
80106082:	0f 85 1b ff ff ff    	jne    80105fa3 <trap+0xa3>
80106088:	e9 33 ff ff ff       	jmp    80105fc0 <trap+0xc0>
8010608d:	8b 7b 38             	mov    0x38(%ebx),%edi
80106090:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106094:	e8 57 de ff ff       	call   80103ef0 <cpuid>
80106099:	57                   	push   %edi
8010609a:	56                   	push   %esi
8010609b:	50                   	push   %eax
8010609c:	68 84 7e 10 80       	push   $0x80107e84
801060a1:	e8 da a8 ff ff       	call   80100980 <cprintf>
801060a6:	e8 c5 cd ff ff       	call   80102e70 <lapiceoi>
801060ab:	83 c4 10             	add    $0x10,%esp
801060ae:	e8 5d de ff ff       	call   80103f10 <myproc>
801060b3:	85 c0                	test   %eax,%eax
801060b5:	0f 85 e8 fe ff ff    	jne    80105fa3 <trap+0xa3>
801060bb:	e9 00 ff ff ff       	jmp    80105fc0 <trap+0xc0>
801060c0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801060c4:	0f 85 0e ff ff ff    	jne    80105fd8 <trap+0xd8>
801060ca:	e8 b1 e3 ff ff       	call   80104480 <yield>
801060cf:	e9 04 ff ff ff       	jmp    80105fd8 <trap+0xd8>
801060d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060d8:	e8 33 de ff ff       	call   80103f10 <myproc>
801060dd:	8b 70 24             	mov    0x24(%eax),%esi
801060e0:	85 f6                	test   %esi,%esi
801060e2:	75 3c                	jne    80106120 <trap+0x220>
801060e4:	e8 27 de ff ff       	call   80103f10 <myproc>
801060e9:	89 58 18             	mov    %ebx,0x18(%eax)
801060ec:	e8 ff ee ff ff       	call   80104ff0 <syscall>
801060f1:	e8 1a de ff ff       	call   80103f10 <myproc>
801060f6:	8b 48 24             	mov    0x24(%eax),%ecx
801060f9:	85 c9                	test   %ecx,%ecx
801060fb:	0f 84 fd fe ff ff    	je     80105ffe <trap+0xfe>
80106101:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106104:	5b                   	pop    %ebx
80106105:	5e                   	pop    %esi
80106106:	5f                   	pop    %edi
80106107:	5d                   	pop    %ebp
80106108:	e9 33 e2 ff ff       	jmp    80104340 <exit>
8010610d:	8d 76 00             	lea    0x0(%esi),%esi
80106110:	e8 2b e2 ff ff       	call   80104340 <exit>
80106115:	e9 a6 fe ff ff       	jmp    80105fc0 <trap+0xc0>
8010611a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106120:	e8 1b e2 ff ff       	call   80104340 <exit>
80106125:	eb bd                	jmp    801060e4 <trap+0x1e4>
80106127:	0f 20 d6             	mov    %cr2,%esi
8010612a:	e8 c1 dd ff ff       	call   80103ef0 <cpuid>
8010612f:	83 ec 0c             	sub    $0xc,%esp
80106132:	56                   	push   %esi
80106133:	57                   	push   %edi
80106134:	50                   	push   %eax
80106135:	ff 73 30             	pushl  0x30(%ebx)
80106138:	68 a8 7e 10 80       	push   $0x80107ea8
8010613d:	e8 3e a8 ff ff       	call   80100980 <cprintf>
80106142:	83 c4 14             	add    $0x14,%esp
80106145:	68 7e 7e 10 80       	push   $0x80107e7e
8010614a:	e8 41 a2 ff ff       	call   80100390 <panic>
8010614f:	90                   	nop

80106150 <uartgetc>:
80106150:	f3 0f 1e fb          	endbr32 
80106154:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106159:	85 c0                	test   %eax,%eax
8010615b:	74 1b                	je     80106178 <uartgetc+0x28>
8010615d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106162:	ec                   	in     (%dx),%al
80106163:	a8 01                	test   $0x1,%al
80106165:	74 11                	je     80106178 <uartgetc+0x28>
80106167:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010616c:	ec                   	in     (%dx),%al
8010616d:	0f b6 c0             	movzbl %al,%eax
80106170:	c3                   	ret    
80106171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010617d:	c3                   	ret    
8010617e:	66 90                	xchg   %ax,%ax

80106180 <uartputc.part.0>:
80106180:	55                   	push   %ebp
80106181:	89 e5                	mov    %esp,%ebp
80106183:	57                   	push   %edi
80106184:	89 c7                	mov    %eax,%edi
80106186:	56                   	push   %esi
80106187:	be fd 03 00 00       	mov    $0x3fd,%esi
8010618c:	53                   	push   %ebx
8010618d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106192:	83 ec 0c             	sub    $0xc,%esp
80106195:	eb 1b                	jmp    801061b2 <uartputc.part.0+0x32>
80106197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010619e:	66 90                	xchg   %ax,%ax
801061a0:	83 ec 0c             	sub    $0xc,%esp
801061a3:	6a 0a                	push   $0xa
801061a5:	e8 e6 cc ff ff       	call   80102e90 <microdelay>
801061aa:	83 c4 10             	add    $0x10,%esp
801061ad:	83 eb 01             	sub    $0x1,%ebx
801061b0:	74 07                	je     801061b9 <uartputc.part.0+0x39>
801061b2:	89 f2                	mov    %esi,%edx
801061b4:	ec                   	in     (%dx),%al
801061b5:	a8 20                	test   $0x20,%al
801061b7:	74 e7                	je     801061a0 <uartputc.part.0+0x20>
801061b9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061be:	89 f8                	mov    %edi,%eax
801061c0:	ee                   	out    %al,(%dx)
801061c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061c4:	5b                   	pop    %ebx
801061c5:	5e                   	pop    %esi
801061c6:	5f                   	pop    %edi
801061c7:	5d                   	pop    %ebp
801061c8:	c3                   	ret    
801061c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061d0 <uartinit>:
801061d0:	f3 0f 1e fb          	endbr32 
801061d4:	55                   	push   %ebp
801061d5:	31 c9                	xor    %ecx,%ecx
801061d7:	89 c8                	mov    %ecx,%eax
801061d9:	89 e5                	mov    %esp,%ebp
801061db:	57                   	push   %edi
801061dc:	56                   	push   %esi
801061dd:	53                   	push   %ebx
801061de:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801061e3:	89 da                	mov    %ebx,%edx
801061e5:	83 ec 0c             	sub    $0xc,%esp
801061e8:	ee                   	out    %al,(%dx)
801061e9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801061ee:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801061f3:	89 fa                	mov    %edi,%edx
801061f5:	ee                   	out    %al,(%dx)
801061f6:	b8 0c 00 00 00       	mov    $0xc,%eax
801061fb:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106200:	ee                   	out    %al,(%dx)
80106201:	be f9 03 00 00       	mov    $0x3f9,%esi
80106206:	89 c8                	mov    %ecx,%eax
80106208:	89 f2                	mov    %esi,%edx
8010620a:	ee                   	out    %al,(%dx)
8010620b:	b8 03 00 00 00       	mov    $0x3,%eax
80106210:	89 fa                	mov    %edi,%edx
80106212:	ee                   	out    %al,(%dx)
80106213:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106218:	89 c8                	mov    %ecx,%eax
8010621a:	ee                   	out    %al,(%dx)
8010621b:	b8 01 00 00 00       	mov    $0x1,%eax
80106220:	89 f2                	mov    %esi,%edx
80106222:	ee                   	out    %al,(%dx)
80106223:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106228:	ec                   	in     (%dx),%al
80106229:	3c ff                	cmp    $0xff,%al
8010622b:	74 52                	je     8010627f <uartinit+0xaf>
8010622d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106234:	00 00 00 
80106237:	89 da                	mov    %ebx,%edx
80106239:	ec                   	in     (%dx),%al
8010623a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010623f:	ec                   	in     (%dx),%al
80106240:	83 ec 08             	sub    $0x8,%esp
80106243:	be 76 00 00 00       	mov    $0x76,%esi
80106248:	bb a0 7f 10 80       	mov    $0x80107fa0,%ebx
8010624d:	6a 00                	push   $0x0
8010624f:	6a 04                	push   $0x4
80106251:	e8 8a c7 ff ff       	call   801029e0 <ioapicenable>
80106256:	83 c4 10             	add    $0x10,%esp
80106259:	b8 78 00 00 00       	mov    $0x78,%eax
8010625e:	eb 04                	jmp    80106264 <uartinit+0x94>
80106260:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
80106264:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010626a:	85 d2                	test   %edx,%edx
8010626c:	74 08                	je     80106276 <uartinit+0xa6>
8010626e:	0f be c0             	movsbl %al,%eax
80106271:	e8 0a ff ff ff       	call   80106180 <uartputc.part.0>
80106276:	89 f0                	mov    %esi,%eax
80106278:	83 c3 01             	add    $0x1,%ebx
8010627b:	84 c0                	test   %al,%al
8010627d:	75 e1                	jne    80106260 <uartinit+0x90>
8010627f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106282:	5b                   	pop    %ebx
80106283:	5e                   	pop    %esi
80106284:	5f                   	pop    %edi
80106285:	5d                   	pop    %ebp
80106286:	c3                   	ret    
80106287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010628e:	66 90                	xchg   %ax,%ax

80106290 <uartputc>:
80106290:	f3 0f 1e fb          	endbr32 
80106294:	55                   	push   %ebp
80106295:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010629b:	89 e5                	mov    %esp,%ebp
8010629d:	8b 45 08             	mov    0x8(%ebp),%eax
801062a0:	85 d2                	test   %edx,%edx
801062a2:	74 0c                	je     801062b0 <uartputc+0x20>
801062a4:	5d                   	pop    %ebp
801062a5:	e9 d6 fe ff ff       	jmp    80106180 <uartputc.part.0>
801062aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801062b0:	5d                   	pop    %ebp
801062b1:	c3                   	ret    
801062b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062c0 <uartintr>:
801062c0:	f3 0f 1e fb          	endbr32 
801062c4:	55                   	push   %ebp
801062c5:	89 e5                	mov    %esp,%ebp
801062c7:	83 ec 14             	sub    $0x14,%esp
801062ca:	68 50 61 10 80       	push   $0x80106150
801062cf:	e8 5c a8 ff ff       	call   80100b30 <consoleintr>
801062d4:	83 c4 10             	add    $0x10,%esp
801062d7:	c9                   	leave  
801062d8:	c3                   	ret    

801062d9 <vector0>:
801062d9:	6a 00                	push   $0x0
801062db:	6a 00                	push   $0x0
801062dd:	e9 3c fb ff ff       	jmp    80105e1e <alltraps>

801062e2 <vector1>:
801062e2:	6a 00                	push   $0x0
801062e4:	6a 01                	push   $0x1
801062e6:	e9 33 fb ff ff       	jmp    80105e1e <alltraps>

801062eb <vector2>:
801062eb:	6a 00                	push   $0x0
801062ed:	6a 02                	push   $0x2
801062ef:	e9 2a fb ff ff       	jmp    80105e1e <alltraps>

801062f4 <vector3>:
801062f4:	6a 00                	push   $0x0
801062f6:	6a 03                	push   $0x3
801062f8:	e9 21 fb ff ff       	jmp    80105e1e <alltraps>

801062fd <vector4>:
801062fd:	6a 00                	push   $0x0
801062ff:	6a 04                	push   $0x4
80106301:	e9 18 fb ff ff       	jmp    80105e1e <alltraps>

80106306 <vector5>:
80106306:	6a 00                	push   $0x0
80106308:	6a 05                	push   $0x5
8010630a:	e9 0f fb ff ff       	jmp    80105e1e <alltraps>

8010630f <vector6>:
8010630f:	6a 00                	push   $0x0
80106311:	6a 06                	push   $0x6
80106313:	e9 06 fb ff ff       	jmp    80105e1e <alltraps>

80106318 <vector7>:
80106318:	6a 00                	push   $0x0
8010631a:	6a 07                	push   $0x7
8010631c:	e9 fd fa ff ff       	jmp    80105e1e <alltraps>

80106321 <vector8>:
80106321:	6a 08                	push   $0x8
80106323:	e9 f6 fa ff ff       	jmp    80105e1e <alltraps>

80106328 <vector9>:
80106328:	6a 00                	push   $0x0
8010632a:	6a 09                	push   $0x9
8010632c:	e9 ed fa ff ff       	jmp    80105e1e <alltraps>

80106331 <vector10>:
80106331:	6a 0a                	push   $0xa
80106333:	e9 e6 fa ff ff       	jmp    80105e1e <alltraps>

80106338 <vector11>:
80106338:	6a 0b                	push   $0xb
8010633a:	e9 df fa ff ff       	jmp    80105e1e <alltraps>

8010633f <vector12>:
8010633f:	6a 0c                	push   $0xc
80106341:	e9 d8 fa ff ff       	jmp    80105e1e <alltraps>

80106346 <vector13>:
80106346:	6a 0d                	push   $0xd
80106348:	e9 d1 fa ff ff       	jmp    80105e1e <alltraps>

8010634d <vector14>:
8010634d:	6a 0e                	push   $0xe
8010634f:	e9 ca fa ff ff       	jmp    80105e1e <alltraps>

80106354 <vector15>:
80106354:	6a 00                	push   $0x0
80106356:	6a 0f                	push   $0xf
80106358:	e9 c1 fa ff ff       	jmp    80105e1e <alltraps>

8010635d <vector16>:
8010635d:	6a 00                	push   $0x0
8010635f:	6a 10                	push   $0x10
80106361:	e9 b8 fa ff ff       	jmp    80105e1e <alltraps>

80106366 <vector17>:
80106366:	6a 11                	push   $0x11
80106368:	e9 b1 fa ff ff       	jmp    80105e1e <alltraps>

8010636d <vector18>:
8010636d:	6a 00                	push   $0x0
8010636f:	6a 12                	push   $0x12
80106371:	e9 a8 fa ff ff       	jmp    80105e1e <alltraps>

80106376 <vector19>:
80106376:	6a 00                	push   $0x0
80106378:	6a 13                	push   $0x13
8010637a:	e9 9f fa ff ff       	jmp    80105e1e <alltraps>

8010637f <vector20>:
8010637f:	6a 00                	push   $0x0
80106381:	6a 14                	push   $0x14
80106383:	e9 96 fa ff ff       	jmp    80105e1e <alltraps>

80106388 <vector21>:
80106388:	6a 00                	push   $0x0
8010638a:	6a 15                	push   $0x15
8010638c:	e9 8d fa ff ff       	jmp    80105e1e <alltraps>

80106391 <vector22>:
80106391:	6a 00                	push   $0x0
80106393:	6a 16                	push   $0x16
80106395:	e9 84 fa ff ff       	jmp    80105e1e <alltraps>

8010639a <vector23>:
8010639a:	6a 00                	push   $0x0
8010639c:	6a 17                	push   $0x17
8010639e:	e9 7b fa ff ff       	jmp    80105e1e <alltraps>

801063a3 <vector24>:
801063a3:	6a 00                	push   $0x0
801063a5:	6a 18                	push   $0x18
801063a7:	e9 72 fa ff ff       	jmp    80105e1e <alltraps>

801063ac <vector25>:
801063ac:	6a 00                	push   $0x0
801063ae:	6a 19                	push   $0x19
801063b0:	e9 69 fa ff ff       	jmp    80105e1e <alltraps>

801063b5 <vector26>:
801063b5:	6a 00                	push   $0x0
801063b7:	6a 1a                	push   $0x1a
801063b9:	e9 60 fa ff ff       	jmp    80105e1e <alltraps>

801063be <vector27>:
801063be:	6a 00                	push   $0x0
801063c0:	6a 1b                	push   $0x1b
801063c2:	e9 57 fa ff ff       	jmp    80105e1e <alltraps>

801063c7 <vector28>:
801063c7:	6a 00                	push   $0x0
801063c9:	6a 1c                	push   $0x1c
801063cb:	e9 4e fa ff ff       	jmp    80105e1e <alltraps>

801063d0 <vector29>:
801063d0:	6a 00                	push   $0x0
801063d2:	6a 1d                	push   $0x1d
801063d4:	e9 45 fa ff ff       	jmp    80105e1e <alltraps>

801063d9 <vector30>:
801063d9:	6a 00                	push   $0x0
801063db:	6a 1e                	push   $0x1e
801063dd:	e9 3c fa ff ff       	jmp    80105e1e <alltraps>

801063e2 <vector31>:
801063e2:	6a 00                	push   $0x0
801063e4:	6a 1f                	push   $0x1f
801063e6:	e9 33 fa ff ff       	jmp    80105e1e <alltraps>

801063eb <vector32>:
801063eb:	6a 00                	push   $0x0
801063ed:	6a 20                	push   $0x20
801063ef:	e9 2a fa ff ff       	jmp    80105e1e <alltraps>

801063f4 <vector33>:
801063f4:	6a 00                	push   $0x0
801063f6:	6a 21                	push   $0x21
801063f8:	e9 21 fa ff ff       	jmp    80105e1e <alltraps>

801063fd <vector34>:
801063fd:	6a 00                	push   $0x0
801063ff:	6a 22                	push   $0x22
80106401:	e9 18 fa ff ff       	jmp    80105e1e <alltraps>

80106406 <vector35>:
80106406:	6a 00                	push   $0x0
80106408:	6a 23                	push   $0x23
8010640a:	e9 0f fa ff ff       	jmp    80105e1e <alltraps>

8010640f <vector36>:
8010640f:	6a 00                	push   $0x0
80106411:	6a 24                	push   $0x24
80106413:	e9 06 fa ff ff       	jmp    80105e1e <alltraps>

80106418 <vector37>:
80106418:	6a 00                	push   $0x0
8010641a:	6a 25                	push   $0x25
8010641c:	e9 fd f9 ff ff       	jmp    80105e1e <alltraps>

80106421 <vector38>:
80106421:	6a 00                	push   $0x0
80106423:	6a 26                	push   $0x26
80106425:	e9 f4 f9 ff ff       	jmp    80105e1e <alltraps>

8010642a <vector39>:
8010642a:	6a 00                	push   $0x0
8010642c:	6a 27                	push   $0x27
8010642e:	e9 eb f9 ff ff       	jmp    80105e1e <alltraps>

80106433 <vector40>:
80106433:	6a 00                	push   $0x0
80106435:	6a 28                	push   $0x28
80106437:	e9 e2 f9 ff ff       	jmp    80105e1e <alltraps>

8010643c <vector41>:
8010643c:	6a 00                	push   $0x0
8010643e:	6a 29                	push   $0x29
80106440:	e9 d9 f9 ff ff       	jmp    80105e1e <alltraps>

80106445 <vector42>:
80106445:	6a 00                	push   $0x0
80106447:	6a 2a                	push   $0x2a
80106449:	e9 d0 f9 ff ff       	jmp    80105e1e <alltraps>

8010644e <vector43>:
8010644e:	6a 00                	push   $0x0
80106450:	6a 2b                	push   $0x2b
80106452:	e9 c7 f9 ff ff       	jmp    80105e1e <alltraps>

80106457 <vector44>:
80106457:	6a 00                	push   $0x0
80106459:	6a 2c                	push   $0x2c
8010645b:	e9 be f9 ff ff       	jmp    80105e1e <alltraps>

80106460 <vector45>:
80106460:	6a 00                	push   $0x0
80106462:	6a 2d                	push   $0x2d
80106464:	e9 b5 f9 ff ff       	jmp    80105e1e <alltraps>

80106469 <vector46>:
80106469:	6a 00                	push   $0x0
8010646b:	6a 2e                	push   $0x2e
8010646d:	e9 ac f9 ff ff       	jmp    80105e1e <alltraps>

80106472 <vector47>:
80106472:	6a 00                	push   $0x0
80106474:	6a 2f                	push   $0x2f
80106476:	e9 a3 f9 ff ff       	jmp    80105e1e <alltraps>

8010647b <vector48>:
8010647b:	6a 00                	push   $0x0
8010647d:	6a 30                	push   $0x30
8010647f:	e9 9a f9 ff ff       	jmp    80105e1e <alltraps>

80106484 <vector49>:
80106484:	6a 00                	push   $0x0
80106486:	6a 31                	push   $0x31
80106488:	e9 91 f9 ff ff       	jmp    80105e1e <alltraps>

8010648d <vector50>:
8010648d:	6a 00                	push   $0x0
8010648f:	6a 32                	push   $0x32
80106491:	e9 88 f9 ff ff       	jmp    80105e1e <alltraps>

80106496 <vector51>:
80106496:	6a 00                	push   $0x0
80106498:	6a 33                	push   $0x33
8010649a:	e9 7f f9 ff ff       	jmp    80105e1e <alltraps>

8010649f <vector52>:
8010649f:	6a 00                	push   $0x0
801064a1:	6a 34                	push   $0x34
801064a3:	e9 76 f9 ff ff       	jmp    80105e1e <alltraps>

801064a8 <vector53>:
801064a8:	6a 00                	push   $0x0
801064aa:	6a 35                	push   $0x35
801064ac:	e9 6d f9 ff ff       	jmp    80105e1e <alltraps>

801064b1 <vector54>:
801064b1:	6a 00                	push   $0x0
801064b3:	6a 36                	push   $0x36
801064b5:	e9 64 f9 ff ff       	jmp    80105e1e <alltraps>

801064ba <vector55>:
801064ba:	6a 00                	push   $0x0
801064bc:	6a 37                	push   $0x37
801064be:	e9 5b f9 ff ff       	jmp    80105e1e <alltraps>

801064c3 <vector56>:
801064c3:	6a 00                	push   $0x0
801064c5:	6a 38                	push   $0x38
801064c7:	e9 52 f9 ff ff       	jmp    80105e1e <alltraps>

801064cc <vector57>:
801064cc:	6a 00                	push   $0x0
801064ce:	6a 39                	push   $0x39
801064d0:	e9 49 f9 ff ff       	jmp    80105e1e <alltraps>

801064d5 <vector58>:
801064d5:	6a 00                	push   $0x0
801064d7:	6a 3a                	push   $0x3a
801064d9:	e9 40 f9 ff ff       	jmp    80105e1e <alltraps>

801064de <vector59>:
801064de:	6a 00                	push   $0x0
801064e0:	6a 3b                	push   $0x3b
801064e2:	e9 37 f9 ff ff       	jmp    80105e1e <alltraps>

801064e7 <vector60>:
801064e7:	6a 00                	push   $0x0
801064e9:	6a 3c                	push   $0x3c
801064eb:	e9 2e f9 ff ff       	jmp    80105e1e <alltraps>

801064f0 <vector61>:
801064f0:	6a 00                	push   $0x0
801064f2:	6a 3d                	push   $0x3d
801064f4:	e9 25 f9 ff ff       	jmp    80105e1e <alltraps>

801064f9 <vector62>:
801064f9:	6a 00                	push   $0x0
801064fb:	6a 3e                	push   $0x3e
801064fd:	e9 1c f9 ff ff       	jmp    80105e1e <alltraps>

80106502 <vector63>:
80106502:	6a 00                	push   $0x0
80106504:	6a 3f                	push   $0x3f
80106506:	e9 13 f9 ff ff       	jmp    80105e1e <alltraps>

8010650b <vector64>:
8010650b:	6a 00                	push   $0x0
8010650d:	6a 40                	push   $0x40
8010650f:	e9 0a f9 ff ff       	jmp    80105e1e <alltraps>

80106514 <vector65>:
80106514:	6a 00                	push   $0x0
80106516:	6a 41                	push   $0x41
80106518:	e9 01 f9 ff ff       	jmp    80105e1e <alltraps>

8010651d <vector66>:
8010651d:	6a 00                	push   $0x0
8010651f:	6a 42                	push   $0x42
80106521:	e9 f8 f8 ff ff       	jmp    80105e1e <alltraps>

80106526 <vector67>:
80106526:	6a 00                	push   $0x0
80106528:	6a 43                	push   $0x43
8010652a:	e9 ef f8 ff ff       	jmp    80105e1e <alltraps>

8010652f <vector68>:
8010652f:	6a 00                	push   $0x0
80106531:	6a 44                	push   $0x44
80106533:	e9 e6 f8 ff ff       	jmp    80105e1e <alltraps>

80106538 <vector69>:
80106538:	6a 00                	push   $0x0
8010653a:	6a 45                	push   $0x45
8010653c:	e9 dd f8 ff ff       	jmp    80105e1e <alltraps>

80106541 <vector70>:
80106541:	6a 00                	push   $0x0
80106543:	6a 46                	push   $0x46
80106545:	e9 d4 f8 ff ff       	jmp    80105e1e <alltraps>

8010654a <vector71>:
8010654a:	6a 00                	push   $0x0
8010654c:	6a 47                	push   $0x47
8010654e:	e9 cb f8 ff ff       	jmp    80105e1e <alltraps>

80106553 <vector72>:
80106553:	6a 00                	push   $0x0
80106555:	6a 48                	push   $0x48
80106557:	e9 c2 f8 ff ff       	jmp    80105e1e <alltraps>

8010655c <vector73>:
8010655c:	6a 00                	push   $0x0
8010655e:	6a 49                	push   $0x49
80106560:	e9 b9 f8 ff ff       	jmp    80105e1e <alltraps>

80106565 <vector74>:
80106565:	6a 00                	push   $0x0
80106567:	6a 4a                	push   $0x4a
80106569:	e9 b0 f8 ff ff       	jmp    80105e1e <alltraps>

8010656e <vector75>:
8010656e:	6a 00                	push   $0x0
80106570:	6a 4b                	push   $0x4b
80106572:	e9 a7 f8 ff ff       	jmp    80105e1e <alltraps>

80106577 <vector76>:
80106577:	6a 00                	push   $0x0
80106579:	6a 4c                	push   $0x4c
8010657b:	e9 9e f8 ff ff       	jmp    80105e1e <alltraps>

80106580 <vector77>:
80106580:	6a 00                	push   $0x0
80106582:	6a 4d                	push   $0x4d
80106584:	e9 95 f8 ff ff       	jmp    80105e1e <alltraps>

80106589 <vector78>:
80106589:	6a 00                	push   $0x0
8010658b:	6a 4e                	push   $0x4e
8010658d:	e9 8c f8 ff ff       	jmp    80105e1e <alltraps>

80106592 <vector79>:
80106592:	6a 00                	push   $0x0
80106594:	6a 4f                	push   $0x4f
80106596:	e9 83 f8 ff ff       	jmp    80105e1e <alltraps>

8010659b <vector80>:
8010659b:	6a 00                	push   $0x0
8010659d:	6a 50                	push   $0x50
8010659f:	e9 7a f8 ff ff       	jmp    80105e1e <alltraps>

801065a4 <vector81>:
801065a4:	6a 00                	push   $0x0
801065a6:	6a 51                	push   $0x51
801065a8:	e9 71 f8 ff ff       	jmp    80105e1e <alltraps>

801065ad <vector82>:
801065ad:	6a 00                	push   $0x0
801065af:	6a 52                	push   $0x52
801065b1:	e9 68 f8 ff ff       	jmp    80105e1e <alltraps>

801065b6 <vector83>:
801065b6:	6a 00                	push   $0x0
801065b8:	6a 53                	push   $0x53
801065ba:	e9 5f f8 ff ff       	jmp    80105e1e <alltraps>

801065bf <vector84>:
801065bf:	6a 00                	push   $0x0
801065c1:	6a 54                	push   $0x54
801065c3:	e9 56 f8 ff ff       	jmp    80105e1e <alltraps>

801065c8 <vector85>:
801065c8:	6a 00                	push   $0x0
801065ca:	6a 55                	push   $0x55
801065cc:	e9 4d f8 ff ff       	jmp    80105e1e <alltraps>

801065d1 <vector86>:
801065d1:	6a 00                	push   $0x0
801065d3:	6a 56                	push   $0x56
801065d5:	e9 44 f8 ff ff       	jmp    80105e1e <alltraps>

801065da <vector87>:
801065da:	6a 00                	push   $0x0
801065dc:	6a 57                	push   $0x57
801065de:	e9 3b f8 ff ff       	jmp    80105e1e <alltraps>

801065e3 <vector88>:
801065e3:	6a 00                	push   $0x0
801065e5:	6a 58                	push   $0x58
801065e7:	e9 32 f8 ff ff       	jmp    80105e1e <alltraps>

801065ec <vector89>:
801065ec:	6a 00                	push   $0x0
801065ee:	6a 59                	push   $0x59
801065f0:	e9 29 f8 ff ff       	jmp    80105e1e <alltraps>

801065f5 <vector90>:
801065f5:	6a 00                	push   $0x0
801065f7:	6a 5a                	push   $0x5a
801065f9:	e9 20 f8 ff ff       	jmp    80105e1e <alltraps>

801065fe <vector91>:
801065fe:	6a 00                	push   $0x0
80106600:	6a 5b                	push   $0x5b
80106602:	e9 17 f8 ff ff       	jmp    80105e1e <alltraps>

80106607 <vector92>:
80106607:	6a 00                	push   $0x0
80106609:	6a 5c                	push   $0x5c
8010660b:	e9 0e f8 ff ff       	jmp    80105e1e <alltraps>

80106610 <vector93>:
80106610:	6a 00                	push   $0x0
80106612:	6a 5d                	push   $0x5d
80106614:	e9 05 f8 ff ff       	jmp    80105e1e <alltraps>

80106619 <vector94>:
80106619:	6a 00                	push   $0x0
8010661b:	6a 5e                	push   $0x5e
8010661d:	e9 fc f7 ff ff       	jmp    80105e1e <alltraps>

80106622 <vector95>:
80106622:	6a 00                	push   $0x0
80106624:	6a 5f                	push   $0x5f
80106626:	e9 f3 f7 ff ff       	jmp    80105e1e <alltraps>

8010662b <vector96>:
8010662b:	6a 00                	push   $0x0
8010662d:	6a 60                	push   $0x60
8010662f:	e9 ea f7 ff ff       	jmp    80105e1e <alltraps>

80106634 <vector97>:
80106634:	6a 00                	push   $0x0
80106636:	6a 61                	push   $0x61
80106638:	e9 e1 f7 ff ff       	jmp    80105e1e <alltraps>

8010663d <vector98>:
8010663d:	6a 00                	push   $0x0
8010663f:	6a 62                	push   $0x62
80106641:	e9 d8 f7 ff ff       	jmp    80105e1e <alltraps>

80106646 <vector99>:
80106646:	6a 00                	push   $0x0
80106648:	6a 63                	push   $0x63
8010664a:	e9 cf f7 ff ff       	jmp    80105e1e <alltraps>

8010664f <vector100>:
8010664f:	6a 00                	push   $0x0
80106651:	6a 64                	push   $0x64
80106653:	e9 c6 f7 ff ff       	jmp    80105e1e <alltraps>

80106658 <vector101>:
80106658:	6a 00                	push   $0x0
8010665a:	6a 65                	push   $0x65
8010665c:	e9 bd f7 ff ff       	jmp    80105e1e <alltraps>

80106661 <vector102>:
80106661:	6a 00                	push   $0x0
80106663:	6a 66                	push   $0x66
80106665:	e9 b4 f7 ff ff       	jmp    80105e1e <alltraps>

8010666a <vector103>:
8010666a:	6a 00                	push   $0x0
8010666c:	6a 67                	push   $0x67
8010666e:	e9 ab f7 ff ff       	jmp    80105e1e <alltraps>

80106673 <vector104>:
80106673:	6a 00                	push   $0x0
80106675:	6a 68                	push   $0x68
80106677:	e9 a2 f7 ff ff       	jmp    80105e1e <alltraps>

8010667c <vector105>:
8010667c:	6a 00                	push   $0x0
8010667e:	6a 69                	push   $0x69
80106680:	e9 99 f7 ff ff       	jmp    80105e1e <alltraps>

80106685 <vector106>:
80106685:	6a 00                	push   $0x0
80106687:	6a 6a                	push   $0x6a
80106689:	e9 90 f7 ff ff       	jmp    80105e1e <alltraps>

8010668e <vector107>:
8010668e:	6a 00                	push   $0x0
80106690:	6a 6b                	push   $0x6b
80106692:	e9 87 f7 ff ff       	jmp    80105e1e <alltraps>

80106697 <vector108>:
80106697:	6a 00                	push   $0x0
80106699:	6a 6c                	push   $0x6c
8010669b:	e9 7e f7 ff ff       	jmp    80105e1e <alltraps>

801066a0 <vector109>:
801066a0:	6a 00                	push   $0x0
801066a2:	6a 6d                	push   $0x6d
801066a4:	e9 75 f7 ff ff       	jmp    80105e1e <alltraps>

801066a9 <vector110>:
801066a9:	6a 00                	push   $0x0
801066ab:	6a 6e                	push   $0x6e
801066ad:	e9 6c f7 ff ff       	jmp    80105e1e <alltraps>

801066b2 <vector111>:
801066b2:	6a 00                	push   $0x0
801066b4:	6a 6f                	push   $0x6f
801066b6:	e9 63 f7 ff ff       	jmp    80105e1e <alltraps>

801066bb <vector112>:
801066bb:	6a 00                	push   $0x0
801066bd:	6a 70                	push   $0x70
801066bf:	e9 5a f7 ff ff       	jmp    80105e1e <alltraps>

801066c4 <vector113>:
801066c4:	6a 00                	push   $0x0
801066c6:	6a 71                	push   $0x71
801066c8:	e9 51 f7 ff ff       	jmp    80105e1e <alltraps>

801066cd <vector114>:
801066cd:	6a 00                	push   $0x0
801066cf:	6a 72                	push   $0x72
801066d1:	e9 48 f7 ff ff       	jmp    80105e1e <alltraps>

801066d6 <vector115>:
801066d6:	6a 00                	push   $0x0
801066d8:	6a 73                	push   $0x73
801066da:	e9 3f f7 ff ff       	jmp    80105e1e <alltraps>

801066df <vector116>:
801066df:	6a 00                	push   $0x0
801066e1:	6a 74                	push   $0x74
801066e3:	e9 36 f7 ff ff       	jmp    80105e1e <alltraps>

801066e8 <vector117>:
801066e8:	6a 00                	push   $0x0
801066ea:	6a 75                	push   $0x75
801066ec:	e9 2d f7 ff ff       	jmp    80105e1e <alltraps>

801066f1 <vector118>:
801066f1:	6a 00                	push   $0x0
801066f3:	6a 76                	push   $0x76
801066f5:	e9 24 f7 ff ff       	jmp    80105e1e <alltraps>

801066fa <vector119>:
801066fa:	6a 00                	push   $0x0
801066fc:	6a 77                	push   $0x77
801066fe:	e9 1b f7 ff ff       	jmp    80105e1e <alltraps>

80106703 <vector120>:
80106703:	6a 00                	push   $0x0
80106705:	6a 78                	push   $0x78
80106707:	e9 12 f7 ff ff       	jmp    80105e1e <alltraps>

8010670c <vector121>:
8010670c:	6a 00                	push   $0x0
8010670e:	6a 79                	push   $0x79
80106710:	e9 09 f7 ff ff       	jmp    80105e1e <alltraps>

80106715 <vector122>:
80106715:	6a 00                	push   $0x0
80106717:	6a 7a                	push   $0x7a
80106719:	e9 00 f7 ff ff       	jmp    80105e1e <alltraps>

8010671e <vector123>:
8010671e:	6a 00                	push   $0x0
80106720:	6a 7b                	push   $0x7b
80106722:	e9 f7 f6 ff ff       	jmp    80105e1e <alltraps>

80106727 <vector124>:
80106727:	6a 00                	push   $0x0
80106729:	6a 7c                	push   $0x7c
8010672b:	e9 ee f6 ff ff       	jmp    80105e1e <alltraps>

80106730 <vector125>:
80106730:	6a 00                	push   $0x0
80106732:	6a 7d                	push   $0x7d
80106734:	e9 e5 f6 ff ff       	jmp    80105e1e <alltraps>

80106739 <vector126>:
80106739:	6a 00                	push   $0x0
8010673b:	6a 7e                	push   $0x7e
8010673d:	e9 dc f6 ff ff       	jmp    80105e1e <alltraps>

80106742 <vector127>:
80106742:	6a 00                	push   $0x0
80106744:	6a 7f                	push   $0x7f
80106746:	e9 d3 f6 ff ff       	jmp    80105e1e <alltraps>

8010674b <vector128>:
8010674b:	6a 00                	push   $0x0
8010674d:	68 80 00 00 00       	push   $0x80
80106752:	e9 c7 f6 ff ff       	jmp    80105e1e <alltraps>

80106757 <vector129>:
80106757:	6a 00                	push   $0x0
80106759:	68 81 00 00 00       	push   $0x81
8010675e:	e9 bb f6 ff ff       	jmp    80105e1e <alltraps>

80106763 <vector130>:
80106763:	6a 00                	push   $0x0
80106765:	68 82 00 00 00       	push   $0x82
8010676a:	e9 af f6 ff ff       	jmp    80105e1e <alltraps>

8010676f <vector131>:
8010676f:	6a 00                	push   $0x0
80106771:	68 83 00 00 00       	push   $0x83
80106776:	e9 a3 f6 ff ff       	jmp    80105e1e <alltraps>

8010677b <vector132>:
8010677b:	6a 00                	push   $0x0
8010677d:	68 84 00 00 00       	push   $0x84
80106782:	e9 97 f6 ff ff       	jmp    80105e1e <alltraps>

80106787 <vector133>:
80106787:	6a 00                	push   $0x0
80106789:	68 85 00 00 00       	push   $0x85
8010678e:	e9 8b f6 ff ff       	jmp    80105e1e <alltraps>

80106793 <vector134>:
80106793:	6a 00                	push   $0x0
80106795:	68 86 00 00 00       	push   $0x86
8010679a:	e9 7f f6 ff ff       	jmp    80105e1e <alltraps>

8010679f <vector135>:
8010679f:	6a 00                	push   $0x0
801067a1:	68 87 00 00 00       	push   $0x87
801067a6:	e9 73 f6 ff ff       	jmp    80105e1e <alltraps>

801067ab <vector136>:
801067ab:	6a 00                	push   $0x0
801067ad:	68 88 00 00 00       	push   $0x88
801067b2:	e9 67 f6 ff ff       	jmp    80105e1e <alltraps>

801067b7 <vector137>:
801067b7:	6a 00                	push   $0x0
801067b9:	68 89 00 00 00       	push   $0x89
801067be:	e9 5b f6 ff ff       	jmp    80105e1e <alltraps>

801067c3 <vector138>:
801067c3:	6a 00                	push   $0x0
801067c5:	68 8a 00 00 00       	push   $0x8a
801067ca:	e9 4f f6 ff ff       	jmp    80105e1e <alltraps>

801067cf <vector139>:
801067cf:	6a 00                	push   $0x0
801067d1:	68 8b 00 00 00       	push   $0x8b
801067d6:	e9 43 f6 ff ff       	jmp    80105e1e <alltraps>

801067db <vector140>:
801067db:	6a 00                	push   $0x0
801067dd:	68 8c 00 00 00       	push   $0x8c
801067e2:	e9 37 f6 ff ff       	jmp    80105e1e <alltraps>

801067e7 <vector141>:
801067e7:	6a 00                	push   $0x0
801067e9:	68 8d 00 00 00       	push   $0x8d
801067ee:	e9 2b f6 ff ff       	jmp    80105e1e <alltraps>

801067f3 <vector142>:
801067f3:	6a 00                	push   $0x0
801067f5:	68 8e 00 00 00       	push   $0x8e
801067fa:	e9 1f f6 ff ff       	jmp    80105e1e <alltraps>

801067ff <vector143>:
801067ff:	6a 00                	push   $0x0
80106801:	68 8f 00 00 00       	push   $0x8f
80106806:	e9 13 f6 ff ff       	jmp    80105e1e <alltraps>

8010680b <vector144>:
8010680b:	6a 00                	push   $0x0
8010680d:	68 90 00 00 00       	push   $0x90
80106812:	e9 07 f6 ff ff       	jmp    80105e1e <alltraps>

80106817 <vector145>:
80106817:	6a 00                	push   $0x0
80106819:	68 91 00 00 00       	push   $0x91
8010681e:	e9 fb f5 ff ff       	jmp    80105e1e <alltraps>

80106823 <vector146>:
80106823:	6a 00                	push   $0x0
80106825:	68 92 00 00 00       	push   $0x92
8010682a:	e9 ef f5 ff ff       	jmp    80105e1e <alltraps>

8010682f <vector147>:
8010682f:	6a 00                	push   $0x0
80106831:	68 93 00 00 00       	push   $0x93
80106836:	e9 e3 f5 ff ff       	jmp    80105e1e <alltraps>

8010683b <vector148>:
8010683b:	6a 00                	push   $0x0
8010683d:	68 94 00 00 00       	push   $0x94
80106842:	e9 d7 f5 ff ff       	jmp    80105e1e <alltraps>

80106847 <vector149>:
80106847:	6a 00                	push   $0x0
80106849:	68 95 00 00 00       	push   $0x95
8010684e:	e9 cb f5 ff ff       	jmp    80105e1e <alltraps>

80106853 <vector150>:
80106853:	6a 00                	push   $0x0
80106855:	68 96 00 00 00       	push   $0x96
8010685a:	e9 bf f5 ff ff       	jmp    80105e1e <alltraps>

8010685f <vector151>:
8010685f:	6a 00                	push   $0x0
80106861:	68 97 00 00 00       	push   $0x97
80106866:	e9 b3 f5 ff ff       	jmp    80105e1e <alltraps>

8010686b <vector152>:
8010686b:	6a 00                	push   $0x0
8010686d:	68 98 00 00 00       	push   $0x98
80106872:	e9 a7 f5 ff ff       	jmp    80105e1e <alltraps>

80106877 <vector153>:
80106877:	6a 00                	push   $0x0
80106879:	68 99 00 00 00       	push   $0x99
8010687e:	e9 9b f5 ff ff       	jmp    80105e1e <alltraps>

80106883 <vector154>:
80106883:	6a 00                	push   $0x0
80106885:	68 9a 00 00 00       	push   $0x9a
8010688a:	e9 8f f5 ff ff       	jmp    80105e1e <alltraps>

8010688f <vector155>:
8010688f:	6a 00                	push   $0x0
80106891:	68 9b 00 00 00       	push   $0x9b
80106896:	e9 83 f5 ff ff       	jmp    80105e1e <alltraps>

8010689b <vector156>:
8010689b:	6a 00                	push   $0x0
8010689d:	68 9c 00 00 00       	push   $0x9c
801068a2:	e9 77 f5 ff ff       	jmp    80105e1e <alltraps>

801068a7 <vector157>:
801068a7:	6a 00                	push   $0x0
801068a9:	68 9d 00 00 00       	push   $0x9d
801068ae:	e9 6b f5 ff ff       	jmp    80105e1e <alltraps>

801068b3 <vector158>:
801068b3:	6a 00                	push   $0x0
801068b5:	68 9e 00 00 00       	push   $0x9e
801068ba:	e9 5f f5 ff ff       	jmp    80105e1e <alltraps>

801068bf <vector159>:
801068bf:	6a 00                	push   $0x0
801068c1:	68 9f 00 00 00       	push   $0x9f
801068c6:	e9 53 f5 ff ff       	jmp    80105e1e <alltraps>

801068cb <vector160>:
801068cb:	6a 00                	push   $0x0
801068cd:	68 a0 00 00 00       	push   $0xa0
801068d2:	e9 47 f5 ff ff       	jmp    80105e1e <alltraps>

801068d7 <vector161>:
801068d7:	6a 00                	push   $0x0
801068d9:	68 a1 00 00 00       	push   $0xa1
801068de:	e9 3b f5 ff ff       	jmp    80105e1e <alltraps>

801068e3 <vector162>:
801068e3:	6a 00                	push   $0x0
801068e5:	68 a2 00 00 00       	push   $0xa2
801068ea:	e9 2f f5 ff ff       	jmp    80105e1e <alltraps>

801068ef <vector163>:
801068ef:	6a 00                	push   $0x0
801068f1:	68 a3 00 00 00       	push   $0xa3
801068f6:	e9 23 f5 ff ff       	jmp    80105e1e <alltraps>

801068fb <vector164>:
801068fb:	6a 00                	push   $0x0
801068fd:	68 a4 00 00 00       	push   $0xa4
80106902:	e9 17 f5 ff ff       	jmp    80105e1e <alltraps>

80106907 <vector165>:
80106907:	6a 00                	push   $0x0
80106909:	68 a5 00 00 00       	push   $0xa5
8010690e:	e9 0b f5 ff ff       	jmp    80105e1e <alltraps>

80106913 <vector166>:
80106913:	6a 00                	push   $0x0
80106915:	68 a6 00 00 00       	push   $0xa6
8010691a:	e9 ff f4 ff ff       	jmp    80105e1e <alltraps>

8010691f <vector167>:
8010691f:	6a 00                	push   $0x0
80106921:	68 a7 00 00 00       	push   $0xa7
80106926:	e9 f3 f4 ff ff       	jmp    80105e1e <alltraps>

8010692b <vector168>:
8010692b:	6a 00                	push   $0x0
8010692d:	68 a8 00 00 00       	push   $0xa8
80106932:	e9 e7 f4 ff ff       	jmp    80105e1e <alltraps>

80106937 <vector169>:
80106937:	6a 00                	push   $0x0
80106939:	68 a9 00 00 00       	push   $0xa9
8010693e:	e9 db f4 ff ff       	jmp    80105e1e <alltraps>

80106943 <vector170>:
80106943:	6a 00                	push   $0x0
80106945:	68 aa 00 00 00       	push   $0xaa
8010694a:	e9 cf f4 ff ff       	jmp    80105e1e <alltraps>

8010694f <vector171>:
8010694f:	6a 00                	push   $0x0
80106951:	68 ab 00 00 00       	push   $0xab
80106956:	e9 c3 f4 ff ff       	jmp    80105e1e <alltraps>

8010695b <vector172>:
8010695b:	6a 00                	push   $0x0
8010695d:	68 ac 00 00 00       	push   $0xac
80106962:	e9 b7 f4 ff ff       	jmp    80105e1e <alltraps>

80106967 <vector173>:
80106967:	6a 00                	push   $0x0
80106969:	68 ad 00 00 00       	push   $0xad
8010696e:	e9 ab f4 ff ff       	jmp    80105e1e <alltraps>

80106973 <vector174>:
80106973:	6a 00                	push   $0x0
80106975:	68 ae 00 00 00       	push   $0xae
8010697a:	e9 9f f4 ff ff       	jmp    80105e1e <alltraps>

8010697f <vector175>:
8010697f:	6a 00                	push   $0x0
80106981:	68 af 00 00 00       	push   $0xaf
80106986:	e9 93 f4 ff ff       	jmp    80105e1e <alltraps>

8010698b <vector176>:
8010698b:	6a 00                	push   $0x0
8010698d:	68 b0 00 00 00       	push   $0xb0
80106992:	e9 87 f4 ff ff       	jmp    80105e1e <alltraps>

80106997 <vector177>:
80106997:	6a 00                	push   $0x0
80106999:	68 b1 00 00 00       	push   $0xb1
8010699e:	e9 7b f4 ff ff       	jmp    80105e1e <alltraps>

801069a3 <vector178>:
801069a3:	6a 00                	push   $0x0
801069a5:	68 b2 00 00 00       	push   $0xb2
801069aa:	e9 6f f4 ff ff       	jmp    80105e1e <alltraps>

801069af <vector179>:
801069af:	6a 00                	push   $0x0
801069b1:	68 b3 00 00 00       	push   $0xb3
801069b6:	e9 63 f4 ff ff       	jmp    80105e1e <alltraps>

801069bb <vector180>:
801069bb:	6a 00                	push   $0x0
801069bd:	68 b4 00 00 00       	push   $0xb4
801069c2:	e9 57 f4 ff ff       	jmp    80105e1e <alltraps>

801069c7 <vector181>:
801069c7:	6a 00                	push   $0x0
801069c9:	68 b5 00 00 00       	push   $0xb5
801069ce:	e9 4b f4 ff ff       	jmp    80105e1e <alltraps>

801069d3 <vector182>:
801069d3:	6a 00                	push   $0x0
801069d5:	68 b6 00 00 00       	push   $0xb6
801069da:	e9 3f f4 ff ff       	jmp    80105e1e <alltraps>

801069df <vector183>:
801069df:	6a 00                	push   $0x0
801069e1:	68 b7 00 00 00       	push   $0xb7
801069e6:	e9 33 f4 ff ff       	jmp    80105e1e <alltraps>

801069eb <vector184>:
801069eb:	6a 00                	push   $0x0
801069ed:	68 b8 00 00 00       	push   $0xb8
801069f2:	e9 27 f4 ff ff       	jmp    80105e1e <alltraps>

801069f7 <vector185>:
801069f7:	6a 00                	push   $0x0
801069f9:	68 b9 00 00 00       	push   $0xb9
801069fe:	e9 1b f4 ff ff       	jmp    80105e1e <alltraps>

80106a03 <vector186>:
80106a03:	6a 00                	push   $0x0
80106a05:	68 ba 00 00 00       	push   $0xba
80106a0a:	e9 0f f4 ff ff       	jmp    80105e1e <alltraps>

80106a0f <vector187>:
80106a0f:	6a 00                	push   $0x0
80106a11:	68 bb 00 00 00       	push   $0xbb
80106a16:	e9 03 f4 ff ff       	jmp    80105e1e <alltraps>

80106a1b <vector188>:
80106a1b:	6a 00                	push   $0x0
80106a1d:	68 bc 00 00 00       	push   $0xbc
80106a22:	e9 f7 f3 ff ff       	jmp    80105e1e <alltraps>

80106a27 <vector189>:
80106a27:	6a 00                	push   $0x0
80106a29:	68 bd 00 00 00       	push   $0xbd
80106a2e:	e9 eb f3 ff ff       	jmp    80105e1e <alltraps>

80106a33 <vector190>:
80106a33:	6a 00                	push   $0x0
80106a35:	68 be 00 00 00       	push   $0xbe
80106a3a:	e9 df f3 ff ff       	jmp    80105e1e <alltraps>

80106a3f <vector191>:
80106a3f:	6a 00                	push   $0x0
80106a41:	68 bf 00 00 00       	push   $0xbf
80106a46:	e9 d3 f3 ff ff       	jmp    80105e1e <alltraps>

80106a4b <vector192>:
80106a4b:	6a 00                	push   $0x0
80106a4d:	68 c0 00 00 00       	push   $0xc0
80106a52:	e9 c7 f3 ff ff       	jmp    80105e1e <alltraps>

80106a57 <vector193>:
80106a57:	6a 00                	push   $0x0
80106a59:	68 c1 00 00 00       	push   $0xc1
80106a5e:	e9 bb f3 ff ff       	jmp    80105e1e <alltraps>

80106a63 <vector194>:
80106a63:	6a 00                	push   $0x0
80106a65:	68 c2 00 00 00       	push   $0xc2
80106a6a:	e9 af f3 ff ff       	jmp    80105e1e <alltraps>

80106a6f <vector195>:
80106a6f:	6a 00                	push   $0x0
80106a71:	68 c3 00 00 00       	push   $0xc3
80106a76:	e9 a3 f3 ff ff       	jmp    80105e1e <alltraps>

80106a7b <vector196>:
80106a7b:	6a 00                	push   $0x0
80106a7d:	68 c4 00 00 00       	push   $0xc4
80106a82:	e9 97 f3 ff ff       	jmp    80105e1e <alltraps>

80106a87 <vector197>:
80106a87:	6a 00                	push   $0x0
80106a89:	68 c5 00 00 00       	push   $0xc5
80106a8e:	e9 8b f3 ff ff       	jmp    80105e1e <alltraps>

80106a93 <vector198>:
80106a93:	6a 00                	push   $0x0
80106a95:	68 c6 00 00 00       	push   $0xc6
80106a9a:	e9 7f f3 ff ff       	jmp    80105e1e <alltraps>

80106a9f <vector199>:
80106a9f:	6a 00                	push   $0x0
80106aa1:	68 c7 00 00 00       	push   $0xc7
80106aa6:	e9 73 f3 ff ff       	jmp    80105e1e <alltraps>

80106aab <vector200>:
80106aab:	6a 00                	push   $0x0
80106aad:	68 c8 00 00 00       	push   $0xc8
80106ab2:	e9 67 f3 ff ff       	jmp    80105e1e <alltraps>

80106ab7 <vector201>:
80106ab7:	6a 00                	push   $0x0
80106ab9:	68 c9 00 00 00       	push   $0xc9
80106abe:	e9 5b f3 ff ff       	jmp    80105e1e <alltraps>

80106ac3 <vector202>:
80106ac3:	6a 00                	push   $0x0
80106ac5:	68 ca 00 00 00       	push   $0xca
80106aca:	e9 4f f3 ff ff       	jmp    80105e1e <alltraps>

80106acf <vector203>:
80106acf:	6a 00                	push   $0x0
80106ad1:	68 cb 00 00 00       	push   $0xcb
80106ad6:	e9 43 f3 ff ff       	jmp    80105e1e <alltraps>

80106adb <vector204>:
80106adb:	6a 00                	push   $0x0
80106add:	68 cc 00 00 00       	push   $0xcc
80106ae2:	e9 37 f3 ff ff       	jmp    80105e1e <alltraps>

80106ae7 <vector205>:
80106ae7:	6a 00                	push   $0x0
80106ae9:	68 cd 00 00 00       	push   $0xcd
80106aee:	e9 2b f3 ff ff       	jmp    80105e1e <alltraps>

80106af3 <vector206>:
80106af3:	6a 00                	push   $0x0
80106af5:	68 ce 00 00 00       	push   $0xce
80106afa:	e9 1f f3 ff ff       	jmp    80105e1e <alltraps>

80106aff <vector207>:
80106aff:	6a 00                	push   $0x0
80106b01:	68 cf 00 00 00       	push   $0xcf
80106b06:	e9 13 f3 ff ff       	jmp    80105e1e <alltraps>

80106b0b <vector208>:
80106b0b:	6a 00                	push   $0x0
80106b0d:	68 d0 00 00 00       	push   $0xd0
80106b12:	e9 07 f3 ff ff       	jmp    80105e1e <alltraps>

80106b17 <vector209>:
80106b17:	6a 00                	push   $0x0
80106b19:	68 d1 00 00 00       	push   $0xd1
80106b1e:	e9 fb f2 ff ff       	jmp    80105e1e <alltraps>

80106b23 <vector210>:
80106b23:	6a 00                	push   $0x0
80106b25:	68 d2 00 00 00       	push   $0xd2
80106b2a:	e9 ef f2 ff ff       	jmp    80105e1e <alltraps>

80106b2f <vector211>:
80106b2f:	6a 00                	push   $0x0
80106b31:	68 d3 00 00 00       	push   $0xd3
80106b36:	e9 e3 f2 ff ff       	jmp    80105e1e <alltraps>

80106b3b <vector212>:
80106b3b:	6a 00                	push   $0x0
80106b3d:	68 d4 00 00 00       	push   $0xd4
80106b42:	e9 d7 f2 ff ff       	jmp    80105e1e <alltraps>

80106b47 <vector213>:
80106b47:	6a 00                	push   $0x0
80106b49:	68 d5 00 00 00       	push   $0xd5
80106b4e:	e9 cb f2 ff ff       	jmp    80105e1e <alltraps>

80106b53 <vector214>:
80106b53:	6a 00                	push   $0x0
80106b55:	68 d6 00 00 00       	push   $0xd6
80106b5a:	e9 bf f2 ff ff       	jmp    80105e1e <alltraps>

80106b5f <vector215>:
80106b5f:	6a 00                	push   $0x0
80106b61:	68 d7 00 00 00       	push   $0xd7
80106b66:	e9 b3 f2 ff ff       	jmp    80105e1e <alltraps>

80106b6b <vector216>:
80106b6b:	6a 00                	push   $0x0
80106b6d:	68 d8 00 00 00       	push   $0xd8
80106b72:	e9 a7 f2 ff ff       	jmp    80105e1e <alltraps>

80106b77 <vector217>:
80106b77:	6a 00                	push   $0x0
80106b79:	68 d9 00 00 00       	push   $0xd9
80106b7e:	e9 9b f2 ff ff       	jmp    80105e1e <alltraps>

80106b83 <vector218>:
80106b83:	6a 00                	push   $0x0
80106b85:	68 da 00 00 00       	push   $0xda
80106b8a:	e9 8f f2 ff ff       	jmp    80105e1e <alltraps>

80106b8f <vector219>:
80106b8f:	6a 00                	push   $0x0
80106b91:	68 db 00 00 00       	push   $0xdb
80106b96:	e9 83 f2 ff ff       	jmp    80105e1e <alltraps>

80106b9b <vector220>:
80106b9b:	6a 00                	push   $0x0
80106b9d:	68 dc 00 00 00       	push   $0xdc
80106ba2:	e9 77 f2 ff ff       	jmp    80105e1e <alltraps>

80106ba7 <vector221>:
80106ba7:	6a 00                	push   $0x0
80106ba9:	68 dd 00 00 00       	push   $0xdd
80106bae:	e9 6b f2 ff ff       	jmp    80105e1e <alltraps>

80106bb3 <vector222>:
80106bb3:	6a 00                	push   $0x0
80106bb5:	68 de 00 00 00       	push   $0xde
80106bba:	e9 5f f2 ff ff       	jmp    80105e1e <alltraps>

80106bbf <vector223>:
80106bbf:	6a 00                	push   $0x0
80106bc1:	68 df 00 00 00       	push   $0xdf
80106bc6:	e9 53 f2 ff ff       	jmp    80105e1e <alltraps>

80106bcb <vector224>:
80106bcb:	6a 00                	push   $0x0
80106bcd:	68 e0 00 00 00       	push   $0xe0
80106bd2:	e9 47 f2 ff ff       	jmp    80105e1e <alltraps>

80106bd7 <vector225>:
80106bd7:	6a 00                	push   $0x0
80106bd9:	68 e1 00 00 00       	push   $0xe1
80106bde:	e9 3b f2 ff ff       	jmp    80105e1e <alltraps>

80106be3 <vector226>:
80106be3:	6a 00                	push   $0x0
80106be5:	68 e2 00 00 00       	push   $0xe2
80106bea:	e9 2f f2 ff ff       	jmp    80105e1e <alltraps>

80106bef <vector227>:
80106bef:	6a 00                	push   $0x0
80106bf1:	68 e3 00 00 00       	push   $0xe3
80106bf6:	e9 23 f2 ff ff       	jmp    80105e1e <alltraps>

80106bfb <vector228>:
80106bfb:	6a 00                	push   $0x0
80106bfd:	68 e4 00 00 00       	push   $0xe4
80106c02:	e9 17 f2 ff ff       	jmp    80105e1e <alltraps>

80106c07 <vector229>:
80106c07:	6a 00                	push   $0x0
80106c09:	68 e5 00 00 00       	push   $0xe5
80106c0e:	e9 0b f2 ff ff       	jmp    80105e1e <alltraps>

80106c13 <vector230>:
80106c13:	6a 00                	push   $0x0
80106c15:	68 e6 00 00 00       	push   $0xe6
80106c1a:	e9 ff f1 ff ff       	jmp    80105e1e <alltraps>

80106c1f <vector231>:
80106c1f:	6a 00                	push   $0x0
80106c21:	68 e7 00 00 00       	push   $0xe7
80106c26:	e9 f3 f1 ff ff       	jmp    80105e1e <alltraps>

80106c2b <vector232>:
80106c2b:	6a 00                	push   $0x0
80106c2d:	68 e8 00 00 00       	push   $0xe8
80106c32:	e9 e7 f1 ff ff       	jmp    80105e1e <alltraps>

80106c37 <vector233>:
80106c37:	6a 00                	push   $0x0
80106c39:	68 e9 00 00 00       	push   $0xe9
80106c3e:	e9 db f1 ff ff       	jmp    80105e1e <alltraps>

80106c43 <vector234>:
80106c43:	6a 00                	push   $0x0
80106c45:	68 ea 00 00 00       	push   $0xea
80106c4a:	e9 cf f1 ff ff       	jmp    80105e1e <alltraps>

80106c4f <vector235>:
80106c4f:	6a 00                	push   $0x0
80106c51:	68 eb 00 00 00       	push   $0xeb
80106c56:	e9 c3 f1 ff ff       	jmp    80105e1e <alltraps>

80106c5b <vector236>:
80106c5b:	6a 00                	push   $0x0
80106c5d:	68 ec 00 00 00       	push   $0xec
80106c62:	e9 b7 f1 ff ff       	jmp    80105e1e <alltraps>

80106c67 <vector237>:
80106c67:	6a 00                	push   $0x0
80106c69:	68 ed 00 00 00       	push   $0xed
80106c6e:	e9 ab f1 ff ff       	jmp    80105e1e <alltraps>

80106c73 <vector238>:
80106c73:	6a 00                	push   $0x0
80106c75:	68 ee 00 00 00       	push   $0xee
80106c7a:	e9 9f f1 ff ff       	jmp    80105e1e <alltraps>

80106c7f <vector239>:
80106c7f:	6a 00                	push   $0x0
80106c81:	68 ef 00 00 00       	push   $0xef
80106c86:	e9 93 f1 ff ff       	jmp    80105e1e <alltraps>

80106c8b <vector240>:
80106c8b:	6a 00                	push   $0x0
80106c8d:	68 f0 00 00 00       	push   $0xf0
80106c92:	e9 87 f1 ff ff       	jmp    80105e1e <alltraps>

80106c97 <vector241>:
80106c97:	6a 00                	push   $0x0
80106c99:	68 f1 00 00 00       	push   $0xf1
80106c9e:	e9 7b f1 ff ff       	jmp    80105e1e <alltraps>

80106ca3 <vector242>:
80106ca3:	6a 00                	push   $0x0
80106ca5:	68 f2 00 00 00       	push   $0xf2
80106caa:	e9 6f f1 ff ff       	jmp    80105e1e <alltraps>

80106caf <vector243>:
80106caf:	6a 00                	push   $0x0
80106cb1:	68 f3 00 00 00       	push   $0xf3
80106cb6:	e9 63 f1 ff ff       	jmp    80105e1e <alltraps>

80106cbb <vector244>:
80106cbb:	6a 00                	push   $0x0
80106cbd:	68 f4 00 00 00       	push   $0xf4
80106cc2:	e9 57 f1 ff ff       	jmp    80105e1e <alltraps>

80106cc7 <vector245>:
80106cc7:	6a 00                	push   $0x0
80106cc9:	68 f5 00 00 00       	push   $0xf5
80106cce:	e9 4b f1 ff ff       	jmp    80105e1e <alltraps>

80106cd3 <vector246>:
80106cd3:	6a 00                	push   $0x0
80106cd5:	68 f6 00 00 00       	push   $0xf6
80106cda:	e9 3f f1 ff ff       	jmp    80105e1e <alltraps>

80106cdf <vector247>:
80106cdf:	6a 00                	push   $0x0
80106ce1:	68 f7 00 00 00       	push   $0xf7
80106ce6:	e9 33 f1 ff ff       	jmp    80105e1e <alltraps>

80106ceb <vector248>:
80106ceb:	6a 00                	push   $0x0
80106ced:	68 f8 00 00 00       	push   $0xf8
80106cf2:	e9 27 f1 ff ff       	jmp    80105e1e <alltraps>

80106cf7 <vector249>:
80106cf7:	6a 00                	push   $0x0
80106cf9:	68 f9 00 00 00       	push   $0xf9
80106cfe:	e9 1b f1 ff ff       	jmp    80105e1e <alltraps>

80106d03 <vector250>:
80106d03:	6a 00                	push   $0x0
80106d05:	68 fa 00 00 00       	push   $0xfa
80106d0a:	e9 0f f1 ff ff       	jmp    80105e1e <alltraps>

80106d0f <vector251>:
80106d0f:	6a 00                	push   $0x0
80106d11:	68 fb 00 00 00       	push   $0xfb
80106d16:	e9 03 f1 ff ff       	jmp    80105e1e <alltraps>

80106d1b <vector252>:
80106d1b:	6a 00                	push   $0x0
80106d1d:	68 fc 00 00 00       	push   $0xfc
80106d22:	e9 f7 f0 ff ff       	jmp    80105e1e <alltraps>

80106d27 <vector253>:
80106d27:	6a 00                	push   $0x0
80106d29:	68 fd 00 00 00       	push   $0xfd
80106d2e:	e9 eb f0 ff ff       	jmp    80105e1e <alltraps>

80106d33 <vector254>:
80106d33:	6a 00                	push   $0x0
80106d35:	68 fe 00 00 00       	push   $0xfe
80106d3a:	e9 df f0 ff ff       	jmp    80105e1e <alltraps>

80106d3f <vector255>:
80106d3f:	6a 00                	push   $0x0
80106d41:	68 ff 00 00 00       	push   $0xff
80106d46:	e9 d3 f0 ff ff       	jmp    80105e1e <alltraps>
80106d4b:	66 90                	xchg   %ax,%ax
80106d4d:	66 90                	xchg   %ax,%ax
80106d4f:	90                   	nop

80106d50 <walkpgdir>:
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	57                   	push   %edi
80106d54:	56                   	push   %esi
80106d55:	89 d6                	mov    %edx,%esi
80106d57:	c1 ea 16             	shr    $0x16,%edx
80106d5a:	53                   	push   %ebx
80106d5b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80106d5e:	83 ec 0c             	sub    $0xc,%esp
80106d61:	8b 1f                	mov    (%edi),%ebx
80106d63:	f6 c3 01             	test   $0x1,%bl
80106d66:	74 28                	je     80106d90 <walkpgdir+0x40>
80106d68:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106d6e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106d74:	89 f0                	mov    %esi,%eax
80106d76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d79:	c1 e8 0a             	shr    $0xa,%eax
80106d7c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d81:	01 d8                	add    %ebx,%eax
80106d83:	5b                   	pop    %ebx
80106d84:	5e                   	pop    %esi
80106d85:	5f                   	pop    %edi
80106d86:	5d                   	pop    %ebp
80106d87:	c3                   	ret    
80106d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d8f:	90                   	nop
80106d90:	85 c9                	test   %ecx,%ecx
80106d92:	74 2c                	je     80106dc0 <walkpgdir+0x70>
80106d94:	e8 47 be ff ff       	call   80102be0 <kalloc>
80106d99:	89 c3                	mov    %eax,%ebx
80106d9b:	85 c0                	test   %eax,%eax
80106d9d:	74 21                	je     80106dc0 <walkpgdir+0x70>
80106d9f:	83 ec 04             	sub    $0x4,%esp
80106da2:	68 00 10 00 00       	push   $0x1000
80106da7:	6a 00                	push   $0x0
80106da9:	50                   	push   %eax
80106daa:	e8 71 de ff ff       	call   80104c20 <memset>
80106daf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106db5:	83 c4 10             	add    $0x10,%esp
80106db8:	83 c8 07             	or     $0x7,%eax
80106dbb:	89 07                	mov    %eax,(%edi)
80106dbd:	eb b5                	jmp    80106d74 <walkpgdir+0x24>
80106dbf:	90                   	nop
80106dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dc3:	31 c0                	xor    %eax,%eax
80106dc5:	5b                   	pop    %ebx
80106dc6:	5e                   	pop    %esi
80106dc7:	5f                   	pop    %edi
80106dc8:	5d                   	pop    %ebp
80106dc9:	c3                   	ret    
80106dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106dd0 <mappages>:
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	89 c7                	mov    %eax,%edi
80106dd6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106dda:	56                   	push   %esi
80106ddb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106de0:	89 d6                	mov    %edx,%esi
80106de2:	53                   	push   %ebx
80106de3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106de9:	83 ec 1c             	sub    $0x1c,%esp
80106dec:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106def:	8b 45 08             	mov    0x8(%ebp),%eax
80106df2:	29 f0                	sub    %esi,%eax
80106df4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106df7:	eb 1f                	jmp    80106e18 <mappages+0x48>
80106df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e00:	f6 00 01             	testb  $0x1,(%eax)
80106e03:	75 45                	jne    80106e4a <mappages+0x7a>
80106e05:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106e08:	83 cb 01             	or     $0x1,%ebx
80106e0b:	89 18                	mov    %ebx,(%eax)
80106e0d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106e10:	74 2e                	je     80106e40 <mappages+0x70>
80106e12:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e1b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106e20:	89 f2                	mov    %esi,%edx
80106e22:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106e25:	89 f8                	mov    %edi,%eax
80106e27:	e8 24 ff ff ff       	call   80106d50 <walkpgdir>
80106e2c:	85 c0                	test   %eax,%eax
80106e2e:	75 d0                	jne    80106e00 <mappages+0x30>
80106e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e38:	5b                   	pop    %ebx
80106e39:	5e                   	pop    %esi
80106e3a:	5f                   	pop    %edi
80106e3b:	5d                   	pop    %ebp
80106e3c:	c3                   	ret    
80106e3d:	8d 76 00             	lea    0x0(%esi),%esi
80106e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e43:	31 c0                	xor    %eax,%eax
80106e45:	5b                   	pop    %ebx
80106e46:	5e                   	pop    %esi
80106e47:	5f                   	pop    %edi
80106e48:	5d                   	pop    %ebp
80106e49:	c3                   	ret    
80106e4a:	83 ec 0c             	sub    $0xc,%esp
80106e4d:	68 a8 7f 10 80       	push   $0x80107fa8
80106e52:	e8 39 95 ff ff       	call   80100390 <panic>
80106e57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e5e:	66 90                	xchg   %ax,%ax

80106e60 <deallocuvm.part.0>:
80106e60:	55                   	push   %ebp
80106e61:	89 e5                	mov    %esp,%ebp
80106e63:	57                   	push   %edi
80106e64:	56                   	push   %esi
80106e65:	89 c6                	mov    %eax,%esi
80106e67:	53                   	push   %ebx
80106e68:	89 d3                	mov    %edx,%ebx
80106e6a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106e70:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106e76:	83 ec 1c             	sub    $0x1c,%esp
80106e79:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106e7c:	39 da                	cmp    %ebx,%edx
80106e7e:	73 5b                	jae    80106edb <deallocuvm.part.0+0x7b>
80106e80:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106e83:	89 d7                	mov    %edx,%edi
80106e85:	eb 14                	jmp    80106e9b <deallocuvm.part.0+0x3b>
80106e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e8e:	66 90                	xchg   %ax,%ax
80106e90:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106e96:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106e99:	76 40                	jbe    80106edb <deallocuvm.part.0+0x7b>
80106e9b:	31 c9                	xor    %ecx,%ecx
80106e9d:	89 fa                	mov    %edi,%edx
80106e9f:	89 f0                	mov    %esi,%eax
80106ea1:	e8 aa fe ff ff       	call   80106d50 <walkpgdir>
80106ea6:	89 c3                	mov    %eax,%ebx
80106ea8:	85 c0                	test   %eax,%eax
80106eaa:	74 44                	je     80106ef0 <deallocuvm.part.0+0x90>
80106eac:	8b 00                	mov    (%eax),%eax
80106eae:	a8 01                	test   $0x1,%al
80106eb0:	74 de                	je     80106e90 <deallocuvm.part.0+0x30>
80106eb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106eb7:	74 47                	je     80106f00 <deallocuvm.part.0+0xa0>
80106eb9:	83 ec 0c             	sub    $0xc,%esp
80106ebc:	05 00 00 00 80       	add    $0x80000000,%eax
80106ec1:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106ec7:	50                   	push   %eax
80106ec8:	e8 53 bb ff ff       	call   80102a20 <kfree>
80106ecd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106ed3:	83 c4 10             	add    $0x10,%esp
80106ed6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106ed9:	77 c0                	ja     80106e9b <deallocuvm.part.0+0x3b>
80106edb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ee1:	5b                   	pop    %ebx
80106ee2:	5e                   	pop    %esi
80106ee3:	5f                   	pop    %edi
80106ee4:	5d                   	pop    %ebp
80106ee5:	c3                   	ret    
80106ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eed:	8d 76 00             	lea    0x0(%esi),%esi
80106ef0:	89 fa                	mov    %edi,%edx
80106ef2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106ef8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80106efe:	eb 96                	jmp    80106e96 <deallocuvm.part.0+0x36>
80106f00:	83 ec 0c             	sub    $0xc,%esp
80106f03:	68 5e 79 10 80       	push   $0x8010795e
80106f08:	e8 83 94 ff ff       	call   80100390 <panic>
80106f0d:	8d 76 00             	lea    0x0(%esi),%esi

80106f10 <seginit>:
80106f10:	f3 0f 1e fb          	endbr32 
80106f14:	55                   	push   %ebp
80106f15:	89 e5                	mov    %esp,%ebp
80106f17:	83 ec 18             	sub    $0x18,%esp
80106f1a:	e8 d1 cf ff ff       	call   80103ef0 <cpuid>
80106f1f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106f24:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106f2a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106f2e:	c7 80 98 3d 11 80 ff 	movl   $0xffff,-0x7feec268(%eax)
80106f35:	ff 00 00 
80106f38:	c7 80 9c 3d 11 80 00 	movl   $0xcf9a00,-0x7feec264(%eax)
80106f3f:	9a cf 00 
80106f42:	c7 80 a0 3d 11 80 ff 	movl   $0xffff,-0x7feec260(%eax)
80106f49:	ff 00 00 
80106f4c:	c7 80 a4 3d 11 80 00 	movl   $0xcf9200,-0x7feec25c(%eax)
80106f53:	92 cf 00 
80106f56:	c7 80 a8 3d 11 80 ff 	movl   $0xffff,-0x7feec258(%eax)
80106f5d:	ff 00 00 
80106f60:	c7 80 ac 3d 11 80 00 	movl   $0xcffa00,-0x7feec254(%eax)
80106f67:	fa cf 00 
80106f6a:	c7 80 b0 3d 11 80 ff 	movl   $0xffff,-0x7feec250(%eax)
80106f71:	ff 00 00 
80106f74:	c7 80 b4 3d 11 80 00 	movl   $0xcff200,-0x7feec24c(%eax)
80106f7b:	f2 cf 00 
80106f7e:	05 90 3d 11 80       	add    $0x80113d90,%eax
80106f83:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80106f87:	c1 e8 10             	shr    $0x10,%eax
80106f8a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
80106f8e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f91:	0f 01 10             	lgdtl  (%eax)
80106f94:	c9                   	leave  
80106f95:	c3                   	ret    
80106f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f9d:	8d 76 00             	lea    0x0(%esi),%esi

80106fa0 <switchkvm>:
80106fa0:	f3 0f 1e fb          	endbr32 
80106fa4:	a1 44 6a 11 80       	mov    0x80116a44,%eax
80106fa9:	05 00 00 00 80       	add    $0x80000000,%eax
80106fae:	0f 22 d8             	mov    %eax,%cr3
80106fb1:	c3                   	ret    
80106fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fc0 <switchuvm>:
80106fc0:	f3 0f 1e fb          	endbr32 
80106fc4:	55                   	push   %ebp
80106fc5:	89 e5                	mov    %esp,%ebp
80106fc7:	57                   	push   %edi
80106fc8:	56                   	push   %esi
80106fc9:	53                   	push   %ebx
80106fca:	83 ec 1c             	sub    $0x1c,%esp
80106fcd:	8b 75 08             	mov    0x8(%ebp),%esi
80106fd0:	85 f6                	test   %esi,%esi
80106fd2:	0f 84 cb 00 00 00    	je     801070a3 <switchuvm+0xe3>
80106fd8:	8b 46 08             	mov    0x8(%esi),%eax
80106fdb:	85 c0                	test   %eax,%eax
80106fdd:	0f 84 da 00 00 00    	je     801070bd <switchuvm+0xfd>
80106fe3:	8b 46 04             	mov    0x4(%esi),%eax
80106fe6:	85 c0                	test   %eax,%eax
80106fe8:	0f 84 c2 00 00 00    	je     801070b0 <switchuvm+0xf0>
80106fee:	e8 1d da ff ff       	call   80104a10 <pushcli>
80106ff3:	e8 88 ce ff ff       	call   80103e80 <mycpu>
80106ff8:	89 c3                	mov    %eax,%ebx
80106ffa:	e8 81 ce ff ff       	call   80103e80 <mycpu>
80106fff:	89 c7                	mov    %eax,%edi
80107001:	e8 7a ce ff ff       	call   80103e80 <mycpu>
80107006:	83 c7 08             	add    $0x8,%edi
80107009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010700c:	e8 6f ce ff ff       	call   80103e80 <mycpu>
80107011:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107014:	ba 67 00 00 00       	mov    $0x67,%edx
80107019:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107020:	83 c0 08             	add    $0x8,%eax
80107023:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010702a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010702f:	83 c1 08             	add    $0x8,%ecx
80107032:	c1 e8 18             	shr    $0x18,%eax
80107035:	c1 e9 10             	shr    $0x10,%ecx
80107038:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010703e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107044:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107049:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
80107050:	bb 10 00 00 00       	mov    $0x10,%ebx
80107055:	e8 26 ce ff ff       	call   80103e80 <mycpu>
8010705a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
80107061:	e8 1a ce ff ff       	call   80103e80 <mycpu>
80107066:	66 89 58 10          	mov    %bx,0x10(%eax)
8010706a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010706d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107073:	e8 08 ce ff ff       	call   80103e80 <mycpu>
80107078:	89 58 0c             	mov    %ebx,0xc(%eax)
8010707b:	e8 00 ce ff ff       	call   80103e80 <mycpu>
80107080:	66 89 78 6e          	mov    %di,0x6e(%eax)
80107084:	b8 28 00 00 00       	mov    $0x28,%eax
80107089:	0f 00 d8             	ltr    %ax
8010708c:	8b 46 04             	mov    0x4(%esi),%eax
8010708f:	05 00 00 00 80       	add    $0x80000000,%eax
80107094:	0f 22 d8             	mov    %eax,%cr3
80107097:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010709a:	5b                   	pop    %ebx
8010709b:	5e                   	pop    %esi
8010709c:	5f                   	pop    %edi
8010709d:	5d                   	pop    %ebp
8010709e:	e9 bd d9 ff ff       	jmp    80104a60 <popcli>
801070a3:	83 ec 0c             	sub    $0xc,%esp
801070a6:	68 ae 7f 10 80       	push   $0x80107fae
801070ab:	e8 e0 92 ff ff       	call   80100390 <panic>
801070b0:	83 ec 0c             	sub    $0xc,%esp
801070b3:	68 d9 7f 10 80       	push   $0x80107fd9
801070b8:	e8 d3 92 ff ff       	call   80100390 <panic>
801070bd:	83 ec 0c             	sub    $0xc,%esp
801070c0:	68 c4 7f 10 80       	push   $0x80107fc4
801070c5:	e8 c6 92 ff ff       	call   80100390 <panic>
801070ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070d0 <inituvm>:
801070d0:	f3 0f 1e fb          	endbr32 
801070d4:	55                   	push   %ebp
801070d5:	89 e5                	mov    %esp,%ebp
801070d7:	57                   	push   %edi
801070d8:	56                   	push   %esi
801070d9:	53                   	push   %ebx
801070da:	83 ec 1c             	sub    $0x1c,%esp
801070dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801070e0:	8b 75 10             	mov    0x10(%ebp),%esi
801070e3:	8b 7d 08             	mov    0x8(%ebp),%edi
801070e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070e9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801070ef:	77 4b                	ja     8010713c <inituvm+0x6c>
801070f1:	e8 ea ba ff ff       	call   80102be0 <kalloc>
801070f6:	83 ec 04             	sub    $0x4,%esp
801070f9:	68 00 10 00 00       	push   $0x1000
801070fe:	89 c3                	mov    %eax,%ebx
80107100:	6a 00                	push   $0x0
80107102:	50                   	push   %eax
80107103:	e8 18 db ff ff       	call   80104c20 <memset>
80107108:	58                   	pop    %eax
80107109:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010710f:	5a                   	pop    %edx
80107110:	6a 06                	push   $0x6
80107112:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107117:	31 d2                	xor    %edx,%edx
80107119:	50                   	push   %eax
8010711a:	89 f8                	mov    %edi,%eax
8010711c:	e8 af fc ff ff       	call   80106dd0 <mappages>
80107121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107124:	89 75 10             	mov    %esi,0x10(%ebp)
80107127:	83 c4 10             	add    $0x10,%esp
8010712a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010712d:	89 45 0c             	mov    %eax,0xc(%ebp)
80107130:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107133:	5b                   	pop    %ebx
80107134:	5e                   	pop    %esi
80107135:	5f                   	pop    %edi
80107136:	5d                   	pop    %ebp
80107137:	e9 84 db ff ff       	jmp    80104cc0 <memmove>
8010713c:	83 ec 0c             	sub    $0xc,%esp
8010713f:	68 ed 7f 10 80       	push   $0x80107fed
80107144:	e8 47 92 ff ff       	call   80100390 <panic>
80107149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107150 <loaduvm>:
80107150:	f3 0f 1e fb          	endbr32 
80107154:	55                   	push   %ebp
80107155:	89 e5                	mov    %esp,%ebp
80107157:	57                   	push   %edi
80107158:	56                   	push   %esi
80107159:	53                   	push   %ebx
8010715a:	83 ec 1c             	sub    $0x1c,%esp
8010715d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107160:	8b 75 18             	mov    0x18(%ebp),%esi
80107163:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107168:	0f 85 99 00 00 00    	jne    80107207 <loaduvm+0xb7>
8010716e:	01 f0                	add    %esi,%eax
80107170:	89 f3                	mov    %esi,%ebx
80107172:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107175:	8b 45 14             	mov    0x14(%ebp),%eax
80107178:	01 f0                	add    %esi,%eax
8010717a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010717d:	85 f6                	test   %esi,%esi
8010717f:	75 15                	jne    80107196 <loaduvm+0x46>
80107181:	eb 6d                	jmp    801071f0 <loaduvm+0xa0>
80107183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107187:	90                   	nop
80107188:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010718e:	89 f0                	mov    %esi,%eax
80107190:	29 d8                	sub    %ebx,%eax
80107192:	39 c6                	cmp    %eax,%esi
80107194:	76 5a                	jbe    801071f0 <loaduvm+0xa0>
80107196:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107199:	8b 45 08             	mov    0x8(%ebp),%eax
8010719c:	31 c9                	xor    %ecx,%ecx
8010719e:	29 da                	sub    %ebx,%edx
801071a0:	e8 ab fb ff ff       	call   80106d50 <walkpgdir>
801071a5:	85 c0                	test   %eax,%eax
801071a7:	74 51                	je     801071fa <loaduvm+0xaa>
801071a9:	8b 00                	mov    (%eax),%eax
801071ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801071ae:	bf 00 10 00 00       	mov    $0x1000,%edi
801071b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071b8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801071be:	0f 46 fb             	cmovbe %ebx,%edi
801071c1:	29 d9                	sub    %ebx,%ecx
801071c3:	05 00 00 00 80       	add    $0x80000000,%eax
801071c8:	57                   	push   %edi
801071c9:	51                   	push   %ecx
801071ca:	50                   	push   %eax
801071cb:	ff 75 10             	pushl  0x10(%ebp)
801071ce:	e8 3d ae ff ff       	call   80102010 <readi>
801071d3:	83 c4 10             	add    $0x10,%esp
801071d6:	39 f8                	cmp    %edi,%eax
801071d8:	74 ae                	je     80107188 <loaduvm+0x38>
801071da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071e2:	5b                   	pop    %ebx
801071e3:	5e                   	pop    %esi
801071e4:	5f                   	pop    %edi
801071e5:	5d                   	pop    %ebp
801071e6:	c3                   	ret    
801071e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ee:	66 90                	xchg   %ax,%ax
801071f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071f3:	31 c0                	xor    %eax,%eax
801071f5:	5b                   	pop    %ebx
801071f6:	5e                   	pop    %esi
801071f7:	5f                   	pop    %edi
801071f8:	5d                   	pop    %ebp
801071f9:	c3                   	ret    
801071fa:	83 ec 0c             	sub    $0xc,%esp
801071fd:	68 07 80 10 80       	push   $0x80108007
80107202:	e8 89 91 ff ff       	call   80100390 <panic>
80107207:	83 ec 0c             	sub    $0xc,%esp
8010720a:	68 a8 80 10 80       	push   $0x801080a8
8010720f:	e8 7c 91 ff ff       	call   80100390 <panic>
80107214:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010721b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010721f:	90                   	nop

80107220 <allocuvm>:
80107220:	f3 0f 1e fb          	endbr32 
80107224:	55                   	push   %ebp
80107225:	89 e5                	mov    %esp,%ebp
80107227:	57                   	push   %edi
80107228:	56                   	push   %esi
80107229:	53                   	push   %ebx
8010722a:	83 ec 1c             	sub    $0x1c,%esp
8010722d:	8b 45 10             	mov    0x10(%ebp),%eax
80107230:	8b 7d 08             	mov    0x8(%ebp),%edi
80107233:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107236:	85 c0                	test   %eax,%eax
80107238:	0f 88 b2 00 00 00    	js     801072f0 <allocuvm+0xd0>
8010723e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107241:	8b 45 0c             	mov    0xc(%ebp),%eax
80107244:	0f 82 96 00 00 00    	jb     801072e0 <allocuvm+0xc0>
8010724a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107250:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80107256:	39 75 10             	cmp    %esi,0x10(%ebp)
80107259:	77 40                	ja     8010729b <allocuvm+0x7b>
8010725b:	e9 83 00 00 00       	jmp    801072e3 <allocuvm+0xc3>
80107260:	83 ec 04             	sub    $0x4,%esp
80107263:	68 00 10 00 00       	push   $0x1000
80107268:	6a 00                	push   $0x0
8010726a:	50                   	push   %eax
8010726b:	e8 b0 d9 ff ff       	call   80104c20 <memset>
80107270:	58                   	pop    %eax
80107271:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107277:	5a                   	pop    %edx
80107278:	6a 06                	push   $0x6
8010727a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010727f:	89 f2                	mov    %esi,%edx
80107281:	50                   	push   %eax
80107282:	89 f8                	mov    %edi,%eax
80107284:	e8 47 fb ff ff       	call   80106dd0 <mappages>
80107289:	83 c4 10             	add    $0x10,%esp
8010728c:	85 c0                	test   %eax,%eax
8010728e:	78 78                	js     80107308 <allocuvm+0xe8>
80107290:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107296:	39 75 10             	cmp    %esi,0x10(%ebp)
80107299:	76 48                	jbe    801072e3 <allocuvm+0xc3>
8010729b:	e8 40 b9 ff ff       	call   80102be0 <kalloc>
801072a0:	89 c3                	mov    %eax,%ebx
801072a2:	85 c0                	test   %eax,%eax
801072a4:	75 ba                	jne    80107260 <allocuvm+0x40>
801072a6:	83 ec 0c             	sub    $0xc,%esp
801072a9:	68 25 80 10 80       	push   $0x80108025
801072ae:	e8 cd 96 ff ff       	call   80100980 <cprintf>
801072b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801072b6:	83 c4 10             	add    $0x10,%esp
801072b9:	39 45 10             	cmp    %eax,0x10(%ebp)
801072bc:	74 32                	je     801072f0 <allocuvm+0xd0>
801072be:	8b 55 10             	mov    0x10(%ebp),%edx
801072c1:	89 c1                	mov    %eax,%ecx
801072c3:	89 f8                	mov    %edi,%eax
801072c5:	e8 96 fb ff ff       	call   80106e60 <deallocuvm.part.0>
801072ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801072d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072d7:	5b                   	pop    %ebx
801072d8:	5e                   	pop    %esi
801072d9:	5f                   	pop    %edi
801072da:	5d                   	pop    %ebp
801072db:	c3                   	ret    
801072dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072e9:	5b                   	pop    %ebx
801072ea:	5e                   	pop    %esi
801072eb:	5f                   	pop    %edi
801072ec:	5d                   	pop    %ebp
801072ed:	c3                   	ret    
801072ee:	66 90                	xchg   %ax,%ax
801072f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801072f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072fd:	5b                   	pop    %ebx
801072fe:	5e                   	pop    %esi
801072ff:	5f                   	pop    %edi
80107300:	5d                   	pop    %ebp
80107301:	c3                   	ret    
80107302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107308:	83 ec 0c             	sub    $0xc,%esp
8010730b:	68 3d 80 10 80       	push   $0x8010803d
80107310:	e8 6b 96 ff ff       	call   80100980 <cprintf>
80107315:	8b 45 0c             	mov    0xc(%ebp),%eax
80107318:	83 c4 10             	add    $0x10,%esp
8010731b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010731e:	74 0c                	je     8010732c <allocuvm+0x10c>
80107320:	8b 55 10             	mov    0x10(%ebp),%edx
80107323:	89 c1                	mov    %eax,%ecx
80107325:	89 f8                	mov    %edi,%eax
80107327:	e8 34 fb ff ff       	call   80106e60 <deallocuvm.part.0>
8010732c:	83 ec 0c             	sub    $0xc,%esp
8010732f:	53                   	push   %ebx
80107330:	e8 eb b6 ff ff       	call   80102a20 <kfree>
80107335:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010733c:	83 c4 10             	add    $0x10,%esp
8010733f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107342:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107345:	5b                   	pop    %ebx
80107346:	5e                   	pop    %esi
80107347:	5f                   	pop    %edi
80107348:	5d                   	pop    %ebp
80107349:	c3                   	ret    
8010734a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107350 <deallocuvm>:
80107350:	f3 0f 1e fb          	endbr32 
80107354:	55                   	push   %ebp
80107355:	89 e5                	mov    %esp,%ebp
80107357:	8b 55 0c             	mov    0xc(%ebp),%edx
8010735a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010735d:	8b 45 08             	mov    0x8(%ebp),%eax
80107360:	39 d1                	cmp    %edx,%ecx
80107362:	73 0c                	jae    80107370 <deallocuvm+0x20>
80107364:	5d                   	pop    %ebp
80107365:	e9 f6 fa ff ff       	jmp    80106e60 <deallocuvm.part.0>
8010736a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107370:	89 d0                	mov    %edx,%eax
80107372:	5d                   	pop    %ebp
80107373:	c3                   	ret    
80107374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010737b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010737f:	90                   	nop

80107380 <freevm>:
80107380:	f3 0f 1e fb          	endbr32 
80107384:	55                   	push   %ebp
80107385:	89 e5                	mov    %esp,%ebp
80107387:	57                   	push   %edi
80107388:	56                   	push   %esi
80107389:	53                   	push   %ebx
8010738a:	83 ec 0c             	sub    $0xc,%esp
8010738d:	8b 75 08             	mov    0x8(%ebp),%esi
80107390:	85 f6                	test   %esi,%esi
80107392:	74 55                	je     801073e9 <freevm+0x69>
80107394:	31 c9                	xor    %ecx,%ecx
80107396:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010739b:	89 f0                	mov    %esi,%eax
8010739d:	89 f3                	mov    %esi,%ebx
8010739f:	e8 bc fa ff ff       	call   80106e60 <deallocuvm.part.0>
801073a4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801073aa:	eb 0b                	jmp    801073b7 <freevm+0x37>
801073ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073b0:	83 c3 04             	add    $0x4,%ebx
801073b3:	39 df                	cmp    %ebx,%edi
801073b5:	74 23                	je     801073da <freevm+0x5a>
801073b7:	8b 03                	mov    (%ebx),%eax
801073b9:	a8 01                	test   $0x1,%al
801073bb:	74 f3                	je     801073b0 <freevm+0x30>
801073bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801073c2:	83 ec 0c             	sub    $0xc,%esp
801073c5:	83 c3 04             	add    $0x4,%ebx
801073c8:	05 00 00 00 80       	add    $0x80000000,%eax
801073cd:	50                   	push   %eax
801073ce:	e8 4d b6 ff ff       	call   80102a20 <kfree>
801073d3:	83 c4 10             	add    $0x10,%esp
801073d6:	39 df                	cmp    %ebx,%edi
801073d8:	75 dd                	jne    801073b7 <freevm+0x37>
801073da:	89 75 08             	mov    %esi,0x8(%ebp)
801073dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073e0:	5b                   	pop    %ebx
801073e1:	5e                   	pop    %esi
801073e2:	5f                   	pop    %edi
801073e3:	5d                   	pop    %ebp
801073e4:	e9 37 b6 ff ff       	jmp    80102a20 <kfree>
801073e9:	83 ec 0c             	sub    $0xc,%esp
801073ec:	68 59 80 10 80       	push   $0x80108059
801073f1:	e8 9a 8f ff ff       	call   80100390 <panic>
801073f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073fd:	8d 76 00             	lea    0x0(%esi),%esi

80107400 <setupkvm>:
80107400:	f3 0f 1e fb          	endbr32 
80107404:	55                   	push   %ebp
80107405:	89 e5                	mov    %esp,%ebp
80107407:	56                   	push   %esi
80107408:	53                   	push   %ebx
80107409:	e8 d2 b7 ff ff       	call   80102be0 <kalloc>
8010740e:	89 c6                	mov    %eax,%esi
80107410:	85 c0                	test   %eax,%eax
80107412:	74 42                	je     80107456 <setupkvm+0x56>
80107414:	83 ec 04             	sub    $0x4,%esp
80107417:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
8010741c:	68 00 10 00 00       	push   $0x1000
80107421:	6a 00                	push   $0x0
80107423:	50                   	push   %eax
80107424:	e8 f7 d7 ff ff       	call   80104c20 <memset>
80107429:	83 c4 10             	add    $0x10,%esp
8010742c:	8b 43 04             	mov    0x4(%ebx),%eax
8010742f:	83 ec 08             	sub    $0x8,%esp
80107432:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107435:	ff 73 0c             	pushl  0xc(%ebx)
80107438:	8b 13                	mov    (%ebx),%edx
8010743a:	50                   	push   %eax
8010743b:	29 c1                	sub    %eax,%ecx
8010743d:	89 f0                	mov    %esi,%eax
8010743f:	e8 8c f9 ff ff       	call   80106dd0 <mappages>
80107444:	83 c4 10             	add    $0x10,%esp
80107447:	85 c0                	test   %eax,%eax
80107449:	78 15                	js     80107460 <setupkvm+0x60>
8010744b:	83 c3 10             	add    $0x10,%ebx
8010744e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107454:	75 d6                	jne    8010742c <setupkvm+0x2c>
80107456:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107459:	89 f0                	mov    %esi,%eax
8010745b:	5b                   	pop    %ebx
8010745c:	5e                   	pop    %esi
8010745d:	5d                   	pop    %ebp
8010745e:	c3                   	ret    
8010745f:	90                   	nop
80107460:	83 ec 0c             	sub    $0xc,%esp
80107463:	56                   	push   %esi
80107464:	31 f6                	xor    %esi,%esi
80107466:	e8 15 ff ff ff       	call   80107380 <freevm>
8010746b:	83 c4 10             	add    $0x10,%esp
8010746e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107471:	89 f0                	mov    %esi,%eax
80107473:	5b                   	pop    %ebx
80107474:	5e                   	pop    %esi
80107475:	5d                   	pop    %ebp
80107476:	c3                   	ret    
80107477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010747e:	66 90                	xchg   %ax,%ax

80107480 <kvmalloc>:
80107480:	f3 0f 1e fb          	endbr32 
80107484:	55                   	push   %ebp
80107485:	89 e5                	mov    %esp,%ebp
80107487:	83 ec 08             	sub    $0x8,%esp
8010748a:	e8 71 ff ff ff       	call   80107400 <setupkvm>
8010748f:	a3 44 6a 11 80       	mov    %eax,0x80116a44
80107494:	05 00 00 00 80       	add    $0x80000000,%eax
80107499:	0f 22 d8             	mov    %eax,%cr3
8010749c:	c9                   	leave  
8010749d:	c3                   	ret    
8010749e:	66 90                	xchg   %ax,%ax

801074a0 <clearpteu>:
801074a0:	f3 0f 1e fb          	endbr32 
801074a4:	55                   	push   %ebp
801074a5:	31 c9                	xor    %ecx,%ecx
801074a7:	89 e5                	mov    %esp,%ebp
801074a9:	83 ec 08             	sub    $0x8,%esp
801074ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801074af:	8b 45 08             	mov    0x8(%ebp),%eax
801074b2:	e8 99 f8 ff ff       	call   80106d50 <walkpgdir>
801074b7:	85 c0                	test   %eax,%eax
801074b9:	74 05                	je     801074c0 <clearpteu+0x20>
801074bb:	83 20 fb             	andl   $0xfffffffb,(%eax)
801074be:	c9                   	leave  
801074bf:	c3                   	ret    
801074c0:	83 ec 0c             	sub    $0xc,%esp
801074c3:	68 6a 80 10 80       	push   $0x8010806a
801074c8:	e8 c3 8e ff ff       	call   80100390 <panic>
801074cd:	8d 76 00             	lea    0x0(%esi),%esi

801074d0 <copyuvm>:
801074d0:	f3 0f 1e fb          	endbr32 
801074d4:	55                   	push   %ebp
801074d5:	89 e5                	mov    %esp,%ebp
801074d7:	57                   	push   %edi
801074d8:	56                   	push   %esi
801074d9:	53                   	push   %ebx
801074da:	83 ec 1c             	sub    $0x1c,%esp
801074dd:	e8 1e ff ff ff       	call   80107400 <setupkvm>
801074e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074e5:	85 c0                	test   %eax,%eax
801074e7:	0f 84 9b 00 00 00    	je     80107588 <copyuvm+0xb8>
801074ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074f0:	85 c9                	test   %ecx,%ecx
801074f2:	0f 84 90 00 00 00    	je     80107588 <copyuvm+0xb8>
801074f8:	31 f6                	xor    %esi,%esi
801074fa:	eb 46                	jmp    80107542 <copyuvm+0x72>
801074fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107500:	83 ec 04             	sub    $0x4,%esp
80107503:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107509:	68 00 10 00 00       	push   $0x1000
8010750e:	57                   	push   %edi
8010750f:	50                   	push   %eax
80107510:	e8 ab d7 ff ff       	call   80104cc0 <memmove>
80107515:	58                   	pop    %eax
80107516:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010751c:	5a                   	pop    %edx
8010751d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107520:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107525:	89 f2                	mov    %esi,%edx
80107527:	50                   	push   %eax
80107528:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010752b:	e8 a0 f8 ff ff       	call   80106dd0 <mappages>
80107530:	83 c4 10             	add    $0x10,%esp
80107533:	85 c0                	test   %eax,%eax
80107535:	78 61                	js     80107598 <copyuvm+0xc8>
80107537:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010753d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107540:	76 46                	jbe    80107588 <copyuvm+0xb8>
80107542:	8b 45 08             	mov    0x8(%ebp),%eax
80107545:	31 c9                	xor    %ecx,%ecx
80107547:	89 f2                	mov    %esi,%edx
80107549:	e8 02 f8 ff ff       	call   80106d50 <walkpgdir>
8010754e:	85 c0                	test   %eax,%eax
80107550:	74 61                	je     801075b3 <copyuvm+0xe3>
80107552:	8b 00                	mov    (%eax),%eax
80107554:	a8 01                	test   $0x1,%al
80107556:	74 4e                	je     801075a6 <copyuvm+0xd6>
80107558:	89 c7                	mov    %eax,%edi
8010755a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010755f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107562:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80107568:	e8 73 b6 ff ff       	call   80102be0 <kalloc>
8010756d:	89 c3                	mov    %eax,%ebx
8010756f:	85 c0                	test   %eax,%eax
80107571:	75 8d                	jne    80107500 <copyuvm+0x30>
80107573:	83 ec 0c             	sub    $0xc,%esp
80107576:	ff 75 e0             	pushl  -0x20(%ebp)
80107579:	e8 02 fe ff ff       	call   80107380 <freevm>
8010757e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107585:	83 c4 10             	add    $0x10,%esp
80107588:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010758b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010758e:	5b                   	pop    %ebx
8010758f:	5e                   	pop    %esi
80107590:	5f                   	pop    %edi
80107591:	5d                   	pop    %ebp
80107592:	c3                   	ret    
80107593:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107597:	90                   	nop
80107598:	83 ec 0c             	sub    $0xc,%esp
8010759b:	53                   	push   %ebx
8010759c:	e8 7f b4 ff ff       	call   80102a20 <kfree>
801075a1:	83 c4 10             	add    $0x10,%esp
801075a4:	eb cd                	jmp    80107573 <copyuvm+0xa3>
801075a6:	83 ec 0c             	sub    $0xc,%esp
801075a9:	68 8e 80 10 80       	push   $0x8010808e
801075ae:	e8 dd 8d ff ff       	call   80100390 <panic>
801075b3:	83 ec 0c             	sub    $0xc,%esp
801075b6:	68 74 80 10 80       	push   $0x80108074
801075bb:	e8 d0 8d ff ff       	call   80100390 <panic>

801075c0 <uva2ka>:
801075c0:	f3 0f 1e fb          	endbr32 
801075c4:	55                   	push   %ebp
801075c5:	31 c9                	xor    %ecx,%ecx
801075c7:	89 e5                	mov    %esp,%ebp
801075c9:	83 ec 08             	sub    $0x8,%esp
801075cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801075cf:	8b 45 08             	mov    0x8(%ebp),%eax
801075d2:	e8 79 f7 ff ff       	call   80106d50 <walkpgdir>
801075d7:	8b 00                	mov    (%eax),%eax
801075d9:	c9                   	leave  
801075da:	89 c2                	mov    %eax,%edx
801075dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801075e1:	83 e2 05             	and    $0x5,%edx
801075e4:	05 00 00 00 80       	add    $0x80000000,%eax
801075e9:	83 fa 05             	cmp    $0x5,%edx
801075ec:	ba 00 00 00 00       	mov    $0x0,%edx
801075f1:	0f 45 c2             	cmovne %edx,%eax
801075f4:	c3                   	ret    
801075f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107600 <copyout>:
80107600:	f3 0f 1e fb          	endbr32 
80107604:	55                   	push   %ebp
80107605:	89 e5                	mov    %esp,%ebp
80107607:	57                   	push   %edi
80107608:	56                   	push   %esi
80107609:	53                   	push   %ebx
8010760a:	83 ec 0c             	sub    $0xc,%esp
8010760d:	8b 75 14             	mov    0x14(%ebp),%esi
80107610:	8b 55 0c             	mov    0xc(%ebp),%edx
80107613:	85 f6                	test   %esi,%esi
80107615:	75 3c                	jne    80107653 <copyout+0x53>
80107617:	eb 67                	jmp    80107680 <copyout+0x80>
80107619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107620:	8b 55 0c             	mov    0xc(%ebp),%edx
80107623:	89 fb                	mov    %edi,%ebx
80107625:	29 d3                	sub    %edx,%ebx
80107627:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010762d:	39 f3                	cmp    %esi,%ebx
8010762f:	0f 47 de             	cmova  %esi,%ebx
80107632:	29 fa                	sub    %edi,%edx
80107634:	83 ec 04             	sub    $0x4,%esp
80107637:	01 c2                	add    %eax,%edx
80107639:	53                   	push   %ebx
8010763a:	ff 75 10             	pushl  0x10(%ebp)
8010763d:	52                   	push   %edx
8010763e:	e8 7d d6 ff ff       	call   80104cc0 <memmove>
80107643:	01 5d 10             	add    %ebx,0x10(%ebp)
80107646:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
8010764c:	83 c4 10             	add    $0x10,%esp
8010764f:	29 de                	sub    %ebx,%esi
80107651:	74 2d                	je     80107680 <copyout+0x80>
80107653:	89 d7                	mov    %edx,%edi
80107655:	83 ec 08             	sub    $0x8,%esp
80107658:	89 55 0c             	mov    %edx,0xc(%ebp)
8010765b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80107661:	57                   	push   %edi
80107662:	ff 75 08             	pushl  0x8(%ebp)
80107665:	e8 56 ff ff ff       	call   801075c0 <uva2ka>
8010766a:	83 c4 10             	add    $0x10,%esp
8010766d:	85 c0                	test   %eax,%eax
8010766f:	75 af                	jne    80107620 <copyout+0x20>
80107671:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107679:	5b                   	pop    %ebx
8010767a:	5e                   	pop    %esi
8010767b:	5f                   	pop    %edi
8010767c:	5d                   	pop    %ebp
8010767d:	c3                   	ret    
8010767e:	66 90                	xchg   %ax,%ax
80107680:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107683:	31 c0                	xor    %eax,%eax
80107685:	5b                   	pop    %ebx
80107686:	5e                   	pop    %esi
80107687:	5f                   	pop    %edi
80107688:	5d                   	pop    %ebp
80107689:	c3                   	ret    
