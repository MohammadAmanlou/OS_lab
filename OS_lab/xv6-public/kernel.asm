
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 d5 10 80       	mov    $0x8010d5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 35 10 80       	mov    $0x80103530,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 d5 10 80       	mov    $0x8010d5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 a0 87 10 80       	push   $0x801087a0
80100055:	68 c0 d5 10 80       	push   $0x8010d5c0
8010005a:	e8 51 56 00 00       	call   801056b0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 1c 11 80       	mov    $0x80111cbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 1d 11 80 bc 	movl   $0x80111cbc,0x80111d0c
8010006e:	1c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 1d 11 80 bc 	movl   $0x80111cbc,0x80111d10
80100078:	1c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 1c 11 80 	movl   $0x80111cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 87 10 80       	push   $0x801087a7
80100097:	50                   	push   %eax
80100098:	e8 d3 54 00 00       	call   80105570 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 1d 11 80       	mov    0x80111d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 1d 11 80    	mov    %ebx,0x80111d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 1a 11 80    	cmp    $0x80111a60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 d5 10 80       	push   $0x8010d5c0
801000e8:	e8 43 57 00 00       	call   80105830 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 1d 11 80    	mov    0x80111d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 1d 11 80    	mov    0x80111d0c,%ebx
80100126:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 d5 10 80       	push   $0x8010d5c0
80100162:	e8 89 57 00 00       	call   801058f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 54 00 00       	call   801055b0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 df 25 00 00       	call   80102770 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ae 87 10 80       	push   $0x801087ae
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 89 54 00 00       	call   80105650 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 93 25 00 00       	jmp    80102770 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 bf 87 10 80       	push   $0x801087bf
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 48 54 00 00       	call   80105650 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 f8 53 00 00       	call   80105610 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 d5 10 80 	movl   $0x8010d5c0,(%esp)
8010021f:	e8 0c 56 00 00       	call   80105830 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 1d 11 80       	mov    0x80111d10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc 1c 11 80 	movl   $0x80111cbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 1d 11 80       	mov    0x80111d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 1d 11 80    	mov    %ebx,0x80111d10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 d5 10 80 	movl   $0x8010d5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 7b 56 00 00       	jmp    801058f0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 c6 87 10 80       	push   $0x801087c6
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
801002a5:	e8 86 1a 00 00       	call   80101d30 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
801002b1:	e8 7a 55 00 00       	call   80105830 <acquire>
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
801002c6:	a1 a0 1f 11 80       	mov    0x80111fa0,%eax
801002cb:	3b 05 a4 1f 11 80    	cmp    0x80111fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 c5 10 80       	push   $0x8010c520
801002e0:	68 a0 1f 11 80       	push   $0x80111fa0
801002e5:	e8 a6 41 00 00       	call   80104490 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 1f 11 80       	mov    0x80111fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 1f 11 80    	cmp    0x80111fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 b1 3b 00 00       	call   80103eb0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 c5 10 80       	push   $0x8010c520
8010030e:	e8 dd 55 00 00       	call   801058f0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 34 19 00 00       	call   80101c50 <ilock>
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
80100333:	89 15 a0 1f 11 80    	mov    %edx,0x80111fa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 1f 11 80 	movsbl -0x7feee0e0(%edx),%ecx
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
80100360:	68 20 c5 10 80       	push   $0x8010c520
80100365:	e8 86 55 00 00       	call   801058f0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 dd 18 00 00       	call   80101c50 <ilock>
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
80100386:	a3 a0 1f 11 80       	mov    %eax,0x80111fa0
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
8010039d:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 de 29 00 00       	call   80102d90 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 cd 87 10 80       	push   $0x801087cd
801003bb:	e8 00 05 00 00       	call   801008c0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 f7 04 00 00       	call   801008c0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 df 92 10 80 	movl   $0x801092df,(%esp)
801003d0:	e8 eb 04 00 00       	call   801008c0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ef 52 00 00       	call   801056d0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 e1 87 10 80       	push   $0x801087e1
801003f1:	e8 ca 04 00 00       	call   801008c0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 5c c5 10 80 01 	movl   $0x1,0x8010c55c
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
8010042a:	e8 71 6f 00 00       	call   801073a0 <uartputc>
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
80100468:	8b 3d 58 c5 10 80    	mov    0x8010c558,%edi
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
801004ce:	8b 3d 58 c5 10 80    	mov    0x8010c558,%edi
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
80100560:	c7 05 58 c5 10 80 00 	movl   $0x0,0x8010c558
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
8010058d:	e8 0e 6e 00 00       	call   801073a0 <uartputc>
80100592:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100599:	e8 02 6e 00 00       	call   801073a0 <uartputc>
8010059e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005a5:	e8 f6 6d 00 00       	call   801073a0 <uartputc>
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
801005cf:	e8 0c 54 00 00       	call   801059e0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005d4:	b8 80 07 00 00       	mov    $0x780,%eax
801005d9:	83 c4 0c             	add    $0xc,%esp
801005dc:	29 d8                	sub    %ebx,%eax
801005de:	01 c0                	add    %eax,%eax
801005e0:	50                   	push   %eax
801005e1:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
801005e8:	6a 00                	push   $0x0
801005ea:	50                   	push   %eax
801005eb:	e8 50 53 00 00       	call   80105940 <memset>
801005f0:	8b 3d 58 c5 10 80    	mov    0x8010c558,%edi
801005f6:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801005fa:	83 c4 10             	add    $0x10,%esp
801005fd:	01 df                	add    %ebx,%edi
801005ff:	e9 d7 fe ff ff       	jmp    801004db <consputc.part.0+0xcb>
    panic("pos under/overflow");
80100604:	83 ec 0c             	sub    $0xc,%esp
80100607:	68 e5 87 10 80       	push   $0x801087e5
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
80100649:	0f b6 92 68 88 10 80 	movzbl -0x7fef7798(%edx),%edx
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
80100683:	8b 15 5c c5 10 80    	mov    0x8010c55c,%edx
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
801006cc:	a1 58 c5 10 80       	mov    0x8010c558,%eax
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
8010072f:	c7 05 58 c5 10 80 00 	movl   $0x0,0x8010c558
80100736:	00 00 00 
  for ( int i = input.e ; i > input.w ; i-- ){
80100739:	8b 1d a8 1f 11 80    	mov    0x80111fa8,%ebx
8010073f:	3b 1d a4 1f 11 80    	cmp    0x80111fa4,%ebx
80100745:	76 2b                	jbe    80100772 <arrow+0xb2>
    if (input.buf[i - 1] != '\n'){
80100747:	83 eb 01             	sub    $0x1,%ebx
8010074a:	80 bb 20 1f 11 80 0a 	cmpb   $0xa,-0x7feee0e0(%ebx)
80100751:	74 17                	je     8010076a <arrow+0xaa>
  if(panicked){
80100753:	8b 15 5c c5 10 80    	mov    0x8010c55c,%edx
80100759:	85 d2                	test   %edx,%edx
8010075b:	74 03                	je     80100760 <arrow+0xa0>
  asm volatile("cli");
8010075d:	fa                   	cli    
    for(;;)
8010075e:	eb fe                	jmp    8010075e <arrow+0x9e>
80100760:	b8 00 01 00 00       	mov    $0x100,%eax
80100765:	e8 a6 fc ff ff       	call   80100410 <consputc.part.0>
  for ( int i = input.e ; i > input.w ; i-- ){
8010076a:	39 1d a4 1f 11 80    	cmp    %ebx,0x80111fa4
80100770:	72 d5                	jb     80100747 <arrow+0x87>
  if (arr == UP){
80100772:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100775:	a1 38 25 11 80       	mov    0x80112538,%eax
8010077a:	85 c9                	test   %ecx,%ecx
8010077c:	74 50                	je     801007ce <arrow+0x10e>
  if ((arr == DOWN)&&(history.index < 9)&&(history.index + 1 < history.last )){
8010077e:	83 f8 08             	cmp    $0x8,%eax
80100781:	0f 8f b8 00 00 00    	jg     8010083f <arrow+0x17f>
80100787:	8d 50 01             	lea    0x1(%eax),%edx
8010078a:	3b 15 40 25 11 80    	cmp    0x80112540,%edx
80100790:	0f 8d a9 00 00 00    	jge    8010083f <arrow+0x17f>
    input = history.hist[history.index + 2 ];
80100796:	8d 70 02             	lea    0x2(%eax),%esi
80100799:	bf 20 1f 11 80       	mov    $0x80111f20,%edi
8010079e:	b9 23 00 00 00       	mov    $0x23,%ecx
    history.index ++ ;
801007a3:	89 15 38 25 11 80    	mov    %edx,0x80112538
    input = history.hist[history.index + 2 ];
801007a9:	69 f6 8c 00 00 00    	imul   $0x8c,%esi,%esi
801007af:	81 c6 c0 1f 11 80    	add    $0x80111fc0,%esi
801007b5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    input.e -- ;
801007b7:	8b 15 a8 1f 11 80    	mov    0x80111fa8,%edx
801007bd:	8d 42 ff             	lea    -0x1(%edx),%eax
    input.buf[input.e] = '\0';
801007c0:	c6 82 1f 1f 11 80 00 	movb   $0x0,-0x7feee0e1(%edx)
    input.e -- ;
801007c7:	a3 a8 1f 11 80       	mov    %eax,0x80111fa8
    input.buf[input.e] = '\0';
801007cc:	eb 35                	jmp    80100803 <arrow+0x143>
    input = history.hist[history.index ];
801007ce:	69 f0 8c 00 00 00    	imul   $0x8c,%eax,%esi
801007d4:	bf 20 1f 11 80       	mov    $0x80111f20,%edi
801007d9:	b9 23 00 00 00       	mov    $0x23,%ecx
    history.index -- ;
801007de:	83 e8 01             	sub    $0x1,%eax
801007e1:	a3 38 25 11 80       	mov    %eax,0x80112538
    input = history.hist[history.index ];
801007e6:	81 c6 c0 1f 11 80    	add    $0x80111fc0,%esi
801007ec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    input.e -- ;
801007ee:	8b 15 a8 1f 11 80    	mov    0x80111fa8,%edx
801007f4:	8d 42 ff             	lea    -0x1(%edx),%eax
    input.buf[input.e] = '\0';
801007f7:	c6 82 1f 1f 11 80 00 	movb   $0x0,-0x7feee0e1(%edx)
    input.e -- ;
801007fe:	a3 a8 1f 11 80       	mov    %eax,0x80111fa8
  for (int i = input.w ; i < input.e; i++)
80100803:	8b 1d a4 1f 11 80    	mov    0x80111fa4,%ebx
80100809:	39 d8                	cmp    %ebx,%eax
8010080b:	76 2a                	jbe    80100837 <arrow+0x177>
  if(panicked){
8010080d:	a1 5c c5 10 80       	mov    0x8010c55c,%eax
80100812:	85 c0                	test   %eax,%eax
80100814:	74 0a                	je     80100820 <arrow+0x160>
80100816:	fa                   	cli    
    for(;;)
80100817:	eb fe                	jmp    80100817 <arrow+0x157>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(input.buf[i]);
80100820:	0f be 83 20 1f 11 80 	movsbl -0x7feee0e0(%ebx),%eax
  for (int i = input.w ; i < input.e; i++)
80100827:	83 c3 01             	add    $0x1,%ebx
8010082a:	e8 e1 fb ff ff       	call   80100410 <consputc.part.0>
8010082f:	39 1d a8 1f 11 80    	cmp    %ebx,0x80111fa8
80100835:	77 d6                	ja     8010080d <arrow+0x14d>
}
80100837:	83 c4 1c             	add    $0x1c,%esp
8010083a:	5b                   	pop    %ebx
8010083b:	5e                   	pop    %esi
8010083c:	5f                   	pop    %edi
8010083d:	5d                   	pop    %ebp
8010083e:	c3                   	ret    
8010083f:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
80100844:	eb bd                	jmp    80100803 <arrow+0x143>
80100846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010084d:	8d 76 00             	lea    0x0(%esi),%esi

80100850 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100850:	f3 0f 1e fb          	endbr32 
80100854:	55                   	push   %ebp
80100855:	89 e5                	mov    %esp,%ebp
80100857:	57                   	push   %edi
80100858:	56                   	push   %esi
80100859:	53                   	push   %ebx
8010085a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010085d:	ff 75 08             	pushl  0x8(%ebp)
{
80100860:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100863:	e8 c8 14 00 00       	call   80101d30 <iunlock>
  acquire(&cons.lock);
80100868:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010086f:	e8 bc 4f 00 00       	call   80105830 <acquire>
  for(i = 0; i < n; i++)
80100874:	83 c4 10             	add    $0x10,%esp
80100877:	85 db                	test   %ebx,%ebx
80100879:	7e 24                	jle    8010089f <consolewrite+0x4f>
8010087b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010087e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100881:	8b 15 5c c5 10 80    	mov    0x8010c55c,%edx
80100887:	85 d2                	test   %edx,%edx
80100889:	74 05                	je     80100890 <consolewrite+0x40>
8010088b:	fa                   	cli    
    for(;;)
8010088c:	eb fe                	jmp    8010088c <consolewrite+0x3c>
8010088e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100890:	0f b6 07             	movzbl (%edi),%eax
80100893:	83 c7 01             	add    $0x1,%edi
80100896:	e8 75 fb ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010089b:	39 fe                	cmp    %edi,%esi
8010089d:	75 e2                	jne    80100881 <consolewrite+0x31>
  release(&cons.lock);
8010089f:	83 ec 0c             	sub    $0xc,%esp
801008a2:	68 20 c5 10 80       	push   $0x8010c520
801008a7:	e8 44 50 00 00       	call   801058f0 <release>
  ilock(ip);
801008ac:	58                   	pop    %eax
801008ad:	ff 75 08             	pushl  0x8(%ebp)
801008b0:	e8 9b 13 00 00       	call   80101c50 <ilock>

  return n;
}
801008b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008b8:	89 d8                	mov    %ebx,%eax
801008ba:	5b                   	pop    %ebx
801008bb:	5e                   	pop    %esi
801008bc:	5f                   	pop    %edi
801008bd:	5d                   	pop    %ebp
801008be:	c3                   	ret    
801008bf:	90                   	nop

801008c0 <cprintf>:
{
801008c0:	f3 0f 1e fb          	endbr32 
801008c4:	55                   	push   %ebp
801008c5:	89 e5                	mov    %esp,%ebp
801008c7:	57                   	push   %edi
801008c8:	56                   	push   %esi
801008c9:	53                   	push   %ebx
801008ca:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801008cd:	a1 54 c5 10 80       	mov    0x8010c554,%eax
801008d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801008d5:	85 c0                	test   %eax,%eax
801008d7:	0f 85 e8 00 00 00    	jne    801009c5 <cprintf+0x105>
  if (fmt == 0)
801008dd:	8b 45 08             	mov    0x8(%ebp),%eax
801008e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801008e3:	85 c0                	test   %eax,%eax
801008e5:	0f 84 5a 01 00 00    	je     80100a45 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008eb:	0f b6 00             	movzbl (%eax),%eax
801008ee:	85 c0                	test   %eax,%eax
801008f0:	74 36                	je     80100928 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801008f2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008f5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801008f7:	83 f8 25             	cmp    $0x25,%eax
801008fa:	74 44                	je     80100940 <cprintf+0x80>
  if(panicked){
801008fc:	8b 0d 5c c5 10 80    	mov    0x8010c55c,%ecx
80100902:	85 c9                	test   %ecx,%ecx
80100904:	74 0f                	je     80100915 <cprintf+0x55>
80100906:	fa                   	cli    
    for(;;)
80100907:	eb fe                	jmp    80100907 <cprintf+0x47>
80100909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100910:	b8 25 00 00 00       	mov    $0x25,%eax
80100915:	e8 f6 fa ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010091a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010091d:	83 c6 01             	add    $0x1,%esi
80100920:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100924:	85 c0                	test   %eax,%eax
80100926:	75 cf                	jne    801008f7 <cprintf+0x37>
  if(locking)
80100928:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010092b:	85 c0                	test   %eax,%eax
8010092d:	0f 85 fd 00 00 00    	jne    80100a30 <cprintf+0x170>
}
80100933:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100936:	5b                   	pop    %ebx
80100937:	5e                   	pop    %esi
80100938:	5f                   	pop    %edi
80100939:	5d                   	pop    %ebp
8010093a:	c3                   	ret    
8010093b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010093f:	90                   	nop
    c = fmt[++i] & 0xff;
80100940:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100943:	83 c6 01             	add    $0x1,%esi
80100946:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010094a:	85 ff                	test   %edi,%edi
8010094c:	74 da                	je     80100928 <cprintf+0x68>
    switch(c){
8010094e:	83 ff 70             	cmp    $0x70,%edi
80100951:	74 5a                	je     801009ad <cprintf+0xed>
80100953:	7f 2a                	jg     8010097f <cprintf+0xbf>
80100955:	83 ff 25             	cmp    $0x25,%edi
80100958:	0f 84 92 00 00 00    	je     801009f0 <cprintf+0x130>
8010095e:	83 ff 64             	cmp    $0x64,%edi
80100961:	0f 85 a1 00 00 00    	jne    80100a08 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100967:	8b 03                	mov    (%ebx),%eax
80100969:	8d 7b 04             	lea    0x4(%ebx),%edi
8010096c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100971:	ba 0a 00 00 00       	mov    $0xa,%edx
80100976:	89 fb                	mov    %edi,%ebx
80100978:	e8 a3 fc ff ff       	call   80100620 <printint>
      break;
8010097d:	eb 9b                	jmp    8010091a <cprintf+0x5a>
    switch(c){
8010097f:	83 ff 73             	cmp    $0x73,%edi
80100982:	75 24                	jne    801009a8 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100984:	8d 7b 04             	lea    0x4(%ebx),%edi
80100987:	8b 1b                	mov    (%ebx),%ebx
80100989:	85 db                	test   %ebx,%ebx
8010098b:	75 55                	jne    801009e2 <cprintf+0x122>
        s = "(null)";
8010098d:	bb f8 87 10 80       	mov    $0x801087f8,%ebx
      for(; *s; s++)
80100992:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100997:	8b 15 5c c5 10 80    	mov    0x8010c55c,%edx
8010099d:	85 d2                	test   %edx,%edx
8010099f:	74 39                	je     801009da <cprintf+0x11a>
801009a1:	fa                   	cli    
    for(;;)
801009a2:	eb fe                	jmp    801009a2 <cprintf+0xe2>
801009a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
801009a8:	83 ff 78             	cmp    $0x78,%edi
801009ab:	75 5b                	jne    80100a08 <cprintf+0x148>
      printint(*argp++, 16, 0);
801009ad:	8b 03                	mov    (%ebx),%eax
801009af:	8d 7b 04             	lea    0x4(%ebx),%edi
801009b2:	31 c9                	xor    %ecx,%ecx
801009b4:	ba 10 00 00 00       	mov    $0x10,%edx
801009b9:	89 fb                	mov    %edi,%ebx
801009bb:	e8 60 fc ff ff       	call   80100620 <printint>
      break;
801009c0:	e9 55 ff ff ff       	jmp    8010091a <cprintf+0x5a>
    acquire(&cons.lock);
801009c5:	83 ec 0c             	sub    $0xc,%esp
801009c8:	68 20 c5 10 80       	push   $0x8010c520
801009cd:	e8 5e 4e 00 00       	call   80105830 <acquire>
801009d2:	83 c4 10             	add    $0x10,%esp
801009d5:	e9 03 ff ff ff       	jmp    801008dd <cprintf+0x1d>
801009da:	e8 31 fa ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801009df:	83 c3 01             	add    $0x1,%ebx
801009e2:	0f be 03             	movsbl (%ebx),%eax
801009e5:	84 c0                	test   %al,%al
801009e7:	75 ae                	jne    80100997 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801009e9:	89 fb                	mov    %edi,%ebx
801009eb:	e9 2a ff ff ff       	jmp    8010091a <cprintf+0x5a>
  if(panicked){
801009f0:	8b 3d 5c c5 10 80    	mov    0x8010c55c,%edi
801009f6:	85 ff                	test   %edi,%edi
801009f8:	0f 84 12 ff ff ff    	je     80100910 <cprintf+0x50>
801009fe:	fa                   	cli    
    for(;;)
801009ff:	eb fe                	jmp    801009ff <cprintf+0x13f>
80100a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100a08:	8b 0d 5c c5 10 80    	mov    0x8010c55c,%ecx
80100a0e:	85 c9                	test   %ecx,%ecx
80100a10:	74 06                	je     80100a18 <cprintf+0x158>
80100a12:	fa                   	cli    
    for(;;)
80100a13:	eb fe                	jmp    80100a13 <cprintf+0x153>
80100a15:	8d 76 00             	lea    0x0(%esi),%esi
80100a18:	b8 25 00 00 00       	mov    $0x25,%eax
80100a1d:	e8 ee f9 ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100a22:	8b 15 5c c5 10 80    	mov    0x8010c55c,%edx
80100a28:	85 d2                	test   %edx,%edx
80100a2a:	74 2c                	je     80100a58 <cprintf+0x198>
80100a2c:	fa                   	cli    
    for(;;)
80100a2d:	eb fe                	jmp    80100a2d <cprintf+0x16d>
80100a2f:	90                   	nop
    release(&cons.lock);
80100a30:	83 ec 0c             	sub    $0xc,%esp
80100a33:	68 20 c5 10 80       	push   $0x8010c520
80100a38:	e8 b3 4e 00 00       	call   801058f0 <release>
80100a3d:	83 c4 10             	add    $0x10,%esp
}
80100a40:	e9 ee fe ff ff       	jmp    80100933 <cprintf+0x73>
    panic("null fmt");
80100a45:	83 ec 0c             	sub    $0xc,%esp
80100a48:	68 ff 87 10 80       	push   $0x801087ff
80100a4d:	e8 3e f9 ff ff       	call   80100390 <panic>
80100a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100a58:	89 f8                	mov    %edi,%eax
80100a5a:	e8 b1 f9 ff ff       	call   80100410 <consputc.part.0>
80100a5f:	e9 b6 fe ff ff       	jmp    8010091a <cprintf+0x5a>
80100a64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a6f:	90                   	nop

80100a70 <consoleintr>:
{
80100a70:	f3 0f 1e fb          	endbr32 
80100a74:	55                   	push   %ebp
80100a75:	89 e5                	mov    %esp,%ebp
80100a77:	57                   	push   %edi
80100a78:	56                   	push   %esi
80100a79:	53                   	push   %ebx
  int c, doprocdump = 0;
80100a7a:	31 db                	xor    %ebx,%ebx
{
80100a7c:	83 ec 28             	sub    $0x28,%esp
80100a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
80100a82:	68 20 c5 10 80       	push   $0x8010c520
{
80100a87:	89 45 dc             	mov    %eax,-0x24(%ebp)
  acquire(&cons.lock);
80100a8a:	e8 a1 4d 00 00       	call   80105830 <acquire>
  while((c = getc()) >= 0){
80100a8f:	83 c4 10             	add    $0x10,%esp
80100a92:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100a95:	ff d0                	call   *%eax
80100a97:	89 c6                	mov    %eax,%esi
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	0f 88 bc 02 00 00    	js     80100d5d <consoleintr+0x2ed>
    switch(c){
80100aa1:	83 fe 15             	cmp    $0x15,%esi
80100aa4:	7f 5a                	jg     80100b00 <consoleintr+0x90>
80100aa6:	83 fe 01             	cmp    $0x1,%esi
80100aa9:	0f 8e b1 01 00 00    	jle    80100c60 <consoleintr+0x1f0>
80100aaf:	83 fe 15             	cmp    $0x15,%esi
80100ab2:	0f 87 a8 01 00 00    	ja     80100c60 <consoleintr+0x1f0>
80100ab8:	3e ff 24 b5 10 88 10 	notrack jmp *-0x7fef77f0(,%esi,4)
80100abf:	80 
80100ac0:	bb 01 00 00 00       	mov    $0x1,%ebx
80100ac5:	eb cb                	jmp    80100a92 <consoleintr+0x22>
80100ac7:	b8 00 01 00 00       	mov    $0x100,%eax
80100acc:	e8 3f f9 ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
80100ad1:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
80100ad6:	3b 05 a4 1f 11 80    	cmp    0x80111fa4,%eax
80100adc:	74 b4                	je     80100a92 <consoleintr+0x22>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100ade:	83 e8 01             	sub    $0x1,%eax
80100ae1:	89 c2                	mov    %eax,%edx
80100ae3:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100ae6:	80 ba 20 1f 11 80 0a 	cmpb   $0xa,-0x7feee0e0(%edx)
80100aed:	74 a3                	je     80100a92 <consoleintr+0x22>
        input.e--;
80100aef:	a3 a8 1f 11 80       	mov    %eax,0x80111fa8
  if(panicked){
80100af4:	a1 5c c5 10 80       	mov    0x8010c55c,%eax
80100af9:	85 c0                	test   %eax,%eax
80100afb:	74 ca                	je     80100ac7 <consoleintr+0x57>
80100afd:	fa                   	cli    
    for(;;)
80100afe:	eb fe                	jmp    80100afe <consoleintr+0x8e>
    switch(c){
80100b00:	81 fe e2 00 00 00    	cmp    $0xe2,%esi
80100b06:	0f 84 24 02 00 00    	je     80100d30 <consoleintr+0x2c0>
80100b0c:	81 fe e3 00 00 00    	cmp    $0xe3,%esi
80100b12:	75 34                	jne    80100b48 <consoleintr+0xd8>
      if ((history.count != 0 ) && (history.last - history.index > 0))
80100b14:	a1 3c 25 11 80       	mov    0x8011253c,%eax
80100b19:	85 c0                	test   %eax,%eax
80100b1b:	0f 84 71 ff ff ff    	je     80100a92 <consoleintr+0x22>
80100b21:	a1 40 25 11 80       	mov    0x80112540,%eax
80100b26:	2b 05 38 25 11 80    	sub    0x80112538,%eax
80100b2c:	85 c0                	test   %eax,%eax
80100b2e:	0f 8e 5e ff ff ff    	jle    80100a92 <consoleintr+0x22>
        arrow(DOWN);
80100b34:	b8 01 00 00 00       	mov    $0x1,%eax
80100b39:	e8 82 fb ff ff       	call   801006c0 <arrow>
80100b3e:	e9 4f ff ff ff       	jmp    80100a92 <consoleintr+0x22>
80100b43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b47:	90                   	nop
    switch(c){
80100b48:	83 fe 7f             	cmp    $0x7f,%esi
80100b4b:	0f 85 17 01 00 00    	jne    80100c68 <consoleintr+0x1f8>
      if(input.e != input.w){
80100b51:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
80100b56:	3b 05 a4 1f 11 80    	cmp    0x80111fa4,%eax
80100b5c:	0f 84 30 ff ff ff    	je     80100a92 <consoleintr+0x22>
        input.e--;  
80100b62:	83 e8 01             	sub    $0x1,%eax
80100b65:	a3 a8 1f 11 80       	mov    %eax,0x80111fa8
  if(panicked){
80100b6a:	a1 5c c5 10 80       	mov    0x8010c55c,%eax
80100b6f:	85 c0                	test   %eax,%eax
80100b71:	0f 84 06 02 00 00    	je     80100d7d <consoleintr+0x30d>
80100b77:	fa                   	cli    
    for(;;)
80100b78:	eb fe                	jmp    80100b78 <consoleintr+0x108>
      if (backs > 0) {
80100b7a:	a1 58 c5 10 80       	mov    0x8010c558,%eax
80100b7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100b82:	85 c0                	test   %eax,%eax
80100b84:	0f 8e 08 ff ff ff    	jle    80100a92 <consoleintr+0x22>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b8a:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100b8f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100b94:	89 fa                	mov    %edi,%edx
80100b96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b97:	be d5 03 00 00       	mov    $0x3d5,%esi
80100b9c:	89 f2                	mov    %esi,%edx
80100b9e:	ec                   	in     (%dx),%al
80100b9f:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100ba2:	89 fa                	mov    %edi,%edx
80100ba4:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT + 1) << 8;
80100ba9:	c1 e1 08             	shl    $0x8,%ecx
80100bac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100bad:	89 f2                	mov    %esi,%edx
80100baf:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100bb0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100bb3:	89 fa                	mov    %edi,%edx
80100bb5:	09 c1                	or     %eax,%ecx
80100bb7:	b8 0e 00 00 00       	mov    $0xe,%eax
    pos++;
80100bbc:	83 c1 01             	add    $0x1,%ecx
80100bbf:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100bc0:	89 ca                	mov    %ecx,%edx
80100bc2:	c1 fa 08             	sar    $0x8,%edx
80100bc5:	89 d0                	mov    %edx,%eax
80100bc7:	89 f2                	mov    %esi,%edx
80100bc9:	ee                   	out    %al,(%dx)
80100bca:	b8 0f 00 00 00       	mov    $0xf,%eax
80100bcf:	89 fa                	mov    %edi,%edx
80100bd1:	ee                   	out    %al,(%dx)
80100bd2:	89 c8                	mov    %ecx,%eax
80100bd4:	89 f2                	mov    %esi,%edx
80100bd6:	ee                   	out    %al,(%dx)
        backs--;
80100bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100bda:	83 e8 01             	sub    $0x1,%eax
80100bdd:	a3 58 c5 10 80       	mov    %eax,0x8010c558
80100be2:	e9 ab fe ff ff       	jmp    80100a92 <consoleintr+0x22>
      if ((input.e - backs) > input.w)
80100be7:	a1 58 c5 10 80       	mov    0x8010c558,%eax
80100bec:	8b 3d a8 1f 11 80    	mov    0x80111fa8,%edi
80100bf2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100bf5:	29 c7                	sub    %eax,%edi
80100bf7:	3b 3d a4 1f 11 80    	cmp    0x80111fa4,%edi
80100bfd:	0f 86 8f fe ff ff    	jbe    80100a92 <consoleintr+0x22>
80100c03:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100c08:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c0d:	89 fa                	mov    %edi,%edx
80100c0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c10:	be d5 03 00 00       	mov    $0x3d5,%esi
80100c15:	89 f2                	mov    %esi,%edx
80100c17:	ec                   	in     (%dx),%al
80100c18:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c1b:	89 fa                	mov    %edi,%edx
80100c1d:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT + 1) << 8;
80100c22:	c1 e1 08             	shl    $0x8,%ecx
80100c25:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c26:	89 f2                	mov    %esi,%edx
80100c28:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100c29:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c2c:	89 fa                	mov    %edi,%edx
80100c2e:	09 c1                	or     %eax,%ecx
80100c30:	b8 0e 00 00 00       	mov    $0xe,%eax
    pos--;
80100c35:	83 e9 01             	sub    $0x1,%ecx
80100c38:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100c39:	89 ca                	mov    %ecx,%edx
80100c3b:	c1 fa 08             	sar    $0x8,%edx
80100c3e:	89 d0                	mov    %edx,%eax
80100c40:	89 f2                	mov    %esi,%edx
80100c42:	ee                   	out    %al,(%dx)
80100c43:	b8 0f 00 00 00       	mov    $0xf,%eax
80100c48:	89 fa                	mov    %edi,%edx
80100c4a:	ee                   	out    %al,(%dx)
80100c4b:	89 c8                	mov    %ecx,%eax
80100c4d:	89 f2                	mov    %esi,%edx
80100c4f:	ee                   	out    %al,(%dx)
        backs++;
80100c50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c53:	83 c0 01             	add    $0x1,%eax
80100c56:	a3 58 c5 10 80       	mov    %eax,0x8010c558
80100c5b:	e9 32 fe ff ff       	jmp    80100a92 <consoleintr+0x22>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100c60:	85 f6                	test   %esi,%esi
80100c62:	0f 84 2a fe ff ff    	je     80100a92 <consoleintr+0x22>
80100c68:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
80100c6d:	89 c2                	mov    %eax,%edx
80100c6f:	2b 15 a0 1f 11 80    	sub    0x80111fa0,%edx
80100c75:	83 fa 7f             	cmp    $0x7f,%edx
80100c78:	0f 87 14 fe ff ff    	ja     80100a92 <consoleintr+0x22>
        c = (c == '\r') ? '\n' : c;
80100c7e:	8d 48 01             	lea    0x1(%eax),%ecx
80100c81:	8b 15 5c c5 10 80    	mov    0x8010c55c,%edx
80100c87:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
80100c8a:	89 0d a8 1f 11 80    	mov    %ecx,0x80111fa8
        c = (c == '\r') ? '\n' : c;
80100c90:	83 fe 0d             	cmp    $0xd,%esi
80100c93:	0f 84 f3 00 00 00    	je     80100d8c <consoleintr+0x31c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100c99:	89 f1                	mov    %esi,%ecx
80100c9b:	88 88 20 1f 11 80    	mov    %cl,-0x7feee0e0(%eax)
  if(panicked){
80100ca1:	85 d2                	test   %edx,%edx
80100ca3:	0f 84 d7 01 00 00    	je     80100e80 <consoleintr+0x410>
  asm volatile("cli");
80100ca9:	fa                   	cli    
    for(;;)
80100caa:	eb fe                	jmp    80100caa <consoleintr+0x23a>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100cac:	be d4 03 00 00       	mov    $0x3d4,%esi
80100cb1:	b8 0e 00 00 00       	mov    $0xe,%eax
80100cb6:	89 f2                	mov    %esi,%edx
80100cb8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100cb9:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100cbe:	89 ca                	mov    %ecx,%edx
80100cc0:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100cc1:	b8 0f 00 00 00       	mov    $0xf,%eax
80100cc6:	89 f2                	mov    %esi,%edx
80100cc8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100cc9:	89 ca                	mov    %ecx,%edx
80100ccb:	ec                   	in     (%dx),%al
80100ccc:	be d0 07 00 00       	mov    $0x7d0,%esi
  if(panicked){
80100cd1:	8b 3d 5c c5 10 80    	mov    0x8010c55c,%edi
80100cd7:	85 ff                	test   %edi,%edi
80100cd9:	74 05                	je     80100ce0 <consoleintr+0x270>
  asm volatile("cli");
80100cdb:	fa                   	cli    
    for(;;)
80100cdc:	eb fe                	jmp    80100cdc <consoleintr+0x26c>
80100cde:	66 90                	xchg   %ax,%ax
80100ce0:	b8 00 01 00 00       	mov    $0x100,%eax
80100ce5:	e8 26 f7 ff ff       	call   80100410 <consputc.part.0>
  for (int pos = 0; pos < SCREEN_SIZE ; pos++){
80100cea:	83 ee 01             	sub    $0x1,%esi
80100ced:	75 e2                	jne    80100cd1 <consoleintr+0x261>
  if(panicked){
80100cef:	8b 0d 5c c5 10 80    	mov    0x8010c55c,%ecx
  backs = 0;
80100cf5:	c7 05 58 c5 10 80 00 	movl   $0x0,0x8010c558
80100cfc:	00 00 00 
  input.e = input.w = input.r = 0;
80100cff:	c7 05 a0 1f 11 80 00 	movl   $0x0,0x80111fa0
80100d06:	00 00 00 
80100d09:	c7 05 a4 1f 11 80 00 	movl   $0x0,0x80111fa4
80100d10:	00 00 00 
80100d13:	c7 05 a8 1f 11 80 00 	movl   $0x0,0x80111fa8
80100d1a:	00 00 00 
  if(panicked){
80100d1d:	85 c9                	test   %ecx,%ecx
80100d1f:	0f 84 fb 00 00 00    	je     80100e20 <consoleintr+0x3b0>
80100d25:	fa                   	cli    
    for(;;)
80100d26:	eb fe                	jmp    80100d26 <consoleintr+0x2b6>
80100d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d2f:	90                   	nop
      if ((history.count != 0)  && (history.last - history.index < history.count))
80100d30:	8b 15 3c 25 11 80    	mov    0x8011253c,%edx
80100d36:	85 d2                	test   %edx,%edx
80100d38:	0f 84 54 fd ff ff    	je     80100a92 <consoleintr+0x22>
80100d3e:	a1 40 25 11 80       	mov    0x80112540,%eax
80100d43:	2b 05 38 25 11 80    	sub    0x80112538,%eax
80100d49:	39 c2                	cmp    %eax,%edx
80100d4b:	0f 8e 41 fd ff ff    	jle    80100a92 <consoleintr+0x22>
        arrow(UP);
80100d51:	31 c0                	xor    %eax,%eax
80100d53:	e8 68 f9 ff ff       	call   801006c0 <arrow>
80100d58:	e9 35 fd ff ff       	jmp    80100a92 <consoleintr+0x22>
  release(&cons.lock);
80100d5d:	83 ec 0c             	sub    $0xc,%esp
80100d60:	68 20 c5 10 80       	push   $0x8010c520
80100d65:	e8 86 4b 00 00       	call   801058f0 <release>
  if(doprocdump) {
80100d6a:	83 c4 10             	add    $0x10,%esp
80100d6d:	85 db                	test   %ebx,%ebx
80100d6f:	0f 85 40 01 00 00    	jne    80100eb5 <consoleintr+0x445>
}
80100d75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d78:	5b                   	pop    %ebx
80100d79:	5e                   	pop    %esi
80100d7a:	5f                   	pop    %edi
80100d7b:	5d                   	pop    %ebp
80100d7c:	c3                   	ret    
80100d7d:	b8 00 01 00 00       	mov    $0x100,%eax
80100d82:	e8 89 f6 ff ff       	call   80100410 <consputc.part.0>
80100d87:	e9 06 fd ff ff       	jmp    80100a92 <consoleintr+0x22>
        input.buf[input.e++ % INPUT_BUF] = c;
80100d8c:	c6 80 20 1f 11 80 0a 	movb   $0xa,-0x7feee0e0(%eax)
  if(panicked){
80100d93:	85 d2                	test   %edx,%edx
80100d95:	0f 85 0e ff ff ff    	jne    80100ca9 <consoleintr+0x239>
80100d9b:	b8 0a 00 00 00       	mov    $0xa,%eax
80100da0:	e8 6b f6 ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100da5:	8b 15 a8 1f 11 80    	mov    0x80111fa8,%edx
          if (history.count < 9){
80100dab:	a1 3c 25 11 80       	mov    0x8011253c,%eax
80100db0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100db3:	83 f8 08             	cmp    $0x8,%eax
80100db6:	0f 8f 05 01 00 00    	jg     80100ec1 <consoleintr+0x451>
            history.hist[history.last + 1] = input;
80100dbc:	8b 3d 40 25 11 80    	mov    0x80112540,%edi
80100dc2:	b9 23 00 00 00       	mov    $0x23,%ecx
80100dc7:	be 20 1f 11 80       	mov    $0x80111f20,%esi
80100dcc:	83 c7 01             	add    $0x1,%edi
80100dcf:	69 c7 8c 00 00 00    	imul   $0x8c,%edi,%eax
80100dd5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80100dd8:	05 c0 1f 11 80       	add    $0x80111fc0,%eax
80100ddd:	89 c7                	mov    %eax,%edi
            history.count ++ ;
80100ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
            history.hist[history.last + 1] = input;
80100de2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            history.last ++ ;
80100de4:	8b 7d e0             	mov    -0x20(%ebp),%edi
            history.count ++ ;
80100de7:	83 c0 01             	add    $0x1,%eax
            history.last ++ ;
80100dea:	89 3d 40 25 11 80    	mov    %edi,0x80112540
            history.index = history.last;
80100df0:	89 3d 38 25 11 80    	mov    %edi,0x80112538
            history.count ++ ;
80100df6:	a3 3c 25 11 80       	mov    %eax,0x8011253c
          wakeup(&input.r);
80100dfb:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100dfe:	89 15 a4 1f 11 80    	mov    %edx,0x80111fa4
          wakeup(&input.r);
80100e04:	68 a0 1f 11 80       	push   $0x80111fa0
          backs = 0;
80100e09:	c7 05 58 c5 10 80 00 	movl   $0x0,0x8010c558
80100e10:	00 00 00 
          wakeup(&input.r);
80100e13:	e8 38 38 00 00       	call   80104650 <wakeup>
80100e18:	83 c4 10             	add    $0x10,%esp
80100e1b:	e9 72 fc ff ff       	jmp    80100a92 <consoleintr+0x22>
80100e20:	b8 24 00 00 00       	mov    $0x24,%eax
80100e25:	e8 e6 f5 ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100e2a:	8b 15 5c c5 10 80    	mov    0x8010c55c,%edx
80100e30:	85 d2                	test   %edx,%edx
80100e32:	74 0c                	je     80100e40 <consoleintr+0x3d0>
80100e34:	fa                   	cli    
    for(;;)
80100e35:	eb fe                	jmp    80100e35 <consoleintr+0x3c5>
80100e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e3e:	66 90                	xchg   %ax,%ax
80100e40:	b8 20 00 00 00       	mov    $0x20,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100e45:	be d4 03 00 00       	mov    $0x3d4,%esi
80100e4a:	e8 c1 f5 ff ff       	call   80100410 <consputc.part.0>
80100e4f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100e54:	89 f2                	mov    %esi,%edx
80100e56:	ee                   	out    %al,(%dx)
80100e57:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100e5c:	31 c0                	xor    %eax,%eax
80100e5e:	89 ca                	mov    %ecx,%edx
80100e60:	ee                   	out    %al,(%dx)
80100e61:	b8 0f 00 00 00       	mov    $0xf,%eax
80100e66:	89 f2                	mov    %esi,%edx
80100e68:	ee                   	out    %al,(%dx)
80100e69:	b8 02 00 00 00       	mov    $0x2,%eax
80100e6e:	89 ca                	mov    %ecx,%edx
80100e70:	ee                   	out    %al,(%dx)
}
80100e71:	e9 1c fc ff ff       	jmp    80100a92 <consoleintr+0x22>
80100e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e7d:	8d 76 00             	lea    0x0(%esi),%esi
80100e80:	89 f0                	mov    %esi,%eax
80100e82:	e8 89 f5 ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100e87:	83 fe 0a             	cmp    $0xa,%esi
80100e8a:	0f 84 15 ff ff ff    	je     80100da5 <consoleintr+0x335>
80100e90:	83 fe 04             	cmp    $0x4,%esi
80100e93:	0f 84 0c ff ff ff    	je     80100da5 <consoleintr+0x335>
80100e99:	a1 a0 1f 11 80       	mov    0x80111fa0,%eax
80100e9e:	8d 90 80 00 00 00    	lea    0x80(%eax),%edx
80100ea4:	39 15 a8 1f 11 80    	cmp    %edx,0x80111fa8
80100eaa:	0f 85 e2 fb ff ff    	jne    80100a92 <consoleintr+0x22>
80100eb0:	e9 f6 fe ff ff       	jmp    80100dab <consoleintr+0x33b>
}
80100eb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eb8:	5b                   	pop    %ebx
80100eb9:	5e                   	pop    %esi
80100eba:	5f                   	pop    %edi
80100ebb:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100ebc:	e9 6f 39 00 00       	jmp    80104830 <procdump>
80100ec1:	b8 c0 1f 11 80       	mov    $0x80111fc0,%eax
              history.hist[h] = history.hist[h+1]; 
80100ec6:	8d b0 8c 00 00 00    	lea    0x8c(%eax),%esi
80100ecc:	89 c7                	mov    %eax,%edi
80100ece:	b9 23 00 00 00       	mov    $0x23,%ecx
80100ed3:	05 8c 00 00 00       	add    $0x8c,%eax
80100ed8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            for (int h = 0; h < 9; h++) {
80100eda:	bf ac 24 11 80       	mov    $0x801124ac,%edi
80100edf:	39 c7                	cmp    %eax,%edi
80100ee1:	75 e3                	jne    80100ec6 <consoleintr+0x456>
            history.hist[9] = input;
80100ee3:	b9 23 00 00 00       	mov    $0x23,%ecx
80100ee8:	be 20 1f 11 80       	mov    $0x80111f20,%esi
            history.index = 9;
80100eed:	c7 05 38 25 11 80 09 	movl   $0x9,0x80112538
80100ef4:	00 00 00 
            history.hist[9] = input;
80100ef7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            history.last = 9;
80100ef9:	c7 05 40 25 11 80 09 	movl   $0x9,0x80112540
80100f00:	00 00 00 
            history.count = 10;
80100f03:	c7 05 3c 25 11 80 0a 	movl   $0xa,0x8011253c
80100f0a:	00 00 00 
80100f0d:	e9 e9 fe ff ff       	jmp    80100dfb <consoleintr+0x38b>
80100f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f20 <consoleinit>:

void
consoleinit(void)
{
80100f20:	f3 0f 1e fb          	endbr32 
80100f24:	55                   	push   %ebp
80100f25:	89 e5                	mov    %esp,%ebp
80100f27:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100f2a:	68 08 88 10 80       	push   $0x80108808
80100f2f:	68 20 c5 10 80       	push   $0x8010c520
80100f34:	e8 77 47 00 00       	call   801056b0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100f39:	58                   	pop    %eax
80100f3a:	5a                   	pop    %edx
80100f3b:	6a 00                	push   $0x0
80100f3d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100f3f:	c7 05 0c 2f 11 80 50 	movl   $0x80100850,0x80112f0c
80100f46:	08 10 80 
  devsw[CONSOLE].read = consoleread;
80100f49:	c7 05 08 2f 11 80 90 	movl   $0x80100290,0x80112f08
80100f50:	02 10 80 
  cons.locking = 1;
80100f53:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
80100f5a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100f5d:	e8 be 19 00 00       	call   80102920 <ioapicenable>
}
80100f62:	83 c4 10             	add    $0x10,%esp
80100f65:	c9                   	leave  
80100f66:	c3                   	ret    
80100f67:	66 90                	xchg   %ax,%ax
80100f69:	66 90                	xchg   %ax,%ax
80100f6b:	66 90                	xchg   %ax,%ax
80100f6d:	66 90                	xchg   %ax,%ax
80100f6f:	90                   	nop

80100f70 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100f70:	f3 0f 1e fb          	endbr32 
80100f74:	55                   	push   %ebp
80100f75:	89 e5                	mov    %esp,%ebp
80100f77:	57                   	push   %edi
80100f78:	56                   	push   %esi
80100f79:	53                   	push   %ebx
80100f7a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100f80:	e8 2b 2f 00 00       	call   80103eb0 <myproc>
80100f85:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100f8b:	e8 90 22 00 00       	call   80103220 <begin_op>

  if((ip = namei(path)) == 0){
80100f90:	83 ec 0c             	sub    $0xc,%esp
80100f93:	ff 75 08             	pushl  0x8(%ebp)
80100f96:	e8 85 15 00 00       	call   80102520 <namei>
80100f9b:	83 c4 10             	add    $0x10,%esp
80100f9e:	85 c0                	test   %eax,%eax
80100fa0:	0f 84 fe 02 00 00    	je     801012a4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100fa6:	83 ec 0c             	sub    $0xc,%esp
80100fa9:	89 c3                	mov    %eax,%ebx
80100fab:	50                   	push   %eax
80100fac:	e8 9f 0c 00 00       	call   80101c50 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100fb1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100fb7:	6a 34                	push   $0x34
80100fb9:	6a 00                	push   $0x0
80100fbb:	50                   	push   %eax
80100fbc:	53                   	push   %ebx
80100fbd:	e8 8e 0f 00 00       	call   80101f50 <readi>
80100fc2:	83 c4 20             	add    $0x20,%esp
80100fc5:	83 f8 34             	cmp    $0x34,%eax
80100fc8:	74 26                	je     80100ff0 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100fca:	83 ec 0c             	sub    $0xc,%esp
80100fcd:	53                   	push   %ebx
80100fce:	e8 1d 0f 00 00       	call   80101ef0 <iunlockput>
    end_op();
80100fd3:	e8 b8 22 00 00       	call   80103290 <end_op>
80100fd8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100fdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe3:	5b                   	pop    %ebx
80100fe4:	5e                   	pop    %esi
80100fe5:	5f                   	pop    %edi
80100fe6:	5d                   	pop    %ebp
80100fe7:	c3                   	ret    
80100fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fef:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100ff0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100ff7:	45 4c 46 
80100ffa:	75 ce                	jne    80100fca <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100ffc:	e8 0f 75 00 00       	call   80108510 <setupkvm>
80101001:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101007:	85 c0                	test   %eax,%eax
80101009:	74 bf                	je     80100fca <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010100b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101012:	00 
80101013:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101019:	0f 84 a4 02 00 00    	je     801012c3 <exec+0x353>
  sz = 0;
8010101f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101026:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101029:	31 ff                	xor    %edi,%edi
8010102b:	e9 86 00 00 00       	jmp    801010b6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80101030:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101037:	75 6c                	jne    801010a5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80101039:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010103f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101045:	0f 82 87 00 00 00    	jb     801010d2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
8010104b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101051:	72 7f                	jb     801010d2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101053:	83 ec 04             	sub    $0x4,%esp
80101056:	50                   	push   %eax
80101057:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
8010105d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101063:	e8 c8 72 00 00       	call   80108330 <allocuvm>
80101068:	83 c4 10             	add    $0x10,%esp
8010106b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101071:	85 c0                	test   %eax,%eax
80101073:	74 5d                	je     801010d2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101075:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010107b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101080:	75 50                	jne    801010d2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101082:	83 ec 0c             	sub    $0xc,%esp
80101085:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
8010108b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80101091:	53                   	push   %ebx
80101092:	50                   	push   %eax
80101093:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101099:	e8 c2 71 00 00       	call   80108260 <loaduvm>
8010109e:	83 c4 20             	add    $0x20,%esp
801010a1:	85 c0                	test   %eax,%eax
801010a3:	78 2d                	js     801010d2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010a5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
801010ac:	83 c7 01             	add    $0x1,%edi
801010af:	83 c6 20             	add    $0x20,%esi
801010b2:	39 f8                	cmp    %edi,%eax
801010b4:	7e 3a                	jle    801010f0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801010b6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801010bc:	6a 20                	push   $0x20
801010be:	56                   	push   %esi
801010bf:	50                   	push   %eax
801010c0:	53                   	push   %ebx
801010c1:	e8 8a 0e 00 00       	call   80101f50 <readi>
801010c6:	83 c4 10             	add    $0x10,%esp
801010c9:	83 f8 20             	cmp    $0x20,%eax
801010cc:	0f 84 5e ff ff ff    	je     80101030 <exec+0xc0>
    freevm(pgdir);
801010d2:	83 ec 0c             	sub    $0xc,%esp
801010d5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801010db:	e8 b0 73 00 00       	call   80108490 <freevm>
  if(ip){
801010e0:	83 c4 10             	add    $0x10,%esp
801010e3:	e9 e2 fe ff ff       	jmp    80100fca <exec+0x5a>
801010e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ef:	90                   	nop
801010f0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801010f6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
801010fc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80101102:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80101108:	83 ec 0c             	sub    $0xc,%esp
8010110b:	53                   	push   %ebx
8010110c:	e8 df 0d 00 00       	call   80101ef0 <iunlockput>
  end_op();
80101111:	e8 7a 21 00 00       	call   80103290 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101116:	83 c4 0c             	add    $0xc,%esp
80101119:	56                   	push   %esi
8010111a:	57                   	push   %edi
8010111b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101121:	57                   	push   %edi
80101122:	e8 09 72 00 00       	call   80108330 <allocuvm>
80101127:	83 c4 10             	add    $0x10,%esp
8010112a:	89 c6                	mov    %eax,%esi
8010112c:	85 c0                	test   %eax,%eax
8010112e:	0f 84 94 00 00 00    	je     801011c8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
8010113d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010113f:	50                   	push   %eax
80101140:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80101141:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101143:	e8 68 74 00 00       	call   801085b0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101148:	8b 45 0c             	mov    0xc(%ebp),%eax
8010114b:	83 c4 10             	add    $0x10,%esp
8010114e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101154:	8b 00                	mov    (%eax),%eax
80101156:	85 c0                	test   %eax,%eax
80101158:	0f 84 8b 00 00 00    	je     801011e9 <exec+0x279>
8010115e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101164:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
8010116a:	eb 23                	jmp    8010118f <exec+0x21f>
8010116c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101170:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101173:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010117a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010117d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101183:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101186:	85 c0                	test   %eax,%eax
80101188:	74 59                	je     801011e3 <exec+0x273>
    if(argc >= MAXARG)
8010118a:	83 ff 20             	cmp    $0x20,%edi
8010118d:	74 39                	je     801011c8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010118f:	83 ec 0c             	sub    $0xc,%esp
80101192:	50                   	push   %eax
80101193:	e8 a8 49 00 00       	call   80105b40 <strlen>
80101198:	f7 d0                	not    %eax
8010119a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010119c:	58                   	pop    %eax
8010119d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801011a0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801011a3:	ff 34 b8             	pushl  (%eax,%edi,4)
801011a6:	e8 95 49 00 00       	call   80105b40 <strlen>
801011ab:	83 c0 01             	add    $0x1,%eax
801011ae:	50                   	push   %eax
801011af:	8b 45 0c             	mov    0xc(%ebp),%eax
801011b2:	ff 34 b8             	pushl  (%eax,%edi,4)
801011b5:	53                   	push   %ebx
801011b6:	56                   	push   %esi
801011b7:	e8 54 75 00 00       	call   80108710 <copyout>
801011bc:	83 c4 20             	add    $0x20,%esp
801011bf:	85 c0                	test   %eax,%eax
801011c1:	79 ad                	jns    80101170 <exec+0x200>
801011c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011c7:	90                   	nop
    freevm(pgdir);
801011c8:	83 ec 0c             	sub    $0xc,%esp
801011cb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801011d1:	e8 ba 72 00 00       	call   80108490 <freevm>
801011d6:	83 c4 10             	add    $0x10,%esp
  return -1;
801011d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011de:	e9 fd fd ff ff       	jmp    80100fe0 <exec+0x70>
801011e3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801011e9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
801011f0:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
801011f2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
801011f9:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801011fd:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
801011ff:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101202:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101208:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010120a:	50                   	push   %eax
8010120b:	52                   	push   %edx
8010120c:	53                   	push   %ebx
8010120d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101213:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010121a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010121d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101223:	e8 e8 74 00 00       	call   80108710 <copyout>
80101228:	83 c4 10             	add    $0x10,%esp
8010122b:	85 c0                	test   %eax,%eax
8010122d:	78 99                	js     801011c8 <exec+0x258>
  for(last=s=path; *s; s++)
8010122f:	8b 45 08             	mov    0x8(%ebp),%eax
80101232:	8b 55 08             	mov    0x8(%ebp),%edx
80101235:	0f b6 00             	movzbl (%eax),%eax
80101238:	84 c0                	test   %al,%al
8010123a:	74 13                	je     8010124f <exec+0x2df>
8010123c:	89 d1                	mov    %edx,%ecx
8010123e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80101240:	83 c1 01             	add    $0x1,%ecx
80101243:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101245:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80101248:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010124b:	84 c0                	test   %al,%al
8010124d:	75 f1                	jne    80101240 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010124f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101255:	83 ec 04             	sub    $0x4,%esp
80101258:	6a 10                	push   $0x10
8010125a:	89 f8                	mov    %edi,%eax
8010125c:	52                   	push   %edx
8010125d:	83 c0 6c             	add    $0x6c,%eax
80101260:	50                   	push   %eax
80101261:	e8 9a 48 00 00       	call   80105b00 <safestrcpy>
  curproc->pgdir = pgdir;
80101266:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010126c:	89 f8                	mov    %edi,%eax
8010126e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101271:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101273:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101276:	89 c1                	mov    %eax,%ecx
80101278:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010127e:	8b 40 18             	mov    0x18(%eax),%eax
80101281:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101284:	8b 41 18             	mov    0x18(%ecx),%eax
80101287:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010128a:	89 0c 24             	mov    %ecx,(%esp)
8010128d:	e8 3e 6e 00 00       	call   801080d0 <switchuvm>
  freevm(oldpgdir);
80101292:	89 3c 24             	mov    %edi,(%esp)
80101295:	e8 f6 71 00 00       	call   80108490 <freevm>
  return 0;
8010129a:	83 c4 10             	add    $0x10,%esp
8010129d:	31 c0                	xor    %eax,%eax
8010129f:	e9 3c fd ff ff       	jmp    80100fe0 <exec+0x70>
    end_op();
801012a4:	e8 e7 1f 00 00       	call   80103290 <end_op>
    cprintf("exec: fail\n");
801012a9:	83 ec 0c             	sub    $0xc,%esp
801012ac:	68 79 88 10 80       	push   $0x80108879
801012b1:	e8 0a f6 ff ff       	call   801008c0 <cprintf>
    return -1;
801012b6:	83 c4 10             	add    $0x10,%esp
801012b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012be:	e9 1d fd ff ff       	jmp    80100fe0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801012c3:	31 ff                	xor    %edi,%edi
801012c5:	be 00 20 00 00       	mov    $0x2000,%esi
801012ca:	e9 39 fe ff ff       	jmp    80101108 <exec+0x198>
801012cf:	90                   	nop

801012d0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801012d0:	f3 0f 1e fb          	endbr32 
801012d4:	55                   	push   %ebp
801012d5:	89 e5                	mov    %esp,%ebp
801012d7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801012da:	68 85 88 10 80       	push   $0x80108885
801012df:	68 60 25 11 80       	push   $0x80112560
801012e4:	e8 c7 43 00 00       	call   801056b0 <initlock>
}
801012e9:	83 c4 10             	add    $0x10,%esp
801012ec:	c9                   	leave  
801012ed:	c3                   	ret    
801012ee:	66 90                	xchg   %ax,%ax

801012f0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801012f0:	f3 0f 1e fb          	endbr32 
801012f4:	55                   	push   %ebp
801012f5:	89 e5                	mov    %esp,%ebp
801012f7:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801012f8:	bb 94 25 11 80       	mov    $0x80112594,%ebx
{
801012fd:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80101300:	68 60 25 11 80       	push   $0x80112560
80101305:	e8 26 45 00 00       	call   80105830 <acquire>
8010130a:	83 c4 10             	add    $0x10,%esp
8010130d:	eb 0c                	jmp    8010131b <filealloc+0x2b>
8010130f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101310:	83 c3 18             	add    $0x18,%ebx
80101313:	81 fb f4 2e 11 80    	cmp    $0x80112ef4,%ebx
80101319:	74 25                	je     80101340 <filealloc+0x50>
    if(f->ref == 0){
8010131b:	8b 43 04             	mov    0x4(%ebx),%eax
8010131e:	85 c0                	test   %eax,%eax
80101320:	75 ee                	jne    80101310 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101322:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101325:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010132c:	68 60 25 11 80       	push   $0x80112560
80101331:	e8 ba 45 00 00       	call   801058f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101336:	89 d8                	mov    %ebx,%eax
      return f;
80101338:	83 c4 10             	add    $0x10,%esp
}
8010133b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010133e:	c9                   	leave  
8010133f:	c3                   	ret    
  release(&ftable.lock);
80101340:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101343:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101345:	68 60 25 11 80       	push   $0x80112560
8010134a:	e8 a1 45 00 00       	call   801058f0 <release>
}
8010134f:	89 d8                	mov    %ebx,%eax
  return 0;
80101351:	83 c4 10             	add    $0x10,%esp
}
80101354:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101357:	c9                   	leave  
80101358:	c3                   	ret    
80101359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101360 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101360:	f3 0f 1e fb          	endbr32 
80101364:	55                   	push   %ebp
80101365:	89 e5                	mov    %esp,%ebp
80101367:	53                   	push   %ebx
80101368:	83 ec 10             	sub    $0x10,%esp
8010136b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010136e:	68 60 25 11 80       	push   $0x80112560
80101373:	e8 b8 44 00 00       	call   80105830 <acquire>
  if(f->ref < 1)
80101378:	8b 43 04             	mov    0x4(%ebx),%eax
8010137b:	83 c4 10             	add    $0x10,%esp
8010137e:	85 c0                	test   %eax,%eax
80101380:	7e 1a                	jle    8010139c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80101382:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101385:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101388:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
8010138b:	68 60 25 11 80       	push   $0x80112560
80101390:	e8 5b 45 00 00       	call   801058f0 <release>
  return f;
}
80101395:	89 d8                	mov    %ebx,%eax
80101397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010139a:	c9                   	leave  
8010139b:	c3                   	ret    
    panic("filedup");
8010139c:	83 ec 0c             	sub    $0xc,%esp
8010139f:	68 8c 88 10 80       	push   $0x8010888c
801013a4:	e8 e7 ef ff ff       	call   80100390 <panic>
801013a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801013b0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801013b0:	f3 0f 1e fb          	endbr32 
801013b4:	55                   	push   %ebp
801013b5:	89 e5                	mov    %esp,%ebp
801013b7:	57                   	push   %edi
801013b8:	56                   	push   %esi
801013b9:	53                   	push   %ebx
801013ba:	83 ec 28             	sub    $0x28,%esp
801013bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801013c0:	68 60 25 11 80       	push   $0x80112560
801013c5:	e8 66 44 00 00       	call   80105830 <acquire>
  if(f->ref < 1)
801013ca:	8b 53 04             	mov    0x4(%ebx),%edx
801013cd:	83 c4 10             	add    $0x10,%esp
801013d0:	85 d2                	test   %edx,%edx
801013d2:	0f 8e a1 00 00 00    	jle    80101479 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801013d8:	83 ea 01             	sub    $0x1,%edx
801013db:	89 53 04             	mov    %edx,0x4(%ebx)
801013de:	75 40                	jne    80101420 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801013e0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801013e4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801013e7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801013e9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801013ef:	8b 73 0c             	mov    0xc(%ebx),%esi
801013f2:	88 45 e7             	mov    %al,-0x19(%ebp)
801013f5:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801013f8:	68 60 25 11 80       	push   $0x80112560
  ff = *f;
801013fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101400:	e8 eb 44 00 00       	call   801058f0 <release>

  if(ff.type == FD_PIPE)
80101405:	83 c4 10             	add    $0x10,%esp
80101408:	83 ff 01             	cmp    $0x1,%edi
8010140b:	74 53                	je     80101460 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
8010140d:	83 ff 02             	cmp    $0x2,%edi
80101410:	74 26                	je     80101438 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101412:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101415:	5b                   	pop    %ebx
80101416:	5e                   	pop    %esi
80101417:	5f                   	pop    %edi
80101418:	5d                   	pop    %ebp
80101419:	c3                   	ret    
8010141a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101420:	c7 45 08 60 25 11 80 	movl   $0x80112560,0x8(%ebp)
}
80101427:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010142a:	5b                   	pop    %ebx
8010142b:	5e                   	pop    %esi
8010142c:	5f                   	pop    %edi
8010142d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010142e:	e9 bd 44 00 00       	jmp    801058f0 <release>
80101433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101437:	90                   	nop
    begin_op();
80101438:	e8 e3 1d 00 00       	call   80103220 <begin_op>
    iput(ff.ip);
8010143d:	83 ec 0c             	sub    $0xc,%esp
80101440:	ff 75 e0             	pushl  -0x20(%ebp)
80101443:	e8 38 09 00 00       	call   80101d80 <iput>
    end_op();
80101448:	83 c4 10             	add    $0x10,%esp
}
8010144b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010144e:	5b                   	pop    %ebx
8010144f:	5e                   	pop    %esi
80101450:	5f                   	pop    %edi
80101451:	5d                   	pop    %ebp
    end_op();
80101452:	e9 39 1e 00 00       	jmp    80103290 <end_op>
80101457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010145e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101460:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101464:	83 ec 08             	sub    $0x8,%esp
80101467:	53                   	push   %ebx
80101468:	56                   	push   %esi
80101469:	e8 82 25 00 00       	call   801039f0 <pipeclose>
8010146e:	83 c4 10             	add    $0x10,%esp
}
80101471:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101474:	5b                   	pop    %ebx
80101475:	5e                   	pop    %esi
80101476:	5f                   	pop    %edi
80101477:	5d                   	pop    %ebp
80101478:	c3                   	ret    
    panic("fileclose");
80101479:	83 ec 0c             	sub    $0xc,%esp
8010147c:	68 94 88 10 80       	push   $0x80108894
80101481:	e8 0a ef ff ff       	call   80100390 <panic>
80101486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010148d:	8d 76 00             	lea    0x0(%esi),%esi

80101490 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101490:	f3 0f 1e fb          	endbr32 
80101494:	55                   	push   %ebp
80101495:	89 e5                	mov    %esp,%ebp
80101497:	53                   	push   %ebx
80101498:	83 ec 04             	sub    $0x4,%esp
8010149b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010149e:	83 3b 02             	cmpl   $0x2,(%ebx)
801014a1:	75 2d                	jne    801014d0 <filestat+0x40>
    ilock(f->ip);
801014a3:	83 ec 0c             	sub    $0xc,%esp
801014a6:	ff 73 10             	pushl  0x10(%ebx)
801014a9:	e8 a2 07 00 00       	call   80101c50 <ilock>
    stati(f->ip, st);
801014ae:	58                   	pop    %eax
801014af:	5a                   	pop    %edx
801014b0:	ff 75 0c             	pushl  0xc(%ebp)
801014b3:	ff 73 10             	pushl  0x10(%ebx)
801014b6:	e8 65 0a 00 00       	call   80101f20 <stati>
    iunlock(f->ip);
801014bb:	59                   	pop    %ecx
801014bc:	ff 73 10             	pushl  0x10(%ebx)
801014bf:	e8 6c 08 00 00       	call   80101d30 <iunlock>
    return 0;
  }
  return -1;
}
801014c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801014c7:	83 c4 10             	add    $0x10,%esp
801014ca:	31 c0                	xor    %eax,%eax
}
801014cc:	c9                   	leave  
801014cd:	c3                   	ret    
801014ce:	66 90                	xchg   %ax,%ax
801014d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801014d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801014d8:	c9                   	leave  
801014d9:	c3                   	ret    
801014da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801014e0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801014e0:	f3 0f 1e fb          	endbr32 
801014e4:	55                   	push   %ebp
801014e5:	89 e5                	mov    %esp,%ebp
801014e7:	57                   	push   %edi
801014e8:	56                   	push   %esi
801014e9:	53                   	push   %ebx
801014ea:	83 ec 0c             	sub    $0xc,%esp
801014ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
801014f0:	8b 75 0c             	mov    0xc(%ebp),%esi
801014f3:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801014f6:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801014fa:	74 64                	je     80101560 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
801014fc:	8b 03                	mov    (%ebx),%eax
801014fe:	83 f8 01             	cmp    $0x1,%eax
80101501:	74 45                	je     80101548 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101503:	83 f8 02             	cmp    $0x2,%eax
80101506:	75 5f                	jne    80101567 <fileread+0x87>
    ilock(f->ip);
80101508:	83 ec 0c             	sub    $0xc,%esp
8010150b:	ff 73 10             	pushl  0x10(%ebx)
8010150e:	e8 3d 07 00 00       	call   80101c50 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101513:	57                   	push   %edi
80101514:	ff 73 14             	pushl  0x14(%ebx)
80101517:	56                   	push   %esi
80101518:	ff 73 10             	pushl  0x10(%ebx)
8010151b:	e8 30 0a 00 00       	call   80101f50 <readi>
80101520:	83 c4 20             	add    $0x20,%esp
80101523:	89 c6                	mov    %eax,%esi
80101525:	85 c0                	test   %eax,%eax
80101527:	7e 03                	jle    8010152c <fileread+0x4c>
      f->off += r;
80101529:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010152c:	83 ec 0c             	sub    $0xc,%esp
8010152f:	ff 73 10             	pushl  0x10(%ebx)
80101532:	e8 f9 07 00 00       	call   80101d30 <iunlock>
    return r;
80101537:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010153a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010153d:	89 f0                	mov    %esi,%eax
8010153f:	5b                   	pop    %ebx
80101540:	5e                   	pop    %esi
80101541:	5f                   	pop    %edi
80101542:	5d                   	pop    %ebp
80101543:	c3                   	ret    
80101544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101548:	8b 43 0c             	mov    0xc(%ebx),%eax
8010154b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010154e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101551:	5b                   	pop    %ebx
80101552:	5e                   	pop    %esi
80101553:	5f                   	pop    %edi
80101554:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101555:	e9 36 26 00 00       	jmp    80103b90 <piperead>
8010155a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101560:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101565:	eb d3                	jmp    8010153a <fileread+0x5a>
  panic("fileread");
80101567:	83 ec 0c             	sub    $0xc,%esp
8010156a:	68 9e 88 10 80       	push   $0x8010889e
8010156f:	e8 1c ee ff ff       	call   80100390 <panic>
80101574:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010157b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010157f:	90                   	nop

80101580 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101580:	f3 0f 1e fb          	endbr32 
80101584:	55                   	push   %ebp
80101585:	89 e5                	mov    %esp,%ebp
80101587:	57                   	push   %edi
80101588:	56                   	push   %esi
80101589:	53                   	push   %ebx
8010158a:	83 ec 1c             	sub    $0x1c,%esp
8010158d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101590:	8b 75 08             	mov    0x8(%ebp),%esi
80101593:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101596:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101599:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010159d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801015a0:	0f 84 c1 00 00 00    	je     80101667 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801015a6:	8b 06                	mov    (%esi),%eax
801015a8:	83 f8 01             	cmp    $0x1,%eax
801015ab:	0f 84 c3 00 00 00    	je     80101674 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801015b1:	83 f8 02             	cmp    $0x2,%eax
801015b4:	0f 85 cc 00 00 00    	jne    80101686 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801015ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801015bd:	31 ff                	xor    %edi,%edi
    while(i < n){
801015bf:	85 c0                	test   %eax,%eax
801015c1:	7f 34                	jg     801015f7 <filewrite+0x77>
801015c3:	e9 98 00 00 00       	jmp    80101660 <filewrite+0xe0>
801015c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015cf:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801015d0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801015d3:	83 ec 0c             	sub    $0xc,%esp
801015d6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801015d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801015dc:	e8 4f 07 00 00       	call   80101d30 <iunlock>
      end_op();
801015e1:	e8 aa 1c 00 00       	call   80103290 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801015e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801015e9:	83 c4 10             	add    $0x10,%esp
801015ec:	39 c3                	cmp    %eax,%ebx
801015ee:	75 60                	jne    80101650 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
801015f0:	01 df                	add    %ebx,%edi
    while(i < n){
801015f2:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801015f5:	7e 69                	jle    80101660 <filewrite+0xe0>
      int n1 = n - i;
801015f7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801015fa:	b8 00 06 00 00       	mov    $0x600,%eax
801015ff:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101601:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101607:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010160a:	e8 11 1c 00 00       	call   80103220 <begin_op>
      ilock(f->ip);
8010160f:	83 ec 0c             	sub    $0xc,%esp
80101612:	ff 76 10             	pushl  0x10(%esi)
80101615:	e8 36 06 00 00       	call   80101c50 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010161a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010161d:	53                   	push   %ebx
8010161e:	ff 76 14             	pushl  0x14(%esi)
80101621:	01 f8                	add    %edi,%eax
80101623:	50                   	push   %eax
80101624:	ff 76 10             	pushl  0x10(%esi)
80101627:	e8 24 0a 00 00       	call   80102050 <writei>
8010162c:	83 c4 20             	add    $0x20,%esp
8010162f:	85 c0                	test   %eax,%eax
80101631:	7f 9d                	jg     801015d0 <filewrite+0x50>
      iunlock(f->ip);
80101633:	83 ec 0c             	sub    $0xc,%esp
80101636:	ff 76 10             	pushl  0x10(%esi)
80101639:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010163c:	e8 ef 06 00 00       	call   80101d30 <iunlock>
      end_op();
80101641:	e8 4a 1c 00 00       	call   80103290 <end_op>
      if(r < 0)
80101646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101649:	83 c4 10             	add    $0x10,%esp
8010164c:	85 c0                	test   %eax,%eax
8010164e:	75 17                	jne    80101667 <filewrite+0xe7>
        panic("short filewrite");
80101650:	83 ec 0c             	sub    $0xc,%esp
80101653:	68 a7 88 10 80       	push   $0x801088a7
80101658:	e8 33 ed ff ff       	call   80100390 <panic>
8010165d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101660:	89 f8                	mov    %edi,%eax
80101662:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101665:	74 05                	je     8010166c <filewrite+0xec>
80101667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010166c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010166f:	5b                   	pop    %ebx
80101670:	5e                   	pop    %esi
80101671:	5f                   	pop    %edi
80101672:	5d                   	pop    %ebp
80101673:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101674:	8b 46 0c             	mov    0xc(%esi),%eax
80101677:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010167a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010167d:	5b                   	pop    %ebx
8010167e:	5e                   	pop    %esi
8010167f:	5f                   	pop    %edi
80101680:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101681:	e9 0a 24 00 00       	jmp    80103a90 <pipewrite>
  panic("filewrite");
80101686:	83 ec 0c             	sub    $0xc,%esp
80101689:	68 ad 88 10 80       	push   $0x801088ad
8010168e:	e8 fd ec ff ff       	call   80100390 <panic>
80101693:	66 90                	xchg   %ax,%ax
80101695:	66 90                	xchg   %ax,%ax
80101697:	66 90                	xchg   %ax,%ax
80101699:	66 90                	xchg   %ax,%ax
8010169b:	66 90                	xchg   %ax,%ax
8010169d:	66 90                	xchg   %ax,%ax
8010169f:	90                   	nop

801016a0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801016a0:	55                   	push   %ebp
801016a1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801016a3:	89 d0                	mov    %edx,%eax
801016a5:	c1 e8 0c             	shr    $0xc,%eax
801016a8:	03 05 78 2f 11 80    	add    0x80112f78,%eax
{
801016ae:	89 e5                	mov    %esp,%ebp
801016b0:	56                   	push   %esi
801016b1:	53                   	push   %ebx
801016b2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801016b4:	83 ec 08             	sub    $0x8,%esp
801016b7:	50                   	push   %eax
801016b8:	51                   	push   %ecx
801016b9:	e8 12 ea ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801016be:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801016c0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801016c3:	ba 01 00 00 00       	mov    $0x1,%edx
801016c8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801016cb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801016d1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801016d4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801016d6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801016db:	85 d1                	test   %edx,%ecx
801016dd:	74 25                	je     80101704 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801016df:	f7 d2                	not    %edx
  log_write(bp);
801016e1:	83 ec 0c             	sub    $0xc,%esp
801016e4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801016e6:	21 ca                	and    %ecx,%edx
801016e8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801016ec:	50                   	push   %eax
801016ed:	e8 0e 1d 00 00       	call   80103400 <log_write>
  brelse(bp);
801016f2:	89 34 24             	mov    %esi,(%esp)
801016f5:	e8 f6 ea ff ff       	call   801001f0 <brelse>
}
801016fa:	83 c4 10             	add    $0x10,%esp
801016fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101700:	5b                   	pop    %ebx
80101701:	5e                   	pop    %esi
80101702:	5d                   	pop    %ebp
80101703:	c3                   	ret    
    panic("freeing free block");
80101704:	83 ec 0c             	sub    $0xc,%esp
80101707:	68 b7 88 10 80       	push   $0x801088b7
8010170c:	e8 7f ec ff ff       	call   80100390 <panic>
80101711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010171f:	90                   	nop

80101720 <balloc>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	57                   	push   %edi
80101724:	56                   	push   %esi
80101725:	53                   	push   %ebx
80101726:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101729:	8b 0d 60 2f 11 80    	mov    0x80112f60,%ecx
{
8010172f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101732:	85 c9                	test   %ecx,%ecx
80101734:	0f 84 87 00 00 00    	je     801017c1 <balloc+0xa1>
8010173a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101741:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101744:	83 ec 08             	sub    $0x8,%esp
80101747:	89 f0                	mov    %esi,%eax
80101749:	c1 f8 0c             	sar    $0xc,%eax
8010174c:	03 05 78 2f 11 80    	add    0x80112f78,%eax
80101752:	50                   	push   %eax
80101753:	ff 75 d8             	pushl  -0x28(%ebp)
80101756:	e8 75 e9 ff ff       	call   801000d0 <bread>
8010175b:	83 c4 10             	add    $0x10,%esp
8010175e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101761:	a1 60 2f 11 80       	mov    0x80112f60,%eax
80101766:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101769:	31 c0                	xor    %eax,%eax
8010176b:	eb 2f                	jmp    8010179c <balloc+0x7c>
8010176d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101770:	89 c1                	mov    %eax,%ecx
80101772:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101777:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010177a:	83 e1 07             	and    $0x7,%ecx
8010177d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010177f:	89 c1                	mov    %eax,%ecx
80101781:	c1 f9 03             	sar    $0x3,%ecx
80101784:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101789:	89 fa                	mov    %edi,%edx
8010178b:	85 df                	test   %ebx,%edi
8010178d:	74 41                	je     801017d0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010178f:	83 c0 01             	add    $0x1,%eax
80101792:	83 c6 01             	add    $0x1,%esi
80101795:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010179a:	74 05                	je     801017a1 <balloc+0x81>
8010179c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010179f:	77 cf                	ja     80101770 <balloc+0x50>
    brelse(bp);
801017a1:	83 ec 0c             	sub    $0xc,%esp
801017a4:	ff 75 e4             	pushl  -0x1c(%ebp)
801017a7:	e8 44 ea ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801017ac:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801017b3:	83 c4 10             	add    $0x10,%esp
801017b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801017b9:	39 05 60 2f 11 80    	cmp    %eax,0x80112f60
801017bf:	77 80                	ja     80101741 <balloc+0x21>
  panic("balloc: out of blocks");
801017c1:	83 ec 0c             	sub    $0xc,%esp
801017c4:	68 ca 88 10 80       	push   $0x801088ca
801017c9:	e8 c2 eb ff ff       	call   80100390 <panic>
801017ce:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801017d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801017d3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801017d6:	09 da                	or     %ebx,%edx
801017d8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801017dc:	57                   	push   %edi
801017dd:	e8 1e 1c 00 00       	call   80103400 <log_write>
        brelse(bp);
801017e2:	89 3c 24             	mov    %edi,(%esp)
801017e5:	e8 06 ea ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801017ea:	58                   	pop    %eax
801017eb:	5a                   	pop    %edx
801017ec:	56                   	push   %esi
801017ed:	ff 75 d8             	pushl  -0x28(%ebp)
801017f0:	e8 db e8 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801017f5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801017f8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801017fa:	8d 40 5c             	lea    0x5c(%eax),%eax
801017fd:	68 00 02 00 00       	push   $0x200
80101802:	6a 00                	push   $0x0
80101804:	50                   	push   %eax
80101805:	e8 36 41 00 00       	call   80105940 <memset>
  log_write(bp);
8010180a:	89 1c 24             	mov    %ebx,(%esp)
8010180d:	e8 ee 1b 00 00       	call   80103400 <log_write>
  brelse(bp);
80101812:	89 1c 24             	mov    %ebx,(%esp)
80101815:	e8 d6 e9 ff ff       	call   801001f0 <brelse>
}
8010181a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010181d:	89 f0                	mov    %esi,%eax
8010181f:	5b                   	pop    %ebx
80101820:	5e                   	pop    %esi
80101821:	5f                   	pop    %edi
80101822:	5d                   	pop    %ebp
80101823:	c3                   	ret    
80101824:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010182b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010182f:	90                   	nop

80101830 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	57                   	push   %edi
80101834:	89 c7                	mov    %eax,%edi
80101836:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101837:	31 f6                	xor    %esi,%esi
{
80101839:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010183a:	bb b4 2f 11 80       	mov    $0x80112fb4,%ebx
{
8010183f:	83 ec 28             	sub    $0x28,%esp
80101842:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101845:	68 80 2f 11 80       	push   $0x80112f80
8010184a:	e8 e1 3f 00 00       	call   80105830 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010184f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101852:	83 c4 10             	add    $0x10,%esp
80101855:	eb 1b                	jmp    80101872 <iget+0x42>
80101857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101860:	39 3b                	cmp    %edi,(%ebx)
80101862:	74 6c                	je     801018d0 <iget+0xa0>
80101864:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010186a:	81 fb d4 4b 11 80    	cmp    $0x80114bd4,%ebx
80101870:	73 26                	jae    80101898 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101872:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101875:	85 c9                	test   %ecx,%ecx
80101877:	7f e7                	jg     80101860 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101879:	85 f6                	test   %esi,%esi
8010187b:	75 e7                	jne    80101864 <iget+0x34>
8010187d:	89 d8                	mov    %ebx,%eax
8010187f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101885:	85 c9                	test   %ecx,%ecx
80101887:	75 6e                	jne    801018f7 <iget+0xc7>
80101889:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010188b:	81 fb d4 4b 11 80    	cmp    $0x80114bd4,%ebx
80101891:	72 df                	jb     80101872 <iget+0x42>
80101893:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101897:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101898:	85 f6                	test   %esi,%esi
8010189a:	74 73                	je     8010190f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010189c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010189f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801018a1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801018a4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801018ab:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801018b2:	68 80 2f 11 80       	push   $0x80112f80
801018b7:	e8 34 40 00 00       	call   801058f0 <release>

  return ip;
801018bc:	83 c4 10             	add    $0x10,%esp
}
801018bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018c2:	89 f0                	mov    %esi,%eax
801018c4:	5b                   	pop    %ebx
801018c5:	5e                   	pop    %esi
801018c6:	5f                   	pop    %edi
801018c7:	5d                   	pop    %ebp
801018c8:	c3                   	ret    
801018c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018d0:	39 53 04             	cmp    %edx,0x4(%ebx)
801018d3:	75 8f                	jne    80101864 <iget+0x34>
      release(&icache.lock);
801018d5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801018d8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801018db:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801018dd:	68 80 2f 11 80       	push   $0x80112f80
      ip->ref++;
801018e2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801018e5:	e8 06 40 00 00       	call   801058f0 <release>
      return ip;
801018ea:	83 c4 10             	add    $0x10,%esp
}
801018ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018f0:	89 f0                	mov    %esi,%eax
801018f2:	5b                   	pop    %ebx
801018f3:	5e                   	pop    %esi
801018f4:	5f                   	pop    %edi
801018f5:	5d                   	pop    %ebp
801018f6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018f7:	81 fb d4 4b 11 80    	cmp    $0x80114bd4,%ebx
801018fd:	73 10                	jae    8010190f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018ff:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101902:	85 c9                	test   %ecx,%ecx
80101904:	0f 8f 56 ff ff ff    	jg     80101860 <iget+0x30>
8010190a:	e9 6e ff ff ff       	jmp    8010187d <iget+0x4d>
    panic("iget: no inodes");
8010190f:	83 ec 0c             	sub    $0xc,%esp
80101912:	68 e0 88 10 80       	push   $0x801088e0
80101917:	e8 74 ea ff ff       	call   80100390 <panic>
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	57                   	push   %edi
80101924:	56                   	push   %esi
80101925:	89 c6                	mov    %eax,%esi
80101927:	53                   	push   %ebx
80101928:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010192b:	83 fa 0b             	cmp    $0xb,%edx
8010192e:	0f 86 84 00 00 00    	jbe    801019b8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101934:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101937:	83 fb 7f             	cmp    $0x7f,%ebx
8010193a:	0f 87 98 00 00 00    	ja     801019d8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101940:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101946:	8b 16                	mov    (%esi),%edx
80101948:	85 c0                	test   %eax,%eax
8010194a:	74 54                	je     801019a0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010194c:	83 ec 08             	sub    $0x8,%esp
8010194f:	50                   	push   %eax
80101950:	52                   	push   %edx
80101951:	e8 7a e7 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101956:	83 c4 10             	add    $0x10,%esp
80101959:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010195d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010195f:	8b 1a                	mov    (%edx),%ebx
80101961:	85 db                	test   %ebx,%ebx
80101963:	74 1b                	je     80101980 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101965:	83 ec 0c             	sub    $0xc,%esp
80101968:	57                   	push   %edi
80101969:	e8 82 e8 ff ff       	call   801001f0 <brelse>
    return addr;
8010196e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101971:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101974:	89 d8                	mov    %ebx,%eax
80101976:	5b                   	pop    %ebx
80101977:	5e                   	pop    %esi
80101978:	5f                   	pop    %edi
80101979:	5d                   	pop    %ebp
8010197a:	c3                   	ret    
8010197b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010197f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101980:	8b 06                	mov    (%esi),%eax
80101982:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101985:	e8 96 fd ff ff       	call   80101720 <balloc>
8010198a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010198d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101990:	89 c3                	mov    %eax,%ebx
80101992:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101994:	57                   	push   %edi
80101995:	e8 66 1a 00 00       	call   80103400 <log_write>
8010199a:	83 c4 10             	add    $0x10,%esp
8010199d:	eb c6                	jmp    80101965 <bmap+0x45>
8010199f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801019a0:	89 d0                	mov    %edx,%eax
801019a2:	e8 79 fd ff ff       	call   80101720 <balloc>
801019a7:	8b 16                	mov    (%esi),%edx
801019a9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801019af:	eb 9b                	jmp    8010194c <bmap+0x2c>
801019b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801019b8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801019bb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801019be:	85 db                	test   %ebx,%ebx
801019c0:	75 af                	jne    80101971 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801019c2:	8b 00                	mov    (%eax),%eax
801019c4:	e8 57 fd ff ff       	call   80101720 <balloc>
801019c9:	89 47 5c             	mov    %eax,0x5c(%edi)
801019cc:	89 c3                	mov    %eax,%ebx
}
801019ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019d1:	89 d8                	mov    %ebx,%eax
801019d3:	5b                   	pop    %ebx
801019d4:	5e                   	pop    %esi
801019d5:	5f                   	pop    %edi
801019d6:	5d                   	pop    %ebp
801019d7:	c3                   	ret    
  panic("bmap: out of range");
801019d8:	83 ec 0c             	sub    $0xc,%esp
801019db:	68 f0 88 10 80       	push   $0x801088f0
801019e0:	e8 ab e9 ff ff       	call   80100390 <panic>
801019e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019f0 <readsb>:
{
801019f0:	f3 0f 1e fb          	endbr32 
801019f4:	55                   	push   %ebp
801019f5:	89 e5                	mov    %esp,%ebp
801019f7:	56                   	push   %esi
801019f8:	53                   	push   %ebx
801019f9:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801019fc:	83 ec 08             	sub    $0x8,%esp
801019ff:	6a 01                	push   $0x1
80101a01:	ff 75 08             	pushl  0x8(%ebp)
80101a04:	e8 c7 e6 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101a09:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101a0c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101a0e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101a11:	6a 1c                	push   $0x1c
80101a13:	50                   	push   %eax
80101a14:	56                   	push   %esi
80101a15:	e8 c6 3f 00 00       	call   801059e0 <memmove>
  brelse(bp);
80101a1a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a1d:	83 c4 10             	add    $0x10,%esp
}
80101a20:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a23:	5b                   	pop    %ebx
80101a24:	5e                   	pop    %esi
80101a25:	5d                   	pop    %ebp
  brelse(bp);
80101a26:	e9 c5 e7 ff ff       	jmp    801001f0 <brelse>
80101a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a2f:	90                   	nop

80101a30 <iinit>:
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	53                   	push   %ebx
80101a38:	bb c0 2f 11 80       	mov    $0x80112fc0,%ebx
80101a3d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101a40:	68 03 89 10 80       	push   $0x80108903
80101a45:	68 80 2f 11 80       	push   $0x80112f80
80101a4a:	e8 61 3c 00 00       	call   801056b0 <initlock>
  for(i = 0; i < NINODE; i++) {
80101a4f:	83 c4 10             	add    $0x10,%esp
80101a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101a58:	83 ec 08             	sub    $0x8,%esp
80101a5b:	68 0a 89 10 80       	push   $0x8010890a
80101a60:	53                   	push   %ebx
80101a61:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101a67:	e8 04 3b 00 00       	call   80105570 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101a6c:	83 c4 10             	add    $0x10,%esp
80101a6f:	81 fb e0 4b 11 80    	cmp    $0x80114be0,%ebx
80101a75:	75 e1                	jne    80101a58 <iinit+0x28>
  readsb(dev, &sb);
80101a77:	83 ec 08             	sub    $0x8,%esp
80101a7a:	68 60 2f 11 80       	push   $0x80112f60
80101a7f:	ff 75 08             	pushl  0x8(%ebp)
80101a82:	e8 69 ff ff ff       	call   801019f0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101a87:	ff 35 78 2f 11 80    	pushl  0x80112f78
80101a8d:	ff 35 74 2f 11 80    	pushl  0x80112f74
80101a93:	ff 35 70 2f 11 80    	pushl  0x80112f70
80101a99:	ff 35 6c 2f 11 80    	pushl  0x80112f6c
80101a9f:	ff 35 68 2f 11 80    	pushl  0x80112f68
80101aa5:	ff 35 64 2f 11 80    	pushl  0x80112f64
80101aab:	ff 35 60 2f 11 80    	pushl  0x80112f60
80101ab1:	68 70 89 10 80       	push   $0x80108970
80101ab6:	e8 05 ee ff ff       	call   801008c0 <cprintf>
}
80101abb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101abe:	83 c4 30             	add    $0x30,%esp
80101ac1:	c9                   	leave  
80101ac2:	c3                   	ret    
80101ac3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ad0 <ialloc>:
{
80101ad0:	f3 0f 1e fb          	endbr32 
80101ad4:	55                   	push   %ebp
80101ad5:	89 e5                	mov    %esp,%ebp
80101ad7:	57                   	push   %edi
80101ad8:	56                   	push   %esi
80101ad9:	53                   	push   %ebx
80101ada:	83 ec 1c             	sub    $0x1c,%esp
80101add:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101ae0:	83 3d 68 2f 11 80 01 	cmpl   $0x1,0x80112f68
{
80101ae7:	8b 75 08             	mov    0x8(%ebp),%esi
80101aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101aed:	0f 86 8d 00 00 00    	jbe    80101b80 <ialloc+0xb0>
80101af3:	bf 01 00 00 00       	mov    $0x1,%edi
80101af8:	eb 1d                	jmp    80101b17 <ialloc+0x47>
80101afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101b00:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101b03:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101b06:	53                   	push   %ebx
80101b07:	e8 e4 e6 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101b0c:	83 c4 10             	add    $0x10,%esp
80101b0f:	3b 3d 68 2f 11 80    	cmp    0x80112f68,%edi
80101b15:	73 69                	jae    80101b80 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101b17:	89 f8                	mov    %edi,%eax
80101b19:	83 ec 08             	sub    $0x8,%esp
80101b1c:	c1 e8 03             	shr    $0x3,%eax
80101b1f:	03 05 74 2f 11 80    	add    0x80112f74,%eax
80101b25:	50                   	push   %eax
80101b26:	56                   	push   %esi
80101b27:	e8 a4 e5 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101b2c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101b2f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101b31:	89 f8                	mov    %edi,%eax
80101b33:	83 e0 07             	and    $0x7,%eax
80101b36:	c1 e0 06             	shl    $0x6,%eax
80101b39:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101b3d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101b41:	75 bd                	jne    80101b00 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101b43:	83 ec 04             	sub    $0x4,%esp
80101b46:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101b49:	6a 40                	push   $0x40
80101b4b:	6a 00                	push   $0x0
80101b4d:	51                   	push   %ecx
80101b4e:	e8 ed 3d 00 00       	call   80105940 <memset>
      dip->type = type;
80101b53:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101b57:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b5a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101b5d:	89 1c 24             	mov    %ebx,(%esp)
80101b60:	e8 9b 18 00 00       	call   80103400 <log_write>
      brelse(bp);
80101b65:	89 1c 24             	mov    %ebx,(%esp)
80101b68:	e8 83 e6 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101b6d:	83 c4 10             	add    $0x10,%esp
}
80101b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101b73:	89 fa                	mov    %edi,%edx
}
80101b75:	5b                   	pop    %ebx
      return iget(dev, inum);
80101b76:	89 f0                	mov    %esi,%eax
}
80101b78:	5e                   	pop    %esi
80101b79:	5f                   	pop    %edi
80101b7a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101b7b:	e9 b0 fc ff ff       	jmp    80101830 <iget>
  panic("ialloc: no inodes");
80101b80:	83 ec 0c             	sub    $0xc,%esp
80101b83:	68 10 89 10 80       	push   $0x80108910
80101b88:	e8 03 e8 ff ff       	call   80100390 <panic>
80101b8d:	8d 76 00             	lea    0x0(%esi),%esi

80101b90 <iupdate>:
{
80101b90:	f3 0f 1e fb          	endbr32 
80101b94:	55                   	push   %ebp
80101b95:	89 e5                	mov    %esp,%ebp
80101b97:	56                   	push   %esi
80101b98:	53                   	push   %ebx
80101b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b9c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101b9f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101ba2:	83 ec 08             	sub    $0x8,%esp
80101ba5:	c1 e8 03             	shr    $0x3,%eax
80101ba8:	03 05 74 2f 11 80    	add    0x80112f74,%eax
80101bae:	50                   	push   %eax
80101baf:	ff 73 a4             	pushl  -0x5c(%ebx)
80101bb2:	e8 19 e5 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101bb7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bbb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101bbe:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101bc0:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101bc3:	83 e0 07             	and    $0x7,%eax
80101bc6:	c1 e0 06             	shl    $0x6,%eax
80101bc9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101bcd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101bd0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bd4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101bd7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101bdb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101bdf:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101be3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101be7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101beb:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101bee:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bf1:	6a 34                	push   $0x34
80101bf3:	53                   	push   %ebx
80101bf4:	50                   	push   %eax
80101bf5:	e8 e6 3d 00 00       	call   801059e0 <memmove>
  log_write(bp);
80101bfa:	89 34 24             	mov    %esi,(%esp)
80101bfd:	e8 fe 17 00 00       	call   80103400 <log_write>
  brelse(bp);
80101c02:	89 75 08             	mov    %esi,0x8(%ebp)
80101c05:	83 c4 10             	add    $0x10,%esp
}
80101c08:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c0b:	5b                   	pop    %ebx
80101c0c:	5e                   	pop    %esi
80101c0d:	5d                   	pop    %ebp
  brelse(bp);
80101c0e:	e9 dd e5 ff ff       	jmp    801001f0 <brelse>
80101c13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c20 <idup>:
{
80101c20:	f3 0f 1e fb          	endbr32 
80101c24:	55                   	push   %ebp
80101c25:	89 e5                	mov    %esp,%ebp
80101c27:	53                   	push   %ebx
80101c28:	83 ec 10             	sub    $0x10,%esp
80101c2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101c2e:	68 80 2f 11 80       	push   $0x80112f80
80101c33:	e8 f8 3b 00 00       	call   80105830 <acquire>
  ip->ref++;
80101c38:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c3c:	c7 04 24 80 2f 11 80 	movl   $0x80112f80,(%esp)
80101c43:	e8 a8 3c 00 00       	call   801058f0 <release>
}
80101c48:	89 d8                	mov    %ebx,%eax
80101c4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c4d:	c9                   	leave  
80101c4e:	c3                   	ret    
80101c4f:	90                   	nop

80101c50 <ilock>:
{
80101c50:	f3 0f 1e fb          	endbr32 
80101c54:	55                   	push   %ebp
80101c55:	89 e5                	mov    %esp,%ebp
80101c57:	56                   	push   %esi
80101c58:	53                   	push   %ebx
80101c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101c5c:	85 db                	test   %ebx,%ebx
80101c5e:	0f 84 b3 00 00 00    	je     80101d17 <ilock+0xc7>
80101c64:	8b 53 08             	mov    0x8(%ebx),%edx
80101c67:	85 d2                	test   %edx,%edx
80101c69:	0f 8e a8 00 00 00    	jle    80101d17 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101c6f:	83 ec 0c             	sub    $0xc,%esp
80101c72:	8d 43 0c             	lea    0xc(%ebx),%eax
80101c75:	50                   	push   %eax
80101c76:	e8 35 39 00 00       	call   801055b0 <acquiresleep>
  if(ip->valid == 0){
80101c7b:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101c7e:	83 c4 10             	add    $0x10,%esp
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 0b                	je     80101c90 <ilock+0x40>
}
80101c85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c88:	5b                   	pop    %ebx
80101c89:	5e                   	pop    %esi
80101c8a:	5d                   	pop    %ebp
80101c8b:	c3                   	ret    
80101c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c90:	8b 43 04             	mov    0x4(%ebx),%eax
80101c93:	83 ec 08             	sub    $0x8,%esp
80101c96:	c1 e8 03             	shr    $0x3,%eax
80101c99:	03 05 74 2f 11 80    	add    0x80112f74,%eax
80101c9f:	50                   	push   %eax
80101ca0:	ff 33                	pushl  (%ebx)
80101ca2:	e8 29 e4 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ca7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101caa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101cac:	8b 43 04             	mov    0x4(%ebx),%eax
80101caf:	83 e0 07             	and    $0x7,%eax
80101cb2:	c1 e0 06             	shl    $0x6,%eax
80101cb5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101cb9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101cbc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101cbf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101cc3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101cc7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101ccb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101ccf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101cd3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101cd7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101cdb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101cde:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ce1:	6a 34                	push   $0x34
80101ce3:	50                   	push   %eax
80101ce4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101ce7:	50                   	push   %eax
80101ce8:	e8 f3 3c 00 00       	call   801059e0 <memmove>
    brelse(bp);
80101ced:	89 34 24             	mov    %esi,(%esp)
80101cf0:	e8 fb e4 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101cf5:	83 c4 10             	add    $0x10,%esp
80101cf8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101cfd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101d04:	0f 85 7b ff ff ff    	jne    80101c85 <ilock+0x35>
      panic("ilock: no type");
80101d0a:	83 ec 0c             	sub    $0xc,%esp
80101d0d:	68 28 89 10 80       	push   $0x80108928
80101d12:	e8 79 e6 ff ff       	call   80100390 <panic>
    panic("ilock");
80101d17:	83 ec 0c             	sub    $0xc,%esp
80101d1a:	68 22 89 10 80       	push   $0x80108922
80101d1f:	e8 6c e6 ff ff       	call   80100390 <panic>
80101d24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d2f:	90                   	nop

80101d30 <iunlock>:
{
80101d30:	f3 0f 1e fb          	endbr32 
80101d34:	55                   	push   %ebp
80101d35:	89 e5                	mov    %esp,%ebp
80101d37:	56                   	push   %esi
80101d38:	53                   	push   %ebx
80101d39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d3c:	85 db                	test   %ebx,%ebx
80101d3e:	74 28                	je     80101d68 <iunlock+0x38>
80101d40:	83 ec 0c             	sub    $0xc,%esp
80101d43:	8d 73 0c             	lea    0xc(%ebx),%esi
80101d46:	56                   	push   %esi
80101d47:	e8 04 39 00 00       	call   80105650 <holdingsleep>
80101d4c:	83 c4 10             	add    $0x10,%esp
80101d4f:	85 c0                	test   %eax,%eax
80101d51:	74 15                	je     80101d68 <iunlock+0x38>
80101d53:	8b 43 08             	mov    0x8(%ebx),%eax
80101d56:	85 c0                	test   %eax,%eax
80101d58:	7e 0e                	jle    80101d68 <iunlock+0x38>
  releasesleep(&ip->lock);
80101d5a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101d5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d60:	5b                   	pop    %ebx
80101d61:	5e                   	pop    %esi
80101d62:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101d63:	e9 a8 38 00 00       	jmp    80105610 <releasesleep>
    panic("iunlock");
80101d68:	83 ec 0c             	sub    $0xc,%esp
80101d6b:	68 37 89 10 80       	push   $0x80108937
80101d70:	e8 1b e6 ff ff       	call   80100390 <panic>
80101d75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d80 <iput>:
{
80101d80:	f3 0f 1e fb          	endbr32 
80101d84:	55                   	push   %ebp
80101d85:	89 e5                	mov    %esp,%ebp
80101d87:	57                   	push   %edi
80101d88:	56                   	push   %esi
80101d89:	53                   	push   %ebx
80101d8a:	83 ec 28             	sub    $0x28,%esp
80101d8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101d90:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101d93:	57                   	push   %edi
80101d94:	e8 17 38 00 00       	call   801055b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101d99:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101d9c:	83 c4 10             	add    $0x10,%esp
80101d9f:	85 d2                	test   %edx,%edx
80101da1:	74 07                	je     80101daa <iput+0x2a>
80101da3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101da8:	74 36                	je     80101de0 <iput+0x60>
  releasesleep(&ip->lock);
80101daa:	83 ec 0c             	sub    $0xc,%esp
80101dad:	57                   	push   %edi
80101dae:	e8 5d 38 00 00       	call   80105610 <releasesleep>
  acquire(&icache.lock);
80101db3:	c7 04 24 80 2f 11 80 	movl   $0x80112f80,(%esp)
80101dba:	e8 71 3a 00 00       	call   80105830 <acquire>
  ip->ref--;
80101dbf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101dc3:	83 c4 10             	add    $0x10,%esp
80101dc6:	c7 45 08 80 2f 11 80 	movl   $0x80112f80,0x8(%ebp)
}
80101dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd0:	5b                   	pop    %ebx
80101dd1:	5e                   	pop    %esi
80101dd2:	5f                   	pop    %edi
80101dd3:	5d                   	pop    %ebp
  release(&icache.lock);
80101dd4:	e9 17 3b 00 00       	jmp    801058f0 <release>
80101dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101de0:	83 ec 0c             	sub    $0xc,%esp
80101de3:	68 80 2f 11 80       	push   $0x80112f80
80101de8:	e8 43 3a 00 00       	call   80105830 <acquire>
    int r = ip->ref;
80101ded:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101df0:	c7 04 24 80 2f 11 80 	movl   $0x80112f80,(%esp)
80101df7:	e8 f4 3a 00 00       	call   801058f0 <release>
    if(r == 1){
80101dfc:	83 c4 10             	add    $0x10,%esp
80101dff:	83 fe 01             	cmp    $0x1,%esi
80101e02:	75 a6                	jne    80101daa <iput+0x2a>
80101e04:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101e0a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101e0d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101e10:	89 cf                	mov    %ecx,%edi
80101e12:	eb 0b                	jmp    80101e1f <iput+0x9f>
80101e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e18:	83 c6 04             	add    $0x4,%esi
80101e1b:	39 fe                	cmp    %edi,%esi
80101e1d:	74 19                	je     80101e38 <iput+0xb8>
    if(ip->addrs[i]){
80101e1f:	8b 16                	mov    (%esi),%edx
80101e21:	85 d2                	test   %edx,%edx
80101e23:	74 f3                	je     80101e18 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101e25:	8b 03                	mov    (%ebx),%eax
80101e27:	e8 74 f8 ff ff       	call   801016a0 <bfree>
      ip->addrs[i] = 0;
80101e2c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101e32:	eb e4                	jmp    80101e18 <iput+0x98>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101e38:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101e3e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101e41:	85 c0                	test   %eax,%eax
80101e43:	75 33                	jne    80101e78 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101e45:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101e48:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101e4f:	53                   	push   %ebx
80101e50:	e8 3b fd ff ff       	call   80101b90 <iupdate>
      ip->type = 0;
80101e55:	31 c0                	xor    %eax,%eax
80101e57:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101e5b:	89 1c 24             	mov    %ebx,(%esp)
80101e5e:	e8 2d fd ff ff       	call   80101b90 <iupdate>
      ip->valid = 0;
80101e63:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101e6a:	83 c4 10             	add    $0x10,%esp
80101e6d:	e9 38 ff ff ff       	jmp    80101daa <iput+0x2a>
80101e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e78:	83 ec 08             	sub    $0x8,%esp
80101e7b:	50                   	push   %eax
80101e7c:	ff 33                	pushl  (%ebx)
80101e7e:	e8 4d e2 ff ff       	call   801000d0 <bread>
80101e83:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101e86:	83 c4 10             	add    $0x10,%esp
80101e89:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101e8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e92:	8d 70 5c             	lea    0x5c(%eax),%esi
80101e95:	89 cf                	mov    %ecx,%edi
80101e97:	eb 0e                	jmp    80101ea7 <iput+0x127>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea0:	83 c6 04             	add    $0x4,%esi
80101ea3:	39 f7                	cmp    %esi,%edi
80101ea5:	74 19                	je     80101ec0 <iput+0x140>
      if(a[j])
80101ea7:	8b 16                	mov    (%esi),%edx
80101ea9:	85 d2                	test   %edx,%edx
80101eab:	74 f3                	je     80101ea0 <iput+0x120>
        bfree(ip->dev, a[j]);
80101ead:	8b 03                	mov    (%ebx),%eax
80101eaf:	e8 ec f7 ff ff       	call   801016a0 <bfree>
80101eb4:	eb ea                	jmp    80101ea0 <iput+0x120>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101ec0:	83 ec 0c             	sub    $0xc,%esp
80101ec3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ec6:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ec9:	e8 22 e3 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ece:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101ed4:	8b 03                	mov    (%ebx),%eax
80101ed6:	e8 c5 f7 ff ff       	call   801016a0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101edb:	83 c4 10             	add    $0x10,%esp
80101ede:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101ee5:	00 00 00 
80101ee8:	e9 58 ff ff ff       	jmp    80101e45 <iput+0xc5>
80101eed:	8d 76 00             	lea    0x0(%esi),%esi

80101ef0 <iunlockput>:
{
80101ef0:	f3 0f 1e fb          	endbr32 
80101ef4:	55                   	push   %ebp
80101ef5:	89 e5                	mov    %esp,%ebp
80101ef7:	53                   	push   %ebx
80101ef8:	83 ec 10             	sub    $0x10,%esp
80101efb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101efe:	53                   	push   %ebx
80101eff:	e8 2c fe ff ff       	call   80101d30 <iunlock>
  iput(ip);
80101f04:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101f07:	83 c4 10             	add    $0x10,%esp
}
80101f0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f0d:	c9                   	leave  
  iput(ip);
80101f0e:	e9 6d fe ff ff       	jmp    80101d80 <iput>
80101f13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f20 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f20:	f3 0f 1e fb          	endbr32 
80101f24:	55                   	push   %ebp
80101f25:	89 e5                	mov    %esp,%ebp
80101f27:	8b 55 08             	mov    0x8(%ebp),%edx
80101f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101f2d:	8b 0a                	mov    (%edx),%ecx
80101f2f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101f32:	8b 4a 04             	mov    0x4(%edx),%ecx
80101f35:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101f38:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101f3c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101f3f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101f43:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101f47:	8b 52 58             	mov    0x58(%edx),%edx
80101f4a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f4d:	5d                   	pop    %ebp
80101f4e:	c3                   	ret    
80101f4f:	90                   	nop

80101f50 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f50:	f3 0f 1e fb          	endbr32 
80101f54:	55                   	push   %ebp
80101f55:	89 e5                	mov    %esp,%ebp
80101f57:	57                   	push   %edi
80101f58:	56                   	push   %esi
80101f59:	53                   	push   %ebx
80101f5a:	83 ec 1c             	sub    $0x1c,%esp
80101f5d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101f60:	8b 45 08             	mov    0x8(%ebp),%eax
80101f63:	8b 75 10             	mov    0x10(%ebp),%esi
80101f66:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101f69:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f6c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101f71:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101f74:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101f77:	0f 84 a3 00 00 00    	je     80102020 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101f7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f80:	8b 40 58             	mov    0x58(%eax),%eax
80101f83:	39 c6                	cmp    %eax,%esi
80101f85:	0f 87 b6 00 00 00    	ja     80102041 <readi+0xf1>
80101f8b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101f8e:	31 c9                	xor    %ecx,%ecx
80101f90:	89 da                	mov    %ebx,%edx
80101f92:	01 f2                	add    %esi,%edx
80101f94:	0f 92 c1             	setb   %cl
80101f97:	89 cf                	mov    %ecx,%edi
80101f99:	0f 82 a2 00 00 00    	jb     80102041 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101f9f:	89 c1                	mov    %eax,%ecx
80101fa1:	29 f1                	sub    %esi,%ecx
80101fa3:	39 d0                	cmp    %edx,%eax
80101fa5:	0f 43 cb             	cmovae %ebx,%ecx
80101fa8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fab:	85 c9                	test   %ecx,%ecx
80101fad:	74 63                	je     80102012 <readi+0xc2>
80101faf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fb0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101fb3:	89 f2                	mov    %esi,%edx
80101fb5:	c1 ea 09             	shr    $0x9,%edx
80101fb8:	89 d8                	mov    %ebx,%eax
80101fba:	e8 61 f9 ff ff       	call   80101920 <bmap>
80101fbf:	83 ec 08             	sub    $0x8,%esp
80101fc2:	50                   	push   %eax
80101fc3:	ff 33                	pushl  (%ebx)
80101fc5:	e8 06 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101fca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101fcd:	b9 00 02 00 00       	mov    $0x200,%ecx
80101fd2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fd5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101fd7:	89 f0                	mov    %esi,%eax
80101fd9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fde:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101fe0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fe3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101fe5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101fe9:	39 d9                	cmp    %ebx,%ecx
80101feb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101fee:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fef:	01 df                	add    %ebx,%edi
80101ff1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ff3:	50                   	push   %eax
80101ff4:	ff 75 e0             	pushl  -0x20(%ebp)
80101ff7:	e8 e4 39 00 00       	call   801059e0 <memmove>
    brelse(bp);
80101ffc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101fff:	89 14 24             	mov    %edx,(%esp)
80102002:	e8 e9 e1 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102007:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010200a:	83 c4 10             	add    $0x10,%esp
8010200d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102010:	77 9e                	ja     80101fb0 <readi+0x60>
  }
  return n;
80102012:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102015:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102018:	5b                   	pop    %ebx
80102019:	5e                   	pop    %esi
8010201a:	5f                   	pop    %edi
8010201b:	5d                   	pop    %ebp
8010201c:	c3                   	ret    
8010201d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102020:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102024:	66 83 f8 09          	cmp    $0x9,%ax
80102028:	77 17                	ja     80102041 <readi+0xf1>
8010202a:	8b 04 c5 00 2f 11 80 	mov    -0x7feed100(,%eax,8),%eax
80102031:	85 c0                	test   %eax,%eax
80102033:	74 0c                	je     80102041 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102035:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102038:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010203b:	5b                   	pop    %ebx
8010203c:	5e                   	pop    %esi
8010203d:	5f                   	pop    %edi
8010203e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010203f:	ff e0                	jmp    *%eax
      return -1;
80102041:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102046:	eb cd                	jmp    80102015 <readi+0xc5>
80102048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010204f:	90                   	nop

80102050 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
80102055:	89 e5                	mov    %esp,%ebp
80102057:	57                   	push   %edi
80102058:	56                   	push   %esi
80102059:	53                   	push   %ebx
8010205a:	83 ec 1c             	sub    $0x1c,%esp
8010205d:	8b 45 08             	mov    0x8(%ebp),%eax
80102060:	8b 75 0c             	mov    0xc(%ebp),%esi
80102063:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102066:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
8010206b:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010206e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102071:	8b 75 10             	mov    0x10(%ebp),%esi
80102074:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80102077:	0f 84 b3 00 00 00    	je     80102130 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
8010207d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102080:	39 70 58             	cmp    %esi,0x58(%eax)
80102083:	0f 82 e3 00 00 00    	jb     8010216c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102089:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010208c:	89 f8                	mov    %edi,%eax
8010208e:	01 f0                	add    %esi,%eax
80102090:	0f 82 d6 00 00 00    	jb     8010216c <writei+0x11c>
80102096:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010209b:	0f 87 cb 00 00 00    	ja     8010216c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801020a8:	85 ff                	test   %edi,%edi
801020aa:	74 75                	je     80102121 <writei+0xd1>
801020ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020b0:	8b 7d d8             	mov    -0x28(%ebp),%edi
801020b3:	89 f2                	mov    %esi,%edx
801020b5:	c1 ea 09             	shr    $0x9,%edx
801020b8:	89 f8                	mov    %edi,%eax
801020ba:	e8 61 f8 ff ff       	call   80101920 <bmap>
801020bf:	83 ec 08             	sub    $0x8,%esp
801020c2:	50                   	push   %eax
801020c3:	ff 37                	pushl  (%edi)
801020c5:	e8 06 e0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801020ca:	b9 00 02 00 00       	mov    $0x200,%ecx
801020cf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801020d2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020d5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
801020d7:	89 f0                	mov    %esi,%eax
801020d9:	83 c4 0c             	add    $0xc,%esp
801020dc:	25 ff 01 00 00       	and    $0x1ff,%eax
801020e1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
801020e3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801020e7:	39 d9                	cmp    %ebx,%ecx
801020e9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
801020ec:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020ed:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
801020ef:	ff 75 dc             	pushl  -0x24(%ebp)
801020f2:	50                   	push   %eax
801020f3:	e8 e8 38 00 00       	call   801059e0 <memmove>
    log_write(bp);
801020f8:	89 3c 24             	mov    %edi,(%esp)
801020fb:	e8 00 13 00 00       	call   80103400 <log_write>
    brelse(bp);
80102100:	89 3c 24             	mov    %edi,(%esp)
80102103:	e8 e8 e0 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102108:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010210b:	83 c4 10             	add    $0x10,%esp
8010210e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102111:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102114:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102117:	77 97                	ja     801020b0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102119:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010211c:	3b 70 58             	cmp    0x58(%eax),%esi
8010211f:	77 37                	ja     80102158 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102121:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102124:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102127:	5b                   	pop    %ebx
80102128:	5e                   	pop    %esi
80102129:	5f                   	pop    %edi
8010212a:	5d                   	pop    %ebp
8010212b:	c3                   	ret    
8010212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102130:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102134:	66 83 f8 09          	cmp    $0x9,%ax
80102138:	77 32                	ja     8010216c <writei+0x11c>
8010213a:	8b 04 c5 04 2f 11 80 	mov    -0x7feed0fc(,%eax,8),%eax
80102141:	85 c0                	test   %eax,%eax
80102143:	74 27                	je     8010216c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102145:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102148:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010214b:	5b                   	pop    %ebx
8010214c:	5e                   	pop    %esi
8010214d:	5f                   	pop    %edi
8010214e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010214f:	ff e0                	jmp    *%eax
80102151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102158:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010215b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010215e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102161:	50                   	push   %eax
80102162:	e8 29 fa ff ff       	call   80101b90 <iupdate>
80102167:	83 c4 10             	add    $0x10,%esp
8010216a:	eb b5                	jmp    80102121 <writei+0xd1>
      return -1;
8010216c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102171:	eb b1                	jmp    80102124 <writei+0xd4>
80102173:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010217a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102180 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102180:	f3 0f 1e fb          	endbr32 
80102184:	55                   	push   %ebp
80102185:	89 e5                	mov    %esp,%ebp
80102187:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010218a:	6a 0e                	push   $0xe
8010218c:	ff 75 0c             	pushl  0xc(%ebp)
8010218f:	ff 75 08             	pushl  0x8(%ebp)
80102192:	e8 b9 38 00 00       	call   80105a50 <strncmp>
}
80102197:	c9                   	leave  
80102198:	c3                   	ret    
80102199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021a0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021a0:	f3 0f 1e fb          	endbr32 
801021a4:	55                   	push   %ebp
801021a5:	89 e5                	mov    %esp,%ebp
801021a7:	57                   	push   %edi
801021a8:	56                   	push   %esi
801021a9:	53                   	push   %ebx
801021aa:	83 ec 1c             	sub    $0x1c,%esp
801021ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801021b5:	0f 85 89 00 00 00    	jne    80102244 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021bb:	8b 53 58             	mov    0x58(%ebx),%edx
801021be:	31 ff                	xor    %edi,%edi
801021c0:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021c3:	85 d2                	test   %edx,%edx
801021c5:	74 42                	je     80102209 <dirlookup+0x69>
801021c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ce:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021d0:	6a 10                	push   $0x10
801021d2:	57                   	push   %edi
801021d3:	56                   	push   %esi
801021d4:	53                   	push   %ebx
801021d5:	e8 76 fd ff ff       	call   80101f50 <readi>
801021da:	83 c4 10             	add    $0x10,%esp
801021dd:	83 f8 10             	cmp    $0x10,%eax
801021e0:	75 55                	jne    80102237 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
801021e2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801021e7:	74 18                	je     80102201 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
801021e9:	83 ec 04             	sub    $0x4,%esp
801021ec:	8d 45 da             	lea    -0x26(%ebp),%eax
801021ef:	6a 0e                	push   $0xe
801021f1:	50                   	push   %eax
801021f2:	ff 75 0c             	pushl  0xc(%ebp)
801021f5:	e8 56 38 00 00       	call   80105a50 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801021fa:	83 c4 10             	add    $0x10,%esp
801021fd:	85 c0                	test   %eax,%eax
801021ff:	74 17                	je     80102218 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102201:	83 c7 10             	add    $0x10,%edi
80102204:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102207:	72 c7                	jb     801021d0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102209:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010220c:	31 c0                	xor    %eax,%eax
}
8010220e:	5b                   	pop    %ebx
8010220f:	5e                   	pop    %esi
80102210:	5f                   	pop    %edi
80102211:	5d                   	pop    %ebp
80102212:	c3                   	ret    
80102213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102217:	90                   	nop
      if(poff)
80102218:	8b 45 10             	mov    0x10(%ebp),%eax
8010221b:	85 c0                	test   %eax,%eax
8010221d:	74 05                	je     80102224 <dirlookup+0x84>
        *poff = off;
8010221f:	8b 45 10             	mov    0x10(%ebp),%eax
80102222:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80102224:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102228:	8b 03                	mov    (%ebx),%eax
8010222a:	e8 01 f6 ff ff       	call   80101830 <iget>
}
8010222f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102232:	5b                   	pop    %ebx
80102233:	5e                   	pop    %esi
80102234:	5f                   	pop    %edi
80102235:	5d                   	pop    %ebp
80102236:	c3                   	ret    
      panic("dirlookup read");
80102237:	83 ec 0c             	sub    $0xc,%esp
8010223a:	68 51 89 10 80       	push   $0x80108951
8010223f:	e8 4c e1 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80102244:	83 ec 0c             	sub    $0xc,%esp
80102247:	68 3f 89 10 80       	push   $0x8010893f
8010224c:	e8 3f e1 ff ff       	call   80100390 <panic>
80102251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010225f:	90                   	nop

80102260 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	57                   	push   %edi
80102264:	56                   	push   %esi
80102265:	53                   	push   %ebx
80102266:	89 c3                	mov    %eax,%ebx
80102268:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010226b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010226e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102271:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102274:	0f 84 86 01 00 00    	je     80102400 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010227a:	e8 31 1c 00 00       	call   80103eb0 <myproc>
  acquire(&icache.lock);
8010227f:	83 ec 0c             	sub    $0xc,%esp
80102282:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102284:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102287:	68 80 2f 11 80       	push   $0x80112f80
8010228c:	e8 9f 35 00 00       	call   80105830 <acquire>
  ip->ref++;
80102291:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102295:	c7 04 24 80 2f 11 80 	movl   $0x80112f80,(%esp)
8010229c:	e8 4f 36 00 00       	call   801058f0 <release>
801022a1:	83 c4 10             	add    $0x10,%esp
801022a4:	eb 0d                	jmp    801022b3 <namex+0x53>
801022a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ad:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
801022b0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
801022b3:	0f b6 07             	movzbl (%edi),%eax
801022b6:	3c 2f                	cmp    $0x2f,%al
801022b8:	74 f6                	je     801022b0 <namex+0x50>
  if(*path == 0)
801022ba:	84 c0                	test   %al,%al
801022bc:	0f 84 ee 00 00 00    	je     801023b0 <namex+0x150>
  while(*path != '/' && *path != 0)
801022c2:	0f b6 07             	movzbl (%edi),%eax
801022c5:	84 c0                	test   %al,%al
801022c7:	0f 84 fb 00 00 00    	je     801023c8 <namex+0x168>
801022cd:	89 fb                	mov    %edi,%ebx
801022cf:	3c 2f                	cmp    $0x2f,%al
801022d1:	0f 84 f1 00 00 00    	je     801023c8 <namex+0x168>
801022d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022de:	66 90                	xchg   %ax,%ax
801022e0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
801022e4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
801022e7:	3c 2f                	cmp    $0x2f,%al
801022e9:	74 04                	je     801022ef <namex+0x8f>
801022eb:	84 c0                	test   %al,%al
801022ed:	75 f1                	jne    801022e0 <namex+0x80>
  len = path - s;
801022ef:	89 d8                	mov    %ebx,%eax
801022f1:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
801022f3:	83 f8 0d             	cmp    $0xd,%eax
801022f6:	0f 8e 84 00 00 00    	jle    80102380 <namex+0x120>
    memmove(name, s, DIRSIZ);
801022fc:	83 ec 04             	sub    $0x4,%esp
801022ff:	6a 0e                	push   $0xe
80102301:	57                   	push   %edi
    path++;
80102302:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80102304:	ff 75 e4             	pushl  -0x1c(%ebp)
80102307:	e8 d4 36 00 00       	call   801059e0 <memmove>
8010230c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010230f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102312:	75 0c                	jne    80102320 <namex+0xc0>
80102314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102318:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
8010231b:	80 3f 2f             	cmpb   $0x2f,(%edi)
8010231e:	74 f8                	je     80102318 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	56                   	push   %esi
80102324:	e8 27 f9 ff ff       	call   80101c50 <ilock>
    if(ip->type != T_DIR){
80102329:	83 c4 10             	add    $0x10,%esp
8010232c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102331:	0f 85 a1 00 00 00    	jne    801023d8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102337:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010233a:	85 d2                	test   %edx,%edx
8010233c:	74 09                	je     80102347 <namex+0xe7>
8010233e:	80 3f 00             	cmpb   $0x0,(%edi)
80102341:	0f 84 d9 00 00 00    	je     80102420 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102347:	83 ec 04             	sub    $0x4,%esp
8010234a:	6a 00                	push   $0x0
8010234c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010234f:	56                   	push   %esi
80102350:	e8 4b fe ff ff       	call   801021a0 <dirlookup>
80102355:	83 c4 10             	add    $0x10,%esp
80102358:	89 c3                	mov    %eax,%ebx
8010235a:	85 c0                	test   %eax,%eax
8010235c:	74 7a                	je     801023d8 <namex+0x178>
  iunlock(ip);
8010235e:	83 ec 0c             	sub    $0xc,%esp
80102361:	56                   	push   %esi
80102362:	e8 c9 f9 ff ff       	call   80101d30 <iunlock>
  iput(ip);
80102367:	89 34 24             	mov    %esi,(%esp)
8010236a:	89 de                	mov    %ebx,%esi
8010236c:	e8 0f fa ff ff       	call   80101d80 <iput>
80102371:	83 c4 10             	add    $0x10,%esp
80102374:	e9 3a ff ff ff       	jmp    801022b3 <namex+0x53>
80102379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102380:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102383:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102386:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102389:	83 ec 04             	sub    $0x4,%esp
8010238c:	50                   	push   %eax
8010238d:	57                   	push   %edi
    name[len] = 0;
8010238e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102390:	ff 75 e4             	pushl  -0x1c(%ebp)
80102393:	e8 48 36 00 00       	call   801059e0 <memmove>
    name[len] = 0;
80102398:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010239b:	83 c4 10             	add    $0x10,%esp
8010239e:	c6 00 00             	movb   $0x0,(%eax)
801023a1:	e9 69 ff ff ff       	jmp    8010230f <namex+0xaf>
801023a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ad:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801023b3:	85 c0                	test   %eax,%eax
801023b5:	0f 85 85 00 00 00    	jne    80102440 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
801023bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023be:	89 f0                	mov    %esi,%eax
801023c0:	5b                   	pop    %ebx
801023c1:	5e                   	pop    %esi
801023c2:	5f                   	pop    %edi
801023c3:	5d                   	pop    %ebp
801023c4:	c3                   	ret    
801023c5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
801023c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801023cb:	89 fb                	mov    %edi,%ebx
801023cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801023d0:	31 c0                	xor    %eax,%eax
801023d2:	eb b5                	jmp    80102389 <namex+0x129>
801023d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801023d8:	83 ec 0c             	sub    $0xc,%esp
801023db:	56                   	push   %esi
801023dc:	e8 4f f9 ff ff       	call   80101d30 <iunlock>
  iput(ip);
801023e1:	89 34 24             	mov    %esi,(%esp)
      return 0;
801023e4:	31 f6                	xor    %esi,%esi
  iput(ip);
801023e6:	e8 95 f9 ff ff       	call   80101d80 <iput>
      return 0;
801023eb:	83 c4 10             	add    $0x10,%esp
}
801023ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023f1:	89 f0                	mov    %esi,%eax
801023f3:	5b                   	pop    %ebx
801023f4:	5e                   	pop    %esi
801023f5:	5f                   	pop    %edi
801023f6:	5d                   	pop    %ebp
801023f7:	c3                   	ret    
801023f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ff:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80102400:	ba 01 00 00 00       	mov    $0x1,%edx
80102405:	b8 01 00 00 00       	mov    $0x1,%eax
8010240a:	89 df                	mov    %ebx,%edi
8010240c:	e8 1f f4 ff ff       	call   80101830 <iget>
80102411:	89 c6                	mov    %eax,%esi
80102413:	e9 9b fe ff ff       	jmp    801022b3 <namex+0x53>
80102418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010241f:	90                   	nop
      iunlock(ip);
80102420:	83 ec 0c             	sub    $0xc,%esp
80102423:	56                   	push   %esi
80102424:	e8 07 f9 ff ff       	call   80101d30 <iunlock>
      return ip;
80102429:	83 c4 10             	add    $0x10,%esp
}
8010242c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010242f:	89 f0                	mov    %esi,%eax
80102431:	5b                   	pop    %ebx
80102432:	5e                   	pop    %esi
80102433:	5f                   	pop    %edi
80102434:	5d                   	pop    %ebp
80102435:	c3                   	ret    
80102436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010243d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80102440:	83 ec 0c             	sub    $0xc,%esp
80102443:	56                   	push   %esi
    return 0;
80102444:	31 f6                	xor    %esi,%esi
    iput(ip);
80102446:	e8 35 f9 ff ff       	call   80101d80 <iput>
    return 0;
8010244b:	83 c4 10             	add    $0x10,%esp
8010244e:	e9 68 ff ff ff       	jmp    801023bb <namex+0x15b>
80102453:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010245a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102460 <dirlink>:
{
80102460:	f3 0f 1e fb          	endbr32 
80102464:	55                   	push   %ebp
80102465:	89 e5                	mov    %esp,%ebp
80102467:	57                   	push   %edi
80102468:	56                   	push   %esi
80102469:	53                   	push   %ebx
8010246a:	83 ec 20             	sub    $0x20,%esp
8010246d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102470:	6a 00                	push   $0x0
80102472:	ff 75 0c             	pushl  0xc(%ebp)
80102475:	53                   	push   %ebx
80102476:	e8 25 fd ff ff       	call   801021a0 <dirlookup>
8010247b:	83 c4 10             	add    $0x10,%esp
8010247e:	85 c0                	test   %eax,%eax
80102480:	75 6b                	jne    801024ed <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102482:	8b 7b 58             	mov    0x58(%ebx),%edi
80102485:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102488:	85 ff                	test   %edi,%edi
8010248a:	74 2d                	je     801024b9 <dirlink+0x59>
8010248c:	31 ff                	xor    %edi,%edi
8010248e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102491:	eb 0d                	jmp    801024a0 <dirlink+0x40>
80102493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102497:	90                   	nop
80102498:	83 c7 10             	add    $0x10,%edi
8010249b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010249e:	73 19                	jae    801024b9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024a0:	6a 10                	push   $0x10
801024a2:	57                   	push   %edi
801024a3:	56                   	push   %esi
801024a4:	53                   	push   %ebx
801024a5:	e8 a6 fa ff ff       	call   80101f50 <readi>
801024aa:	83 c4 10             	add    $0x10,%esp
801024ad:	83 f8 10             	cmp    $0x10,%eax
801024b0:	75 4e                	jne    80102500 <dirlink+0xa0>
    if(de.inum == 0)
801024b2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801024b7:	75 df                	jne    80102498 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
801024b9:	83 ec 04             	sub    $0x4,%esp
801024bc:	8d 45 da             	lea    -0x26(%ebp),%eax
801024bf:	6a 0e                	push   $0xe
801024c1:	ff 75 0c             	pushl  0xc(%ebp)
801024c4:	50                   	push   %eax
801024c5:	e8 d6 35 00 00       	call   80105aa0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024ca:	6a 10                	push   $0x10
  de.inum = inum;
801024cc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024cf:	57                   	push   %edi
801024d0:	56                   	push   %esi
801024d1:	53                   	push   %ebx
  de.inum = inum;
801024d2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024d6:	e8 75 fb ff ff       	call   80102050 <writei>
801024db:	83 c4 20             	add    $0x20,%esp
801024de:	83 f8 10             	cmp    $0x10,%eax
801024e1:	75 2a                	jne    8010250d <dirlink+0xad>
  return 0;
801024e3:	31 c0                	xor    %eax,%eax
}
801024e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024e8:	5b                   	pop    %ebx
801024e9:	5e                   	pop    %esi
801024ea:	5f                   	pop    %edi
801024eb:	5d                   	pop    %ebp
801024ec:	c3                   	ret    
    iput(ip);
801024ed:	83 ec 0c             	sub    $0xc,%esp
801024f0:	50                   	push   %eax
801024f1:	e8 8a f8 ff ff       	call   80101d80 <iput>
    return -1;
801024f6:	83 c4 10             	add    $0x10,%esp
801024f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024fe:	eb e5                	jmp    801024e5 <dirlink+0x85>
      panic("dirlink read");
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 60 89 10 80       	push   $0x80108960
80102508:	e8 83 de ff ff       	call   80100390 <panic>
    panic("dirlink");
8010250d:	83 ec 0c             	sub    $0xc,%esp
80102510:	68 9e 90 10 80       	push   $0x8010909e
80102515:	e8 76 de ff ff       	call   80100390 <panic>
8010251a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102520 <namei>:

struct inode*
namei(char *path)
{
80102520:	f3 0f 1e fb          	endbr32 
80102524:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102525:	31 d2                	xor    %edx,%edx
{
80102527:	89 e5                	mov    %esp,%ebp
80102529:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010252c:	8b 45 08             	mov    0x8(%ebp),%eax
8010252f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102532:	e8 29 fd ff ff       	call   80102260 <namex>
}
80102537:	c9                   	leave  
80102538:	c3                   	ret    
80102539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102540 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102540:	f3 0f 1e fb          	endbr32 
80102544:	55                   	push   %ebp
  return namex(path, 1, name);
80102545:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010254a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010254c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010254f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102552:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102553:	e9 08 fd ff ff       	jmp    80102260 <namex>
80102558:	66 90                	xchg   %ax,%ax
8010255a:	66 90                	xchg   %ax,%ax
8010255c:	66 90                	xchg   %ax,%ax
8010255e:	66 90                	xchg   %ax,%ax

80102560 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	57                   	push   %edi
80102564:	56                   	push   %esi
80102565:	53                   	push   %ebx
80102566:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102569:	85 c0                	test   %eax,%eax
8010256b:	0f 84 b4 00 00 00    	je     80102625 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102571:	8b 70 08             	mov    0x8(%eax),%esi
80102574:	89 c3                	mov    %eax,%ebx
80102576:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010257c:	0f 87 96 00 00 00    	ja     80102618 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102582:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010258e:	66 90                	xchg   %ax,%ax
80102590:	89 ca                	mov    %ecx,%edx
80102592:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102593:	83 e0 c0             	and    $0xffffffc0,%eax
80102596:	3c 40                	cmp    $0x40,%al
80102598:	75 f6                	jne    80102590 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010259a:	31 ff                	xor    %edi,%edi
8010259c:	ba f6 03 00 00       	mov    $0x3f6,%edx
801025a1:	89 f8                	mov    %edi,%eax
801025a3:	ee                   	out    %al,(%dx)
801025a4:	b8 01 00 00 00       	mov    $0x1,%eax
801025a9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801025ae:	ee                   	out    %al,(%dx)
801025af:	ba f3 01 00 00       	mov    $0x1f3,%edx
801025b4:	89 f0                	mov    %esi,%eax
801025b6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801025b7:	89 f0                	mov    %esi,%eax
801025b9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801025be:	c1 f8 08             	sar    $0x8,%eax
801025c1:	ee                   	out    %al,(%dx)
801025c2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801025c7:	89 f8                	mov    %edi,%eax
801025c9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801025ca:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801025ce:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025d3:	c1 e0 04             	shl    $0x4,%eax
801025d6:	83 e0 10             	and    $0x10,%eax
801025d9:	83 c8 e0             	or     $0xffffffe0,%eax
801025dc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801025dd:	f6 03 04             	testb  $0x4,(%ebx)
801025e0:	75 16                	jne    801025f8 <idestart+0x98>
801025e2:	b8 20 00 00 00       	mov    $0x20,%eax
801025e7:	89 ca                	mov    %ecx,%edx
801025e9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801025ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025ed:	5b                   	pop    %ebx
801025ee:	5e                   	pop    %esi
801025ef:	5f                   	pop    %edi
801025f0:	5d                   	pop    %ebp
801025f1:	c3                   	ret    
801025f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025f8:	b8 30 00 00 00       	mov    $0x30,%eax
801025fd:	89 ca                	mov    %ecx,%edx
801025ff:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102600:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102605:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102608:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010260d:	fc                   	cld    
8010260e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102610:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102613:	5b                   	pop    %ebx
80102614:	5e                   	pop    %esi
80102615:	5f                   	pop    %edi
80102616:	5d                   	pop    %ebp
80102617:	c3                   	ret    
    panic("incorrect blockno");
80102618:	83 ec 0c             	sub    $0xc,%esp
8010261b:	68 cc 89 10 80       	push   $0x801089cc
80102620:	e8 6b dd ff ff       	call   80100390 <panic>
    panic("idestart");
80102625:	83 ec 0c             	sub    $0xc,%esp
80102628:	68 c3 89 10 80       	push   $0x801089c3
8010262d:	e8 5e dd ff ff       	call   80100390 <panic>
80102632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102640 <ideinit>:
{
80102640:	f3 0f 1e fb          	endbr32 
80102644:	55                   	push   %ebp
80102645:	89 e5                	mov    %esp,%ebp
80102647:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010264a:	68 de 89 10 80       	push   $0x801089de
8010264f:	68 80 c5 10 80       	push   $0x8010c580
80102654:	e8 57 30 00 00       	call   801056b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102659:	58                   	pop    %eax
8010265a:	a1 a0 52 11 80       	mov    0x801152a0,%eax
8010265f:	5a                   	pop    %edx
80102660:	83 e8 01             	sub    $0x1,%eax
80102663:	50                   	push   %eax
80102664:	6a 0e                	push   $0xe
80102666:	e8 b5 02 00 00       	call   80102920 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010266b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010266e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102673:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102677:	90                   	nop
80102678:	ec                   	in     (%dx),%al
80102679:	83 e0 c0             	and    $0xffffffc0,%eax
8010267c:	3c 40                	cmp    $0x40,%al
8010267e:	75 f8                	jne    80102678 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102680:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102685:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010268a:	ee                   	out    %al,(%dx)
8010268b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102690:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102695:	eb 0e                	jmp    801026a5 <ideinit+0x65>
80102697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010269e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801026a0:	83 e9 01             	sub    $0x1,%ecx
801026a3:	74 0f                	je     801026b4 <ideinit+0x74>
801026a5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801026a6:	84 c0                	test   %al,%al
801026a8:	74 f6                	je     801026a0 <ideinit+0x60>
      havedisk1 = 1;
801026aa:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
801026b1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026b4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801026b9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026be:	ee                   	out    %al,(%dx)
}
801026bf:	c9                   	leave  
801026c0:	c3                   	ret    
801026c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026cf:	90                   	nop

801026d0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026d0:	f3 0f 1e fb          	endbr32 
801026d4:	55                   	push   %ebp
801026d5:	89 e5                	mov    %esp,%ebp
801026d7:	57                   	push   %edi
801026d8:	56                   	push   %esi
801026d9:	53                   	push   %ebx
801026da:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026dd:	68 80 c5 10 80       	push   $0x8010c580
801026e2:	e8 49 31 00 00       	call   80105830 <acquire>

  if((b = idequeue) == 0){
801026e7:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
801026ed:	83 c4 10             	add    $0x10,%esp
801026f0:	85 db                	test   %ebx,%ebx
801026f2:	74 5f                	je     80102753 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801026f4:	8b 43 58             	mov    0x58(%ebx),%eax
801026f7:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801026fc:	8b 33                	mov    (%ebx),%esi
801026fe:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102704:	75 2b                	jne    80102731 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102706:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010270b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010270f:	90                   	nop
80102710:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102711:	89 c1                	mov    %eax,%ecx
80102713:	83 e1 c0             	and    $0xffffffc0,%ecx
80102716:	80 f9 40             	cmp    $0x40,%cl
80102719:	75 f5                	jne    80102710 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010271b:	a8 21                	test   $0x21,%al
8010271d:	75 12                	jne    80102731 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010271f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102722:	b9 80 00 00 00       	mov    $0x80,%ecx
80102727:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010272c:	fc                   	cld    
8010272d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010272f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102731:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102734:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102737:	83 ce 02             	or     $0x2,%esi
8010273a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010273c:	53                   	push   %ebx
8010273d:	e8 0e 1f 00 00       	call   80104650 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102742:	a1 64 c5 10 80       	mov    0x8010c564,%eax
80102747:	83 c4 10             	add    $0x10,%esp
8010274a:	85 c0                	test   %eax,%eax
8010274c:	74 05                	je     80102753 <ideintr+0x83>
    idestart(idequeue);
8010274e:	e8 0d fe ff ff       	call   80102560 <idestart>
    release(&idelock);
80102753:	83 ec 0c             	sub    $0xc,%esp
80102756:	68 80 c5 10 80       	push   $0x8010c580
8010275b:	e8 90 31 00 00       	call   801058f0 <release>

  release(&idelock);
}
80102760:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102763:	5b                   	pop    %ebx
80102764:	5e                   	pop    %esi
80102765:	5f                   	pop    %edi
80102766:	5d                   	pop    %ebp
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop

80102770 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102770:	f3 0f 1e fb          	endbr32 
80102774:	55                   	push   %ebp
80102775:	89 e5                	mov    %esp,%ebp
80102777:	53                   	push   %ebx
80102778:	83 ec 10             	sub    $0x10,%esp
8010277b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010277e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102781:	50                   	push   %eax
80102782:	e8 c9 2e 00 00       	call   80105650 <holdingsleep>
80102787:	83 c4 10             	add    $0x10,%esp
8010278a:	85 c0                	test   %eax,%eax
8010278c:	0f 84 cf 00 00 00    	je     80102861 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102792:	8b 03                	mov    (%ebx),%eax
80102794:	83 e0 06             	and    $0x6,%eax
80102797:	83 f8 02             	cmp    $0x2,%eax
8010279a:	0f 84 b4 00 00 00    	je     80102854 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801027a0:	8b 53 04             	mov    0x4(%ebx),%edx
801027a3:	85 d2                	test   %edx,%edx
801027a5:	74 0d                	je     801027b4 <iderw+0x44>
801027a7:	a1 60 c5 10 80       	mov    0x8010c560,%eax
801027ac:	85 c0                	test   %eax,%eax
801027ae:	0f 84 93 00 00 00    	je     80102847 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801027b4:	83 ec 0c             	sub    $0xc,%esp
801027b7:	68 80 c5 10 80       	push   $0x8010c580
801027bc:	e8 6f 30 00 00       	call   80105830 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027c1:	a1 64 c5 10 80       	mov    0x8010c564,%eax
  b->qnext = 0;
801027c6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027cd:	83 c4 10             	add    $0x10,%esp
801027d0:	85 c0                	test   %eax,%eax
801027d2:	74 6c                	je     80102840 <iderw+0xd0>
801027d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027d8:	89 c2                	mov    %eax,%edx
801027da:	8b 40 58             	mov    0x58(%eax),%eax
801027dd:	85 c0                	test   %eax,%eax
801027df:	75 f7                	jne    801027d8 <iderw+0x68>
801027e1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801027e4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801027e6:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
801027ec:	74 42                	je     80102830 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801027ee:	8b 03                	mov    (%ebx),%eax
801027f0:	83 e0 06             	and    $0x6,%eax
801027f3:	83 f8 02             	cmp    $0x2,%eax
801027f6:	74 23                	je     8010281b <iderw+0xab>
801027f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ff:	90                   	nop
    sleep(b, &idelock);
80102800:	83 ec 08             	sub    $0x8,%esp
80102803:	68 80 c5 10 80       	push   $0x8010c580
80102808:	53                   	push   %ebx
80102809:	e8 82 1c 00 00       	call   80104490 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010280e:	8b 03                	mov    (%ebx),%eax
80102810:	83 c4 10             	add    $0x10,%esp
80102813:	83 e0 06             	and    $0x6,%eax
80102816:	83 f8 02             	cmp    $0x2,%eax
80102819:	75 e5                	jne    80102800 <iderw+0x90>
  }


  release(&idelock);
8010281b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102822:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102825:	c9                   	leave  
  release(&idelock);
80102826:	e9 c5 30 00 00       	jmp    801058f0 <release>
8010282b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010282f:	90                   	nop
    idestart(b);
80102830:	89 d8                	mov    %ebx,%eax
80102832:	e8 29 fd ff ff       	call   80102560 <idestart>
80102837:	eb b5                	jmp    801027ee <iderw+0x7e>
80102839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102840:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
80102845:	eb 9d                	jmp    801027e4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102847:	83 ec 0c             	sub    $0xc,%esp
8010284a:	68 0d 8a 10 80       	push   $0x80108a0d
8010284f:	e8 3c db ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102854:	83 ec 0c             	sub    $0xc,%esp
80102857:	68 f8 89 10 80       	push   $0x801089f8
8010285c:	e8 2f db ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102861:	83 ec 0c             	sub    $0xc,%esp
80102864:	68 e2 89 10 80       	push   $0x801089e2
80102869:	e8 22 db ff ff       	call   80100390 <panic>
8010286e:	66 90                	xchg   %ax,%ax

80102870 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102870:	f3 0f 1e fb          	endbr32 
80102874:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102875:	c7 05 d4 4b 11 80 00 	movl   $0xfec00000,0x80114bd4
8010287c:	00 c0 fe 
{
8010287f:	89 e5                	mov    %esp,%ebp
80102881:	56                   	push   %esi
80102882:	53                   	push   %ebx
  ioapic->reg = reg;
80102883:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010288a:	00 00 00 
  return ioapic->data;
8010288d:	8b 15 d4 4b 11 80    	mov    0x80114bd4,%edx
80102893:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102896:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010289c:	8b 0d d4 4b 11 80    	mov    0x80114bd4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801028a2:	0f b6 15 00 4d 11 80 	movzbl 0x80114d00,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028a9:	c1 ee 10             	shr    $0x10,%esi
801028ac:	89 f0                	mov    %esi,%eax
801028ae:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801028b1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801028b4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801028b7:	39 c2                	cmp    %eax,%edx
801028b9:	74 16                	je     801028d1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028bb:	83 ec 0c             	sub    $0xc,%esp
801028be:	68 2c 8a 10 80       	push   $0x80108a2c
801028c3:	e8 f8 df ff ff       	call   801008c0 <cprintf>
801028c8:	8b 0d d4 4b 11 80    	mov    0x80114bd4,%ecx
801028ce:	83 c4 10             	add    $0x10,%esp
801028d1:	83 c6 21             	add    $0x21,%esi
{
801028d4:	ba 10 00 00 00       	mov    $0x10,%edx
801028d9:	b8 20 00 00 00       	mov    $0x20,%eax
801028de:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801028e0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801028e2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801028e4:	8b 0d d4 4b 11 80    	mov    0x80114bd4,%ecx
801028ea:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801028ed:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801028f3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801028f6:	8d 5a 01             	lea    0x1(%edx),%ebx
801028f9:	83 c2 02             	add    $0x2,%edx
801028fc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801028fe:	8b 0d d4 4b 11 80    	mov    0x80114bd4,%ecx
80102904:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010290b:	39 f0                	cmp    %esi,%eax
8010290d:	75 d1                	jne    801028e0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010290f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102912:	5b                   	pop    %ebx
80102913:	5e                   	pop    %esi
80102914:	5d                   	pop    %ebp
80102915:	c3                   	ret    
80102916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291d:	8d 76 00             	lea    0x0(%esi),%esi

80102920 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102920:	f3 0f 1e fb          	endbr32 
80102924:	55                   	push   %ebp
  ioapic->reg = reg;
80102925:	8b 0d d4 4b 11 80    	mov    0x80114bd4,%ecx
{
8010292b:	89 e5                	mov    %esp,%ebp
8010292d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102930:	8d 50 20             	lea    0x20(%eax),%edx
80102933:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102937:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102939:	8b 0d d4 4b 11 80    	mov    0x80114bd4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010293f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102942:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102945:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102948:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010294a:	a1 d4 4b 11 80       	mov    0x80114bd4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010294f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102952:	89 50 10             	mov    %edx,0x10(%eax)
}
80102955:	5d                   	pop    %ebp
80102956:	c3                   	ret    
80102957:	66 90                	xchg   %ax,%ax
80102959:	66 90                	xchg   %ax,%ax
8010295b:	66 90                	xchg   %ax,%ax
8010295d:	66 90                	xchg   %ax,%ax
8010295f:	90                   	nop

80102960 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102960:	f3 0f 1e fb          	endbr32 
80102964:	55                   	push   %ebp
80102965:	89 e5                	mov    %esp,%ebp
80102967:	53                   	push   %ebx
80102968:	83 ec 04             	sub    $0x4,%esp
8010296b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010296e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102974:	75 7a                	jne    801029f0 <kfree+0x90>
80102976:	81 fb 48 86 11 80    	cmp    $0x80118648,%ebx
8010297c:	72 72                	jb     801029f0 <kfree+0x90>
8010297e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102984:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102989:	77 65                	ja     801029f0 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010298b:	83 ec 04             	sub    $0x4,%esp
8010298e:	68 00 10 00 00       	push   $0x1000
80102993:	6a 01                	push   $0x1
80102995:	53                   	push   %ebx
80102996:	e8 a5 2f 00 00       	call   80105940 <memset>

  if(kmem.use_lock)
8010299b:	8b 15 14 4c 11 80    	mov    0x80114c14,%edx
801029a1:	83 c4 10             	add    $0x10,%esp
801029a4:	85 d2                	test   %edx,%edx
801029a6:	75 20                	jne    801029c8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801029a8:	a1 18 4c 11 80       	mov    0x80114c18,%eax
801029ad:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801029af:	a1 14 4c 11 80       	mov    0x80114c14,%eax
  kmem.freelist = r;
801029b4:	89 1d 18 4c 11 80    	mov    %ebx,0x80114c18
  if(kmem.use_lock)
801029ba:	85 c0                	test   %eax,%eax
801029bc:	75 22                	jne    801029e0 <kfree+0x80>
    release(&kmem.lock);
}
801029be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029c1:	c9                   	leave  
801029c2:	c3                   	ret    
801029c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029c7:	90                   	nop
    acquire(&kmem.lock);
801029c8:	83 ec 0c             	sub    $0xc,%esp
801029cb:	68 e0 4b 11 80       	push   $0x80114be0
801029d0:	e8 5b 2e 00 00       	call   80105830 <acquire>
801029d5:	83 c4 10             	add    $0x10,%esp
801029d8:	eb ce                	jmp    801029a8 <kfree+0x48>
801029da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801029e0:	c7 45 08 e0 4b 11 80 	movl   $0x80114be0,0x8(%ebp)
}
801029e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ea:	c9                   	leave  
    release(&kmem.lock);
801029eb:	e9 00 2f 00 00       	jmp    801058f0 <release>
    panic("kfree");
801029f0:	83 ec 0c             	sub    $0xc,%esp
801029f3:	68 5e 8a 10 80       	push   $0x80108a5e
801029f8:	e8 93 d9 ff ff       	call   80100390 <panic>
801029fd:	8d 76 00             	lea    0x0(%esi),%esi

80102a00 <freerange>:
{
80102a00:	f3 0f 1e fb          	endbr32 
80102a04:	55                   	push   %ebp
80102a05:	89 e5                	mov    %esp,%ebp
80102a07:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a08:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a0b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102a0e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a0f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a15:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a1b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a21:	39 de                	cmp    %ebx,%esi
80102a23:	72 1f                	jb     80102a44 <freerange+0x44>
80102a25:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102a28:	83 ec 0c             	sub    $0xc,%esp
80102a2b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a31:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a37:	50                   	push   %eax
80102a38:	e8 23 ff ff ff       	call   80102960 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a3d:	83 c4 10             	add    $0x10,%esp
80102a40:	39 f3                	cmp    %esi,%ebx
80102a42:	76 e4                	jbe    80102a28 <freerange+0x28>
}
80102a44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a47:	5b                   	pop    %ebx
80102a48:	5e                   	pop    %esi
80102a49:	5d                   	pop    %ebp
80102a4a:	c3                   	ret    
80102a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a4f:	90                   	nop

80102a50 <kinit1>:
{
80102a50:	f3 0f 1e fb          	endbr32 
80102a54:	55                   	push   %ebp
80102a55:	89 e5                	mov    %esp,%ebp
80102a57:	56                   	push   %esi
80102a58:	53                   	push   %ebx
80102a59:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102a5c:	83 ec 08             	sub    $0x8,%esp
80102a5f:	68 64 8a 10 80       	push   $0x80108a64
80102a64:	68 e0 4b 11 80       	push   $0x80114be0
80102a69:	e8 42 2c 00 00       	call   801056b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a71:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102a74:	c7 05 14 4c 11 80 00 	movl   $0x0,0x80114c14
80102a7b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102a7e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a84:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a8a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a90:	39 de                	cmp    %ebx,%esi
80102a92:	72 20                	jb     80102ab4 <kinit1+0x64>
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102a98:	83 ec 0c             	sub    $0xc,%esp
80102a9b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aa1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102aa7:	50                   	push   %eax
80102aa8:	e8 b3 fe ff ff       	call   80102960 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aad:	83 c4 10             	add    $0x10,%esp
80102ab0:	39 de                	cmp    %ebx,%esi
80102ab2:	73 e4                	jae    80102a98 <kinit1+0x48>
}
80102ab4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ab7:	5b                   	pop    %ebx
80102ab8:	5e                   	pop    %esi
80102ab9:	5d                   	pop    %ebp
80102aba:	c3                   	ret    
80102abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102abf:	90                   	nop

80102ac0 <kinit2>:
{
80102ac0:	f3 0f 1e fb          	endbr32 
80102ac4:	55                   	push   %ebp
80102ac5:	89 e5                	mov    %esp,%ebp
80102ac7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102ac8:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102acb:	8b 75 0c             	mov    0xc(%ebp),%esi
80102ace:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102acf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ad5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102adb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102ae1:	39 de                	cmp    %ebx,%esi
80102ae3:	72 1f                	jb     80102b04 <kinit2+0x44>
80102ae5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102ae8:	83 ec 0c             	sub    $0xc,%esp
80102aeb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102af1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102af7:	50                   	push   %eax
80102af8:	e8 63 fe ff ff       	call   80102960 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102afd:	83 c4 10             	add    $0x10,%esp
80102b00:	39 de                	cmp    %ebx,%esi
80102b02:	73 e4                	jae    80102ae8 <kinit2+0x28>
  kmem.use_lock = 1;
80102b04:	c7 05 14 4c 11 80 01 	movl   $0x1,0x80114c14
80102b0b:	00 00 00 
}
80102b0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b11:	5b                   	pop    %ebx
80102b12:	5e                   	pop    %esi
80102b13:	5d                   	pop    %ebp
80102b14:	c3                   	ret    
80102b15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b20 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b20:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102b24:	a1 14 4c 11 80       	mov    0x80114c14,%eax
80102b29:	85 c0                	test   %eax,%eax
80102b2b:	75 1b                	jne    80102b48 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102b2d:	a1 18 4c 11 80       	mov    0x80114c18,%eax
  if(r)
80102b32:	85 c0                	test   %eax,%eax
80102b34:	74 0a                	je     80102b40 <kalloc+0x20>
    kmem.freelist = r->next;
80102b36:	8b 10                	mov    (%eax),%edx
80102b38:	89 15 18 4c 11 80    	mov    %edx,0x80114c18
  if(kmem.use_lock)
80102b3e:	c3                   	ret    
80102b3f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102b40:	c3                   	ret    
80102b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102b48:	55                   	push   %ebp
80102b49:	89 e5                	mov    %esp,%ebp
80102b4b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102b4e:	68 e0 4b 11 80       	push   $0x80114be0
80102b53:	e8 d8 2c 00 00       	call   80105830 <acquire>
  r = kmem.freelist;
80102b58:	a1 18 4c 11 80       	mov    0x80114c18,%eax
  if(r)
80102b5d:	8b 15 14 4c 11 80    	mov    0x80114c14,%edx
80102b63:	83 c4 10             	add    $0x10,%esp
80102b66:	85 c0                	test   %eax,%eax
80102b68:	74 08                	je     80102b72 <kalloc+0x52>
    kmem.freelist = r->next;
80102b6a:	8b 08                	mov    (%eax),%ecx
80102b6c:	89 0d 18 4c 11 80    	mov    %ecx,0x80114c18
  if(kmem.use_lock)
80102b72:	85 d2                	test   %edx,%edx
80102b74:	74 16                	je     80102b8c <kalloc+0x6c>
    release(&kmem.lock);
80102b76:	83 ec 0c             	sub    $0xc,%esp
80102b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b7c:	68 e0 4b 11 80       	push   $0x80114be0
80102b81:	e8 6a 2d 00 00       	call   801058f0 <release>
  return (char*)r;
80102b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102b89:	83 c4 10             	add    $0x10,%esp
}
80102b8c:	c9                   	leave  
80102b8d:	c3                   	ret    
80102b8e:	66 90                	xchg   %ax,%ax

80102b90 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b90:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b94:	ba 64 00 00 00       	mov    $0x64,%edx
80102b99:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102b9a:	a8 01                	test   $0x1,%al
80102b9c:	0f 84 be 00 00 00    	je     80102c60 <kbdgetc+0xd0>
{
80102ba2:	55                   	push   %ebp
80102ba3:	ba 60 00 00 00       	mov    $0x60,%edx
80102ba8:	89 e5                	mov    %esp,%ebp
80102baa:	53                   	push   %ebx
80102bab:	ec                   	in     (%dx),%al
  return data;
80102bac:	8b 1d b4 c5 10 80    	mov    0x8010c5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102bb2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102bb5:	3c e0                	cmp    $0xe0,%al
80102bb7:	74 57                	je     80102c10 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102bb9:	89 d9                	mov    %ebx,%ecx
80102bbb:	83 e1 40             	and    $0x40,%ecx
80102bbe:	84 c0                	test   %al,%al
80102bc0:	78 5e                	js     80102c20 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102bc2:	85 c9                	test   %ecx,%ecx
80102bc4:	74 09                	je     80102bcf <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102bc6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102bc9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102bcc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102bcf:	0f b6 8a a0 8b 10 80 	movzbl -0x7fef7460(%edx),%ecx
  shift ^= togglecode[data];
80102bd6:	0f b6 82 a0 8a 10 80 	movzbl -0x7fef7560(%edx),%eax
  shift |= shiftcode[data];
80102bdd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102bdf:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102be1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102be3:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102be9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102bec:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bef:	8b 04 85 80 8a 10 80 	mov    -0x7fef7580(,%eax,4),%eax
80102bf6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102bfa:	74 0b                	je     80102c07 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102bfc:	8d 50 9f             	lea    -0x61(%eax),%edx
80102bff:	83 fa 19             	cmp    $0x19,%edx
80102c02:	77 44                	ja     80102c48 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102c04:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102c07:	5b                   	pop    %ebx
80102c08:	5d                   	pop    %ebp
80102c09:	c3                   	ret    
80102c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102c10:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102c13:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102c15:	89 1d b4 c5 10 80    	mov    %ebx,0x8010c5b4
}
80102c1b:	5b                   	pop    %ebx
80102c1c:	5d                   	pop    %ebp
80102c1d:	c3                   	ret    
80102c1e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102c20:	83 e0 7f             	and    $0x7f,%eax
80102c23:	85 c9                	test   %ecx,%ecx
80102c25:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102c28:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102c2a:	0f b6 8a a0 8b 10 80 	movzbl -0x7fef7460(%edx),%ecx
80102c31:	83 c9 40             	or     $0x40,%ecx
80102c34:	0f b6 c9             	movzbl %cl,%ecx
80102c37:	f7 d1                	not    %ecx
80102c39:	21 d9                	and    %ebx,%ecx
}
80102c3b:	5b                   	pop    %ebx
80102c3c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102c3d:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80102c43:	c3                   	ret    
80102c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102c48:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102c4b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102c4e:	5b                   	pop    %ebx
80102c4f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102c50:	83 f9 1a             	cmp    $0x1a,%ecx
80102c53:	0f 42 c2             	cmovb  %edx,%eax
}
80102c56:	c3                   	ret    
80102c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c5e:	66 90                	xchg   %ax,%ax
    return -1;
80102c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102c65:	c3                   	ret    
80102c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c6d:	8d 76 00             	lea    0x0(%esi),%esi

80102c70 <kbdintr>:

void
kbdintr(void)
{
80102c70:	f3 0f 1e fb          	endbr32 
80102c74:	55                   	push   %ebp
80102c75:	89 e5                	mov    %esp,%ebp
80102c77:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102c7a:	68 90 2b 10 80       	push   $0x80102b90
80102c7f:	e8 ec dd ff ff       	call   80100a70 <consoleintr>
}
80102c84:	83 c4 10             	add    $0x10,%esp
80102c87:	c9                   	leave  
80102c88:	c3                   	ret    
80102c89:	66 90                	xchg   %ax,%ax
80102c8b:	66 90                	xchg   %ax,%ax
80102c8d:	66 90                	xchg   %ax,%ax
80102c8f:	90                   	nop

80102c90 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102c90:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102c94:	a1 1c 4c 11 80       	mov    0x80114c1c,%eax
80102c99:	85 c0                	test   %eax,%eax
80102c9b:	0f 84 c7 00 00 00    	je     80102d68 <lapicinit+0xd8>
  lapic[index] = value;
80102ca1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102ca8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cab:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cae:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102cb5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cb8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cbb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102cc2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102cc5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cc8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102ccf:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102cd2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cd5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102cdc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cdf:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ce2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102ce9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cec:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102cef:	8b 50 30             	mov    0x30(%eax),%edx
80102cf2:	c1 ea 10             	shr    $0x10,%edx
80102cf5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102cfb:	75 73                	jne    80102d70 <lapicinit+0xe0>
  lapic[index] = value;
80102cfd:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102d04:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d07:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d0a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d11:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d14:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d17:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d1e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d21:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d24:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d2b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d31:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d38:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d3b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d3e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102d45:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102d48:	8b 50 20             	mov    0x20(%eax),%edx
80102d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d4f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102d50:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102d56:	80 e6 10             	and    $0x10,%dh
80102d59:	75 f5                	jne    80102d50 <lapicinit+0xc0>
  lapic[index] = value;
80102d5b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102d62:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d65:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102d68:	c3                   	ret    
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102d70:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102d77:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d7a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102d7d:	e9 7b ff ff ff       	jmp    80102cfd <lapicinit+0x6d>
80102d82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d90 <lapicid>:

int
lapicid(void)
{
80102d90:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102d94:	a1 1c 4c 11 80       	mov    0x80114c1c,%eax
80102d99:	85 c0                	test   %eax,%eax
80102d9b:	74 0b                	je     80102da8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102d9d:	8b 40 20             	mov    0x20(%eax),%eax
80102da0:	c1 e8 18             	shr    $0x18,%eax
80102da3:	c3                   	ret    
80102da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102da8:	31 c0                	xor    %eax,%eax
}
80102daa:	c3                   	ret    
80102dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102daf:	90                   	nop

80102db0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102db0:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102db4:	a1 1c 4c 11 80       	mov    0x80114c1c,%eax
80102db9:	85 c0                	test   %eax,%eax
80102dbb:	74 0d                	je     80102dca <lapiceoi+0x1a>
  lapic[index] = value;
80102dbd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102dc4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102dc7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102dca:	c3                   	ret    
80102dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dcf:	90                   	nop

80102dd0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102dd0:	f3 0f 1e fb          	endbr32 
}
80102dd4:	c3                   	ret    
80102dd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102de0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102de0:	f3 0f 1e fb          	endbr32 
80102de4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102de5:	b8 0f 00 00 00       	mov    $0xf,%eax
80102dea:	ba 70 00 00 00       	mov    $0x70,%edx
80102def:	89 e5                	mov    %esp,%ebp
80102df1:	53                   	push   %ebx
80102df2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102df5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102df8:	ee                   	out    %al,(%dx)
80102df9:	b8 0a 00 00 00       	mov    $0xa,%eax
80102dfe:	ba 71 00 00 00       	mov    $0x71,%edx
80102e03:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102e04:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102e06:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102e09:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102e0f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e11:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102e14:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102e16:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e19:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102e1c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102e22:	a1 1c 4c 11 80       	mov    0x80114c1c,%eax
80102e27:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e2d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e30:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e37:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e3a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e3d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102e44:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e47:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e4a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e50:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e53:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e59:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e5c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e62:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e65:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102e6b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102e6c:	8b 40 20             	mov    0x20(%eax),%eax
}
80102e6f:	5d                   	pop    %ebp
80102e70:	c3                   	ret    
80102e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e7f:	90                   	nop

80102e80 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102e80:	f3 0f 1e fb          	endbr32 
80102e84:	55                   	push   %ebp
80102e85:	b8 0b 00 00 00       	mov    $0xb,%eax
80102e8a:	ba 70 00 00 00       	mov    $0x70,%edx
80102e8f:	89 e5                	mov    %esp,%ebp
80102e91:	57                   	push   %edi
80102e92:	56                   	push   %esi
80102e93:	53                   	push   %ebx
80102e94:	83 ec 4c             	sub    $0x4c,%esp
80102e97:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e98:	ba 71 00 00 00       	mov    $0x71,%edx
80102e9d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102e9e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ea1:	bb 70 00 00 00       	mov    $0x70,%ebx
80102ea6:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eb0:	31 c0                	xor    %eax,%eax
80102eb2:	89 da                	mov    %ebx,%edx
80102eb4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eb5:	b9 71 00 00 00       	mov    $0x71,%ecx
80102eba:	89 ca                	mov    %ecx,%edx
80102ebc:	ec                   	in     (%dx),%al
80102ebd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ec0:	89 da                	mov    %ebx,%edx
80102ec2:	b8 02 00 00 00       	mov    $0x2,%eax
80102ec7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ec8:	89 ca                	mov    %ecx,%edx
80102eca:	ec                   	in     (%dx),%al
80102ecb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ece:	89 da                	mov    %ebx,%edx
80102ed0:	b8 04 00 00 00       	mov    $0x4,%eax
80102ed5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ed6:	89 ca                	mov    %ecx,%edx
80102ed8:	ec                   	in     (%dx),%al
80102ed9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102edc:	89 da                	mov    %ebx,%edx
80102ede:	b8 07 00 00 00       	mov    $0x7,%eax
80102ee3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ee4:	89 ca                	mov    %ecx,%edx
80102ee6:	ec                   	in     (%dx),%al
80102ee7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eea:	89 da                	mov    %ebx,%edx
80102eec:	b8 08 00 00 00       	mov    $0x8,%eax
80102ef1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ef2:	89 ca                	mov    %ecx,%edx
80102ef4:	ec                   	in     (%dx),%al
80102ef5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ef7:	89 da                	mov    %ebx,%edx
80102ef9:	b8 09 00 00 00       	mov    $0x9,%eax
80102efe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eff:	89 ca                	mov    %ecx,%edx
80102f01:	ec                   	in     (%dx),%al
80102f02:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f04:	89 da                	mov    %ebx,%edx
80102f06:	b8 0a 00 00 00       	mov    $0xa,%eax
80102f0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f0c:	89 ca                	mov    %ecx,%edx
80102f0e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102f0f:	84 c0                	test   %al,%al
80102f11:	78 9d                	js     80102eb0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102f13:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102f17:	89 fa                	mov    %edi,%edx
80102f19:	0f b6 fa             	movzbl %dl,%edi
80102f1c:	89 f2                	mov    %esi,%edx
80102f1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102f21:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102f25:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f28:	89 da                	mov    %ebx,%edx
80102f2a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102f2d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102f30:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102f34:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102f37:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102f3a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102f3e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102f41:	31 c0                	xor    %eax,%eax
80102f43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f44:	89 ca                	mov    %ecx,%edx
80102f46:	ec                   	in     (%dx),%al
80102f47:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f4a:	89 da                	mov    %ebx,%edx
80102f4c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102f4f:	b8 02 00 00 00       	mov    $0x2,%eax
80102f54:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f55:	89 ca                	mov    %ecx,%edx
80102f57:	ec                   	in     (%dx),%al
80102f58:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f5b:	89 da                	mov    %ebx,%edx
80102f5d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102f60:	b8 04 00 00 00       	mov    $0x4,%eax
80102f65:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f66:	89 ca                	mov    %ecx,%edx
80102f68:	ec                   	in     (%dx),%al
80102f69:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f6c:	89 da                	mov    %ebx,%edx
80102f6e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102f71:	b8 07 00 00 00       	mov    $0x7,%eax
80102f76:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f77:	89 ca                	mov    %ecx,%edx
80102f79:	ec                   	in     (%dx),%al
80102f7a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f7d:	89 da                	mov    %ebx,%edx
80102f7f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f82:	b8 08 00 00 00       	mov    $0x8,%eax
80102f87:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f88:	89 ca                	mov    %ecx,%edx
80102f8a:	ec                   	in     (%dx),%al
80102f8b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f8e:	89 da                	mov    %ebx,%edx
80102f90:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102f93:	b8 09 00 00 00       	mov    $0x9,%eax
80102f98:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f99:	89 ca                	mov    %ecx,%edx
80102f9b:	ec                   	in     (%dx),%al
80102f9c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f9f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102fa2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102fa5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102fa8:	6a 18                	push   $0x18
80102faa:	50                   	push   %eax
80102fab:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102fae:	50                   	push   %eax
80102faf:	e8 dc 29 00 00       	call   80105990 <memcmp>
80102fb4:	83 c4 10             	add    $0x10,%esp
80102fb7:	85 c0                	test   %eax,%eax
80102fb9:	0f 85 f1 fe ff ff    	jne    80102eb0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102fbf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102fc3:	75 78                	jne    8010303d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102fc5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102fc8:	89 c2                	mov    %eax,%edx
80102fca:	83 e0 0f             	and    $0xf,%eax
80102fcd:	c1 ea 04             	shr    $0x4,%edx
80102fd0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fd3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fd6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102fd9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102fdc:	89 c2                	mov    %eax,%edx
80102fde:	83 e0 0f             	and    $0xf,%eax
80102fe1:	c1 ea 04             	shr    $0x4,%edx
80102fe4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fe7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fea:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102fed:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ff0:	89 c2                	mov    %eax,%edx
80102ff2:	83 e0 0f             	and    $0xf,%eax
80102ff5:	c1 ea 04             	shr    $0x4,%edx
80102ff8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ffb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ffe:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103001:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103004:	89 c2                	mov    %eax,%edx
80103006:	83 e0 0f             	and    $0xf,%eax
80103009:	c1 ea 04             	shr    $0x4,%edx
8010300c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010300f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103012:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103015:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103018:	89 c2                	mov    %eax,%edx
8010301a:	83 e0 0f             	and    $0xf,%eax
8010301d:	c1 ea 04             	shr    $0x4,%edx
80103020:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103023:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103026:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103029:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010302c:	89 c2                	mov    %eax,%edx
8010302e:	83 e0 0f             	and    $0xf,%eax
80103031:	c1 ea 04             	shr    $0x4,%edx
80103034:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103037:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010303a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010303d:	8b 75 08             	mov    0x8(%ebp),%esi
80103040:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103043:	89 06                	mov    %eax,(%esi)
80103045:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103048:	89 46 04             	mov    %eax,0x4(%esi)
8010304b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010304e:	89 46 08             	mov    %eax,0x8(%esi)
80103051:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103054:	89 46 0c             	mov    %eax,0xc(%esi)
80103057:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010305a:	89 46 10             	mov    %eax,0x10(%esi)
8010305d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103060:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103063:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010306a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010306d:	5b                   	pop    %ebx
8010306e:	5e                   	pop    %esi
8010306f:	5f                   	pop    %edi
80103070:	5d                   	pop    %ebp
80103071:	c3                   	ret    
80103072:	66 90                	xchg   %ax,%ax
80103074:	66 90                	xchg   %ax,%ax
80103076:	66 90                	xchg   %ax,%ax
80103078:	66 90                	xchg   %ax,%ax
8010307a:	66 90                	xchg   %ax,%ax
8010307c:	66 90                	xchg   %ax,%ax
8010307e:	66 90                	xchg   %ax,%ax

80103080 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103080:	8b 0d 68 4c 11 80    	mov    0x80114c68,%ecx
80103086:	85 c9                	test   %ecx,%ecx
80103088:	0f 8e 8a 00 00 00    	jle    80103118 <install_trans+0x98>
{
8010308e:	55                   	push   %ebp
8010308f:	89 e5                	mov    %esp,%ebp
80103091:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103092:	31 ff                	xor    %edi,%edi
{
80103094:	56                   	push   %esi
80103095:	53                   	push   %ebx
80103096:	83 ec 0c             	sub    $0xc,%esp
80103099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801030a0:	a1 54 4c 11 80       	mov    0x80114c54,%eax
801030a5:	83 ec 08             	sub    $0x8,%esp
801030a8:	01 f8                	add    %edi,%eax
801030aa:	83 c0 01             	add    $0x1,%eax
801030ad:	50                   	push   %eax
801030ae:	ff 35 64 4c 11 80    	pushl  0x80114c64
801030b4:	e8 17 d0 ff ff       	call   801000d0 <bread>
801030b9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030bb:	58                   	pop    %eax
801030bc:	5a                   	pop    %edx
801030bd:	ff 34 bd 6c 4c 11 80 	pushl  -0x7feeb394(,%edi,4)
801030c4:	ff 35 64 4c 11 80    	pushl  0x80114c64
  for (tail = 0; tail < log.lh.n; tail++) {
801030ca:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030cd:	e8 fe cf ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030d2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030d5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030d7:	8d 46 5c             	lea    0x5c(%esi),%eax
801030da:	68 00 02 00 00       	push   $0x200
801030df:	50                   	push   %eax
801030e0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801030e3:	50                   	push   %eax
801030e4:	e8 f7 28 00 00       	call   801059e0 <memmove>
    bwrite(dbuf);  // write dst to disk
801030e9:	89 1c 24             	mov    %ebx,(%esp)
801030ec:	e8 bf d0 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801030f1:	89 34 24             	mov    %esi,(%esp)
801030f4:	e8 f7 d0 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801030f9:	89 1c 24             	mov    %ebx,(%esp)
801030fc:	e8 ef d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103101:	83 c4 10             	add    $0x10,%esp
80103104:	39 3d 68 4c 11 80    	cmp    %edi,0x80114c68
8010310a:	7f 94                	jg     801030a0 <install_trans+0x20>
  }
}
8010310c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010310f:	5b                   	pop    %ebx
80103110:	5e                   	pop    %esi
80103111:	5f                   	pop    %edi
80103112:	5d                   	pop    %ebp
80103113:	c3                   	ret    
80103114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103118:	c3                   	ret    
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103120 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	53                   	push   %ebx
80103124:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103127:	ff 35 54 4c 11 80    	pushl  0x80114c54
8010312d:	ff 35 64 4c 11 80    	pushl  0x80114c64
80103133:	e8 98 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103138:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010313b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010313d:	a1 68 4c 11 80       	mov    0x80114c68,%eax
80103142:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103145:	85 c0                	test   %eax,%eax
80103147:	7e 19                	jle    80103162 <write_head+0x42>
80103149:	31 d2                	xor    %edx,%edx
8010314b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010314f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103150:	8b 0c 95 6c 4c 11 80 	mov    -0x7feeb394(,%edx,4),%ecx
80103157:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010315b:	83 c2 01             	add    $0x1,%edx
8010315e:	39 d0                	cmp    %edx,%eax
80103160:	75 ee                	jne    80103150 <write_head+0x30>
  }
  bwrite(buf);
80103162:	83 ec 0c             	sub    $0xc,%esp
80103165:	53                   	push   %ebx
80103166:	e8 45 d0 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010316b:	89 1c 24             	mov    %ebx,(%esp)
8010316e:	e8 7d d0 ff ff       	call   801001f0 <brelse>
}
80103173:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103176:	83 c4 10             	add    $0x10,%esp
80103179:	c9                   	leave  
8010317a:	c3                   	ret    
8010317b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010317f:	90                   	nop

80103180 <initlog>:
{
80103180:	f3 0f 1e fb          	endbr32 
80103184:	55                   	push   %ebp
80103185:	89 e5                	mov    %esp,%ebp
80103187:	53                   	push   %ebx
80103188:	83 ec 2c             	sub    $0x2c,%esp
8010318b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010318e:	68 a0 8c 10 80       	push   $0x80108ca0
80103193:	68 20 4c 11 80       	push   $0x80114c20
80103198:	e8 13 25 00 00       	call   801056b0 <initlock>
  readsb(dev, &sb);
8010319d:	58                   	pop    %eax
8010319e:	8d 45 dc             	lea    -0x24(%ebp),%eax
801031a1:	5a                   	pop    %edx
801031a2:	50                   	push   %eax
801031a3:	53                   	push   %ebx
801031a4:	e8 47 e8 ff ff       	call   801019f0 <readsb>
  log.start = sb.logstart;
801031a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801031ac:	59                   	pop    %ecx
  log.dev = dev;
801031ad:	89 1d 64 4c 11 80    	mov    %ebx,0x80114c64
  log.size = sb.nlog;
801031b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801031b6:	a3 54 4c 11 80       	mov    %eax,0x80114c54
  log.size = sb.nlog;
801031bb:	89 15 58 4c 11 80    	mov    %edx,0x80114c58
  struct buf *buf = bread(log.dev, log.start);
801031c1:	5a                   	pop    %edx
801031c2:	50                   	push   %eax
801031c3:	53                   	push   %ebx
801031c4:	e8 07 cf ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801031c9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801031cc:	8b 48 5c             	mov    0x5c(%eax),%ecx
801031cf:	89 0d 68 4c 11 80    	mov    %ecx,0x80114c68
  for (i = 0; i < log.lh.n; i++) {
801031d5:	85 c9                	test   %ecx,%ecx
801031d7:	7e 19                	jle    801031f2 <initlog+0x72>
801031d9:	31 d2                	xor    %edx,%edx
801031db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031df:	90                   	nop
    log.lh.block[i] = lh->block[i];
801031e0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
801031e4:	89 1c 95 6c 4c 11 80 	mov    %ebx,-0x7feeb394(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801031eb:	83 c2 01             	add    $0x1,%edx
801031ee:	39 d1                	cmp    %edx,%ecx
801031f0:	75 ee                	jne    801031e0 <initlog+0x60>
  brelse(buf);
801031f2:	83 ec 0c             	sub    $0xc,%esp
801031f5:	50                   	push   %eax
801031f6:	e8 f5 cf ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801031fb:	e8 80 fe ff ff       	call   80103080 <install_trans>
  log.lh.n = 0;
80103200:	c7 05 68 4c 11 80 00 	movl   $0x0,0x80114c68
80103207:	00 00 00 
  write_head(); // clear the log
8010320a:	e8 11 ff ff ff       	call   80103120 <write_head>
}
8010320f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103212:	83 c4 10             	add    $0x10,%esp
80103215:	c9                   	leave  
80103216:	c3                   	ret    
80103217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010321e:	66 90                	xchg   %ax,%ax

80103220 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103220:	f3 0f 1e fb          	endbr32 
80103224:	55                   	push   %ebp
80103225:	89 e5                	mov    %esp,%ebp
80103227:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010322a:	68 20 4c 11 80       	push   $0x80114c20
8010322f:	e8 fc 25 00 00       	call   80105830 <acquire>
80103234:	83 c4 10             	add    $0x10,%esp
80103237:	eb 1c                	jmp    80103255 <begin_op+0x35>
80103239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103240:	83 ec 08             	sub    $0x8,%esp
80103243:	68 20 4c 11 80       	push   $0x80114c20
80103248:	68 20 4c 11 80       	push   $0x80114c20
8010324d:	e8 3e 12 00 00       	call   80104490 <sleep>
80103252:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103255:	a1 60 4c 11 80       	mov    0x80114c60,%eax
8010325a:	85 c0                	test   %eax,%eax
8010325c:	75 e2                	jne    80103240 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010325e:	a1 5c 4c 11 80       	mov    0x80114c5c,%eax
80103263:	8b 15 68 4c 11 80    	mov    0x80114c68,%edx
80103269:	83 c0 01             	add    $0x1,%eax
8010326c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010326f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103272:	83 fa 1e             	cmp    $0x1e,%edx
80103275:	7f c9                	jg     80103240 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103277:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010327a:	a3 5c 4c 11 80       	mov    %eax,0x80114c5c
      release(&log.lock);
8010327f:	68 20 4c 11 80       	push   $0x80114c20
80103284:	e8 67 26 00 00       	call   801058f0 <release>
      break;
    }
  }
}
80103289:	83 c4 10             	add    $0x10,%esp
8010328c:	c9                   	leave  
8010328d:	c3                   	ret    
8010328e:	66 90                	xchg   %ax,%ax

80103290 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103290:	f3 0f 1e fb          	endbr32 
80103294:	55                   	push   %ebp
80103295:	89 e5                	mov    %esp,%ebp
80103297:	57                   	push   %edi
80103298:	56                   	push   %esi
80103299:	53                   	push   %ebx
8010329a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010329d:	68 20 4c 11 80       	push   $0x80114c20
801032a2:	e8 89 25 00 00       	call   80105830 <acquire>
  log.outstanding -= 1;
801032a7:	a1 5c 4c 11 80       	mov    0x80114c5c,%eax
  if(log.committing)
801032ac:	8b 35 60 4c 11 80    	mov    0x80114c60,%esi
801032b2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801032b5:	8d 58 ff             	lea    -0x1(%eax),%ebx
801032b8:	89 1d 5c 4c 11 80    	mov    %ebx,0x80114c5c
  if(log.committing)
801032be:	85 f6                	test   %esi,%esi
801032c0:	0f 85 1e 01 00 00    	jne    801033e4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801032c6:	85 db                	test   %ebx,%ebx
801032c8:	0f 85 f2 00 00 00    	jne    801033c0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801032ce:	c7 05 60 4c 11 80 01 	movl   $0x1,0x80114c60
801032d5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801032d8:	83 ec 0c             	sub    $0xc,%esp
801032db:	68 20 4c 11 80       	push   $0x80114c20
801032e0:	e8 0b 26 00 00       	call   801058f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801032e5:	8b 0d 68 4c 11 80    	mov    0x80114c68,%ecx
801032eb:	83 c4 10             	add    $0x10,%esp
801032ee:	85 c9                	test   %ecx,%ecx
801032f0:	7f 3e                	jg     80103330 <end_op+0xa0>
    acquire(&log.lock);
801032f2:	83 ec 0c             	sub    $0xc,%esp
801032f5:	68 20 4c 11 80       	push   $0x80114c20
801032fa:	e8 31 25 00 00       	call   80105830 <acquire>
    wakeup(&log);
801032ff:	c7 04 24 20 4c 11 80 	movl   $0x80114c20,(%esp)
    log.committing = 0;
80103306:	c7 05 60 4c 11 80 00 	movl   $0x0,0x80114c60
8010330d:	00 00 00 
    wakeup(&log);
80103310:	e8 3b 13 00 00       	call   80104650 <wakeup>
    release(&log.lock);
80103315:	c7 04 24 20 4c 11 80 	movl   $0x80114c20,(%esp)
8010331c:	e8 cf 25 00 00       	call   801058f0 <release>
80103321:	83 c4 10             	add    $0x10,%esp
}
80103324:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103327:	5b                   	pop    %ebx
80103328:	5e                   	pop    %esi
80103329:	5f                   	pop    %edi
8010332a:	5d                   	pop    %ebp
8010332b:	c3                   	ret    
8010332c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103330:	a1 54 4c 11 80       	mov    0x80114c54,%eax
80103335:	83 ec 08             	sub    $0x8,%esp
80103338:	01 d8                	add    %ebx,%eax
8010333a:	83 c0 01             	add    $0x1,%eax
8010333d:	50                   	push   %eax
8010333e:	ff 35 64 4c 11 80    	pushl  0x80114c64
80103344:	e8 87 cd ff ff       	call   801000d0 <bread>
80103349:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010334b:	58                   	pop    %eax
8010334c:	5a                   	pop    %edx
8010334d:	ff 34 9d 6c 4c 11 80 	pushl  -0x7feeb394(,%ebx,4)
80103354:	ff 35 64 4c 11 80    	pushl  0x80114c64
  for (tail = 0; tail < log.lh.n; tail++) {
8010335a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010335d:	e8 6e cd ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103362:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103365:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103367:	8d 40 5c             	lea    0x5c(%eax),%eax
8010336a:	68 00 02 00 00       	push   $0x200
8010336f:	50                   	push   %eax
80103370:	8d 46 5c             	lea    0x5c(%esi),%eax
80103373:	50                   	push   %eax
80103374:	e8 67 26 00 00       	call   801059e0 <memmove>
    bwrite(to);  // write the log
80103379:	89 34 24             	mov    %esi,(%esp)
8010337c:	e8 2f ce ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103381:	89 3c 24             	mov    %edi,(%esp)
80103384:	e8 67 ce ff ff       	call   801001f0 <brelse>
    brelse(to);
80103389:	89 34 24             	mov    %esi,(%esp)
8010338c:	e8 5f ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103391:	83 c4 10             	add    $0x10,%esp
80103394:	3b 1d 68 4c 11 80    	cmp    0x80114c68,%ebx
8010339a:	7c 94                	jl     80103330 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010339c:	e8 7f fd ff ff       	call   80103120 <write_head>
    install_trans(); // Now install writes to home locations
801033a1:	e8 da fc ff ff       	call   80103080 <install_trans>
    log.lh.n = 0;
801033a6:	c7 05 68 4c 11 80 00 	movl   $0x0,0x80114c68
801033ad:	00 00 00 
    write_head();    // Erase the transaction from the log
801033b0:	e8 6b fd ff ff       	call   80103120 <write_head>
801033b5:	e9 38 ff ff ff       	jmp    801032f2 <end_op+0x62>
801033ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801033c0:	83 ec 0c             	sub    $0xc,%esp
801033c3:	68 20 4c 11 80       	push   $0x80114c20
801033c8:	e8 83 12 00 00       	call   80104650 <wakeup>
  release(&log.lock);
801033cd:	c7 04 24 20 4c 11 80 	movl   $0x80114c20,(%esp)
801033d4:	e8 17 25 00 00       	call   801058f0 <release>
801033d9:	83 c4 10             	add    $0x10,%esp
}
801033dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033df:	5b                   	pop    %ebx
801033e0:	5e                   	pop    %esi
801033e1:	5f                   	pop    %edi
801033e2:	5d                   	pop    %ebp
801033e3:	c3                   	ret    
    panic("log.committing");
801033e4:	83 ec 0c             	sub    $0xc,%esp
801033e7:	68 a4 8c 10 80       	push   $0x80108ca4
801033ec:	e8 9f cf ff ff       	call   80100390 <panic>
801033f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ff:	90                   	nop

80103400 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103400:	f3 0f 1e fb          	endbr32 
80103404:	55                   	push   %ebp
80103405:	89 e5                	mov    %esp,%ebp
80103407:	53                   	push   %ebx
80103408:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010340b:	8b 15 68 4c 11 80    	mov    0x80114c68,%edx
{
80103411:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103414:	83 fa 1d             	cmp    $0x1d,%edx
80103417:	0f 8f 91 00 00 00    	jg     801034ae <log_write+0xae>
8010341d:	a1 58 4c 11 80       	mov    0x80114c58,%eax
80103422:	83 e8 01             	sub    $0x1,%eax
80103425:	39 c2                	cmp    %eax,%edx
80103427:	0f 8d 81 00 00 00    	jge    801034ae <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010342d:	a1 5c 4c 11 80       	mov    0x80114c5c,%eax
80103432:	85 c0                	test   %eax,%eax
80103434:	0f 8e 81 00 00 00    	jle    801034bb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010343a:	83 ec 0c             	sub    $0xc,%esp
8010343d:	68 20 4c 11 80       	push   $0x80114c20
80103442:	e8 e9 23 00 00       	call   80105830 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103447:	8b 15 68 4c 11 80    	mov    0x80114c68,%edx
8010344d:	83 c4 10             	add    $0x10,%esp
80103450:	85 d2                	test   %edx,%edx
80103452:	7e 4e                	jle    801034a2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103454:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103457:	31 c0                	xor    %eax,%eax
80103459:	eb 0c                	jmp    80103467 <log_write+0x67>
8010345b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010345f:	90                   	nop
80103460:	83 c0 01             	add    $0x1,%eax
80103463:	39 c2                	cmp    %eax,%edx
80103465:	74 29                	je     80103490 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103467:	39 0c 85 6c 4c 11 80 	cmp    %ecx,-0x7feeb394(,%eax,4)
8010346e:	75 f0                	jne    80103460 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103470:	89 0c 85 6c 4c 11 80 	mov    %ecx,-0x7feeb394(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103477:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010347a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010347d:	c7 45 08 20 4c 11 80 	movl   $0x80114c20,0x8(%ebp)
}
80103484:	c9                   	leave  
  release(&log.lock);
80103485:	e9 66 24 00 00       	jmp    801058f0 <release>
8010348a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103490:	89 0c 95 6c 4c 11 80 	mov    %ecx,-0x7feeb394(,%edx,4)
    log.lh.n++;
80103497:	83 c2 01             	add    $0x1,%edx
8010349a:	89 15 68 4c 11 80    	mov    %edx,0x80114c68
801034a0:	eb d5                	jmp    80103477 <log_write+0x77>
  log.lh.block[i] = b->blockno;
801034a2:	8b 43 08             	mov    0x8(%ebx),%eax
801034a5:	a3 6c 4c 11 80       	mov    %eax,0x80114c6c
  if (i == log.lh.n)
801034aa:	75 cb                	jne    80103477 <log_write+0x77>
801034ac:	eb e9                	jmp    80103497 <log_write+0x97>
    panic("too big a transaction");
801034ae:	83 ec 0c             	sub    $0xc,%esp
801034b1:	68 b3 8c 10 80       	push   $0x80108cb3
801034b6:	e8 d5 ce ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801034bb:	83 ec 0c             	sub    $0xc,%esp
801034be:	68 c9 8c 10 80       	push   $0x80108cc9
801034c3:	e8 c8 ce ff ff       	call   80100390 <panic>
801034c8:	66 90                	xchg   %ax,%ax
801034ca:	66 90                	xchg   %ax,%ax
801034cc:	66 90                	xchg   %ax,%ax
801034ce:	66 90                	xchg   %ax,%ax

801034d0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	53                   	push   %ebx
801034d4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801034d7:	e8 b4 09 00 00       	call   80103e90 <cpuid>
801034dc:	89 c3                	mov    %eax,%ebx
801034de:	e8 ad 09 00 00       	call   80103e90 <cpuid>
801034e3:	83 ec 04             	sub    $0x4,%esp
801034e6:	53                   	push   %ebx
801034e7:	50                   	push   %eax
801034e8:	68 e4 8c 10 80       	push   $0x80108ce4
801034ed:	e8 ce d3 ff ff       	call   801008c0 <cprintf>
  idtinit();       // load idt register
801034f2:	e8 d9 3a 00 00       	call   80106fd0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801034f7:	e8 24 09 00 00       	call   80103e20 <mycpu>
801034fc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801034fe:	b8 01 00 00 00       	mov    $0x1,%eax
80103503:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010350a:	e8 81 0b 00 00       	call   80104090 <scheduler>
8010350f:	90                   	nop

80103510 <mpenter>:
{
80103510:	f3 0f 1e fb          	endbr32 
80103514:	55                   	push   %ebp
80103515:	89 e5                	mov    %esp,%ebp
80103517:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010351a:	e8 91 4b 00 00       	call   801080b0 <switchkvm>
  seginit();
8010351f:	e8 fc 4a 00 00       	call   80108020 <seginit>
  lapicinit();
80103524:	e8 67 f7 ff ff       	call   80102c90 <lapicinit>
  mpmain();
80103529:	e8 a2 ff ff ff       	call   801034d0 <mpmain>
8010352e:	66 90                	xchg   %ax,%ax

80103530 <main>:
{
80103530:	f3 0f 1e fb          	endbr32 
80103534:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103538:	83 e4 f0             	and    $0xfffffff0,%esp
8010353b:	ff 71 fc             	pushl  -0x4(%ecx)
8010353e:	55                   	push   %ebp
8010353f:	89 e5                	mov    %esp,%ebp
80103541:	53                   	push   %ebx
80103542:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103543:	83 ec 08             	sub    $0x8,%esp
80103546:	68 00 00 40 80       	push   $0x80400000
8010354b:	68 48 86 11 80       	push   $0x80118648
80103550:	e8 fb f4 ff ff       	call   80102a50 <kinit1>
  kvmalloc();      // kernel page table
80103555:	e8 36 50 00 00       	call   80108590 <kvmalloc>
  mpinit();        // detect other processors
8010355a:	e8 81 01 00 00       	call   801036e0 <mpinit>
  lapicinit();     // interrupt controller
8010355f:	e8 2c f7 ff ff       	call   80102c90 <lapicinit>
  seginit();       // segment descriptors
80103564:	e8 b7 4a 00 00       	call   80108020 <seginit>
  picinit();       // disable pic
80103569:	e8 52 03 00 00       	call   801038c0 <picinit>
  ioapicinit();    // another interrupt controller
8010356e:	e8 fd f2 ff ff       	call   80102870 <ioapicinit>
  consoleinit();   // console hardware
80103573:	e8 a8 d9 ff ff       	call   80100f20 <consoleinit>
  uartinit();      // serial port
80103578:	e8 63 3d 00 00       	call   801072e0 <uartinit>
  pinit();         // process table
8010357d:	e8 7e 08 00 00       	call   80103e00 <pinit>
  tvinit();        // trap vectors
80103582:	e8 c9 39 00 00       	call   80106f50 <tvinit>
  binit();         // buffer cache
80103587:	e8 b4 ca ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010358c:	e8 3f dd ff ff       	call   801012d0 <fileinit>
  ideinit();       // disk 
80103591:	e8 aa f0 ff ff       	call   80102640 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103596:	83 c4 0c             	add    $0xc,%esp
80103599:	68 8a 00 00 00       	push   $0x8a
8010359e:	68 8c c4 10 80       	push   $0x8010c48c
801035a3:	68 00 70 00 80       	push   $0x80007000
801035a8:	e8 33 24 00 00       	call   801059e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801035ad:	83 c4 10             	add    $0x10,%esp
801035b0:	69 05 a0 52 11 80 b0 	imul   $0xb0,0x801152a0,%eax
801035b7:	00 00 00 
801035ba:	05 20 4d 11 80       	add    $0x80114d20,%eax
801035bf:	3d 20 4d 11 80       	cmp    $0x80114d20,%eax
801035c4:	76 7a                	jbe    80103640 <main+0x110>
801035c6:	bb 20 4d 11 80       	mov    $0x80114d20,%ebx
801035cb:	eb 1c                	jmp    801035e9 <main+0xb9>
801035cd:	8d 76 00             	lea    0x0(%esi),%esi
801035d0:	69 05 a0 52 11 80 b0 	imul   $0xb0,0x801152a0,%eax
801035d7:	00 00 00 
801035da:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801035e0:	05 20 4d 11 80       	add    $0x80114d20,%eax
801035e5:	39 c3                	cmp    %eax,%ebx
801035e7:	73 57                	jae    80103640 <main+0x110>
    if(c == mycpu())  // We've started already.
801035e9:	e8 32 08 00 00       	call   80103e20 <mycpu>
801035ee:	39 c3                	cmp    %eax,%ebx
801035f0:	74 de                	je     801035d0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801035f2:	e8 29 f5 ff ff       	call   80102b20 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801035f7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801035fa:	c7 05 f8 6f 00 80 10 	movl   $0x80103510,0x80006ff8
80103601:	35 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103604:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
8010360b:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010360e:	05 00 10 00 00       	add    $0x1000,%eax
80103613:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103618:	0f b6 03             	movzbl (%ebx),%eax
8010361b:	68 00 70 00 00       	push   $0x7000
80103620:	50                   	push   %eax
80103621:	e8 ba f7 ff ff       	call   80102de0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103626:	83 c4 10             	add    $0x10,%esp
80103629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103630:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103636:	85 c0                	test   %eax,%eax
80103638:	74 f6                	je     80103630 <main+0x100>
8010363a:	eb 94                	jmp    801035d0 <main+0xa0>
8010363c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103640:	83 ec 08             	sub    $0x8,%esp
80103643:	68 00 00 00 8e       	push   $0x8e000000
80103648:	68 00 00 40 80       	push   $0x80400000
8010364d:	e8 6e f4 ff ff       	call   80102ac0 <kinit2>
  userinit();      // first user process
80103652:	e8 e9 13 00 00       	call   80104a40 <userinit>
  mpmain();        // finish this processor's setup
80103657:	e8 74 fe ff ff       	call   801034d0 <mpmain>
8010365c:	66 90                	xchg   %ax,%ax
8010365e:	66 90                	xchg   %ax,%ax

80103660 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	57                   	push   %edi
80103664:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103665:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010366b:	53                   	push   %ebx
  e = addr+len;
8010366c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010366f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103672:	39 de                	cmp    %ebx,%esi
80103674:	72 10                	jb     80103686 <mpsearch1+0x26>
80103676:	eb 50                	jmp    801036c8 <mpsearch1+0x68>
80103678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010367f:	90                   	nop
80103680:	89 fe                	mov    %edi,%esi
80103682:	39 fb                	cmp    %edi,%ebx
80103684:	76 42                	jbe    801036c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103686:	83 ec 04             	sub    $0x4,%esp
80103689:	8d 7e 10             	lea    0x10(%esi),%edi
8010368c:	6a 04                	push   $0x4
8010368e:	68 f8 8c 10 80       	push   $0x80108cf8
80103693:	56                   	push   %esi
80103694:	e8 f7 22 00 00       	call   80105990 <memcmp>
80103699:	83 c4 10             	add    $0x10,%esp
8010369c:	85 c0                	test   %eax,%eax
8010369e:	75 e0                	jne    80103680 <mpsearch1+0x20>
801036a0:	89 f2                	mov    %esi,%edx
801036a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801036a8:	0f b6 0a             	movzbl (%edx),%ecx
801036ab:	83 c2 01             	add    $0x1,%edx
801036ae:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801036b0:	39 fa                	cmp    %edi,%edx
801036b2:	75 f4                	jne    801036a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036b4:	84 c0                	test   %al,%al
801036b6:	75 c8                	jne    80103680 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801036b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036bb:	89 f0                	mov    %esi,%eax
801036bd:	5b                   	pop    %ebx
801036be:	5e                   	pop    %esi
801036bf:	5f                   	pop    %edi
801036c0:	5d                   	pop    %ebp
801036c1:	c3                   	ret    
801036c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036cb:	31 f6                	xor    %esi,%esi
}
801036cd:	5b                   	pop    %ebx
801036ce:	89 f0                	mov    %esi,%eax
801036d0:	5e                   	pop    %esi
801036d1:	5f                   	pop    %edi
801036d2:	5d                   	pop    %ebp
801036d3:	c3                   	ret    
801036d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036df:	90                   	nop

801036e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801036e0:	f3 0f 1e fb          	endbr32 
801036e4:	55                   	push   %ebp
801036e5:	89 e5                	mov    %esp,%ebp
801036e7:	57                   	push   %edi
801036e8:	56                   	push   %esi
801036e9:	53                   	push   %ebx
801036ea:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801036ed:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801036f4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801036fb:	c1 e0 08             	shl    $0x8,%eax
801036fe:	09 d0                	or     %edx,%eax
80103700:	c1 e0 04             	shl    $0x4,%eax
80103703:	75 1b                	jne    80103720 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103705:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010370c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103713:	c1 e0 08             	shl    $0x8,%eax
80103716:	09 d0                	or     %edx,%eax
80103718:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010371b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103720:	ba 00 04 00 00       	mov    $0x400,%edx
80103725:	e8 36 ff ff ff       	call   80103660 <mpsearch1>
8010372a:	89 c6                	mov    %eax,%esi
8010372c:	85 c0                	test   %eax,%eax
8010372e:	0f 84 4c 01 00 00    	je     80103880 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103734:	8b 5e 04             	mov    0x4(%esi),%ebx
80103737:	85 db                	test   %ebx,%ebx
80103739:	0f 84 61 01 00 00    	je     801038a0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010373f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103742:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103748:	6a 04                	push   $0x4
8010374a:	68 fd 8c 10 80       	push   $0x80108cfd
8010374f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103750:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103753:	e8 38 22 00 00       	call   80105990 <memcmp>
80103758:	83 c4 10             	add    $0x10,%esp
8010375b:	85 c0                	test   %eax,%eax
8010375d:	0f 85 3d 01 00 00    	jne    801038a0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103763:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010376a:	3c 01                	cmp    $0x1,%al
8010376c:	74 08                	je     80103776 <mpinit+0x96>
8010376e:	3c 04                	cmp    $0x4,%al
80103770:	0f 85 2a 01 00 00    	jne    801038a0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103776:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010377d:	66 85 d2             	test   %dx,%dx
80103780:	74 26                	je     801037a8 <mpinit+0xc8>
80103782:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103785:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103787:	31 d2                	xor    %edx,%edx
80103789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103790:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103797:	83 c0 01             	add    $0x1,%eax
8010379a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010379c:	39 f8                	cmp    %edi,%eax
8010379e:	75 f0                	jne    80103790 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801037a0:	84 d2                	test   %dl,%dl
801037a2:	0f 85 f8 00 00 00    	jne    801038a0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801037a8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801037ae:	a3 1c 4c 11 80       	mov    %eax,0x80114c1c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037b3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801037b9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801037c0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037c5:	03 55 e4             	add    -0x1c(%ebp),%edx
801037c8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
801037d0:	39 c2                	cmp    %eax,%edx
801037d2:	76 15                	jbe    801037e9 <mpinit+0x109>
    switch(*p){
801037d4:	0f b6 08             	movzbl (%eax),%ecx
801037d7:	80 f9 02             	cmp    $0x2,%cl
801037da:	74 5c                	je     80103838 <mpinit+0x158>
801037dc:	77 42                	ja     80103820 <mpinit+0x140>
801037de:	84 c9                	test   %cl,%cl
801037e0:	74 6e                	je     80103850 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801037e2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037e5:	39 c2                	cmp    %eax,%edx
801037e7:	77 eb                	ja     801037d4 <mpinit+0xf4>
801037e9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801037ec:	85 db                	test   %ebx,%ebx
801037ee:	0f 84 b9 00 00 00    	je     801038ad <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801037f4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
801037f8:	74 15                	je     8010380f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037fa:	b8 70 00 00 00       	mov    $0x70,%eax
801037ff:	ba 22 00 00 00       	mov    $0x22,%edx
80103804:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103805:	ba 23 00 00 00       	mov    $0x23,%edx
8010380a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010380b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010380e:	ee                   	out    %al,(%dx)
  }
}
8010380f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103812:	5b                   	pop    %ebx
80103813:	5e                   	pop    %esi
80103814:	5f                   	pop    %edi
80103815:	5d                   	pop    %ebp
80103816:	c3                   	ret    
80103817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010381e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103820:	83 e9 03             	sub    $0x3,%ecx
80103823:	80 f9 01             	cmp    $0x1,%cl
80103826:	76 ba                	jbe    801037e2 <mpinit+0x102>
80103828:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010382f:	eb 9f                	jmp    801037d0 <mpinit+0xf0>
80103831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103838:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010383c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010383f:	88 0d 00 4d 11 80    	mov    %cl,0x80114d00
      continue;
80103845:	eb 89                	jmp    801037d0 <mpinit+0xf0>
80103847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010384e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103850:	8b 0d a0 52 11 80    	mov    0x801152a0,%ecx
80103856:	83 f9 07             	cmp    $0x7,%ecx
80103859:	7f 19                	jg     80103874 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010385b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103861:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103865:	83 c1 01             	add    $0x1,%ecx
80103868:	89 0d a0 52 11 80    	mov    %ecx,0x801152a0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010386e:	88 9f 20 4d 11 80    	mov    %bl,-0x7feeb2e0(%edi)
      p += sizeof(struct mpproc);
80103874:	83 c0 14             	add    $0x14,%eax
      continue;
80103877:	e9 54 ff ff ff       	jmp    801037d0 <mpinit+0xf0>
8010387c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103880:	ba 00 00 01 00       	mov    $0x10000,%edx
80103885:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010388a:	e8 d1 fd ff ff       	call   80103660 <mpsearch1>
8010388f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103891:	85 c0                	test   %eax,%eax
80103893:	0f 85 9b fe ff ff    	jne    80103734 <mpinit+0x54>
80103899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801038a0:	83 ec 0c             	sub    $0xc,%esp
801038a3:	68 02 8d 10 80       	push   $0x80108d02
801038a8:	e8 e3 ca ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801038ad:	83 ec 0c             	sub    $0xc,%esp
801038b0:	68 1c 8d 10 80       	push   $0x80108d1c
801038b5:	e8 d6 ca ff ff       	call   80100390 <panic>
801038ba:	66 90                	xchg   %ax,%ax
801038bc:	66 90                	xchg   %ax,%ax
801038be:	66 90                	xchg   %ax,%ax

801038c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801038c0:	f3 0f 1e fb          	endbr32 
801038c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038c9:	ba 21 00 00 00       	mov    $0x21,%edx
801038ce:	ee                   	out    %al,(%dx)
801038cf:	ba a1 00 00 00       	mov    $0xa1,%edx
801038d4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801038d5:	c3                   	ret    
801038d6:	66 90                	xchg   %ax,%ax
801038d8:	66 90                	xchg   %ax,%ax
801038da:	66 90                	xchg   %ax,%ax
801038dc:	66 90                	xchg   %ax,%ax
801038de:	66 90                	xchg   %ax,%ax

801038e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801038e0:	f3 0f 1e fb          	endbr32 
801038e4:	55                   	push   %ebp
801038e5:	89 e5                	mov    %esp,%ebp
801038e7:	57                   	push   %edi
801038e8:	56                   	push   %esi
801038e9:	53                   	push   %ebx
801038ea:	83 ec 0c             	sub    $0xc,%esp
801038ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
801038f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801038f3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801038f9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801038ff:	e8 ec d9 ff ff       	call   801012f0 <filealloc>
80103904:	89 03                	mov    %eax,(%ebx)
80103906:	85 c0                	test   %eax,%eax
80103908:	0f 84 ac 00 00 00    	je     801039ba <pipealloc+0xda>
8010390e:	e8 dd d9 ff ff       	call   801012f0 <filealloc>
80103913:	89 06                	mov    %eax,(%esi)
80103915:	85 c0                	test   %eax,%eax
80103917:	0f 84 8b 00 00 00    	je     801039a8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010391d:	e8 fe f1 ff ff       	call   80102b20 <kalloc>
80103922:	89 c7                	mov    %eax,%edi
80103924:	85 c0                	test   %eax,%eax
80103926:	0f 84 b4 00 00 00    	je     801039e0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010392c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103933:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103936:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103939:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103940:	00 00 00 
  p->nwrite = 0;
80103943:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010394a:	00 00 00 
  p->nread = 0;
8010394d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103954:	00 00 00 
  initlock(&p->lock, "pipe");
80103957:	68 3b 8d 10 80       	push   $0x80108d3b
8010395c:	50                   	push   %eax
8010395d:	e8 4e 1d 00 00       	call   801056b0 <initlock>
  (*f0)->type = FD_PIPE;
80103962:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103964:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103967:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010396d:	8b 03                	mov    (%ebx),%eax
8010396f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103973:	8b 03                	mov    (%ebx),%eax
80103975:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103979:	8b 03                	mov    (%ebx),%eax
8010397b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010397e:	8b 06                	mov    (%esi),%eax
80103980:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103986:	8b 06                	mov    (%esi),%eax
80103988:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010398c:	8b 06                	mov    (%esi),%eax
8010398e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103992:	8b 06                	mov    (%esi),%eax
80103994:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103997:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010399a:	31 c0                	xor    %eax,%eax
}
8010399c:	5b                   	pop    %ebx
8010399d:	5e                   	pop    %esi
8010399e:	5f                   	pop    %edi
8010399f:	5d                   	pop    %ebp
801039a0:	c3                   	ret    
801039a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801039a8:	8b 03                	mov    (%ebx),%eax
801039aa:	85 c0                	test   %eax,%eax
801039ac:	74 1e                	je     801039cc <pipealloc+0xec>
    fileclose(*f0);
801039ae:	83 ec 0c             	sub    $0xc,%esp
801039b1:	50                   	push   %eax
801039b2:	e8 f9 d9 ff ff       	call   801013b0 <fileclose>
801039b7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801039ba:	8b 06                	mov    (%esi),%eax
801039bc:	85 c0                	test   %eax,%eax
801039be:	74 0c                	je     801039cc <pipealloc+0xec>
    fileclose(*f1);
801039c0:	83 ec 0c             	sub    $0xc,%esp
801039c3:	50                   	push   %eax
801039c4:	e8 e7 d9 ff ff       	call   801013b0 <fileclose>
801039c9:	83 c4 10             	add    $0x10,%esp
}
801039cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801039cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801039d4:	5b                   	pop    %ebx
801039d5:	5e                   	pop    %esi
801039d6:	5f                   	pop    %edi
801039d7:	5d                   	pop    %ebp
801039d8:	c3                   	ret    
801039d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801039e0:	8b 03                	mov    (%ebx),%eax
801039e2:	85 c0                	test   %eax,%eax
801039e4:	75 c8                	jne    801039ae <pipealloc+0xce>
801039e6:	eb d2                	jmp    801039ba <pipealloc+0xda>
801039e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ef:	90                   	nop

801039f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801039f0:	f3 0f 1e fb          	endbr32 
801039f4:	55                   	push   %ebp
801039f5:	89 e5                	mov    %esp,%ebp
801039f7:	56                   	push   %esi
801039f8:	53                   	push   %ebx
801039f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801039fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801039ff:	83 ec 0c             	sub    $0xc,%esp
80103a02:	53                   	push   %ebx
80103a03:	e8 28 1e 00 00       	call   80105830 <acquire>
  if(writable){
80103a08:	83 c4 10             	add    $0x10,%esp
80103a0b:	85 f6                	test   %esi,%esi
80103a0d:	74 41                	je     80103a50 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103a0f:	83 ec 0c             	sub    $0xc,%esp
80103a12:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103a18:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103a1f:	00 00 00 
    wakeup(&p->nread);
80103a22:	50                   	push   %eax
80103a23:	e8 28 0c 00 00       	call   80104650 <wakeup>
80103a28:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103a2b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103a31:	85 d2                	test   %edx,%edx
80103a33:	75 0a                	jne    80103a3f <pipeclose+0x4f>
80103a35:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103a3b:	85 c0                	test   %eax,%eax
80103a3d:	74 31                	je     80103a70 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103a42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a45:	5b                   	pop    %ebx
80103a46:	5e                   	pop    %esi
80103a47:	5d                   	pop    %ebp
    release(&p->lock);
80103a48:	e9 a3 1e 00 00       	jmp    801058f0 <release>
80103a4d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103a59:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103a60:	00 00 00 
    wakeup(&p->nwrite);
80103a63:	50                   	push   %eax
80103a64:	e8 e7 0b 00 00       	call   80104650 <wakeup>
80103a69:	83 c4 10             	add    $0x10,%esp
80103a6c:	eb bd                	jmp    80103a2b <pipeclose+0x3b>
80103a6e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103a70:	83 ec 0c             	sub    $0xc,%esp
80103a73:	53                   	push   %ebx
80103a74:	e8 77 1e 00 00       	call   801058f0 <release>
    kfree((char*)p);
80103a79:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103a7c:	83 c4 10             	add    $0x10,%esp
}
80103a7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a82:	5b                   	pop    %ebx
80103a83:	5e                   	pop    %esi
80103a84:	5d                   	pop    %ebp
    kfree((char*)p);
80103a85:	e9 d6 ee ff ff       	jmp    80102960 <kfree>
80103a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a90 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103a90:	f3 0f 1e fb          	endbr32 
80103a94:	55                   	push   %ebp
80103a95:	89 e5                	mov    %esp,%ebp
80103a97:	57                   	push   %edi
80103a98:	56                   	push   %esi
80103a99:	53                   	push   %ebx
80103a9a:	83 ec 28             	sub    $0x28,%esp
80103a9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103aa0:	53                   	push   %ebx
80103aa1:	e8 8a 1d 00 00       	call   80105830 <acquire>
  for(i = 0; i < n; i++){
80103aa6:	8b 45 10             	mov    0x10(%ebp),%eax
80103aa9:	83 c4 10             	add    $0x10,%esp
80103aac:	85 c0                	test   %eax,%eax
80103aae:	0f 8e bc 00 00 00    	jle    80103b70 <pipewrite+0xe0>
80103ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ab7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103abd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103ac3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ac6:	03 45 10             	add    0x10(%ebp),%eax
80103ac9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103acc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ad2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ad8:	89 ca                	mov    %ecx,%edx
80103ada:	05 00 02 00 00       	add    $0x200,%eax
80103adf:	39 c1                	cmp    %eax,%ecx
80103ae1:	74 3b                	je     80103b1e <pipewrite+0x8e>
80103ae3:	eb 63                	jmp    80103b48 <pipewrite+0xb8>
80103ae5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103ae8:	e8 c3 03 00 00       	call   80103eb0 <myproc>
80103aed:	8b 48 24             	mov    0x24(%eax),%ecx
80103af0:	85 c9                	test   %ecx,%ecx
80103af2:	75 34                	jne    80103b28 <pipewrite+0x98>
      wakeup(&p->nread);
80103af4:	83 ec 0c             	sub    $0xc,%esp
80103af7:	57                   	push   %edi
80103af8:	e8 53 0b 00 00       	call   80104650 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103afd:	58                   	pop    %eax
80103afe:	5a                   	pop    %edx
80103aff:	53                   	push   %ebx
80103b00:	56                   	push   %esi
80103b01:	e8 8a 09 00 00       	call   80104490 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b06:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103b0c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103b12:	83 c4 10             	add    $0x10,%esp
80103b15:	05 00 02 00 00       	add    $0x200,%eax
80103b1a:	39 c2                	cmp    %eax,%edx
80103b1c:	75 2a                	jne    80103b48 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103b1e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103b24:	85 c0                	test   %eax,%eax
80103b26:	75 c0                	jne    80103ae8 <pipewrite+0x58>
        release(&p->lock);
80103b28:	83 ec 0c             	sub    $0xc,%esp
80103b2b:	53                   	push   %ebx
80103b2c:	e8 bf 1d 00 00       	call   801058f0 <release>
        return -1;
80103b31:	83 c4 10             	add    $0x10,%esp
80103b34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103b39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b3c:	5b                   	pop    %ebx
80103b3d:	5e                   	pop    %esi
80103b3e:	5f                   	pop    %edi
80103b3f:	5d                   	pop    %ebp
80103b40:	c3                   	ret    
80103b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b48:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103b4b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103b4e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103b54:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103b5a:	0f b6 06             	movzbl (%esi),%eax
80103b5d:	83 c6 01             	add    $0x1,%esi
80103b60:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103b63:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103b67:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103b6a:	0f 85 5c ff ff ff    	jne    80103acc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103b70:	83 ec 0c             	sub    $0xc,%esp
80103b73:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103b79:	50                   	push   %eax
80103b7a:	e8 d1 0a 00 00       	call   80104650 <wakeup>
  release(&p->lock);
80103b7f:	89 1c 24             	mov    %ebx,(%esp)
80103b82:	e8 69 1d 00 00       	call   801058f0 <release>
  return n;
80103b87:	8b 45 10             	mov    0x10(%ebp),%eax
80103b8a:	83 c4 10             	add    $0x10,%esp
80103b8d:	eb aa                	jmp    80103b39 <pipewrite+0xa9>
80103b8f:	90                   	nop

80103b90 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103b90:	f3 0f 1e fb          	endbr32 
80103b94:	55                   	push   %ebp
80103b95:	89 e5                	mov    %esp,%ebp
80103b97:	57                   	push   %edi
80103b98:	56                   	push   %esi
80103b99:	53                   	push   %ebx
80103b9a:	83 ec 18             	sub    $0x18,%esp
80103b9d:	8b 75 08             	mov    0x8(%ebp),%esi
80103ba0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103ba3:	56                   	push   %esi
80103ba4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103baa:	e8 81 1c 00 00       	call   80105830 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103baf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103bb5:	83 c4 10             	add    $0x10,%esp
80103bb8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103bbe:	74 33                	je     80103bf3 <piperead+0x63>
80103bc0:	eb 3b                	jmp    80103bfd <piperead+0x6d>
80103bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103bc8:	e8 e3 02 00 00       	call   80103eb0 <myproc>
80103bcd:	8b 48 24             	mov    0x24(%eax),%ecx
80103bd0:	85 c9                	test   %ecx,%ecx
80103bd2:	0f 85 88 00 00 00    	jne    80103c60 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103bd8:	83 ec 08             	sub    $0x8,%esp
80103bdb:	56                   	push   %esi
80103bdc:	53                   	push   %ebx
80103bdd:	e8 ae 08 00 00       	call   80104490 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103be2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103be8:	83 c4 10             	add    $0x10,%esp
80103beb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103bf1:	75 0a                	jne    80103bfd <piperead+0x6d>
80103bf3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103bf9:	85 c0                	test   %eax,%eax
80103bfb:	75 cb                	jne    80103bc8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103bfd:	8b 55 10             	mov    0x10(%ebp),%edx
80103c00:	31 db                	xor    %ebx,%ebx
80103c02:	85 d2                	test   %edx,%edx
80103c04:	7f 28                	jg     80103c2e <piperead+0x9e>
80103c06:	eb 34                	jmp    80103c3c <piperead+0xac>
80103c08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c0f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103c10:	8d 48 01             	lea    0x1(%eax),%ecx
80103c13:	25 ff 01 00 00       	and    $0x1ff,%eax
80103c18:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103c1e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103c23:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c26:	83 c3 01             	add    $0x1,%ebx
80103c29:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103c2c:	74 0e                	je     80103c3c <piperead+0xac>
    if(p->nread == p->nwrite)
80103c2e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103c34:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103c3a:	75 d4                	jne    80103c10 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103c3c:	83 ec 0c             	sub    $0xc,%esp
80103c3f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103c45:	50                   	push   %eax
80103c46:	e8 05 0a 00 00       	call   80104650 <wakeup>
  release(&p->lock);
80103c4b:	89 34 24             	mov    %esi,(%esp)
80103c4e:	e8 9d 1c 00 00       	call   801058f0 <release>
  return i;
80103c53:	83 c4 10             	add    $0x10,%esp
}
80103c56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c59:	89 d8                	mov    %ebx,%eax
80103c5b:	5b                   	pop    %ebx
80103c5c:	5e                   	pop    %esi
80103c5d:	5f                   	pop    %edi
80103c5e:	5d                   	pop    %ebp
80103c5f:	c3                   	ret    
      release(&p->lock);
80103c60:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103c63:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103c68:	56                   	push   %esi
80103c69:	e8 82 1c 00 00       	call   801058f0 <release>
      return -1;
80103c6e:	83 c4 10             	add    $0x10,%esp
}
80103c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c74:	89 d8                	mov    %ebx,%eax
80103c76:	5b                   	pop    %ebx
80103c77:	5e                   	pop    %esi
80103c78:	5f                   	pop    %edi
80103c79:	5d                   	pop    %ebp
80103c7a:	c3                   	ret    
80103c7b:	66 90                	xchg   %ax,%ax
80103c7d:	66 90                	xchg   %ax,%ax
80103c7f:	90                   	nop

80103c80 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c84:	bb f4 52 11 80       	mov    $0x801152f4,%ebx
{
80103c89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103c8c:	68 c0 52 11 80       	push   $0x801152c0
80103c91:	e8 9a 1b 00 00       	call   80105830 <acquire>
80103c96:	83 c4 10             	add    $0x10,%esp
80103c99:	eb 17                	jmp    80103cb2 <allocproc+0x32>
80103c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c9f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ca0:	81 c3 ac 00 00 00    	add    $0xac,%ebx
80103ca6:	81 fb f4 7d 11 80    	cmp    $0x80117df4,%ebx
80103cac:	0f 84 ce 00 00 00    	je     80103d80 <allocproc+0x100>
    if(p->state == UNUSED)
80103cb2:	8b 43 0c             	mov    0xc(%ebx),%eax
80103cb5:	85 c0                	test   %eax,%eax
80103cb7:	75 e7                	jne    80103ca0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103cb9:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80103cbe:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103cc1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103cc8:	89 43 10             	mov    %eax,0x10(%ebx)
80103ccb:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103cce:	68 c0 52 11 80       	push   $0x801152c0
  p->pid = nextpid++;
80103cd3:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103cd9:	e8 12 1c 00 00       	call   801058f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103cde:	e8 3d ee ff ff       	call   80102b20 <kalloc>
80103ce3:	83 c4 10             	add    $0x10,%esp
80103ce6:	89 43 08             	mov    %eax,0x8(%ebx)
80103ce9:	85 c0                	test   %eax,%eax
80103ceb:	0f 84 a8 00 00 00    	je     80103d99 <allocproc+0x119>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103cf1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103cf7:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103cfa:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103cff:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103d02:	c7 40 14 37 6f 10 80 	movl   $0x80106f37,0x14(%eax)
  p->context = (struct context*)sp;
80103d09:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103d0c:	6a 14                	push   $0x14
80103d0e:	6a 00                	push   $0x0
80103d10:	50                   	push   %eax
80103d11:	e8 2a 1c 00 00       	call   80105940 <memset>
  p->context->eip = (uint)forkret;
80103d16:	8b 43 1c             	mov    0x1c(%ebx),%eax
  p->sched_info.bjf.executed_cycle = 0;
  p->sched_info.bjf.executed_cycle_ratio = 1;
  p->sched_info.bjf.process_size = p->sz;
  p->sched_info.bjf.process_size_ratio = 1;
  p->start_time = ticks;
  return p;
80103d19:	83 c4 10             	add    $0x10,%esp
  p->sched_info.bjf.priority_ratio = 1;
80103d1c:	d9 e8                	fld1   
  p->context->eip = (uint)forkret;
80103d1e:	c7 40 10 b0 3d 10 80 	movl   $0x80103db0,0x10(%eax)
  p->sched_info.bjf.arrival_time = ticks;
80103d25:	a1 40 86 11 80       	mov    0x80118640,%eax
  p->sched_info.bjf.priority_ratio = 1;
80103d2a:	d9 93 8c 00 00 00    	fsts   0x8c(%ebx)
  p->sched_info.bjf.process_size = p->sz;
80103d30:	8b 13                	mov    (%ebx),%edx
  p->sched_info.bjf.arrival_time_ratio = 1;
80103d32:	d9 93 94 00 00 00    	fsts   0x94(%ebx)
  p->sched_info.bjf.executed_cycle_ratio = 1;
80103d38:	d9 93 9c 00 00 00    	fsts   0x9c(%ebx)
  p->sched_info.bjf.arrival_time = ticks;
80103d3e:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
  p->start_time = ticks;
80103d44:	89 43 7c             	mov    %eax,0x7c(%ebx)
}
80103d47:	89 d8                	mov    %ebx,%eax
  p->sched_info.queue = UNSET;
80103d49:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103d50:	00 00 00 
  p->sched_info.bjf.priority = 3;
80103d53:	c7 83 88 00 00 00 03 	movl   $0x3,0x88(%ebx)
80103d5a:	00 00 00 
  p->sched_info.bjf.executed_cycle = 0;
80103d5d:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80103d64:	00 00 00 
  p->sched_info.bjf.process_size = p->sz;
80103d67:	89 93 a0 00 00 00    	mov    %edx,0xa0(%ebx)
  p->sched_info.bjf.process_size_ratio = 1;
80103d6d:	d9 9b a4 00 00 00    	fstps  0xa4(%ebx)
}
80103d73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d76:	c9                   	leave  
80103d77:	c3                   	ret    
80103d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d7f:	90                   	nop
  release(&ptable.lock);
80103d80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103d83:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103d85:	68 c0 52 11 80       	push   $0x801152c0
80103d8a:	e8 61 1b 00 00       	call   801058f0 <release>
}
80103d8f:	89 d8                	mov    %ebx,%eax
  return 0;
80103d91:	83 c4 10             	add    $0x10,%esp
}
80103d94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d97:	c9                   	leave  
80103d98:	c3                   	ret    
    p->state = UNUSED;
80103d99:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103da0:	31 db                	xor    %ebx,%ebx
}
80103da2:	89 d8                	mov    %ebx,%eax
80103da4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103da7:	c9                   	leave  
80103da8:	c3                   	ret    
80103da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103db0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103db0:	f3 0f 1e fb          	endbr32 
80103db4:	55                   	push   %ebp
80103db5:	89 e5                	mov    %esp,%ebp
80103db7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103dba:	68 c0 52 11 80       	push   $0x801152c0
80103dbf:	e8 2c 1b 00 00       	call   801058f0 <release>

  if (first) {
80103dc4:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103dc9:	83 c4 10             	add    $0x10,%esp
80103dcc:	85 c0                	test   %eax,%eax
80103dce:	75 08                	jne    80103dd8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103dd0:	c9                   	leave  
80103dd1:	c3                   	ret    
80103dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103dd8:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103ddf:	00 00 00 
    iinit(ROOTDEV);
80103de2:	83 ec 0c             	sub    $0xc,%esp
80103de5:	6a 01                	push   $0x1
80103de7:	e8 44 dc ff ff       	call   80101a30 <iinit>
    initlog(ROOTDEV);
80103dec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103df3:	e8 88 f3 ff ff       	call   80103180 <initlog>
}
80103df8:	83 c4 10             	add    $0x10,%esp
80103dfb:	c9                   	leave  
80103dfc:	c3                   	ret    
80103dfd:	8d 76 00             	lea    0x0(%esi),%esi

80103e00 <pinit>:
{
80103e00:	f3 0f 1e fb          	endbr32 
80103e04:	55                   	push   %ebp
80103e05:	89 e5                	mov    %esp,%ebp
80103e07:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103e0a:	68 40 8d 10 80       	push   $0x80108d40
80103e0f:	68 c0 52 11 80       	push   $0x801152c0
80103e14:	e8 97 18 00 00       	call   801056b0 <initlock>
}
80103e19:	83 c4 10             	add    $0x10,%esp
80103e1c:	c9                   	leave  
80103e1d:	c3                   	ret    
80103e1e:	66 90                	xchg   %ax,%ax

80103e20 <mycpu>:
{
80103e20:	f3 0f 1e fb          	endbr32 
80103e24:	55                   	push   %ebp
80103e25:	89 e5                	mov    %esp,%ebp
80103e27:	56                   	push   %esi
80103e28:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e29:	9c                   	pushf  
80103e2a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e2b:	f6 c4 02             	test   $0x2,%ah
80103e2e:	75 4a                	jne    80103e7a <mycpu+0x5a>
  apicid = lapicid();
80103e30:	e8 5b ef ff ff       	call   80102d90 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103e35:	8b 35 a0 52 11 80    	mov    0x801152a0,%esi
  apicid = lapicid();
80103e3b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103e3d:	85 f6                	test   %esi,%esi
80103e3f:	7e 2c                	jle    80103e6d <mycpu+0x4d>
80103e41:	31 d2                	xor    %edx,%edx
80103e43:	eb 0a                	jmp    80103e4f <mycpu+0x2f>
80103e45:	8d 76 00             	lea    0x0(%esi),%esi
80103e48:	83 c2 01             	add    $0x1,%edx
80103e4b:	39 f2                	cmp    %esi,%edx
80103e4d:	74 1e                	je     80103e6d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103e4f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103e55:	0f b6 81 20 4d 11 80 	movzbl -0x7feeb2e0(%ecx),%eax
80103e5c:	39 d8                	cmp    %ebx,%eax
80103e5e:	75 e8                	jne    80103e48 <mycpu+0x28>
}
80103e60:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103e63:	8d 81 20 4d 11 80    	lea    -0x7feeb2e0(%ecx),%eax
}
80103e69:	5b                   	pop    %ebx
80103e6a:	5e                   	pop    %esi
80103e6b:	5d                   	pop    %ebp
80103e6c:	c3                   	ret    
  panic("unknown apicid\n");
80103e6d:	83 ec 0c             	sub    $0xc,%esp
80103e70:	68 47 8d 10 80       	push   $0x80108d47
80103e75:	e8 16 c5 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103e7a:	83 ec 0c             	sub    $0xc,%esp
80103e7d:	68 5c 8e 10 80       	push   $0x80108e5c
80103e82:	e8 09 c5 ff ff       	call   80100390 <panic>
80103e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e8e:	66 90                	xchg   %ax,%ax

80103e90 <cpuid>:
cpuid() {
80103e90:	f3 0f 1e fb          	endbr32 
80103e94:	55                   	push   %ebp
80103e95:	89 e5                	mov    %esp,%ebp
80103e97:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103e9a:	e8 81 ff ff ff       	call   80103e20 <mycpu>
}
80103e9f:	c9                   	leave  
  return mycpu()-cpus;
80103ea0:	2d 20 4d 11 80       	sub    $0x80114d20,%eax
80103ea5:	c1 f8 04             	sar    $0x4,%eax
80103ea8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103eae:	c3                   	ret    
80103eaf:	90                   	nop

80103eb0 <myproc>:
myproc(void) {
80103eb0:	f3 0f 1e fb          	endbr32 
80103eb4:	55                   	push   %ebp
80103eb5:	89 e5                	mov    %esp,%ebp
80103eb7:	53                   	push   %ebx
80103eb8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ebb:	e8 70 18 00 00       	call   80105730 <pushcli>
  c = mycpu();
80103ec0:	e8 5b ff ff ff       	call   80103e20 <mycpu>
  p = c->proc;
80103ec5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ecb:	e8 b0 18 00 00       	call   80105780 <popcli>
}
80103ed0:	83 c4 04             	add    $0x4,%esp
80103ed3:	89 d8                	mov    %ebx,%eax
80103ed5:	5b                   	pop    %ebx
80103ed6:	5d                   	pop    %ebp
80103ed7:	c3                   	ret    
80103ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edf:	90                   	nop

80103ee0 <growproc>:
{
80103ee0:	f3 0f 1e fb          	endbr32 
80103ee4:	55                   	push   %ebp
80103ee5:	89 e5                	mov    %esp,%ebp
80103ee7:	56                   	push   %esi
80103ee8:	53                   	push   %ebx
80103ee9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103eec:	e8 3f 18 00 00       	call   80105730 <pushcli>
  c = mycpu();
80103ef1:	e8 2a ff ff ff       	call   80103e20 <mycpu>
  p = c->proc;
80103ef6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103efc:	e8 7f 18 00 00       	call   80105780 <popcli>
  sz = curproc->sz;
80103f01:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103f03:	85 f6                	test   %esi,%esi
80103f05:	7f 19                	jg     80103f20 <growproc+0x40>
  } else if(n < 0){
80103f07:	75 37                	jne    80103f40 <growproc+0x60>
  switchuvm(curproc);
80103f09:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f0c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f0e:	53                   	push   %ebx
80103f0f:	e8 bc 41 00 00       	call   801080d0 <switchuvm>
  return 0;
80103f14:	83 c4 10             	add    $0x10,%esp
80103f17:	31 c0                	xor    %eax,%eax
}
80103f19:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f1c:	5b                   	pop    %ebx
80103f1d:	5e                   	pop    %esi
80103f1e:	5d                   	pop    %ebp
80103f1f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f20:	83 ec 04             	sub    $0x4,%esp
80103f23:	01 c6                	add    %eax,%esi
80103f25:	56                   	push   %esi
80103f26:	50                   	push   %eax
80103f27:	ff 73 04             	pushl  0x4(%ebx)
80103f2a:	e8 01 44 00 00       	call   80108330 <allocuvm>
80103f2f:	83 c4 10             	add    $0x10,%esp
80103f32:	85 c0                	test   %eax,%eax
80103f34:	75 d3                	jne    80103f09 <growproc+0x29>
      return -1;
80103f36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f3b:	eb dc                	jmp    80103f19 <growproc+0x39>
80103f3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f40:	83 ec 04             	sub    $0x4,%esp
80103f43:	01 c6                	add    %eax,%esi
80103f45:	56                   	push   %esi
80103f46:	50                   	push   %eax
80103f47:	ff 73 04             	pushl  0x4(%ebx)
80103f4a:	e8 11 45 00 00       	call   80108460 <deallocuvm>
80103f4f:	83 c4 10             	add    $0x10,%esp
80103f52:	85 c0                	test   %eax,%eax
80103f54:	75 b3                	jne    80103f09 <growproc+0x29>
80103f56:	eb de                	jmp    80103f36 <growproc+0x56>
80103f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f5f:	90                   	nop

80103f60 <bjfrank>:
{
80103f60:	f3 0f 1e fb          	endbr32 
80103f64:	55                   	push   %ebp
80103f65:	89 e5                	mov    %esp,%ebp
80103f67:	8b 45 08             	mov    0x8(%ebp),%eax
}
80103f6a:	5d                   	pop    %ebp
  return p->sched_info.bjf.priority * p->sched_info.bjf.priority_ratio +
80103f6b:	db 80 88 00 00 00    	fildl  0x88(%eax)
80103f71:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
80103f77:	db 80 90 00 00 00    	fildl  0x90(%eax)
80103f7d:	d8 88 94 00 00 00    	fmuls  0x94(%eax)
  return p->sched_info.bjf.priority * p->sched_info.bjf.priority_ratio +
80103f83:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
80103f85:	d9 80 98 00 00 00    	flds   0x98(%eax)
80103f8b:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
80103f91:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.process_size * p->sched_info.bjf.process_size_ratio;
80103f93:	db 80 a0 00 00 00    	fildl  0xa0(%eax)
80103f99:	d8 88 a4 00 00 00    	fmuls  0xa4(%eax)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
80103f9f:	de c1                	faddp  %st,%st(1)
}
80103fa1:	c3                   	ret    
80103fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fb0 <lcfs>:
{
80103fb0:	f3 0f 1e fb          	endbr32 
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fb4:	b8 f4 52 11 80       	mov    $0x801152f4,%eax
  struct proc *result = 0;
80103fb9:	31 d2                	xor    %edx,%edx
80103fbb:	eb 1f                	jmp    80103fdc <lcfs+0x2c>
80103fbd:	8d 76 00             	lea    0x0(%esi),%esi
      if (result->sched_info.arrival_queue_time < p->sched_info.arrival_queue_time)
80103fc0:	8b 88 a8 00 00 00    	mov    0xa8(%eax),%ecx
80103fc6:	39 8a a8 00 00 00    	cmp    %ecx,0xa8(%edx)
80103fcc:	0f 4c d0             	cmovl  %eax,%edx
80103fcf:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fd0:	05 ac 00 00 00       	add    $0xac,%eax
80103fd5:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
80103fda:	74 21                	je     80103ffd <lcfs+0x4d>
    if (p->state != RUNNABLE || p->sched_info.queue != LCFS)
80103fdc:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103fe0:	75 ee                	jne    80103fd0 <lcfs+0x20>
80103fe2:	83 b8 80 00 00 00 02 	cmpl   $0x2,0x80(%eax)
80103fe9:	75 e5                	jne    80103fd0 <lcfs+0x20>
    if (result != 0)
80103feb:	85 d2                	test   %edx,%edx
80103fed:	75 d1                	jne    80103fc0 <lcfs+0x10>
80103fef:	89 c2                	mov    %eax,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ff1:	05 ac 00 00 00       	add    $0xac,%eax
80103ff6:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
80103ffb:	75 df                	jne    80103fdc <lcfs+0x2c>
}
80103ffd:	89 d0                	mov    %edx,%eax
80103fff:	c3                   	ret    

80104000 <bestjobfirst>:
{
80104000:	f3 0f 1e fb          	endbr32 
  float min_rank = 2e6;
80104004:	d9 05 84 8f 10 80    	flds   0x80108f84
  struct proc *min_p = 0;
8010400a:	31 d2                	xor    %edx,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010400c:	b8 f4 52 11 80       	mov    $0x801152f4,%eax
80104011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != RUNNABLE || p->sched_info.queue != BJF)
80104018:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010401c:	75 5a                	jne    80104078 <bestjobfirst+0x78>
8010401e:	83 b8 80 00 00 00 03 	cmpl   $0x3,0x80(%eax)
80104025:	75 51                	jne    80104078 <bestjobfirst+0x78>
  return p->sched_info.bjf.priority * p->sched_info.bjf.priority_ratio +
80104027:	db 80 88 00 00 00    	fildl  0x88(%eax)
8010402d:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
80104033:	db 80 90 00 00 00    	fildl  0x90(%eax)
80104039:	d8 88 94 00 00 00    	fmuls  0x94(%eax)
  return p->sched_info.bjf.priority * p->sched_info.bjf.priority_ratio +
8010403f:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
80104041:	d9 80 98 00 00 00    	flds   0x98(%eax)
80104047:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
8010404d:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.process_size * p->sched_info.bjf.process_size_ratio;
8010404f:	db 80 a0 00 00 00    	fildl  0xa0(%eax)
80104055:	d8 88 a4 00 00 00    	fmuls  0xa4(%eax)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
8010405b:	de c1                	faddp  %st,%st(1)
8010405d:	d9 c9                	fxch   %st(1)
    if (p_rank < min_rank)
8010405f:	db f1                	fcomi  %st(1),%st
80104061:	76 0d                	jbe    80104070 <bestjobfirst+0x70>
80104063:	dd d8                	fstp   %st(0)
80104065:	89 c2                	mov    %eax,%edx
80104067:	eb 0f                	jmp    80104078 <bestjobfirst+0x78>
80104069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104070:	dd d9                	fstp   %st(1)
80104072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104078:	05 ac 00 00 00       	add    $0xac,%eax
8010407d:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
80104082:	75 94                	jne    80104018 <bestjobfirst+0x18>
80104084:	dd d8                	fstp   %st(0)
}
80104086:	89 d0                	mov    %edx,%eax
80104088:	c3                   	ret    
80104089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104090 <scheduler>:
{
80104090:	f3 0f 1e fb          	endbr32 
80104094:	55                   	push   %ebp
80104095:	89 e5                	mov    %esp,%ebp
80104097:	57                   	push   %edi
      p = ptable.proc;
80104098:	bf f4 52 11 80       	mov    $0x801152f4,%edi
{
8010409d:	56                   	push   %esi
  struct proc *last_scheduled_RR = &ptable.proc[NPROC - 1];
8010409e:	be 48 7d 11 80       	mov    $0x80117d48,%esi
{
801040a3:	53                   	push   %ebx
801040a4:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801040a7:	e8 74 fd ff ff       	call   80103e20 <mycpu>
  c->proc = 0;
801040ac:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801040b3:	00 00 00 
  struct cpu *c = mycpu();
801040b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  c->proc = 0;
801040b9:	83 c0 04             	add    $0x4,%eax
801040bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801040bf:	90                   	nop
  asm volatile("sti");
801040c0:	fb                   	sti    
    acquire(&ptable.lock);
801040c1:	83 ec 0c             	sub    $0xc,%esp
801040c4:	89 f3                	mov    %esi,%ebx
801040c6:	68 c0 52 11 80       	push   $0x801152c0
801040cb:	e8 60 17 00 00       	call   80105830 <acquire>
801040d0:	83 c4 10             	add    $0x10,%esp
801040d3:	eb 0b                	jmp    801040e0 <scheduler+0x50>
801040d5:	8d 76 00             	lea    0x0(%esi),%esi
    if (p == last_scheduled)
801040d8:	39 de                	cmp    %ebx,%esi
801040da:	0f 84 90 00 00 00    	je     80104170 <scheduler+0xe0>
    p++;
801040e0:	81 c3 ac 00 00 00    	add    $0xac,%ebx
      p = ptable.proc;
801040e6:	81 fb f4 7d 11 80    	cmp    $0x80117df4,%ebx
801040ec:	0f 43 df             	cmovae %edi,%ebx
    if (p->state == RUNNABLE && p->sched_info.queue == ROUND_ROBIN)
801040ef:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801040f3:	75 e3                	jne    801040d8 <scheduler+0x48>
801040f5:	83 bb 80 00 00 00 01 	cmpl   $0x1,0x80(%ebx)
801040fc:	75 da                	jne    801040d8 <scheduler+0x48>
801040fe:	89 de                	mov    %ebx,%esi
    c->proc = p;
80104100:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    switchuvm(p);
80104103:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
80104106:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
    switchuvm(p);
8010410c:	53                   	push   %ebx
8010410d:	e8 be 3f 00 00       	call   801080d0 <switchuvm>
    p->sched_info.bjf.executed_cycle += 0.1f;
80104112:	d9 05 88 8f 10 80    	flds   0x80108f88
80104118:	d8 83 98 00 00 00    	fadds  0x98(%ebx)
    p->state = RUNNING;
8010411e:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
    p->sched_info.last_run = ticks;
80104125:	a1 40 86 11 80       	mov    0x80118640,%eax
8010412a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
    p->sched_info.bjf.executed_cycle += 0.1f;
80104130:	d9 9b 98 00 00 00    	fstps  0x98(%ebx)
    swtch(&(c->scheduler), p->context);
80104136:	58                   	pop    %eax
80104137:	5a                   	pop    %edx
80104138:	ff 73 1c             	pushl  0x1c(%ebx)
8010413b:	ff 75 e0             	pushl  -0x20(%ebp)
8010413e:	e8 20 1a 00 00       	call   80105b63 <swtch>
    switchkvm();
80104143:	e8 68 3f 00 00       	call   801080b0 <switchkvm>
    c->proc = 0;
80104148:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010414b:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104152:	00 00 00 
  release(&ptable.lock);
80104155:	c7 04 24 c0 52 11 80 	movl   $0x801152c0,(%esp)
8010415c:	e8 8f 17 00 00       	call   801058f0 <release>
80104161:	83 c4 10             	add    $0x10,%esp
80104164:	e9 57 ff ff ff       	jmp    801040c0 <scheduler+0x30>
80104169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *result = 0;
80104170:	31 db                	xor    %ebx,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104172:	b8 f4 52 11 80       	mov    $0x801152f4,%eax
80104177:	eb 23                	jmp    8010419c <scheduler+0x10c>
80104179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if (result->sched_info.arrival_queue_time < p->sched_info.arrival_queue_time)
80104180:	8b 90 a8 00 00 00    	mov    0xa8(%eax),%edx
80104186:	39 93 a8 00 00 00    	cmp    %edx,0xa8(%ebx)
8010418c:	0f 4c d8             	cmovl  %eax,%ebx
8010418f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104190:	05 ac 00 00 00       	add    $0xac,%eax
80104195:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
8010419a:	74 24                	je     801041c0 <scheduler+0x130>
    if (p->state != RUNNABLE || p->sched_info.queue != LCFS)
8010419c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801041a0:	75 ee                	jne    80104190 <scheduler+0x100>
801041a2:	83 b8 80 00 00 00 02 	cmpl   $0x2,0x80(%eax)
801041a9:	75 e5                	jne    80104190 <scheduler+0x100>
    if (result != 0)
801041ab:	85 db                	test   %ebx,%ebx
801041ad:	75 d1                	jne    80104180 <scheduler+0xf0>
801041af:	89 c3                	mov    %eax,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041b1:	05 ac 00 00 00       	add    $0xac,%eax
801041b6:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
801041bb:	75 df                	jne    8010419c <scheduler+0x10c>
801041bd:	8d 76 00             	lea    0x0(%esi),%esi
      if (!p)
801041c0:	85 db                	test   %ebx,%ebx
801041c2:	0f 85 38 ff ff ff    	jne    80104100 <scheduler+0x70>
        p = bestjobfirst();
801041c8:	e8 33 fe ff ff       	call   80104000 <bestjobfirst>
801041cd:	89 c3                	mov    %eax,%ebx
        if (!p)
801041cf:	85 c0                	test   %eax,%eax
801041d1:	0f 85 29 ff ff ff    	jne    80104100 <scheduler+0x70>
          release(&ptable.lock);
801041d7:	83 ec 0c             	sub    $0xc,%esp
801041da:	68 c0 52 11 80       	push   $0x801152c0
801041df:	e8 0c 17 00 00       	call   801058f0 <release>
          continue;
801041e4:	83 c4 10             	add    $0x10,%esp
801041e7:	e9 d4 fe ff ff       	jmp    801040c0 <scheduler+0x30>
801041ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041f0 <roundrobin>:
{
801041f0:	f3 0f 1e fb          	endbr32 
801041f4:	55                   	push   %ebp
      p = ptable.proc;
801041f5:	b9 f4 52 11 80       	mov    $0x801152f4,%ecx
{
801041fa:	89 e5                	mov    %esp,%ebp
801041fc:	8b 55 08             	mov    0x8(%ebp),%edx
  struct proc *p = last_scheduled;
801041ff:	89 d0                	mov    %edx,%eax
80104201:	eb 09                	jmp    8010420c <roundrobin+0x1c>
80104203:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104207:	90                   	nop
    if (p == last_scheduled)
80104208:	39 d0                	cmp    %edx,%eax
8010420a:	74 24                	je     80104230 <roundrobin+0x40>
    p++;
8010420c:	05 ac 00 00 00       	add    $0xac,%eax
      p = ptable.proc;
80104211:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
80104216:	0f 43 c1             	cmovae %ecx,%eax
    if (p->state == RUNNABLE && p->sched_info.queue == ROUND_ROBIN)
80104219:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010421d:	75 e9                	jne    80104208 <roundrobin+0x18>
8010421f:	83 b8 80 00 00 00 01 	cmpl   $0x1,0x80(%eax)
80104226:	75 e0                	jne    80104208 <roundrobin+0x18>
}
80104228:	5d                   	pop    %ebp
80104229:	c3                   	ret    
8010422a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return 0;
80104230:	31 c0                	xor    %eax,%eax
}
80104232:	5d                   	pop    %ebp
80104233:	c3                   	ret    
80104234:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010423b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010423f:	90                   	nop

80104240 <sched>:
{
80104240:	f3 0f 1e fb          	endbr32 
80104244:	55                   	push   %ebp
80104245:	89 e5                	mov    %esp,%ebp
80104247:	56                   	push   %esi
80104248:	53                   	push   %ebx
  pushcli();
80104249:	e8 e2 14 00 00       	call   80105730 <pushcli>
  c = mycpu();
8010424e:	e8 cd fb ff ff       	call   80103e20 <mycpu>
  p = c->proc;
80104253:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104259:	e8 22 15 00 00       	call   80105780 <popcli>
  if(!holding(&ptable.lock))
8010425e:	83 ec 0c             	sub    $0xc,%esp
80104261:	68 c0 52 11 80       	push   $0x801152c0
80104266:	e8 75 15 00 00       	call   801057e0 <holding>
8010426b:	83 c4 10             	add    $0x10,%esp
8010426e:	85 c0                	test   %eax,%eax
80104270:	74 4f                	je     801042c1 <sched+0x81>
  if(mycpu()->ncli != 1)
80104272:	e8 a9 fb ff ff       	call   80103e20 <mycpu>
80104277:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010427e:	75 68                	jne    801042e8 <sched+0xa8>
  if(p->state == RUNNING)
80104280:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104284:	74 55                	je     801042db <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104286:	9c                   	pushf  
80104287:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104288:	f6 c4 02             	test   $0x2,%ah
8010428b:	75 41                	jne    801042ce <sched+0x8e>
  intena = mycpu()->intena;
8010428d:	e8 8e fb ff ff       	call   80103e20 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104292:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104295:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010429b:	e8 80 fb ff ff       	call   80103e20 <mycpu>
801042a0:	83 ec 08             	sub    $0x8,%esp
801042a3:	ff 70 04             	pushl  0x4(%eax)
801042a6:	53                   	push   %ebx
801042a7:	e8 b7 18 00 00       	call   80105b63 <swtch>
  mycpu()->intena = intena;
801042ac:	e8 6f fb ff ff       	call   80103e20 <mycpu>
}
801042b1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801042b4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801042ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042bd:	5b                   	pop    %ebx
801042be:	5e                   	pop    %esi
801042bf:	5d                   	pop    %ebp
801042c0:	c3                   	ret    
    panic("sched ptable.lock");
801042c1:	83 ec 0c             	sub    $0xc,%esp
801042c4:	68 57 8d 10 80       	push   $0x80108d57
801042c9:	e8 c2 c0 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801042ce:	83 ec 0c             	sub    $0xc,%esp
801042d1:	68 83 8d 10 80       	push   $0x80108d83
801042d6:	e8 b5 c0 ff ff       	call   80100390 <panic>
    panic("sched running");
801042db:	83 ec 0c             	sub    $0xc,%esp
801042de:	68 75 8d 10 80       	push   $0x80108d75
801042e3:	e8 a8 c0 ff ff       	call   80100390 <panic>
    panic("sched locks");
801042e8:	83 ec 0c             	sub    $0xc,%esp
801042eb:	68 69 8d 10 80       	push   $0x80108d69
801042f0:	e8 9b c0 ff ff       	call   80100390 <panic>
801042f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104300 <exit>:
{
80104300:	f3 0f 1e fb          	endbr32 
80104304:	55                   	push   %ebp
80104305:	89 e5                	mov    %esp,%ebp
80104307:	57                   	push   %edi
80104308:	56                   	push   %esi
80104309:	53                   	push   %ebx
8010430a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010430d:	e8 1e 14 00 00       	call   80105730 <pushcli>
  c = mycpu();
80104312:	e8 09 fb ff ff       	call   80103e20 <mycpu>
  p = c->proc;
80104317:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010431d:	e8 5e 14 00 00       	call   80105780 <popcli>
  if(curproc == initproc)
80104322:	8d 5e 28             	lea    0x28(%esi),%ebx
80104325:	8d 7e 68             	lea    0x68(%esi),%edi
80104328:	39 35 b8 c5 10 80    	cmp    %esi,0x8010c5b8
8010432e:	0f 84 fd 00 00 00    	je     80104431 <exit+0x131>
80104334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104338:	8b 03                	mov    (%ebx),%eax
8010433a:	85 c0                	test   %eax,%eax
8010433c:	74 12                	je     80104350 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010433e:	83 ec 0c             	sub    $0xc,%esp
80104341:	50                   	push   %eax
80104342:	e8 69 d0 ff ff       	call   801013b0 <fileclose>
      curproc->ofile[fd] = 0;
80104347:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010434d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104350:	83 c3 04             	add    $0x4,%ebx
80104353:	39 df                	cmp    %ebx,%edi
80104355:	75 e1                	jne    80104338 <exit+0x38>
  begin_op();
80104357:	e8 c4 ee ff ff       	call   80103220 <begin_op>
  iput(curproc->cwd);
8010435c:	83 ec 0c             	sub    $0xc,%esp
8010435f:	ff 76 68             	pushl  0x68(%esi)
80104362:	e8 19 da ff ff       	call   80101d80 <iput>
  end_op();
80104367:	e8 24 ef ff ff       	call   80103290 <end_op>
  curproc->cwd = 0;
8010436c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104373:	c7 04 24 c0 52 11 80 	movl   $0x801152c0,(%esp)
8010437a:	e8 b1 14 00 00       	call   80105830 <acquire>
  wakeup1(curproc->parent);
8010437f:	8b 56 14             	mov    0x14(%esi),%edx
80104382:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104385:	b8 f4 52 11 80       	mov    $0x801152f4,%eax
8010438a:	eb 10                	jmp    8010439c <exit+0x9c>
8010438c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104390:	05 ac 00 00 00       	add    $0xac,%eax
80104395:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
8010439a:	74 1e                	je     801043ba <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
8010439c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043a0:	75 ee                	jne    80104390 <exit+0x90>
801043a2:	3b 50 20             	cmp    0x20(%eax),%edx
801043a5:	75 e9                	jne    80104390 <exit+0x90>
      p->state = RUNNABLE;
801043a7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ae:	05 ac 00 00 00       	add    $0xac,%eax
801043b3:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
801043b8:	75 e2                	jne    8010439c <exit+0x9c>
      p->parent = initproc;
801043ba:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043c0:	ba f4 52 11 80       	mov    $0x801152f4,%edx
801043c5:	eb 17                	jmp    801043de <exit+0xde>
801043c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ce:	66 90                	xchg   %ax,%ax
801043d0:	81 c2 ac 00 00 00    	add    $0xac,%edx
801043d6:	81 fa f4 7d 11 80    	cmp    $0x80117df4,%edx
801043dc:	74 3a                	je     80104418 <exit+0x118>
    if(p->parent == curproc){
801043de:	39 72 14             	cmp    %esi,0x14(%edx)
801043e1:	75 ed                	jne    801043d0 <exit+0xd0>
      if(p->state == ZOMBIE)
801043e3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801043e7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801043ea:	75 e4                	jne    801043d0 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ec:	b8 f4 52 11 80       	mov    $0x801152f4,%eax
801043f1:	eb 11                	jmp    80104404 <exit+0x104>
801043f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043f7:	90                   	nop
801043f8:	05 ac 00 00 00       	add    $0xac,%eax
801043fd:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
80104402:	74 cc                	je     801043d0 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104404:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104408:	75 ee                	jne    801043f8 <exit+0xf8>
8010440a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010440d:	75 e9                	jne    801043f8 <exit+0xf8>
      p->state = RUNNABLE;
8010440f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104416:	eb e0                	jmp    801043f8 <exit+0xf8>
  curproc->state = ZOMBIE;
80104418:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010441f:	e8 1c fe ff ff       	call   80104240 <sched>
  panic("zombie exit");
80104424:	83 ec 0c             	sub    $0xc,%esp
80104427:	68 a4 8d 10 80       	push   $0x80108da4
8010442c:	e8 5f bf ff ff       	call   80100390 <panic>
    panic("init exiting");
80104431:	83 ec 0c             	sub    $0xc,%esp
80104434:	68 97 8d 10 80       	push   $0x80108d97
80104439:	e8 52 bf ff ff       	call   80100390 <panic>
8010443e:	66 90                	xchg   %ax,%ax

80104440 <yield>:
{
80104440:	f3 0f 1e fb          	endbr32 
80104444:	55                   	push   %ebp
80104445:	89 e5                	mov    %esp,%ebp
80104447:	53                   	push   %ebx
80104448:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010444b:	68 c0 52 11 80       	push   $0x801152c0
80104450:	e8 db 13 00 00       	call   80105830 <acquire>
  pushcli();
80104455:	e8 d6 12 00 00       	call   80105730 <pushcli>
  c = mycpu();
8010445a:	e8 c1 f9 ff ff       	call   80103e20 <mycpu>
  p = c->proc;
8010445f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104465:	e8 16 13 00 00       	call   80105780 <popcli>
  myproc()->state = RUNNABLE;
8010446a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104471:	e8 ca fd ff ff       	call   80104240 <sched>
  release(&ptable.lock);
80104476:	c7 04 24 c0 52 11 80 	movl   $0x801152c0,(%esp)
8010447d:	e8 6e 14 00 00       	call   801058f0 <release>
}
80104482:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104485:	83 c4 10             	add    $0x10,%esp
80104488:	c9                   	leave  
80104489:	c3                   	ret    
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104490 <sleep>:
{
80104490:	f3 0f 1e fb          	endbr32 
80104494:	55                   	push   %ebp
80104495:	89 e5                	mov    %esp,%ebp
80104497:	57                   	push   %edi
80104498:	56                   	push   %esi
80104499:	53                   	push   %ebx
8010449a:	83 ec 0c             	sub    $0xc,%esp
8010449d:	8b 7d 08             	mov    0x8(%ebp),%edi
801044a0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801044a3:	e8 88 12 00 00       	call   80105730 <pushcli>
  c = mycpu();
801044a8:	e8 73 f9 ff ff       	call   80103e20 <mycpu>
  p = c->proc;
801044ad:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044b3:	e8 c8 12 00 00       	call   80105780 <popcli>
  if(p == 0)
801044b8:	85 db                	test   %ebx,%ebx
801044ba:	0f 84 83 00 00 00    	je     80104543 <sleep+0xb3>
  if(lk == 0)
801044c0:	85 f6                	test   %esi,%esi
801044c2:	74 72                	je     80104536 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801044c4:	81 fe c0 52 11 80    	cmp    $0x801152c0,%esi
801044ca:	74 4c                	je     80104518 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801044cc:	83 ec 0c             	sub    $0xc,%esp
801044cf:	68 c0 52 11 80       	push   $0x801152c0
801044d4:	e8 57 13 00 00       	call   80105830 <acquire>
    release(lk);
801044d9:	89 34 24             	mov    %esi,(%esp)
801044dc:	e8 0f 14 00 00       	call   801058f0 <release>
  p->chan = chan;
801044e1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801044e4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044eb:	e8 50 fd ff ff       	call   80104240 <sched>
  p->chan = 0;
801044f0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801044f7:	c7 04 24 c0 52 11 80 	movl   $0x801152c0,(%esp)
801044fe:	e8 ed 13 00 00       	call   801058f0 <release>
    acquire(lk);
80104503:	89 75 08             	mov    %esi,0x8(%ebp)
80104506:	83 c4 10             	add    $0x10,%esp
}
80104509:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010450c:	5b                   	pop    %ebx
8010450d:	5e                   	pop    %esi
8010450e:	5f                   	pop    %edi
8010450f:	5d                   	pop    %ebp
    acquire(lk);
80104510:	e9 1b 13 00 00       	jmp    80105830 <acquire>
80104515:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104518:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010451b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104522:	e8 19 fd ff ff       	call   80104240 <sched>
  p->chan = 0;
80104527:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010452e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104531:	5b                   	pop    %ebx
80104532:	5e                   	pop    %esi
80104533:	5f                   	pop    %edi
80104534:	5d                   	pop    %ebp
80104535:	c3                   	ret    
    panic("sleep without lk");
80104536:	83 ec 0c             	sub    $0xc,%esp
80104539:	68 b6 8d 10 80       	push   $0x80108db6
8010453e:	e8 4d be ff ff       	call   80100390 <panic>
    panic("sleep");
80104543:	83 ec 0c             	sub    $0xc,%esp
80104546:	68 b0 8d 10 80       	push   $0x80108db0
8010454b:	e8 40 be ff ff       	call   80100390 <panic>

80104550 <wait>:
{
80104550:	f3 0f 1e fb          	endbr32 
80104554:	55                   	push   %ebp
80104555:	89 e5                	mov    %esp,%ebp
80104557:	56                   	push   %esi
80104558:	53                   	push   %ebx
  pushcli();
80104559:	e8 d2 11 00 00       	call   80105730 <pushcli>
  c = mycpu();
8010455e:	e8 bd f8 ff ff       	call   80103e20 <mycpu>
  p = c->proc;
80104563:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104569:	e8 12 12 00 00       	call   80105780 <popcli>
  acquire(&ptable.lock);
8010456e:	83 ec 0c             	sub    $0xc,%esp
80104571:	68 c0 52 11 80       	push   $0x801152c0
80104576:	e8 b5 12 00 00       	call   80105830 <acquire>
8010457b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010457e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104580:	bb f4 52 11 80       	mov    $0x801152f4,%ebx
80104585:	eb 17                	jmp    8010459e <wait+0x4e>
80104587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010458e:	66 90                	xchg   %ax,%ax
80104590:	81 c3 ac 00 00 00    	add    $0xac,%ebx
80104596:	81 fb f4 7d 11 80    	cmp    $0x80117df4,%ebx
8010459c:	74 1e                	je     801045bc <wait+0x6c>
      if(p->parent != curproc)
8010459e:	39 73 14             	cmp    %esi,0x14(%ebx)
801045a1:	75 ed                	jne    80104590 <wait+0x40>
      if(p->state == ZOMBIE){
801045a3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801045a7:	74 37                	je     801045e0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045a9:	81 c3 ac 00 00 00    	add    $0xac,%ebx
      havekids = 1;
801045af:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045b4:	81 fb f4 7d 11 80    	cmp    $0x80117df4,%ebx
801045ba:	75 e2                	jne    8010459e <wait+0x4e>
    if(!havekids || curproc->killed){
801045bc:	85 c0                	test   %eax,%eax
801045be:	74 76                	je     80104636 <wait+0xe6>
801045c0:	8b 46 24             	mov    0x24(%esi),%eax
801045c3:	85 c0                	test   %eax,%eax
801045c5:	75 6f                	jne    80104636 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801045c7:	83 ec 08             	sub    $0x8,%esp
801045ca:	68 c0 52 11 80       	push   $0x801152c0
801045cf:	56                   	push   %esi
801045d0:	e8 bb fe ff ff       	call   80104490 <sleep>
    havekids = 0;
801045d5:	83 c4 10             	add    $0x10,%esp
801045d8:	eb a4                	jmp    8010457e <wait+0x2e>
801045da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801045e0:	83 ec 0c             	sub    $0xc,%esp
801045e3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801045e6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801045e9:	e8 72 e3 ff ff       	call   80102960 <kfree>
        freevm(p->pgdir);
801045ee:	5a                   	pop    %edx
801045ef:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801045f2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801045f9:	e8 92 3e 00 00       	call   80108490 <freevm>
        release(&ptable.lock);
801045fe:	c7 04 24 c0 52 11 80 	movl   $0x801152c0,(%esp)
        p->pid = 0;
80104605:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010460c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104613:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104617:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010461e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104625:	e8 c6 12 00 00       	call   801058f0 <release>
        return pid;
8010462a:	83 c4 10             	add    $0x10,%esp
}
8010462d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104630:	89 f0                	mov    %esi,%eax
80104632:	5b                   	pop    %ebx
80104633:	5e                   	pop    %esi
80104634:	5d                   	pop    %ebp
80104635:	c3                   	ret    
      release(&ptable.lock);
80104636:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104639:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010463e:	68 c0 52 11 80       	push   $0x801152c0
80104643:	e8 a8 12 00 00       	call   801058f0 <release>
      return -1;
80104648:	83 c4 10             	add    $0x10,%esp
8010464b:	eb e0                	jmp    8010462d <wait+0xdd>
8010464d:	8d 76 00             	lea    0x0(%esi),%esi

80104650 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104650:	f3 0f 1e fb          	endbr32 
80104654:	55                   	push   %ebp
80104655:	89 e5                	mov    %esp,%ebp
80104657:	53                   	push   %ebx
80104658:	83 ec 10             	sub    $0x10,%esp
8010465b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010465e:	68 c0 52 11 80       	push   $0x801152c0
80104663:	e8 c8 11 00 00       	call   80105830 <acquire>
80104668:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010466b:	b8 f4 52 11 80       	mov    $0x801152f4,%eax
80104670:	eb 12                	jmp    80104684 <wakeup+0x34>
80104672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104678:	05 ac 00 00 00       	add    $0xac,%eax
8010467d:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
80104682:	74 1e                	je     801046a2 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104684:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104688:	75 ee                	jne    80104678 <wakeup+0x28>
8010468a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010468d:	75 e9                	jne    80104678 <wakeup+0x28>
      p->state = RUNNABLE;
8010468f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104696:	05 ac 00 00 00       	add    $0xac,%eax
8010469b:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
801046a0:	75 e2                	jne    80104684 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
801046a2:	c7 45 08 c0 52 11 80 	movl   $0x801152c0,0x8(%ebp)
}
801046a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046ac:	c9                   	leave  
  release(&ptable.lock);
801046ad:	e9 3e 12 00 00       	jmp    801058f0 <release>
801046b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801046c0:	f3 0f 1e fb          	endbr32 
801046c4:	55                   	push   %ebp
801046c5:	89 e5                	mov    %esp,%ebp
801046c7:	53                   	push   %ebx
801046c8:	83 ec 10             	sub    $0x10,%esp
801046cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801046ce:	68 c0 52 11 80       	push   $0x801152c0
801046d3:	e8 58 11 00 00       	call   80105830 <acquire>
801046d8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046db:	b8 f4 52 11 80       	mov    $0x801152f4,%eax
801046e0:	eb 12                	jmp    801046f4 <kill+0x34>
801046e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046e8:	05 ac 00 00 00       	add    $0xac,%eax
801046ed:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
801046f2:	74 34                	je     80104728 <kill+0x68>
    if(p->pid == pid){
801046f4:	39 58 10             	cmp    %ebx,0x10(%eax)
801046f7:	75 ef                	jne    801046e8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801046f9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801046fd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104704:	75 07                	jne    8010470d <kill+0x4d>
        p->state = RUNNABLE;
80104706:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010470d:	83 ec 0c             	sub    $0xc,%esp
80104710:	68 c0 52 11 80       	push   $0x801152c0
80104715:	e8 d6 11 00 00       	call   801058f0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010471a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010471d:	83 c4 10             	add    $0x10,%esp
80104720:	31 c0                	xor    %eax,%eax
}
80104722:	c9                   	leave  
80104723:	c3                   	ret    
80104724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104728:	83 ec 0c             	sub    $0xc,%esp
8010472b:	68 c0 52 11 80       	push   $0x801152c0
80104730:	e8 bb 11 00 00       	call   801058f0 <release>
}
80104735:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104738:	83 c4 10             	add    $0x10,%esp
8010473b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104740:	c9                   	leave  
80104741:	c3                   	ret    
80104742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104750 <get_uncle_count>:
    
}*/


//get_uncle_count
int get_uncle_count(int pid){
80104750:	f3 0f 1e fb          	endbr32 
80104754:	55                   	push   %ebp
80104755:	89 e5                	mov    %esp,%ebp
80104757:	53                   	push   %ebx
80104758:	83 ec 10             	sub    $0x10,%esp
8010475b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  struct proc *p_parent;
  struct proc *p_grandParent = 0;
  acquire(&ptable.lock);
8010475e:	68 c0 52 11 80       	push   $0x801152c0
80104763:	e8 c8 10 00 00       	call   80105830 <acquire>
  if(pid < 0 || pid >= NPROC){
80104768:	83 c4 10             	add    $0x10,%esp
8010476b:	83 fb 3f             	cmp    $0x3f,%ebx
8010476e:	0f 87 a8 00 00 00    	ja     8010481c <get_uncle_count+0xcc>
  struct proc *p_grandParent = 0;
80104774:	31 c9                	xor    %ecx,%ecx
      return -1;
      }
  int count = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104776:	b8 f4 52 11 80       	mov    $0x801152f4,%eax
8010477b:	eb 0f                	jmp    8010478c <get_uncle_count+0x3c>
8010477d:	8d 76 00             	lea    0x0(%esi),%esi
80104780:	05 ac 00 00 00       	add    $0xac,%eax
80104785:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
8010478a:	74 34                	je     801047c0 <get_uncle_count+0x70>
    count ++;
    if((p->pid) == pid){
8010478c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010478f:	75 ef                	jne    80104780 <get_uncle_count+0x30>
      p_parent = p->parent;
80104791:	8b 50 14             	mov    0x14(%eax),%edx
      if(p_parent != 0){
80104794:	85 d2                	test   %edx,%edx
80104796:	74 68                	je     80104800 <get_uncle_count+0xb0>
        p_grandParent = p_parent->parent;
80104798:	8b 4a 14             	mov    0x14(%edx),%ecx
        if(p_grandParent == 0){
8010479b:	85 c9                	test   %ecx,%ecx
8010479d:	75 e1                	jne    80104780 <get_uncle_count+0x30>
          cprintf("grandparent is zero.");
8010479f:	83 ec 0c             	sub    $0xc,%esp
          return -1;
801047a2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
          cprintf("grandparent is zero.");
801047a7:	68 c7 8d 10 80       	push   $0x80108dc7
801047ac:	e8 0f c1 ff ff       	call   801008c0 <cprintf>
          return -1;
801047b1:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return siblings;

}
801047b4:	89 d8                	mov    %ebx,%eax
801047b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047b9:	c9                   	leave  
801047ba:	c3                   	ret    
801047bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047bf:	90                   	nop
  for(struct proc *i = ptable.proc; i < &ptable.proc[NPROC]; i++){
801047c0:	b8 f4 52 11 80       	mov    $0x801152f4,%eax
  int siblings = 0;
801047c5:	31 db                	xor    %ebx,%ebx
801047c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ce:	66 90                	xchg   %ax,%ax
      siblings++;
801047d0:	31 d2                	xor    %edx,%edx
801047d2:	39 48 14             	cmp    %ecx,0x14(%eax)
801047d5:	0f 94 c2             	sete   %dl
  for(struct proc *i = ptable.proc; i < &ptable.proc[NPROC]; i++){
801047d8:	05 ac 00 00 00       	add    $0xac,%eax
      siblings++;
801047dd:	01 d3                	add    %edx,%ebx
  for(struct proc *i = ptable.proc; i < &ptable.proc[NPROC]; i++){
801047df:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
801047e4:	75 ea                	jne    801047d0 <get_uncle_count+0x80>
  release(&ptable.lock);
801047e6:	83 ec 0c             	sub    $0xc,%esp
801047e9:	68 c0 52 11 80       	push   $0x801152c0
801047ee:	e8 fd 10 00 00       	call   801058f0 <release>
}
801047f3:	89 d8                	mov    %ebx,%eax
  return siblings;
801047f5:	83 c4 10             	add    $0x10,%esp
}
801047f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047fb:	c9                   	leave  
801047fc:	c3                   	ret    
801047fd:	8d 76 00             	lea    0x0(%esi),%esi
        cprintf("parent is zero.");
80104800:	83 ec 0c             	sub    $0xc,%esp
        return -1;
80104803:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
        cprintf("parent is zero.");
80104808:	68 cc 8d 10 80       	push   $0x80108dcc
8010480d:	e8 ae c0 ff ff       	call   801008c0 <cprintf>
}
80104812:	89 d8                	mov    %ebx,%eax
        return -1;
80104814:	83 c4 10             	add    $0x10,%esp
}
80104817:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010481a:	c9                   	leave  
8010481b:	c3                   	ret    
      return -1;
8010481c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104821:	eb 91                	jmp    801047b4 <get_uncle_count+0x64>
80104823:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104830 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104830:	f3 0f 1e fb          	endbr32 
80104834:	55                   	push   %ebp
80104835:	89 e5                	mov    %esp,%ebp
80104837:	57                   	push   %edi
80104838:	56                   	push   %esi
80104839:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010483c:	53                   	push   %ebx
8010483d:	bb 60 53 11 80       	mov    $0x80115360,%ebx
80104842:	83 ec 3c             	sub    $0x3c,%esp
80104845:	eb 2b                	jmp    80104872 <procdump+0x42>
80104847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104850:	83 ec 0c             	sub    $0xc,%esp
80104853:	68 df 92 10 80       	push   $0x801092df
80104858:	e8 63 c0 ff ff       	call   801008c0 <cprintf>
8010485d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104860:	81 c3 ac 00 00 00    	add    $0xac,%ebx
80104866:	81 fb 60 7e 11 80    	cmp    $0x80117e60,%ebx
8010486c:	0f 84 8e 00 00 00    	je     80104900 <procdump+0xd0>
    if(p->state == UNUSED)
80104872:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104875:	85 c0                	test   %eax,%eax
80104877:	74 e7                	je     80104860 <procdump+0x30>
      state = "???";
80104879:	ba dc 8d 10 80       	mov    $0x80108ddc,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010487e:	83 f8 05             	cmp    $0x5,%eax
80104881:	77 11                	ja     80104894 <procdump+0x64>
80104883:	8b 14 85 6c 8f 10 80 	mov    -0x7fef7094(,%eax,4),%edx
      state = "???";
8010488a:	b8 dc 8d 10 80       	mov    $0x80108ddc,%eax
8010488f:	85 d2                	test   %edx,%edx
80104891:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104894:	53                   	push   %ebx
80104895:	52                   	push   %edx
80104896:	ff 73 a4             	pushl  -0x5c(%ebx)
80104899:	68 e0 8d 10 80       	push   $0x80108de0
8010489e:	e8 1d c0 ff ff       	call   801008c0 <cprintf>
    if(p->state == SLEEPING){
801048a3:	83 c4 10             	add    $0x10,%esp
801048a6:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801048aa:	75 a4                	jne    80104850 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801048ac:	83 ec 08             	sub    $0x8,%esp
801048af:	8d 45 c0             	lea    -0x40(%ebp),%eax
801048b2:	8d 7d c0             	lea    -0x40(%ebp),%edi
801048b5:	50                   	push   %eax
801048b6:	8b 43 b0             	mov    -0x50(%ebx),%eax
801048b9:	8b 40 0c             	mov    0xc(%eax),%eax
801048bc:	83 c0 08             	add    $0x8,%eax
801048bf:	50                   	push   %eax
801048c0:	e8 0b 0e 00 00       	call   801056d0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801048c5:	83 c4 10             	add    $0x10,%esp
801048c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048cf:	90                   	nop
801048d0:	8b 17                	mov    (%edi),%edx
801048d2:	85 d2                	test   %edx,%edx
801048d4:	0f 84 76 ff ff ff    	je     80104850 <procdump+0x20>
        cprintf(" %p", pc[i]);
801048da:	83 ec 08             	sub    $0x8,%esp
801048dd:	83 c7 04             	add    $0x4,%edi
801048e0:	52                   	push   %edx
801048e1:	68 e1 87 10 80       	push   $0x801087e1
801048e6:	e8 d5 bf ff ff       	call   801008c0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801048eb:	83 c4 10             	add    $0x10,%esp
801048ee:	39 fe                	cmp    %edi,%esi
801048f0:	75 de                	jne    801048d0 <procdump+0xa0>
801048f2:	e9 59 ff ff ff       	jmp    80104850 <procdump+0x20>
801048f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fe:	66 90                	xchg   %ax,%ax
  }
}
80104900:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104903:	5b                   	pop    %ebx
80104904:	5e                   	pop    %esi
80104905:	5f                   	pop    %edi
80104906:	5d                   	pop    %ebp
80104907:	c3                   	ret    
80104908:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490f:	90                   	nop

80104910 <find_digital_root>:

int 
find_digital_root(int n){
80104910:	f3 0f 1e fb          	endbr32 
80104914:	55                   	push   %ebp
80104915:	89 e5                	mov    %esp,%ebp
80104917:	57                   	push   %edi
80104918:	56                   	push   %esi
80104919:	53                   	push   %ebx
8010491a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while(n>9){
8010491d:	83 fb 09             	cmp    $0x9,%ebx
80104920:	7e 3d                	jle    8010495f <find_digital_root+0x4f>
    int sum = 0 ;
    while(n > 0){
      int digit = n%10;
80104922:	be 67 66 66 66       	mov    $0x66666667,%esi
80104927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492e:	66 90                	xchg   %ax,%ax
find_digital_root(int n){
80104930:	89 d9                	mov    %ebx,%ecx
    int sum = 0 ;
80104932:	31 db                	xor    %ebx,%ebx
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      int digit = n%10;
80104938:	89 c8                	mov    %ecx,%eax
8010493a:	89 cf                	mov    %ecx,%edi
8010493c:	f7 ee                	imul   %esi
8010493e:	89 c8                	mov    %ecx,%eax
80104940:	c1 f8 1f             	sar    $0x1f,%eax
80104943:	c1 fa 02             	sar    $0x2,%edx
80104946:	29 c2                	sub    %eax,%edx
80104948:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010494b:	01 c0                	add    %eax,%eax
8010494d:	29 c7                	sub    %eax,%edi
8010494f:	89 c8                	mov    %ecx,%eax
      sum += digit;
      n = n/10;
80104951:	89 d1                	mov    %edx,%ecx
      sum += digit;
80104953:	01 fb                	add    %edi,%ebx
    while(n > 0){
80104955:	83 f8 09             	cmp    $0x9,%eax
80104958:	7f de                	jg     80104938 <find_digital_root+0x28>
  while(n>9){
8010495a:	83 fb 09             	cmp    $0x9,%ebx
8010495d:	7f d1                	jg     80104930 <find_digital_root+0x20>
    }
    n = sum;
  }
  
  return n;
}
8010495f:	89 d8                	mov    %ebx,%eax
80104961:	5b                   	pop    %ebx
80104962:	5e                   	pop    %esi
80104963:	5f                   	pop    %edi
80104964:	5d                   	pop    %ebp
80104965:	c3                   	ret    
80104966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496d:	8d 76 00             	lea    0x0(%esi),%esi

80104970 <get_process_lifetime>:

int
get_process_lifetime(void){
80104970:	f3 0f 1e fb          	endbr32 
80104974:	55                   	push   %ebp
80104975:	89 e5                	mov    %esp,%ebp
80104977:	56                   	push   %esi
80104978:	53                   	push   %ebx
  return sys_uptime() - myproc()->start_time ; 
80104979:	e8 12 24 00 00       	call   80106d90 <sys_uptime>
8010497e:	89 c3                	mov    %eax,%ebx
  pushcli();
80104980:	e8 ab 0d 00 00       	call   80105730 <pushcli>
  c = mycpu();
80104985:	e8 96 f4 ff ff       	call   80103e20 <mycpu>
  p = c->proc;
8010498a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104990:	e8 eb 0d 00 00       	call   80105780 <popcli>
  return sys_uptime() - myproc()->start_time ; 
80104995:	89 d8                	mov    %ebx,%eax
}
80104997:	5b                   	pop    %ebx
  return sys_uptime() - myproc()->start_time ; 
80104998:	2b 46 7c             	sub    0x7c(%esi),%eax
}
8010499b:	5e                   	pop    %esi
8010499c:	5d                   	pop    %ebp
8010499d:	c3                   	ret    
8010499e:	66 90                	xchg   %ax,%ax

801049a0 <change_Q>:
  release(&ptable.lock);
}


int change_Q(int pid, int new_queue)
{
801049a0:	f3 0f 1e fb          	endbr32 
801049a4:	55                   	push   %ebp
801049a5:	89 e5                	mov    %esp,%ebp
801049a7:	57                   	push   %edi
801049a8:	56                   	push   %esi
801049a9:	53                   	push   %ebx
801049aa:	83 ec 0c             	sub    $0xc,%esp
801049ad:	8b 75 0c             	mov    0xc(%ebp),%esi
801049b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  int old_queue = -1;

  if (new_queue == UNSET)
801049b3:	85 f6                	test   %esi,%esi
801049b5:	75 0c                	jne    801049c3 <change_Q+0x23>
  {
    if (pid == 1)
801049b7:	83 fb 01             	cmp    $0x1,%ebx
801049ba:	74 69                	je     80104a25 <change_Q+0x85>
      new_queue = ROUND_ROBIN;
    else if (pid > 1)
801049bc:	7e 6e                	jle    80104a2c <change_Q+0x8c>
      new_queue = LCFS;
801049be:	be 02 00 00 00       	mov    $0x2,%esi
    else
      return -1;
  }
  acquire(&ptable.lock);
801049c3:	83 ec 0c             	sub    $0xc,%esp
  int old_queue = -1;
801049c6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  acquire(&ptable.lock);
801049cb:	68 c0 52 11 80       	push   $0x801152c0
801049d0:	e8 5b 0e 00 00       	call   80105830 <acquire>
    if (p->pid == pid)
    {
      old_queue = p->sched_info.queue;
      p->sched_info.queue = new_queue;

      p->sched_info.arrival_queue_time = ticks;
801049d5:	8b 15 40 86 11 80    	mov    0x80118640,%edx
801049db:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049de:	b8 f4 52 11 80       	mov    $0x801152f4,%eax
801049e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049e7:	90                   	nop
    if (p->pid == pid)
801049e8:	39 58 10             	cmp    %ebx,0x10(%eax)
801049eb:	75 12                	jne    801049ff <change_Q+0x5f>
      old_queue = p->sched_info.queue;
801049ed:	8b b8 80 00 00 00    	mov    0x80(%eax),%edi
      p->sched_info.arrival_queue_time = ticks;
801049f3:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
      p->sched_info.queue = new_queue;
801049f9:	89 b0 80 00 00 00    	mov    %esi,0x80(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049ff:	05 ac 00 00 00       	add    $0xac,%eax
80104a04:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
80104a09:	75 dd                	jne    801049e8 <change_Q+0x48>
    }
  }
  release(&ptable.lock);
80104a0b:	83 ec 0c             	sub    $0xc,%esp
80104a0e:	68 c0 52 11 80       	push   $0x801152c0
80104a13:	e8 d8 0e 00 00       	call   801058f0 <release>
  return old_queue;
80104a18:	83 c4 10             	add    $0x10,%esp
}
80104a1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a1e:	89 f8                	mov    %edi,%eax
80104a20:	5b                   	pop    %ebx
80104a21:	5e                   	pop    %esi
80104a22:	5f                   	pop    %edi
80104a23:	5d                   	pop    %ebp
80104a24:	c3                   	ret    
      new_queue = ROUND_ROBIN;
80104a25:	be 01 00 00 00       	mov    $0x1,%esi
80104a2a:	eb 97                	jmp    801049c3 <change_Q+0x23>
      return -1;
80104a2c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a31:	eb e8                	jmp    80104a1b <change_Q+0x7b>
80104a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a40 <userinit>:
{
80104a40:	f3 0f 1e fb          	endbr32 
80104a44:	55                   	push   %ebp
80104a45:	89 e5                	mov    %esp,%ebp
80104a47:	53                   	push   %ebx
80104a48:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104a4b:	e8 30 f2 ff ff       	call   80103c80 <allocproc>
80104a50:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104a52:	a3 b8 c5 10 80       	mov    %eax,0x8010c5b8
  if((p->pgdir = setupkvm()) == 0)
80104a57:	e8 b4 3a 00 00       	call   80108510 <setupkvm>
80104a5c:	89 43 04             	mov    %eax,0x4(%ebx)
80104a5f:	85 c0                	test   %eax,%eax
80104a61:	0f 84 c9 00 00 00    	je     80104b30 <userinit+0xf0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104a67:	83 ec 04             	sub    $0x4,%esp
80104a6a:	68 2c 00 00 00       	push   $0x2c
80104a6f:	68 60 c4 10 80       	push   $0x8010c460
80104a74:	50                   	push   %eax
80104a75:	e8 66 37 00 00       	call   801081e0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104a7a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104a7d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104a83:	6a 4c                	push   $0x4c
80104a85:	6a 00                	push   $0x0
80104a87:	ff 73 18             	pushl  0x18(%ebx)
80104a8a:	e8 b1 0e 00 00       	call   80105940 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104a8f:	8b 43 18             	mov    0x18(%ebx),%eax
80104a92:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104a97:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104a9a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104a9f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104aa3:	8b 43 18             	mov    0x18(%ebx),%eax
80104aa6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104aaa:	8b 43 18             	mov    0x18(%ebx),%eax
80104aad:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104ab1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104ab5:	8b 43 18             	mov    0x18(%ebx),%eax
80104ab8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104abc:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104ac0:	8b 43 18             	mov    0x18(%ebx),%eax
80104ac3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104aca:	8b 43 18             	mov    0x18(%ebx),%eax
80104acd:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104ad4:	8b 43 18             	mov    0x18(%ebx),%eax
80104ad7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104ade:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104ae1:	6a 10                	push   $0x10
80104ae3:	68 02 8e 10 80       	push   $0x80108e02
80104ae8:	50                   	push   %eax
80104ae9:	e8 12 10 00 00       	call   80105b00 <safestrcpy>
  p->cwd = namei("/");
80104aee:	c7 04 24 0b 8e 10 80 	movl   $0x80108e0b,(%esp)
80104af5:	e8 26 da ff ff       	call   80102520 <namei>
80104afa:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104afd:	c7 04 24 c0 52 11 80 	movl   $0x801152c0,(%esp)
80104b04:	e8 27 0d 00 00       	call   80105830 <acquire>
  p->state = RUNNABLE;
80104b09:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104b10:	c7 04 24 c0 52 11 80 	movl   $0x801152c0,(%esp)
80104b17:	e8 d4 0d 00 00       	call   801058f0 <release>
  change_Q(p->pid, UNSET);
80104b1c:	58                   	pop    %eax
80104b1d:	5a                   	pop    %edx
80104b1e:	6a 00                	push   $0x0
80104b20:	ff 73 10             	pushl  0x10(%ebx)
80104b23:	e8 78 fe ff ff       	call   801049a0 <change_Q>
}
80104b28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b2b:	83 c4 10             	add    $0x10,%esp
80104b2e:	c9                   	leave  
80104b2f:	c3                   	ret    
    panic("userinit: out of memory?");
80104b30:	83 ec 0c             	sub    $0xc,%esp
80104b33:	68 e9 8d 10 80       	push   $0x80108de9
80104b38:	e8 53 b8 ff ff       	call   80100390 <panic>
80104b3d:	8d 76 00             	lea    0x0(%esi),%esi

80104b40 <fork>:
{
80104b40:	f3 0f 1e fb          	endbr32 
80104b44:	55                   	push   %ebp
80104b45:	89 e5                	mov    %esp,%ebp
80104b47:	57                   	push   %edi
80104b48:	56                   	push   %esi
80104b49:	53                   	push   %ebx
80104b4a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104b4d:	e8 de 0b 00 00       	call   80105730 <pushcli>
  c = mycpu();
80104b52:	e8 c9 f2 ff ff       	call   80103e20 <mycpu>
  p = c->proc;
80104b57:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104b5d:	e8 1e 0c 00 00       	call   80105780 <popcli>
  if((np = allocproc()) == 0){
80104b62:	e8 19 f1 ff ff       	call   80103c80 <allocproc>
80104b67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104b6a:	85 c0                	test   %eax,%eax
80104b6c:	0f 84 c7 00 00 00    	je     80104c39 <fork+0xf9>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104b72:	83 ec 08             	sub    $0x8,%esp
80104b75:	ff 33                	pushl  (%ebx)
80104b77:	89 c7                	mov    %eax,%edi
80104b79:	ff 73 04             	pushl  0x4(%ebx)
80104b7c:	e8 5f 3a 00 00       	call   801085e0 <copyuvm>
80104b81:	83 c4 10             	add    $0x10,%esp
80104b84:	89 47 04             	mov    %eax,0x4(%edi)
80104b87:	85 c0                	test   %eax,%eax
80104b89:	0f 84 b1 00 00 00    	je     80104c40 <fork+0x100>
  np->sz = curproc->sz;
80104b8f:	8b 03                	mov    (%ebx),%eax
80104b91:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104b94:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104b96:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104b99:	89 c8                	mov    %ecx,%eax
80104b9b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80104b9e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104ba3:	8b 73 18             	mov    0x18(%ebx),%esi
80104ba6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104ba8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104baa:	8b 40 18             	mov    0x18(%eax),%eax
80104bad:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104bb8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104bbc:	85 c0                	test   %eax,%eax
80104bbe:	74 13                	je     80104bd3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104bc0:	83 ec 0c             	sub    $0xc,%esp
80104bc3:	50                   	push   %eax
80104bc4:	e8 97 c7 ff ff       	call   80101360 <filedup>
80104bc9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104bcc:	83 c4 10             	add    $0x10,%esp
80104bcf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104bd3:	83 c6 01             	add    $0x1,%esi
80104bd6:	83 fe 10             	cmp    $0x10,%esi
80104bd9:	75 dd                	jne    80104bb8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80104bdb:	83 ec 0c             	sub    $0xc,%esp
80104bde:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104be1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104be4:	e8 37 d0 ff ff       	call   80101c20 <idup>
80104be9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104bec:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104bef:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104bf2:	8d 47 6c             	lea    0x6c(%edi),%eax
80104bf5:	6a 10                	push   $0x10
80104bf7:	53                   	push   %ebx
80104bf8:	50                   	push   %eax
80104bf9:	e8 02 0f 00 00       	call   80105b00 <safestrcpy>
  pid = np->pid;
80104bfe:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104c01:	c7 04 24 c0 52 11 80 	movl   $0x801152c0,(%esp)
80104c08:	e8 23 0c 00 00       	call   80105830 <acquire>
  np->state = RUNNABLE;
80104c0d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104c14:	c7 04 24 c0 52 11 80 	movl   $0x801152c0,(%esp)
80104c1b:	e8 d0 0c 00 00       	call   801058f0 <release>
  change_Q(np->pid, UNSET);
80104c20:	58                   	pop    %eax
80104c21:	5a                   	pop    %edx
80104c22:	6a 00                	push   $0x0
80104c24:	ff 77 10             	pushl  0x10(%edi)
80104c27:	e8 74 fd ff ff       	call   801049a0 <change_Q>
  return pid;
80104c2c:	83 c4 10             	add    $0x10,%esp
}
80104c2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c32:	89 d8                	mov    %ebx,%eax
80104c34:	5b                   	pop    %ebx
80104c35:	5e                   	pop    %esi
80104c36:	5f                   	pop    %edi
80104c37:	5d                   	pop    %ebp
80104c38:	c3                   	ret    
    return -1;
80104c39:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104c3e:	eb ef                	jmp    80104c2f <fork+0xef>
    kfree(np->kstack);
80104c40:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104c43:	83 ec 0c             	sub    $0xc,%esp
80104c46:	ff 73 08             	pushl  0x8(%ebx)
80104c49:	e8 12 dd ff ff       	call   80102960 <kfree>
    np->kstack = 0;
80104c4e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104c55:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104c58:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104c5f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104c64:	eb c9                	jmp    80104c2f <fork+0xef>
80104c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi

80104c70 <ageprocs>:
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	56                   	push   %esi
80104c78:	53                   	push   %ebx
80104c79:	8b 75 08             	mov    0x8(%ebp),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c7c:	bb f4 52 11 80       	mov    $0x801152f4,%ebx
  acquire(&ptable.lock);
80104c81:	83 ec 0c             	sub    $0xc,%esp
80104c84:	68 c0 52 11 80       	push   $0x801152c0
80104c89:	e8 a2 0b 00 00       	call   80105830 <acquire>
80104c8e:	83 c4 10             	add    $0x10,%esp
80104c91:	eb 13                	jmp    80104ca6 <ageprocs+0x36>
80104c93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c97:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c98:	81 c3 ac 00 00 00    	add    $0xac,%ebx
80104c9e:	81 fb f4 7d 11 80    	cmp    $0x80117df4,%ebx
80104ca4:	74 57                	je     80104cfd <ageprocs+0x8d>
    if (p->state == RUNNABLE && p->sched_info.queue != ROUND_ROBIN)
80104ca6:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104caa:	75 ec                	jne    80104c98 <ageprocs+0x28>
80104cac:	83 bb 80 00 00 00 01 	cmpl   $0x1,0x80(%ebx)
80104cb3:	74 e3                	je     80104c98 <ageprocs+0x28>
      if (os_ticks - p->sched_info.last_run > AGING_THRESHOLD)
80104cb5:	89 f0                	mov    %esi,%eax
80104cb7:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
80104cbd:	3d 40 1f 00 00       	cmp    $0x1f40,%eax
80104cc2:	7e d4                	jle    80104c98 <ageprocs+0x28>
        release(&ptable.lock);
80104cc4:	83 ec 0c             	sub    $0xc,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cc7:	81 c3 ac 00 00 00    	add    $0xac,%ebx
        release(&ptable.lock);
80104ccd:	68 c0 52 11 80       	push   $0x801152c0
80104cd2:	e8 19 0c 00 00       	call   801058f0 <release>
        change_Q(p->pid, ROUND_ROBIN);
80104cd7:	58                   	pop    %eax
80104cd8:	5a                   	pop    %edx
80104cd9:	6a 01                	push   $0x1
80104cdb:	ff b3 64 ff ff ff    	pushl  -0x9c(%ebx)
80104ce1:	e8 ba fc ff ff       	call   801049a0 <change_Q>
        acquire(&ptable.lock);
80104ce6:	c7 04 24 c0 52 11 80 	movl   $0x801152c0,(%esp)
80104ced:	e8 3e 0b 00 00       	call   80105830 <acquire>
80104cf2:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cf5:	81 fb f4 7d 11 80    	cmp    $0x80117df4,%ebx
80104cfb:	75 a9                	jne    80104ca6 <ageprocs+0x36>
  release(&ptable.lock);
80104cfd:	c7 45 08 c0 52 11 80 	movl   $0x801152c0,0x8(%ebp)
}
80104d04:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d07:	5b                   	pop    %ebx
80104d08:	5e                   	pop    %esi
80104d09:	5d                   	pop    %ebp
  release(&ptable.lock);
80104d0a:	e9 e1 0b 00 00       	jmp    801058f0 <release>
80104d0f:	90                   	nop

80104d10 <num_digits>:

int num_digits(int n) {
80104d10:	f3 0f 1e fb          	endbr32 
80104d14:	55                   	push   %ebp
80104d15:	89 e5                	mov    %esp,%ebp
80104d17:	56                   	push   %esi
80104d18:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d1b:	53                   	push   %ebx
  int num = 0;
80104d1c:	31 db                	xor    %ebx,%ebx
  while(n!= 0) {
80104d1e:	85 c9                	test   %ecx,%ecx
80104d20:	74 21                	je     80104d43 <num_digits+0x33>
    n/=10;
80104d22:	be 67 66 66 66       	mov    $0x66666667,%esi
80104d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2e:	66 90                	xchg   %ax,%ax
80104d30:	89 c8                	mov    %ecx,%eax
80104d32:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
80104d35:	83 c3 01             	add    $0x1,%ebx
    n/=10;
80104d38:	f7 ee                	imul   %esi
80104d3a:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
80104d3d:	29 ca                	sub    %ecx,%edx
80104d3f:	89 d1                	mov    %edx,%ecx
80104d41:	75 ed                	jne    80104d30 <num_digits+0x20>
  }
  return num;
}
80104d43:	89 d8                	mov    %ebx,%eax
80104d45:	5b                   	pop    %ebx
80104d46:	5e                   	pop    %esi
80104d47:	5d                   	pop    %ebp
80104d48:	c3                   	ret    
80104d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d50 <space>:

void
space(int count)
{
80104d50:	f3 0f 1e fb          	endbr32 
80104d54:	55                   	push   %ebp
80104d55:	89 e5                	mov    %esp,%ebp
80104d57:	56                   	push   %esi
80104d58:	8b 75 08             	mov    0x8(%ebp),%esi
80104d5b:	53                   	push   %ebx
  for(int i = 0; i < count; ++i)
80104d5c:	85 f6                	test   %esi,%esi
80104d5e:	7e 1f                	jle    80104d7f <space+0x2f>
80104d60:	31 db                	xor    %ebx,%ebx
80104d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" ");
80104d68:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80104d6b:	83 c3 01             	add    $0x1,%ebx
    cprintf(" ");
80104d6e:	68 58 8e 10 80       	push   $0x80108e58
80104d73:	e8 48 bb ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80104d78:	83 c4 10             	add    $0x10,%esp
80104d7b:	39 de                	cmp    %ebx,%esi
80104d7d:	75 e9                	jne    80104d68 <space+0x18>
}
80104d7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d82:	5b                   	pop    %ebx
80104d83:	5e                   	pop    %esi
80104d84:	5d                   	pop    %ebp
80104d85:	c3                   	ret    
80104d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi

80104d90 <set_proc_bjf_params>:

int set_proc_bjf_params(int pid, float priority_ratio, float arrival_time_ratio, float executed_cycle_ratio, float process_size_ratio)
{
80104d90:	f3 0f 1e fb          	endbr32 
80104d94:	55                   	push   %ebp
80104d95:	89 e5                	mov    %esp,%ebp
80104d97:	53                   	push   %ebx
80104d98:	83 ec 10             	sub    $0x10,%esp
80104d9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104d9e:	68 c0 52 11 80       	push   $0x801152c0
80104da3:	e8 88 0a 00 00       	call   80105830 <acquire>
80104da8:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104dab:	b8 f4 52 11 80       	mov    $0x801152f4,%eax
80104db0:	eb 12                	jmp    80104dc4 <set_proc_bjf_params+0x34>
80104db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104db8:	05 ac 00 00 00       	add    $0xac,%eax
80104dbd:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
80104dc2:	74 44                	je     80104e08 <set_proc_bjf_params+0x78>
  {
    if (p->pid == pid)
80104dc4:	39 58 10             	cmp    %ebx,0x10(%eax)
80104dc7:	75 ef                	jne    80104db8 <set_proc_bjf_params+0x28>
    {
      p->sched_info.bjf.priority_ratio = priority_ratio;
80104dc9:	d9 45 0c             	flds   0xc(%ebp)
      p->sched_info.bjf.arrival_time_ratio = arrival_time_ratio;
      p->sched_info.bjf.executed_cycle_ratio = executed_cycle_ratio;
      p->sched_info.bjf.process_size_ratio = process_size_ratio;
      release(&ptable.lock);
80104dcc:	83 ec 0c             	sub    $0xc,%esp
      p->sched_info.bjf.priority_ratio = priority_ratio;
80104dcf:	d9 98 8c 00 00 00    	fstps  0x8c(%eax)
      p->sched_info.bjf.arrival_time_ratio = arrival_time_ratio;
80104dd5:	d9 45 10             	flds   0x10(%ebp)
80104dd8:	d9 98 94 00 00 00    	fstps  0x94(%eax)
      p->sched_info.bjf.executed_cycle_ratio = executed_cycle_ratio;
80104dde:	d9 45 14             	flds   0x14(%ebp)
80104de1:	d9 98 9c 00 00 00    	fstps  0x9c(%eax)
      p->sched_info.bjf.process_size_ratio = process_size_ratio;
80104de7:	d9 45 18             	flds   0x18(%ebp)
80104dea:	d9 98 a4 00 00 00    	fstps  0xa4(%eax)
      release(&ptable.lock);
80104df0:	68 c0 52 11 80       	push   $0x801152c0
80104df5:	e8 f6 0a 00 00       	call   801058f0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104dfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104dfd:	83 c4 10             	add    $0x10,%esp
80104e00:	31 c0                	xor    %eax,%eax
}
80104e02:	c9                   	leave  
80104e03:	c3                   	ret    
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104e08:	83 ec 0c             	sub    $0xc,%esp
80104e0b:	68 c0 52 11 80       	push   $0x801152c0
80104e10:	e8 db 0a 00 00       	call   801058f0 <release>
}
80104e15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104e18:	83 c4 10             	add    $0x10,%esp
80104e1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e20:	c9                   	leave  
80104e21:	c3                   	ret    
80104e22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e30 <set_system_bjf_params>:

int set_system_bjf_params(float priority_ratio, float arrival_time_ratio, float executed_cycle_ratio, float process_size_ratio)
{
80104e30:	f3 0f 1e fb          	endbr32 
80104e34:	55                   	push   %ebp
80104e35:	89 e5                	mov    %esp,%ebp
80104e37:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104e3a:	68 c0 52 11 80       	push   $0x801152c0
80104e3f:	e8 ec 09 00 00       	call   80105830 <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e44:	d9 45 08             	flds   0x8(%ebp)
80104e47:	d9 45 0c             	flds   0xc(%ebp)
  acquire(&ptable.lock);
80104e4a:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e4d:	d9 45 10             	flds   0x10(%ebp)
80104e50:	d9 45 14             	flds   0x14(%ebp)
80104e53:	d9 cb                	fxch   %st(3)
80104e55:	b8 f4 52 11 80       	mov    $0x801152f4,%eax
80104e5a:	eb 0a                	jmp    80104e66 <set_system_bjf_params+0x36>
80104e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e60:	d9 cb                	fxch   %st(3)
80104e62:	d9 c9                	fxch   %st(1)
80104e64:	d9 ca                	fxch   %st(2)
  {
    p->sched_info.bjf.priority_ratio = priority_ratio;
80104e66:	d9 90 8c 00 00 00    	fsts   0x8c(%eax)
80104e6c:	d9 ca                	fxch   %st(2)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e6e:	05 ac 00 00 00       	add    $0xac,%eax
    p->sched_info.bjf.arrival_time_ratio = arrival_time_ratio;
80104e73:	d9 50 e8             	fsts   -0x18(%eax)
80104e76:	d9 c9                	fxch   %st(1)
    p->sched_info.bjf.executed_cycle_ratio = executed_cycle_ratio;
80104e78:	d9 50 f0             	fsts   -0x10(%eax)
80104e7b:	d9 cb                	fxch   %st(3)
    p->sched_info.bjf.process_size_ratio = process_size_ratio;
80104e7d:	d9 50 f8             	fsts   -0x8(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e80:	3d f4 7d 11 80       	cmp    $0x80117df4,%eax
80104e85:	75 d9                	jne    80104e60 <set_system_bjf_params+0x30>
80104e87:	dd d8                	fstp   %st(0)
80104e89:	dd d8                	fstp   %st(0)
80104e8b:	dd d8                	fstp   %st(0)
80104e8d:	dd d8                	fstp   %st(0)
  }
  release(&ptable.lock);
80104e8f:	83 ec 0c             	sub    $0xc,%esp
80104e92:	68 c0 52 11 80       	push   $0x801152c0
80104e97:	e8 54 0a 00 00       	call   801058f0 <release>
  return 0;
}
80104e9c:	31 c0                	xor    %eax,%eax
80104e9e:	c9                   	leave  
80104e9f:	c3                   	ret    

80104ea0 <show_process_info>:

void show_process_info()
{
80104ea0:	f3 0f 1e fb          	endbr32 
80104ea4:	55                   	push   %ebp
80104ea5:	89 e5                	mov    %esp,%ebp
80104ea7:	57                   	push   %edi
80104ea8:	56                   	push   %esi
  static int columns[] = {16, 8, 9, 8, 8, 8, 9, 8, 8, 8, 8};
  cprintf("Process_Name    PID     State    Queue   Cycle   Arrival Priority R_Prty  R_Arvl  R_Exec  R_Size  Rank\n"
          "------------------------------------------------------------------------------------------------------\n");

  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ea9:	be f4 52 11 80       	mov    $0x801152f4,%esi
{
80104eae:	53                   	push   %ebx
    n/=10;
80104eaf:	bb 67 66 66 66       	mov    $0x66666667,%ebx
{
80104eb4:	83 ec 28             	sub    $0x28,%esp
  cprintf("Process_Name    PID     State    Queue   Cycle   Arrival Priority R_Prty  R_Arvl  R_Exec  R_Size  Rank\n"
80104eb7:	68 84 8e 10 80       	push   $0x80108e84
80104ebc:	e8 ff b9 ff ff       	call   801008c0 <cprintf>
80104ec1:	83 c4 10             	add    $0x10,%esp
80104ec4:	eb 1c                	jmp    80104ee2 <show_process_info+0x42>
80104ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ed0:	81 c6 ac 00 00 00    	add    $0xac,%esi
80104ed6:	81 fe f4 7d 11 80    	cmp    $0x80117df4,%esi
80104edc:	0f 84 7a 06 00 00    	je     8010555c <show_process_info+0x6bc>
  {
    if (p->state == UNUSED)
80104ee2:	8b 46 0c             	mov    0xc(%esi),%eax
80104ee5:	85 c0                	test   %eax,%eax
80104ee7:	74 e7                	je     80104ed0 <show_process_info+0x30>

    const char *state;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "unknown state";
80104ee9:	c7 45 e0 0d 8e 10 80 	movl   $0x80108e0d,-0x20(%ebp)
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104ef0:	83 f8 05             	cmp    $0x5,%eax
80104ef3:	77 14                	ja     80104f09 <show_process_info+0x69>
80104ef5:	8b 3c 85 54 8f 10 80 	mov    -0x7fef70ac(,%eax,4),%edi
      state = "unknown state";
80104efc:	b8 0d 8e 10 80       	mov    $0x80108e0d,%eax
80104f01:	85 ff                	test   %edi,%edi
80104f03:	0f 45 c7             	cmovne %edi,%eax
80104f06:	89 45 e0             	mov    %eax,-0x20(%ebp)

    cprintf("%s", p->name);
80104f09:	83 ec 08             	sub    $0x8,%esp
80104f0c:	8d 7e 6c             	lea    0x6c(%esi),%edi
80104f0f:	57                   	push   %edi
80104f10:	68 e6 8d 10 80       	push   $0x80108de6
80104f15:	e8 a6 b9 ff ff       	call   801008c0 <cprintf>
    space(columns[0] - strlen(p->name));
80104f1a:	89 3c 24             	mov    %edi,(%esp)
80104f1d:	bf 10 00 00 00       	mov    $0x10,%edi
80104f22:	e8 19 0c 00 00       	call   80105b40 <strlen>
  for(int i = 0; i < count; ++i)
80104f27:	83 c4 10             	add    $0x10,%esp
    space(columns[0] - strlen(p->name));
80104f2a:	29 c7                	sub    %eax,%edi
80104f2c:	89 f8                	mov    %edi,%eax
  for(int i = 0; i < count; ++i)
80104f2e:	31 ff                	xor    %edi,%edi
80104f30:	85 c0                	test   %eax,%eax
80104f32:	7e 26                	jle    80104f5a <show_process_info+0xba>
80104f34:	89 75 dc             	mov    %esi,-0x24(%ebp)
80104f37:	89 fe                	mov    %edi,%esi
80104f39:	89 c7                	mov    %eax,%edi
80104f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f3f:	90                   	nop
    cprintf(" ");
80104f40:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80104f43:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80104f46:	68 58 8e 10 80       	push   $0x80108e58
80104f4b:	e8 70 b9 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80104f50:	83 c4 10             	add    $0x10,%esp
80104f53:	39 f7                	cmp    %esi,%edi
80104f55:	75 e9                	jne    80104f40 <show_process_info+0xa0>
80104f57:	8b 75 dc             	mov    -0x24(%ebp),%esi

    cprintf("%d", p->pid);
80104f5a:	83 ec 08             	sub    $0x8,%esp
80104f5d:	ff 76 10             	pushl  0x10(%esi)
  int num = 0;
80104f60:	31 ff                	xor    %edi,%edi
    cprintf("%d", p->pid);
80104f62:	68 1b 8e 10 80       	push   $0x80108e1b
80104f67:	e8 54 b9 ff ff       	call   801008c0 <cprintf>
    space(columns[1] - num_digits(p->pid));
80104f6c:	8b 4e 10             	mov    0x10(%esi),%ecx
  while(n!= 0) {
80104f6f:	83 c4 10             	add    $0x10,%esp
    space(columns[1] - num_digits(p->pid));
80104f72:	b8 08 00 00 00       	mov    $0x8,%eax
  while(n!= 0) {
80104f77:	85 c9                	test   %ecx,%ecx
80104f79:	74 23                	je     80104f9e <show_process_info+0xfe>
80104f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f7f:	90                   	nop
    n/=10;
80104f80:	89 c8                	mov    %ecx,%eax
80104f82:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
80104f85:	83 c7 01             	add    $0x1,%edi
    n/=10;
80104f88:	f7 eb                	imul   %ebx
80104f8a:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
80104f8d:	29 ca                	sub    %ecx,%edx
80104f8f:	89 d1                	mov    %edx,%ecx
80104f91:	75 ed                	jne    80104f80 <show_process_info+0xe0>
    space(columns[1] - num_digits(p->pid));
80104f93:	b8 08 00 00 00       	mov    $0x8,%eax
80104f98:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
80104f9a:	85 c0                	test   %eax,%eax
80104f9c:	7e 2c                	jle    80104fca <show_process_info+0x12a>
    space(columns[1] - num_digits(p->pid));
80104f9e:	31 ff                	xor    %edi,%edi
80104fa0:	89 75 dc             	mov    %esi,-0x24(%ebp)
80104fa3:	89 fe                	mov    %edi,%esi
80104fa5:	89 c7                	mov    %eax,%edi
80104fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fae:	66 90                	xchg   %ax,%ax
    cprintf(" ");
80104fb0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80104fb3:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80104fb6:	68 58 8e 10 80       	push   $0x80108e58
80104fbb:	e8 00 b9 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80104fc0:	83 c4 10             	add    $0x10,%esp
80104fc3:	39 fe                	cmp    %edi,%esi
80104fc5:	7c e9                	jl     80104fb0 <show_process_info+0x110>
80104fc7:	8b 75 dc             	mov    -0x24(%ebp),%esi

    cprintf("%s", state);
80104fca:	8b 7d e0             	mov    -0x20(%ebp),%edi
80104fcd:	83 ec 08             	sub    $0x8,%esp
80104fd0:	57                   	push   %edi
80104fd1:	68 e6 8d 10 80       	push   $0x80108de6
80104fd6:	e8 e5 b8 ff ff       	call   801008c0 <cprintf>
    space(columns[2] - strlen(state));
80104fdb:	89 3c 24             	mov    %edi,(%esp)
80104fde:	bf 09 00 00 00       	mov    $0x9,%edi
80104fe3:	e8 58 0b 00 00       	call   80105b40 <strlen>
  for(int i = 0; i < count; ++i)
80104fe8:	83 c4 10             	add    $0x10,%esp
    space(columns[2] - strlen(state));
80104feb:	29 c7                	sub    %eax,%edi
80104fed:	89 f8                	mov    %edi,%eax
  for(int i = 0; i < count; ++i)
80104fef:	31 ff                	xor    %edi,%edi
80104ff1:	85 c0                	test   %eax,%eax
80104ff3:	7e 25                	jle    8010501a <show_process_info+0x17a>
80104ff5:	89 75 e0             	mov    %esi,-0x20(%ebp)
80104ff8:	89 fe                	mov    %edi,%esi
80104ffa:	89 c7                	mov    %eax,%edi
80104ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80105000:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105003:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105006:	68 58 8e 10 80       	push   $0x80108e58
8010500b:	e8 b0 b8 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105010:	83 c4 10             	add    $0x10,%esp
80105013:	39 f7                	cmp    %esi,%edi
80105015:	75 e9                	jne    80105000 <show_process_info+0x160>
80105017:	8b 75 e0             	mov    -0x20(%ebp),%esi

    cprintf("%d", p->sched_info.queue);
8010501a:	83 ec 08             	sub    $0x8,%esp
8010501d:	ff b6 80 00 00 00    	pushl  0x80(%esi)
  int num = 0;
80105023:	31 ff                	xor    %edi,%edi
    cprintf("%d", p->sched_info.queue);
80105025:	68 1b 8e 10 80       	push   $0x80108e1b
8010502a:	e8 91 b8 ff ff       	call   801008c0 <cprintf>
    space(columns[3] - num_digits(p->sched_info.queue));
8010502f:	8b 8e 80 00 00 00    	mov    0x80(%esi),%ecx
  while(n!= 0) {
80105035:	83 c4 10             	add    $0x10,%esp
    space(columns[3] - num_digits(p->sched_info.queue));
80105038:	b8 08 00 00 00       	mov    $0x8,%eax
  while(n!= 0) {
8010503d:	85 c9                	test   %ecx,%ecx
8010503f:	74 25                	je     80105066 <show_process_info+0x1c6>
80105041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n/=10;
80105048:	89 c8                	mov    %ecx,%eax
8010504a:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
8010504d:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105050:	f7 eb                	imul   %ebx
80105052:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
80105055:	29 ca                	sub    %ecx,%edx
80105057:	89 d1                	mov    %edx,%ecx
80105059:	75 ed                	jne    80105048 <show_process_info+0x1a8>
    space(columns[3] - num_digits(p->sched_info.queue));
8010505b:	b8 08 00 00 00       	mov    $0x8,%eax
80105060:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
80105062:	85 c0                	test   %eax,%eax
80105064:	7e 24                	jle    8010508a <show_process_info+0x1ea>
    space(columns[3] - num_digits(p->sched_info.queue));
80105066:	31 ff                	xor    %edi,%edi
80105068:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010506b:	89 fe                	mov    %edi,%esi
8010506d:	89 c7                	mov    %eax,%edi
8010506f:	90                   	nop
    cprintf(" ");
80105070:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105073:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105076:	68 58 8e 10 80       	push   $0x80108e58
8010507b:	e8 40 b8 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105080:	83 c4 10             	add    $0x10,%esp
80105083:	39 f7                	cmp    %esi,%edi
80105085:	7f e9                	jg     80105070 <show_process_info+0x1d0>
80105087:	8b 75 e0             	mov    -0x20(%ebp),%esi

    cprintf("%d", (int)p->sched_info.bjf.executed_cycle);
8010508a:	d9 86 98 00 00 00    	flds   0x98(%esi)
80105090:	83 ec 08             	sub    $0x8,%esp
  int num = 0;
80105093:	31 ff                	xor    %edi,%edi
    cprintf("%d", (int)p->sched_info.bjf.executed_cycle);
80105095:	d9 7d e6             	fnstcw -0x1a(%ebp)
80105098:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
8010509c:	80 cc 0c             	or     $0xc,%ah
8010509f:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
801050a3:	d9 6d e4             	fldcw  -0x1c(%ebp)
801050a6:	db 5d e0             	fistpl -0x20(%ebp)
801050a9:	d9 6d e6             	fldcw  -0x1a(%ebp)
801050ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050af:	50                   	push   %eax
801050b0:	68 1b 8e 10 80       	push   $0x80108e1b
801050b5:	e8 06 b8 ff ff       	call   801008c0 <cprintf>
    space(columns[4] - num_digits((int)p->sched_info.bjf.executed_cycle));
801050ba:	d9 86 98 00 00 00    	flds   0x98(%esi)
  while(n!= 0) {
801050c0:	83 c4 10             	add    $0x10,%esp
    space(columns[4] - num_digits((int)p->sched_info.bjf.executed_cycle));
801050c3:	d9 7d e6             	fnstcw -0x1a(%ebp)
801050c6:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801050ca:	80 cc 0c             	or     $0xc,%ah
801050cd:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
801050d1:	b8 08 00 00 00       	mov    $0x8,%eax
801050d6:	d9 6d e4             	fldcw  -0x1c(%ebp)
801050d9:	db 5d e0             	fistpl -0x20(%ebp)
801050dc:	d9 6d e6             	fldcw  -0x1a(%ebp)
801050df:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  while(n!= 0) {
801050e2:	85 c9                	test   %ecx,%ecx
801050e4:	74 28                	je     8010510e <show_process_info+0x26e>
801050e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ed:	8d 76 00             	lea    0x0(%esi),%esi
    n/=10;
801050f0:	89 c8                	mov    %ecx,%eax
801050f2:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
801050f5:	83 c7 01             	add    $0x1,%edi
    n/=10;
801050f8:	f7 eb                	imul   %ebx
801050fa:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
801050fd:	29 ca                	sub    %ecx,%edx
801050ff:	89 d1                	mov    %edx,%ecx
80105101:	75 ed                	jne    801050f0 <show_process_info+0x250>
    space(columns[4] - num_digits((int)p->sched_info.bjf.executed_cycle));
80105103:	b8 08 00 00 00       	mov    $0x8,%eax
80105108:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
8010510a:	85 c0                	test   %eax,%eax
8010510c:	7e 2c                	jle    8010513a <show_process_info+0x29a>
    space(columns[4] - num_digits((int)p->sched_info.bjf.executed_cycle));
8010510e:	31 ff                	xor    %edi,%edi
80105110:	89 75 e0             	mov    %esi,-0x20(%ebp)
80105113:	89 fe                	mov    %edi,%esi
80105115:	89 c7                	mov    %eax,%edi
80105117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511e:	66 90                	xchg   %ax,%ax
    cprintf(" ");
80105120:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105123:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105126:	68 58 8e 10 80       	push   $0x80108e58
8010512b:	e8 90 b7 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105130:	83 c4 10             	add    $0x10,%esp
80105133:	39 fe                	cmp    %edi,%esi
80105135:	7c e9                	jl     80105120 <show_process_info+0x280>
80105137:	8b 75 e0             	mov    -0x20(%ebp),%esi

    cprintf("%d", p->sched_info.bjf.arrival_time);
8010513a:	83 ec 08             	sub    $0x8,%esp
8010513d:	ff b6 90 00 00 00    	pushl  0x90(%esi)
  int num = 0;
80105143:	31 ff                	xor    %edi,%edi
    cprintf("%d", p->sched_info.bjf.arrival_time);
80105145:	68 1b 8e 10 80       	push   $0x80108e1b
8010514a:	e8 71 b7 ff ff       	call   801008c0 <cprintf>
    space(columns[5] - num_digits(p->sched_info.bjf.arrival_time));
8010514f:	8b 8e 90 00 00 00    	mov    0x90(%esi),%ecx
  while(n!= 0) {
80105155:	83 c4 10             	add    $0x10,%esp
    space(columns[5] - num_digits(p->sched_info.bjf.arrival_time));
80105158:	b8 08 00 00 00       	mov    $0x8,%eax
  while(n!= 0) {
8010515d:	85 c9                	test   %ecx,%ecx
8010515f:	74 25                	je     80105186 <show_process_info+0x2e6>
80105161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n/=10;
80105168:	89 c8                	mov    %ecx,%eax
8010516a:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
8010516d:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105170:	f7 eb                	imul   %ebx
80105172:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
80105175:	29 ca                	sub    %ecx,%edx
80105177:	89 d1                	mov    %edx,%ecx
80105179:	75 ed                	jne    80105168 <show_process_info+0x2c8>
    space(columns[5] - num_digits(p->sched_info.bjf.arrival_time));
8010517b:	b8 08 00 00 00       	mov    $0x8,%eax
80105180:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
80105182:	85 c0                	test   %eax,%eax
80105184:	7e 24                	jle    801051aa <show_process_info+0x30a>
    space(columns[5] - num_digits(p->sched_info.bjf.arrival_time));
80105186:	31 ff                	xor    %edi,%edi
80105188:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010518b:	89 fe                	mov    %edi,%esi
8010518d:	89 c7                	mov    %eax,%edi
8010518f:	90                   	nop
    cprintf(" ");
80105190:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105193:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105196:	68 58 8e 10 80       	push   $0x80108e58
8010519b:	e8 20 b7 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
801051a0:	83 c4 10             	add    $0x10,%esp
801051a3:	39 fe                	cmp    %edi,%esi
801051a5:	7c e9                	jl     80105190 <show_process_info+0x2f0>
801051a7:	8b 75 e0             	mov    -0x20(%ebp),%esi

    cprintf("%d", p->sched_info.bjf.priority);
801051aa:	83 ec 08             	sub    $0x8,%esp
801051ad:	ff b6 88 00 00 00    	pushl  0x88(%esi)
  int num = 0;
801051b3:	31 ff                	xor    %edi,%edi
    cprintf("%d", p->sched_info.bjf.priority);
801051b5:	68 1b 8e 10 80       	push   $0x80108e1b
801051ba:	e8 01 b7 ff ff       	call   801008c0 <cprintf>
    space(columns[6] - num_digits(p->sched_info.bjf.priority));
801051bf:	8b 8e 88 00 00 00    	mov    0x88(%esi),%ecx
  while(n!= 0) {
801051c5:	83 c4 10             	add    $0x10,%esp
    space(columns[6] - num_digits(p->sched_info.bjf.priority));
801051c8:	b8 09 00 00 00       	mov    $0x9,%eax
  while(n!= 0) {
801051cd:	85 c9                	test   %ecx,%ecx
801051cf:	74 25                	je     801051f6 <show_process_info+0x356>
801051d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n/=10;
801051d8:	89 c8                	mov    %ecx,%eax
801051da:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
801051dd:	83 c7 01             	add    $0x1,%edi
    n/=10;
801051e0:	f7 eb                	imul   %ebx
801051e2:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
801051e5:	29 ca                	sub    %ecx,%edx
801051e7:	89 d1                	mov    %edx,%ecx
801051e9:	75 ed                	jne    801051d8 <show_process_info+0x338>
    space(columns[6] - num_digits(p->sched_info.bjf.priority));
801051eb:	b8 09 00 00 00       	mov    $0x9,%eax
801051f0:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
801051f2:	85 c0                	test   %eax,%eax
801051f4:	7e 24                	jle    8010521a <show_process_info+0x37a>
    space(columns[6] - num_digits(p->sched_info.bjf.priority));
801051f6:	31 ff                	xor    %edi,%edi
801051f8:	89 75 e0             	mov    %esi,-0x20(%ebp)
801051fb:	89 fe                	mov    %edi,%esi
801051fd:	89 c7                	mov    %eax,%edi
801051ff:	90                   	nop
    cprintf(" ");
80105200:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105203:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105206:	68 58 8e 10 80       	push   $0x80108e58
8010520b:	e8 b0 b6 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105210:	83 c4 10             	add    $0x10,%esp
80105213:	39 fe                	cmp    %edi,%esi
80105215:	7c e9                	jl     80105200 <show_process_info+0x360>
80105217:	8b 75 e0             	mov    -0x20(%ebp),%esi

    cprintf("%d", (int)p->sched_info.bjf.priority_ratio);
8010521a:	d9 86 8c 00 00 00    	flds   0x8c(%esi)
80105220:	83 ec 08             	sub    $0x8,%esp
  int num = 0;
80105223:	31 ff                	xor    %edi,%edi
    cprintf("%d", (int)p->sched_info.bjf.priority_ratio);
80105225:	d9 7d e6             	fnstcw -0x1a(%ebp)
80105228:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
8010522c:	80 cc 0c             	or     $0xc,%ah
8010522f:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80105233:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105236:	db 5d e0             	fistpl -0x20(%ebp)
80105239:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010523c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010523f:	50                   	push   %eax
80105240:	68 1b 8e 10 80       	push   $0x80108e1b
80105245:	e8 76 b6 ff ff       	call   801008c0 <cprintf>
    space(columns[7] - num_digits((int)p->sched_info.bjf.priority_ratio));
8010524a:	d9 86 8c 00 00 00    	flds   0x8c(%esi)
  while(n!= 0) {
80105250:	83 c4 10             	add    $0x10,%esp
    space(columns[7] - num_digits((int)p->sched_info.bjf.priority_ratio));
80105253:	d9 7d e6             	fnstcw -0x1a(%ebp)
80105256:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
8010525a:	80 cc 0c             	or     $0xc,%ah
8010525d:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80105261:	b8 08 00 00 00       	mov    $0x8,%eax
80105266:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105269:	db 5d e0             	fistpl -0x20(%ebp)
8010526c:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010526f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  while(n!= 0) {
80105272:	85 c9                	test   %ecx,%ecx
80105274:	74 28                	je     8010529e <show_process_info+0x3fe>
80105276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010527d:	8d 76 00             	lea    0x0(%esi),%esi
    n/=10;
80105280:	89 c8                	mov    %ecx,%eax
80105282:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
80105285:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105288:	f7 eb                	imul   %ebx
8010528a:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
8010528d:	29 ca                	sub    %ecx,%edx
8010528f:	89 d1                	mov    %edx,%ecx
80105291:	75 ed                	jne    80105280 <show_process_info+0x3e0>
    space(columns[7] - num_digits((int)p->sched_info.bjf.priority_ratio));
80105293:	b8 08 00 00 00       	mov    $0x8,%eax
80105298:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
8010529a:	85 c0                	test   %eax,%eax
8010529c:	7e 3a                	jle    801052d8 <show_process_info+0x438>
    space(columns[7] - num_digits((int)p->sched_info.bjf.priority_ratio));
8010529e:	31 ff                	xor    %edi,%edi
801052a0:	89 75 e0             	mov    %esi,-0x20(%ebp)
801052a3:	89 fe                	mov    %edi,%esi
801052a5:	89 c7                	mov    %eax,%edi
801052a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ae:	66 90                	xchg   %ax,%ax
    cprintf(" ");
801052b0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
801052b3:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
801052b6:	68 58 8e 10 80       	push   $0x80108e58
801052bb:	e8 00 b6 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
801052c0:	83 c4 10             	add    $0x10,%esp
801052c3:	39 fe                	cmp    %edi,%esi
801052c5:	7c e9                	jl     801052b0 <show_process_info+0x410>
801052c7:	d9 7d e6             	fnstcw -0x1a(%ebp)
801052ca:	8b 75 e0             	mov    -0x20(%ebp),%esi
801052cd:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801052d1:	80 cc 0c             	or     $0xc,%ah
801052d4:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)

    cprintf("%d", (int)p->sched_info.bjf.arrival_time_ratio);
801052d8:	d9 86 94 00 00 00    	flds   0x94(%esi)
801052de:	83 ec 08             	sub    $0x8,%esp
  int num = 0;
801052e1:	31 ff                	xor    %edi,%edi
    cprintf("%d", (int)p->sched_info.bjf.arrival_time_ratio);
801052e3:	d9 6d e4             	fldcw  -0x1c(%ebp)
801052e6:	db 5d e0             	fistpl -0x20(%ebp)
801052e9:	d9 6d e6             	fldcw  -0x1a(%ebp)
801052ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052ef:	50                   	push   %eax
801052f0:	68 1b 8e 10 80       	push   $0x80108e1b
801052f5:	e8 c6 b5 ff ff       	call   801008c0 <cprintf>
    space(columns[8] - num_digits((int)p->sched_info.bjf.arrival_time_ratio));
801052fa:	d9 86 94 00 00 00    	flds   0x94(%esi)
  while(n!= 0) {
80105300:	83 c4 10             	add    $0x10,%esp
    space(columns[8] - num_digits((int)p->sched_info.bjf.arrival_time_ratio));
80105303:	d9 7d e6             	fnstcw -0x1a(%ebp)
80105306:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
8010530a:	80 cc 0c             	or     $0xc,%ah
8010530d:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80105311:	b8 08 00 00 00       	mov    $0x8,%eax
80105316:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105319:	db 5d e0             	fistpl -0x20(%ebp)
8010531c:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010531f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  while(n!= 0) {
80105322:	85 c9                	test   %ecx,%ecx
80105324:	74 28                	je     8010534e <show_process_info+0x4ae>
80105326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532d:	8d 76 00             	lea    0x0(%esi),%esi
    n/=10;
80105330:	89 c8                	mov    %ecx,%eax
80105332:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
80105335:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105338:	f7 eb                	imul   %ebx
8010533a:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
8010533d:	29 ca                	sub    %ecx,%edx
8010533f:	89 d1                	mov    %edx,%ecx
80105341:	75 ed                	jne    80105330 <show_process_info+0x490>
    space(columns[8] - num_digits((int)p->sched_info.bjf.arrival_time_ratio));
80105343:	b8 08 00 00 00       	mov    $0x8,%eax
80105348:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
8010534a:	85 c0                	test   %eax,%eax
8010534c:	7e 3a                	jle    80105388 <show_process_info+0x4e8>
    space(columns[8] - num_digits((int)p->sched_info.bjf.arrival_time_ratio));
8010534e:	31 ff                	xor    %edi,%edi
80105350:	89 75 e0             	mov    %esi,-0x20(%ebp)
80105353:	89 fe                	mov    %edi,%esi
80105355:	89 c7                	mov    %eax,%edi
80105357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535e:	66 90                	xchg   %ax,%ax
    cprintf(" ");
80105360:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105363:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105366:	68 58 8e 10 80       	push   $0x80108e58
8010536b:	e8 50 b5 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105370:	83 c4 10             	add    $0x10,%esp
80105373:	39 fe                	cmp    %edi,%esi
80105375:	7c e9                	jl     80105360 <show_process_info+0x4c0>
80105377:	d9 7d e6             	fnstcw -0x1a(%ebp)
8010537a:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010537d:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80105381:	80 cc 0c             	or     $0xc,%ah
80105384:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)

    cprintf("%d", (int)p->sched_info.bjf.executed_cycle_ratio);
80105388:	d9 86 9c 00 00 00    	flds   0x9c(%esi)
8010538e:	83 ec 08             	sub    $0x8,%esp
  int num = 0;
80105391:	31 ff                	xor    %edi,%edi
    cprintf("%d", (int)p->sched_info.bjf.executed_cycle_ratio);
80105393:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105396:	db 5d e0             	fistpl -0x20(%ebp)
80105399:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010539c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010539f:	50                   	push   %eax
801053a0:	68 1b 8e 10 80       	push   $0x80108e1b
801053a5:	e8 16 b5 ff ff       	call   801008c0 <cprintf>
    space(columns[9] - num_digits((int)p->sched_info.bjf.executed_cycle_ratio));
801053aa:	d9 86 9c 00 00 00    	flds   0x9c(%esi)
  while(n!= 0) {
801053b0:	83 c4 10             	add    $0x10,%esp
    space(columns[9] - num_digits((int)p->sched_info.bjf.executed_cycle_ratio));
801053b3:	d9 7d e6             	fnstcw -0x1a(%ebp)
801053b6:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801053ba:	80 cc 0c             	or     $0xc,%ah
801053bd:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
801053c1:	b8 08 00 00 00       	mov    $0x8,%eax
801053c6:	d9 6d e4             	fldcw  -0x1c(%ebp)
801053c9:	db 5d e0             	fistpl -0x20(%ebp)
801053cc:	d9 6d e6             	fldcw  -0x1a(%ebp)
801053cf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  while(n!= 0) {
801053d2:	85 c9                	test   %ecx,%ecx
801053d4:	74 28                	je     801053fe <show_process_info+0x55e>
801053d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053dd:	8d 76 00             	lea    0x0(%esi),%esi
    n/=10;
801053e0:	89 c8                	mov    %ecx,%eax
801053e2:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
801053e5:	83 c7 01             	add    $0x1,%edi
    n/=10;
801053e8:	f7 eb                	imul   %ebx
801053ea:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
801053ed:	29 ca                	sub    %ecx,%edx
801053ef:	89 d1                	mov    %edx,%ecx
801053f1:	75 ed                	jne    801053e0 <show_process_info+0x540>
    space(columns[9] - num_digits((int)p->sched_info.bjf.executed_cycle_ratio));
801053f3:	b8 08 00 00 00       	mov    $0x8,%eax
801053f8:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
801053fa:	85 c0                	test   %eax,%eax
801053fc:	7e 3a                	jle    80105438 <show_process_info+0x598>
    space(columns[9] - num_digits((int)p->sched_info.bjf.executed_cycle_ratio));
801053fe:	31 ff                	xor    %edi,%edi
80105400:	89 75 e0             	mov    %esi,-0x20(%ebp)
80105403:	89 fe                	mov    %edi,%esi
80105405:	89 c7                	mov    %eax,%edi
80105407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010540e:	66 90                	xchg   %ax,%ax
    cprintf(" ");
80105410:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105413:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105416:	68 58 8e 10 80       	push   $0x80108e58
8010541b:	e8 a0 b4 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105420:	83 c4 10             	add    $0x10,%esp
80105423:	39 fe                	cmp    %edi,%esi
80105425:	7c e9                	jl     80105410 <show_process_info+0x570>
80105427:	d9 7d e6             	fnstcw -0x1a(%ebp)
8010542a:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010542d:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80105431:	80 cc 0c             	or     $0xc,%ah
80105434:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)

    cprintf("%d", (int)p->sched_info.bjf.process_size_ratio);
80105438:	d9 86 a4 00 00 00    	flds   0xa4(%esi)
8010543e:	83 ec 08             	sub    $0x8,%esp
  int num = 0;
80105441:	31 ff                	xor    %edi,%edi
    cprintf("%d", (int)p->sched_info.bjf.process_size_ratio);
80105443:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105446:	db 5d e0             	fistpl -0x20(%ebp)
80105449:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010544c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010544f:	50                   	push   %eax
80105450:	68 1b 8e 10 80       	push   $0x80108e1b
80105455:	e8 66 b4 ff ff       	call   801008c0 <cprintf>
    space(columns[10] - num_digits((int)p->sched_info.bjf.process_size_ratio));
8010545a:	d9 86 a4 00 00 00    	flds   0xa4(%esi)
  while(n!= 0) {
80105460:	83 c4 10             	add    $0x10,%esp
    space(columns[10] - num_digits((int)p->sched_info.bjf.process_size_ratio));
80105463:	d9 7d e6             	fnstcw -0x1a(%ebp)
80105466:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
8010546a:	80 cc 0c             	or     $0xc,%ah
8010546d:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80105471:	b8 08 00 00 00       	mov    $0x8,%eax
80105476:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105479:	db 55 e0             	fistl  -0x20(%ebp)
8010547c:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010547f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  while(n!= 0) {
80105482:	85 c9                	test   %ecx,%ecx
80105484:	74 32                	je     801054b8 <show_process_info+0x618>
80105486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010548d:	8d 76 00             	lea    0x0(%esi),%esi
    n/=10;
80105490:	89 c8                	mov    %ecx,%eax
80105492:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
80105495:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105498:	f7 eb                	imul   %ebx
8010549a:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
8010549d:	29 ca                	sub    %ecx,%edx
8010549f:	89 d1                	mov    %edx,%ecx
801054a1:	75 ed                	jne    80105490 <show_process_info+0x5f0>
    space(columns[10] - num_digits((int)p->sched_info.bjf.process_size_ratio));
801054a3:	b8 08 00 00 00       	mov    $0x8,%eax
801054a8:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
801054aa:	85 c0                	test   %eax,%eax
801054ac:	7e 50                	jle    801054fe <show_process_info+0x65e>
801054ae:	dd d8                	fstp   %st(0)
801054b0:	eb 0e                	jmp    801054c0 <show_process_info+0x620>
801054b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054b8:	dd d8                	fstp   %st(0)
801054ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    space(columns[10] - num_digits((int)p->sched_info.bjf.process_size_ratio));
801054c0:	31 ff                	xor    %edi,%edi
801054c2:	89 75 e0             	mov    %esi,-0x20(%ebp)
801054c5:	89 fe                	mov    %edi,%esi
801054c7:	89 c7                	mov    %eax,%edi
801054c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
801054d0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
801054d3:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
801054d6:	68 58 8e 10 80       	push   $0x80108e58
801054db:	e8 e0 b3 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
801054e0:	83 c4 10             	add    $0x10,%esp
801054e3:	39 fe                	cmp    %edi,%esi
801054e5:	7c e9                	jl     801054d0 <show_process_info+0x630>
801054e7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801054ea:	d9 86 a4 00 00 00    	flds   0xa4(%esi)
801054f0:	d9 7d e6             	fnstcw -0x1a(%ebp)
801054f3:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801054f7:	80 cc 0c             	or     $0xc,%ah
801054fa:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
801054fe:	db 86 90 00 00 00    	fildl  0x90(%esi)
80105504:	d8 8e 94 00 00 00    	fmuls  0x94(%esi)

    cprintf("%d", (int)bjfrank(p));
8010550a:	83 ec 08             	sub    $0x8,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010550d:	81 c6 ac 00 00 00    	add    $0xac,%esi
  return p->sched_info.bjf.priority * p->sched_info.bjf.priority_ratio +
80105513:	db 46 dc             	fildl  -0x24(%esi)
80105516:	d8 4e e0             	fmuls  -0x20(%esi)
80105519:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
8010551b:	d9 46 ec             	flds   -0x14(%esi)
8010551e:	d8 4e f0             	fmuls  -0x10(%esi)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
80105521:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.process_size * p->sched_info.bjf.process_size_ratio;
80105523:	db 46 f4             	fildl  -0xc(%esi)
80105526:	de ca                	fmulp  %st,%st(2)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
80105528:	de c1                	faddp  %st,%st(1)
    cprintf("%d", (int)bjfrank(p));
8010552a:	d9 6d e4             	fldcw  -0x1c(%ebp)
8010552d:	db 5d e0             	fistpl -0x20(%ebp)
80105530:	d9 6d e6             	fldcw  -0x1a(%ebp)
80105533:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105536:	50                   	push   %eax
80105537:	68 1b 8e 10 80       	push   $0x80108e1b
8010553c:	e8 7f b3 ff ff       	call   801008c0 <cprintf>
    cprintf("\n");
80105541:	c7 04 24 df 92 10 80 	movl   $0x801092df,(%esp)
80105548:	e8 73 b3 ff ff       	call   801008c0 <cprintf>
8010554d:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105550:	81 fe f4 7d 11 80    	cmp    $0x80117df4,%esi
80105556:	0f 85 86 f9 ff ff    	jne    80104ee2 <show_process_info+0x42>
  }
}
8010555c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010555f:	5b                   	pop    %ebx
80105560:	5e                   	pop    %esi
80105561:	5f                   	pop    %edi
80105562:	5d                   	pop    %ebp
80105563:	c3                   	ret    
80105564:	66 90                	xchg   %ax,%ax
80105566:	66 90                	xchg   %ax,%ax
80105568:	66 90                	xchg   %ax,%ax
8010556a:	66 90                	xchg   %ax,%ax
8010556c:	66 90                	xchg   %ax,%ax
8010556e:	66 90                	xchg   %ax,%ax

80105570 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105570:	f3 0f 1e fb          	endbr32 
80105574:	55                   	push   %ebp
80105575:	89 e5                	mov    %esp,%ebp
80105577:	53                   	push   %ebx
80105578:	83 ec 0c             	sub    $0xc,%esp
8010557b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010557e:	68 8c 8f 10 80       	push   $0x80108f8c
80105583:	8d 43 04             	lea    0x4(%ebx),%eax
80105586:	50                   	push   %eax
80105587:	e8 24 01 00 00       	call   801056b0 <initlock>
  lk->name = name;
8010558c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010558f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105595:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105598:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010559f:	89 43 38             	mov    %eax,0x38(%ebx)
}
801055a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055a5:	c9                   	leave  
801055a6:	c3                   	ret    
801055a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ae:	66 90                	xchg   %ax,%ax

801055b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801055b0:	f3 0f 1e fb          	endbr32 
801055b4:	55                   	push   %ebp
801055b5:	89 e5                	mov    %esp,%ebp
801055b7:	56                   	push   %esi
801055b8:	53                   	push   %ebx
801055b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801055bc:	8d 73 04             	lea    0x4(%ebx),%esi
801055bf:	83 ec 0c             	sub    $0xc,%esp
801055c2:	56                   	push   %esi
801055c3:	e8 68 02 00 00       	call   80105830 <acquire>
  while (lk->locked) {
801055c8:	8b 13                	mov    (%ebx),%edx
801055ca:	83 c4 10             	add    $0x10,%esp
801055cd:	85 d2                	test   %edx,%edx
801055cf:	74 1a                	je     801055eb <acquiresleep+0x3b>
801055d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801055d8:	83 ec 08             	sub    $0x8,%esp
801055db:	56                   	push   %esi
801055dc:	53                   	push   %ebx
801055dd:	e8 ae ee ff ff       	call   80104490 <sleep>
  while (lk->locked) {
801055e2:	8b 03                	mov    (%ebx),%eax
801055e4:	83 c4 10             	add    $0x10,%esp
801055e7:	85 c0                	test   %eax,%eax
801055e9:	75 ed                	jne    801055d8 <acquiresleep+0x28>
  }
  lk->locked = 1;
801055eb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801055f1:	e8 ba e8 ff ff       	call   80103eb0 <myproc>
801055f6:	8b 40 10             	mov    0x10(%eax),%eax
801055f9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801055fc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801055ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105602:	5b                   	pop    %ebx
80105603:	5e                   	pop    %esi
80105604:	5d                   	pop    %ebp
  release(&lk->lk);
80105605:	e9 e6 02 00 00       	jmp    801058f0 <release>
8010560a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105610 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105610:	f3 0f 1e fb          	endbr32 
80105614:	55                   	push   %ebp
80105615:	89 e5                	mov    %esp,%ebp
80105617:	56                   	push   %esi
80105618:	53                   	push   %ebx
80105619:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010561c:	8d 73 04             	lea    0x4(%ebx),%esi
8010561f:	83 ec 0c             	sub    $0xc,%esp
80105622:	56                   	push   %esi
80105623:	e8 08 02 00 00       	call   80105830 <acquire>
  lk->locked = 0;
80105628:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010562e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105635:	89 1c 24             	mov    %ebx,(%esp)
80105638:	e8 13 f0 ff ff       	call   80104650 <wakeup>
  release(&lk->lk);
8010563d:	89 75 08             	mov    %esi,0x8(%ebp)
80105640:	83 c4 10             	add    $0x10,%esp
}
80105643:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105646:	5b                   	pop    %ebx
80105647:	5e                   	pop    %esi
80105648:	5d                   	pop    %ebp
  release(&lk->lk);
80105649:	e9 a2 02 00 00       	jmp    801058f0 <release>
8010564e:	66 90                	xchg   %ax,%ax

80105650 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105650:	f3 0f 1e fb          	endbr32 
80105654:	55                   	push   %ebp
80105655:	89 e5                	mov    %esp,%ebp
80105657:	57                   	push   %edi
80105658:	31 ff                	xor    %edi,%edi
8010565a:	56                   	push   %esi
8010565b:	53                   	push   %ebx
8010565c:	83 ec 18             	sub    $0x18,%esp
8010565f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80105662:	8d 73 04             	lea    0x4(%ebx),%esi
80105665:	56                   	push   %esi
80105666:	e8 c5 01 00 00       	call   80105830 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010566b:	8b 03                	mov    (%ebx),%eax
8010566d:	83 c4 10             	add    $0x10,%esp
80105670:	85 c0                	test   %eax,%eax
80105672:	75 1c                	jne    80105690 <holdingsleep+0x40>
  release(&lk->lk);
80105674:	83 ec 0c             	sub    $0xc,%esp
80105677:	56                   	push   %esi
80105678:	e8 73 02 00 00       	call   801058f0 <release>
  return r;
}
8010567d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105680:	89 f8                	mov    %edi,%eax
80105682:	5b                   	pop    %ebx
80105683:	5e                   	pop    %esi
80105684:	5f                   	pop    %edi
80105685:	5d                   	pop    %ebp
80105686:	c3                   	ret    
80105687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010568e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80105690:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105693:	e8 18 e8 ff ff       	call   80103eb0 <myproc>
80105698:	39 58 10             	cmp    %ebx,0x10(%eax)
8010569b:	0f 94 c0             	sete   %al
8010569e:	0f b6 c0             	movzbl %al,%eax
801056a1:	89 c7                	mov    %eax,%edi
801056a3:	eb cf                	jmp    80105674 <holdingsleep+0x24>
801056a5:	66 90                	xchg   %ax,%ax
801056a7:	66 90                	xchg   %ax,%ax
801056a9:	66 90                	xchg   %ax,%ax
801056ab:	66 90                	xchg   %ax,%ax
801056ad:	66 90                	xchg   %ax,%ax
801056af:	90                   	nop

801056b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801056b0:	f3 0f 1e fb          	endbr32 
801056b4:	55                   	push   %ebp
801056b5:	89 e5                	mov    %esp,%ebp
801056b7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801056ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801056bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801056c3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801056c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801056cd:	5d                   	pop    %ebp
801056ce:	c3                   	ret    
801056cf:	90                   	nop

801056d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801056d0:	f3 0f 1e fb          	endbr32 
801056d4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801056d5:	31 d2                	xor    %edx,%edx
{
801056d7:	89 e5                	mov    %esp,%ebp
801056d9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801056da:	8b 45 08             	mov    0x8(%ebp),%eax
{
801056dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801056e0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801056e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056e7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801056e8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801056ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801056f4:	77 1a                	ja     80105710 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
801056f6:	8b 58 04             	mov    0x4(%eax),%ebx
801056f9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801056fc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801056ff:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105701:	83 fa 0a             	cmp    $0xa,%edx
80105704:	75 e2                	jne    801056e8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80105706:	5b                   	pop    %ebx
80105707:	5d                   	pop    %ebp
80105708:	c3                   	ret    
80105709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105710:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105713:	8d 51 28             	lea    0x28(%ecx),%edx
80105716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80105720:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105726:	83 c0 04             	add    $0x4,%eax
80105729:	39 d0                	cmp    %edx,%eax
8010572b:	75 f3                	jne    80105720 <getcallerpcs+0x50>
}
8010572d:	5b                   	pop    %ebx
8010572e:	5d                   	pop    %ebp
8010572f:	c3                   	ret    

80105730 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105730:	f3 0f 1e fb          	endbr32 
80105734:	55                   	push   %ebp
80105735:	89 e5                	mov    %esp,%ebp
80105737:	53                   	push   %ebx
80105738:	83 ec 04             	sub    $0x4,%esp
8010573b:	9c                   	pushf  
8010573c:	5b                   	pop    %ebx
  asm volatile("cli");
8010573d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010573e:	e8 dd e6 ff ff       	call   80103e20 <mycpu>
80105743:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105749:	85 c0                	test   %eax,%eax
8010574b:	74 13                	je     80105760 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010574d:	e8 ce e6 ff ff       	call   80103e20 <mycpu>
80105752:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105759:	83 c4 04             	add    $0x4,%esp
8010575c:	5b                   	pop    %ebx
8010575d:	5d                   	pop    %ebp
8010575e:	c3                   	ret    
8010575f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80105760:	e8 bb e6 ff ff       	call   80103e20 <mycpu>
80105765:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010576b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105771:	eb da                	jmp    8010574d <pushcli+0x1d>
80105773:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105780 <popcli>:

void
popcli(void)
{
80105780:	f3 0f 1e fb          	endbr32 
80105784:	55                   	push   %ebp
80105785:	89 e5                	mov    %esp,%ebp
80105787:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010578a:	9c                   	pushf  
8010578b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010578c:	f6 c4 02             	test   $0x2,%ah
8010578f:	75 31                	jne    801057c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105791:	e8 8a e6 ff ff       	call   80103e20 <mycpu>
80105796:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010579d:	78 30                	js     801057cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010579f:	e8 7c e6 ff ff       	call   80103e20 <mycpu>
801057a4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801057aa:	85 d2                	test   %edx,%edx
801057ac:	74 02                	je     801057b0 <popcli+0x30>
    sti();
}
801057ae:	c9                   	leave  
801057af:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
801057b0:	e8 6b e6 ff ff       	call   80103e20 <mycpu>
801057b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801057bb:	85 c0                	test   %eax,%eax
801057bd:	74 ef                	je     801057ae <popcli+0x2e>
  asm volatile("sti");
801057bf:	fb                   	sti    
}
801057c0:	c9                   	leave  
801057c1:	c3                   	ret    
    panic("popcli - interruptible");
801057c2:	83 ec 0c             	sub    $0xc,%esp
801057c5:	68 97 8f 10 80       	push   $0x80108f97
801057ca:	e8 c1 ab ff ff       	call   80100390 <panic>
    panic("popcli");
801057cf:	83 ec 0c             	sub    $0xc,%esp
801057d2:	68 ae 8f 10 80       	push   $0x80108fae
801057d7:	e8 b4 ab ff ff       	call   80100390 <panic>
801057dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057e0 <holding>:
{
801057e0:	f3 0f 1e fb          	endbr32 
801057e4:	55                   	push   %ebp
801057e5:	89 e5                	mov    %esp,%ebp
801057e7:	56                   	push   %esi
801057e8:	53                   	push   %ebx
801057e9:	8b 75 08             	mov    0x8(%ebp),%esi
801057ec:	31 db                	xor    %ebx,%ebx
  pushcli();
801057ee:	e8 3d ff ff ff       	call   80105730 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801057f3:	8b 06                	mov    (%esi),%eax
801057f5:	85 c0                	test   %eax,%eax
801057f7:	75 0f                	jne    80105808 <holding+0x28>
  popcli();
801057f9:	e8 82 ff ff ff       	call   80105780 <popcli>
}
801057fe:	89 d8                	mov    %ebx,%eax
80105800:	5b                   	pop    %ebx
80105801:	5e                   	pop    %esi
80105802:	5d                   	pop    %ebp
80105803:	c3                   	ret    
80105804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80105808:	8b 5e 08             	mov    0x8(%esi),%ebx
8010580b:	e8 10 e6 ff ff       	call   80103e20 <mycpu>
80105810:	39 c3                	cmp    %eax,%ebx
80105812:	0f 94 c3             	sete   %bl
  popcli();
80105815:	e8 66 ff ff ff       	call   80105780 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010581a:	0f b6 db             	movzbl %bl,%ebx
}
8010581d:	89 d8                	mov    %ebx,%eax
8010581f:	5b                   	pop    %ebx
80105820:	5e                   	pop    %esi
80105821:	5d                   	pop    %ebp
80105822:	c3                   	ret    
80105823:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105830 <acquire>:
{
80105830:	f3 0f 1e fb          	endbr32 
80105834:	55                   	push   %ebp
80105835:	89 e5                	mov    %esp,%ebp
80105837:	56                   	push   %esi
80105838:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105839:	e8 f2 fe ff ff       	call   80105730 <pushcli>
  if(holding(lk))
8010583e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105841:	83 ec 0c             	sub    $0xc,%esp
80105844:	53                   	push   %ebx
80105845:	e8 96 ff ff ff       	call   801057e0 <holding>
8010584a:	83 c4 10             	add    $0x10,%esp
8010584d:	85 c0                	test   %eax,%eax
8010584f:	0f 85 7f 00 00 00    	jne    801058d4 <acquire+0xa4>
80105855:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105857:	ba 01 00 00 00       	mov    $0x1,%edx
8010585c:	eb 05                	jmp    80105863 <acquire+0x33>
8010585e:	66 90                	xchg   %ax,%ax
80105860:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105863:	89 d0                	mov    %edx,%eax
80105865:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105868:	85 c0                	test   %eax,%eax
8010586a:	75 f4                	jne    80105860 <acquire+0x30>
  __sync_synchronize();
8010586c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105871:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105874:	e8 a7 e5 ff ff       	call   80103e20 <mycpu>
80105879:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010587c:	89 e8                	mov    %ebp,%eax
8010587e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105880:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80105886:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010588c:	77 22                	ja     801058b0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010588e:	8b 50 04             	mov    0x4(%eax),%edx
80105891:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80105895:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80105898:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010589a:	83 fe 0a             	cmp    $0xa,%esi
8010589d:	75 e1                	jne    80105880 <acquire+0x50>
}
8010589f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058a2:	5b                   	pop    %ebx
801058a3:	5e                   	pop    %esi
801058a4:	5d                   	pop    %ebp
801058a5:	c3                   	ret    
801058a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
801058b0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
801058b4:	83 c3 34             	add    $0x34,%ebx
801058b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801058c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801058c6:	83 c0 04             	add    $0x4,%eax
801058c9:	39 d8                	cmp    %ebx,%eax
801058cb:	75 f3                	jne    801058c0 <acquire+0x90>
}
801058cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058d0:	5b                   	pop    %ebx
801058d1:	5e                   	pop    %esi
801058d2:	5d                   	pop    %ebp
801058d3:	c3                   	ret    
    panic("acquire");
801058d4:	83 ec 0c             	sub    $0xc,%esp
801058d7:	68 b5 8f 10 80       	push   $0x80108fb5
801058dc:	e8 af aa ff ff       	call   80100390 <panic>
801058e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ef:	90                   	nop

801058f0 <release>:
{
801058f0:	f3 0f 1e fb          	endbr32 
801058f4:	55                   	push   %ebp
801058f5:	89 e5                	mov    %esp,%ebp
801058f7:	53                   	push   %ebx
801058f8:	83 ec 10             	sub    $0x10,%esp
801058fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801058fe:	53                   	push   %ebx
801058ff:	e8 dc fe ff ff       	call   801057e0 <holding>
80105904:	83 c4 10             	add    $0x10,%esp
80105907:	85 c0                	test   %eax,%eax
80105909:	74 22                	je     8010592d <release+0x3d>
  lk->pcs[0] = 0;
8010590b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105912:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105919:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010591e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105924:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105927:	c9                   	leave  
  popcli();
80105928:	e9 53 fe ff ff       	jmp    80105780 <popcli>
    panic("release");
8010592d:	83 ec 0c             	sub    $0xc,%esp
80105930:	68 bd 8f 10 80       	push   $0x80108fbd
80105935:	e8 56 aa ff ff       	call   80100390 <panic>
8010593a:	66 90                	xchg   %ax,%ax
8010593c:	66 90                	xchg   %ax,%ax
8010593e:	66 90                	xchg   %ax,%ax

80105940 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105940:	f3 0f 1e fb          	endbr32 
80105944:	55                   	push   %ebp
80105945:	89 e5                	mov    %esp,%ebp
80105947:	57                   	push   %edi
80105948:	8b 55 08             	mov    0x8(%ebp),%edx
8010594b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010594e:	53                   	push   %ebx
8010594f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105952:	89 d7                	mov    %edx,%edi
80105954:	09 cf                	or     %ecx,%edi
80105956:	83 e7 03             	and    $0x3,%edi
80105959:	75 25                	jne    80105980 <memset+0x40>
    c &= 0xFF;
8010595b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010595e:	c1 e0 18             	shl    $0x18,%eax
80105961:	89 fb                	mov    %edi,%ebx
80105963:	c1 e9 02             	shr    $0x2,%ecx
80105966:	c1 e3 10             	shl    $0x10,%ebx
80105969:	09 d8                	or     %ebx,%eax
8010596b:	09 f8                	or     %edi,%eax
8010596d:	c1 e7 08             	shl    $0x8,%edi
80105970:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105972:	89 d7                	mov    %edx,%edi
80105974:	fc                   	cld    
80105975:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105977:	5b                   	pop    %ebx
80105978:	89 d0                	mov    %edx,%eax
8010597a:	5f                   	pop    %edi
8010597b:	5d                   	pop    %ebp
8010597c:	c3                   	ret    
8010597d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80105980:	89 d7                	mov    %edx,%edi
80105982:	fc                   	cld    
80105983:	f3 aa                	rep stos %al,%es:(%edi)
80105985:	5b                   	pop    %ebx
80105986:	89 d0                	mov    %edx,%eax
80105988:	5f                   	pop    %edi
80105989:	5d                   	pop    %ebp
8010598a:	c3                   	ret    
8010598b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010598f:	90                   	nop

80105990 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105990:	f3 0f 1e fb          	endbr32 
80105994:	55                   	push   %ebp
80105995:	89 e5                	mov    %esp,%ebp
80105997:	56                   	push   %esi
80105998:	8b 75 10             	mov    0x10(%ebp),%esi
8010599b:	8b 55 08             	mov    0x8(%ebp),%edx
8010599e:	53                   	push   %ebx
8010599f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801059a2:	85 f6                	test   %esi,%esi
801059a4:	74 2a                	je     801059d0 <memcmp+0x40>
801059a6:	01 c6                	add    %eax,%esi
801059a8:	eb 10                	jmp    801059ba <memcmp+0x2a>
801059aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801059b0:	83 c0 01             	add    $0x1,%eax
801059b3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801059b6:	39 f0                	cmp    %esi,%eax
801059b8:	74 16                	je     801059d0 <memcmp+0x40>
    if(*s1 != *s2)
801059ba:	0f b6 0a             	movzbl (%edx),%ecx
801059bd:	0f b6 18             	movzbl (%eax),%ebx
801059c0:	38 d9                	cmp    %bl,%cl
801059c2:	74 ec                	je     801059b0 <memcmp+0x20>
      return *s1 - *s2;
801059c4:	0f b6 c1             	movzbl %cl,%eax
801059c7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801059c9:	5b                   	pop    %ebx
801059ca:	5e                   	pop    %esi
801059cb:	5d                   	pop    %ebp
801059cc:	c3                   	ret    
801059cd:	8d 76 00             	lea    0x0(%esi),%esi
801059d0:	5b                   	pop    %ebx
  return 0;
801059d1:	31 c0                	xor    %eax,%eax
}
801059d3:	5e                   	pop    %esi
801059d4:	5d                   	pop    %ebp
801059d5:	c3                   	ret    
801059d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059dd:	8d 76 00             	lea    0x0(%esi),%esi

801059e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801059e0:	f3 0f 1e fb          	endbr32 
801059e4:	55                   	push   %ebp
801059e5:	89 e5                	mov    %esp,%ebp
801059e7:	57                   	push   %edi
801059e8:	8b 55 08             	mov    0x8(%ebp),%edx
801059eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801059ee:	56                   	push   %esi
801059ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801059f2:	39 d6                	cmp    %edx,%esi
801059f4:	73 2a                	jae    80105a20 <memmove+0x40>
801059f6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801059f9:	39 fa                	cmp    %edi,%edx
801059fb:	73 23                	jae    80105a20 <memmove+0x40>
801059fd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105a00:	85 c9                	test   %ecx,%ecx
80105a02:	74 13                	je     80105a17 <memmove+0x37>
80105a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105a08:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105a0c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105a0f:	83 e8 01             	sub    $0x1,%eax
80105a12:	83 f8 ff             	cmp    $0xffffffff,%eax
80105a15:	75 f1                	jne    80105a08 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105a17:	5e                   	pop    %esi
80105a18:	89 d0                	mov    %edx,%eax
80105a1a:	5f                   	pop    %edi
80105a1b:	5d                   	pop    %ebp
80105a1c:	c3                   	ret    
80105a1d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105a20:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105a23:	89 d7                	mov    %edx,%edi
80105a25:	85 c9                	test   %ecx,%ecx
80105a27:	74 ee                	je     80105a17 <memmove+0x37>
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105a30:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105a31:	39 f0                	cmp    %esi,%eax
80105a33:	75 fb                	jne    80105a30 <memmove+0x50>
}
80105a35:	5e                   	pop    %esi
80105a36:	89 d0                	mov    %edx,%eax
80105a38:	5f                   	pop    %edi
80105a39:	5d                   	pop    %ebp
80105a3a:	c3                   	ret    
80105a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a3f:	90                   	nop

80105a40 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105a40:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105a44:	eb 9a                	jmp    801059e0 <memmove>
80105a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4d:	8d 76 00             	lea    0x0(%esi),%esi

80105a50 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105a50:	f3 0f 1e fb          	endbr32 
80105a54:	55                   	push   %ebp
80105a55:	89 e5                	mov    %esp,%ebp
80105a57:	56                   	push   %esi
80105a58:	8b 75 10             	mov    0x10(%ebp),%esi
80105a5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105a5e:	53                   	push   %ebx
80105a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105a62:	85 f6                	test   %esi,%esi
80105a64:	74 32                	je     80105a98 <strncmp+0x48>
80105a66:	01 c6                	add    %eax,%esi
80105a68:	eb 14                	jmp    80105a7e <strncmp+0x2e>
80105a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a70:	38 da                	cmp    %bl,%dl
80105a72:	75 14                	jne    80105a88 <strncmp+0x38>
    n--, p++, q++;
80105a74:	83 c0 01             	add    $0x1,%eax
80105a77:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80105a7a:	39 f0                	cmp    %esi,%eax
80105a7c:	74 1a                	je     80105a98 <strncmp+0x48>
80105a7e:	0f b6 11             	movzbl (%ecx),%edx
80105a81:	0f b6 18             	movzbl (%eax),%ebx
80105a84:	84 d2                	test   %dl,%dl
80105a86:	75 e8                	jne    80105a70 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105a88:	0f b6 c2             	movzbl %dl,%eax
80105a8b:	29 d8                	sub    %ebx,%eax
}
80105a8d:	5b                   	pop    %ebx
80105a8e:	5e                   	pop    %esi
80105a8f:	5d                   	pop    %ebp
80105a90:	c3                   	ret    
80105a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a98:	5b                   	pop    %ebx
    return 0;
80105a99:	31 c0                	xor    %eax,%eax
}
80105a9b:	5e                   	pop    %esi
80105a9c:	5d                   	pop    %ebp
80105a9d:	c3                   	ret    
80105a9e:	66 90                	xchg   %ax,%ax

80105aa0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105aa0:	f3 0f 1e fb          	endbr32 
80105aa4:	55                   	push   %ebp
80105aa5:	89 e5                	mov    %esp,%ebp
80105aa7:	57                   	push   %edi
80105aa8:	56                   	push   %esi
80105aa9:	8b 75 08             	mov    0x8(%ebp),%esi
80105aac:	53                   	push   %ebx
80105aad:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105ab0:	89 f2                	mov    %esi,%edx
80105ab2:	eb 1b                	jmp    80105acf <strncpy+0x2f>
80105ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ab8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105abc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105abf:	83 c2 01             	add    $0x1,%edx
80105ac2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105ac6:	89 f9                	mov    %edi,%ecx
80105ac8:	88 4a ff             	mov    %cl,-0x1(%edx)
80105acb:	84 c9                	test   %cl,%cl
80105acd:	74 09                	je     80105ad8 <strncpy+0x38>
80105acf:	89 c3                	mov    %eax,%ebx
80105ad1:	83 e8 01             	sub    $0x1,%eax
80105ad4:	85 db                	test   %ebx,%ebx
80105ad6:	7f e0                	jg     80105ab8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105ad8:	89 d1                	mov    %edx,%ecx
80105ada:	85 c0                	test   %eax,%eax
80105adc:	7e 15                	jle    80105af3 <strncpy+0x53>
80105ade:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105ae0:	83 c1 01             	add    $0x1,%ecx
80105ae3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105ae7:	89 c8                	mov    %ecx,%eax
80105ae9:	f7 d0                	not    %eax
80105aeb:	01 d0                	add    %edx,%eax
80105aed:	01 d8                	add    %ebx,%eax
80105aef:	85 c0                	test   %eax,%eax
80105af1:	7f ed                	jg     80105ae0 <strncpy+0x40>
  return os;
}
80105af3:	5b                   	pop    %ebx
80105af4:	89 f0                	mov    %esi,%eax
80105af6:	5e                   	pop    %esi
80105af7:	5f                   	pop    %edi
80105af8:	5d                   	pop    %ebp
80105af9:	c3                   	ret    
80105afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105b00:	f3 0f 1e fb          	endbr32 
80105b04:	55                   	push   %ebp
80105b05:	89 e5                	mov    %esp,%ebp
80105b07:	56                   	push   %esi
80105b08:	8b 55 10             	mov    0x10(%ebp),%edx
80105b0b:	8b 75 08             	mov    0x8(%ebp),%esi
80105b0e:	53                   	push   %ebx
80105b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105b12:	85 d2                	test   %edx,%edx
80105b14:	7e 21                	jle    80105b37 <safestrcpy+0x37>
80105b16:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105b1a:	89 f2                	mov    %esi,%edx
80105b1c:	eb 12                	jmp    80105b30 <safestrcpy+0x30>
80105b1e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105b20:	0f b6 08             	movzbl (%eax),%ecx
80105b23:	83 c0 01             	add    $0x1,%eax
80105b26:	83 c2 01             	add    $0x1,%edx
80105b29:	88 4a ff             	mov    %cl,-0x1(%edx)
80105b2c:	84 c9                	test   %cl,%cl
80105b2e:	74 04                	je     80105b34 <safestrcpy+0x34>
80105b30:	39 d8                	cmp    %ebx,%eax
80105b32:	75 ec                	jne    80105b20 <safestrcpy+0x20>
    ;
  *s = 0;
80105b34:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105b37:	89 f0                	mov    %esi,%eax
80105b39:	5b                   	pop    %ebx
80105b3a:	5e                   	pop    %esi
80105b3b:	5d                   	pop    %ebp
80105b3c:	c3                   	ret    
80105b3d:	8d 76 00             	lea    0x0(%esi),%esi

80105b40 <strlen>:

int
strlen(const char *s)
{
80105b40:	f3 0f 1e fb          	endbr32 
80105b44:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105b45:	31 c0                	xor    %eax,%eax
{
80105b47:	89 e5                	mov    %esp,%ebp
80105b49:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105b4c:	80 3a 00             	cmpb   $0x0,(%edx)
80105b4f:	74 10                	je     80105b61 <strlen+0x21>
80105b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b58:	83 c0 01             	add    $0x1,%eax
80105b5b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105b5f:	75 f7                	jne    80105b58 <strlen+0x18>
    ;
  return n;
}
80105b61:	5d                   	pop    %ebp
80105b62:	c3                   	ret    

80105b63 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105b63:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105b67:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105b6b:	55                   	push   %ebp
  pushl %ebx
80105b6c:	53                   	push   %ebx
  pushl %esi
80105b6d:	56                   	push   %esi
  pushl %edi
80105b6e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105b6f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105b71:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105b73:	5f                   	pop    %edi
  popl %esi
80105b74:	5e                   	pop    %esi
  popl %ebx
80105b75:	5b                   	pop    %ebx
  popl %ebp
80105b76:	5d                   	pop    %ebp
  ret
80105b77:	c3                   	ret    
80105b78:	66 90                	xchg   %ax,%ax
80105b7a:	66 90                	xchg   %ax,%ax
80105b7c:	66 90                	xchg   %ax,%ax
80105b7e:	66 90                	xchg   %ax,%ax

80105b80 <fetchfloat>:
#include "x86.h"
#include "syscall.h"

int
fetchfloat(uint addr, float *fp)
{
80105b80:	f3 0f 1e fb          	endbr32 
80105b84:	55                   	push   %ebp
80105b85:	89 e5                	mov    %esp,%ebp
80105b87:	53                   	push   %ebx
80105b88:	83 ec 04             	sub    $0x4,%esp
80105b8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105b8e:	e8 1d e3 ff ff       	call   80103eb0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105b93:	8b 00                	mov    (%eax),%eax
80105b95:	39 d8                	cmp    %ebx,%eax
80105b97:	76 17                	jbe    80105bb0 <fetchfloat+0x30>
80105b99:	8d 53 04             	lea    0x4(%ebx),%edx
80105b9c:	39 d0                	cmp    %edx,%eax
80105b9e:	72 10                	jb     80105bb0 <fetchfloat+0x30>
    return -1;
  *fp = *(float*)(addr);
80105ba0:	d9 03                	flds   (%ebx)
80105ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ba5:	d9 18                	fstps  (%eax)
  return 0;
80105ba7:	31 c0                	xor    %eax,%eax
}
80105ba9:	83 c4 04             	add    $0x4,%esp
80105bac:	5b                   	pop    %ebx
80105bad:	5d                   	pop    %ebp
80105bae:	c3                   	ret    
80105baf:	90                   	nop
    return -1;
80105bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bb5:	eb f2                	jmp    80105ba9 <fetchfloat+0x29>
80105bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bbe:	66 90                	xchg   %ax,%ax

80105bc0 <argfloat>:


int
argfloat(int n, float *fp)
{
80105bc0:	f3 0f 1e fb          	endbr32 
80105bc4:	55                   	push   %ebp
80105bc5:	89 e5                	mov    %esp,%ebp
80105bc7:	56                   	push   %esi
80105bc8:	53                   	push   %ebx
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105bc9:	e8 e2 e2 ff ff       	call   80103eb0 <myproc>
80105bce:	8b 55 08             	mov    0x8(%ebp),%edx
80105bd1:	8b 40 18             	mov    0x18(%eax),%eax
80105bd4:	8b 40 44             	mov    0x44(%eax),%eax
80105bd7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105bda:	e8 d1 e2 ff ff       	call   80103eb0 <myproc>
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105bdf:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105be2:	8b 00                	mov    (%eax),%eax
80105be4:	39 c6                	cmp    %eax,%esi
80105be6:	73 18                	jae    80105c00 <argfloat+0x40>
80105be8:	8d 53 08             	lea    0x8(%ebx),%edx
80105beb:	39 d0                	cmp    %edx,%eax
80105bed:	72 11                	jb     80105c00 <argfloat+0x40>
  *fp = *(float*)(addr);
80105bef:	d9 43 04             	flds   0x4(%ebx)
80105bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bf5:	d9 18                	fstps  (%eax)
  return 0;
80105bf7:	31 c0                	xor    %eax,%eax
}
80105bf9:	5b                   	pop    %ebx
80105bfa:	5e                   	pop    %esi
80105bfb:	5d                   	pop    %ebp
80105bfc:	c3                   	ret    
80105bfd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105c05:	eb f2                	jmp    80105bf9 <argfloat+0x39>
80105c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c0e:	66 90                	xchg   %ax,%ax

80105c10 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105c10:	f3 0f 1e fb          	endbr32 
80105c14:	55                   	push   %ebp
80105c15:	89 e5                	mov    %esp,%ebp
80105c17:	53                   	push   %ebx
80105c18:	83 ec 04             	sub    $0x4,%esp
80105c1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105c1e:	e8 8d e2 ff ff       	call   80103eb0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105c23:	8b 00                	mov    (%eax),%eax
80105c25:	39 d8                	cmp    %ebx,%eax
80105c27:	76 17                	jbe    80105c40 <fetchint+0x30>
80105c29:	8d 53 04             	lea    0x4(%ebx),%edx
80105c2c:	39 d0                	cmp    %edx,%eax
80105c2e:	72 10                	jb     80105c40 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105c30:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c33:	8b 13                	mov    (%ebx),%edx
80105c35:	89 10                	mov    %edx,(%eax)
  return 0;
80105c37:	31 c0                	xor    %eax,%eax
}
80105c39:	83 c4 04             	add    $0x4,%esp
80105c3c:	5b                   	pop    %ebx
80105c3d:	5d                   	pop    %ebp
80105c3e:	c3                   	ret    
80105c3f:	90                   	nop
    return -1;
80105c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c45:	eb f2                	jmp    80105c39 <fetchint+0x29>
80105c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4e:	66 90                	xchg   %ax,%ax

80105c50 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105c50:	f3 0f 1e fb          	endbr32 
80105c54:	55                   	push   %ebp
80105c55:	89 e5                	mov    %esp,%ebp
80105c57:	53                   	push   %ebx
80105c58:	83 ec 04             	sub    $0x4,%esp
80105c5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105c5e:	e8 4d e2 ff ff       	call   80103eb0 <myproc>

  if(addr >= curproc->sz)
80105c63:	39 18                	cmp    %ebx,(%eax)
80105c65:	76 31                	jbe    80105c98 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105c67:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c6a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105c6c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105c6e:	39 d3                	cmp    %edx,%ebx
80105c70:	73 26                	jae    80105c98 <fetchstr+0x48>
80105c72:	89 d8                	mov    %ebx,%eax
80105c74:	eb 11                	jmp    80105c87 <fetchstr+0x37>
80105c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7d:	8d 76 00             	lea    0x0(%esi),%esi
80105c80:	83 c0 01             	add    $0x1,%eax
80105c83:	39 c2                	cmp    %eax,%edx
80105c85:	76 11                	jbe    80105c98 <fetchstr+0x48>
    if(*s == 0)
80105c87:	80 38 00             	cmpb   $0x0,(%eax)
80105c8a:	75 f4                	jne    80105c80 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80105c8c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80105c8f:	29 d8                	sub    %ebx,%eax
}
80105c91:	5b                   	pop    %ebx
80105c92:	5d                   	pop    %ebp
80105c93:	c3                   	ret    
80105c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c98:	83 c4 04             	add    $0x4,%esp
    return -1;
80105c9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ca0:	5b                   	pop    %ebx
80105ca1:	5d                   	pop    %ebp
80105ca2:	c3                   	ret    
80105ca3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cb0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105cb0:	f3 0f 1e fb          	endbr32 
80105cb4:	55                   	push   %ebp
80105cb5:	89 e5                	mov    %esp,%ebp
80105cb7:	56                   	push   %esi
80105cb8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105cb9:	e8 f2 e1 ff ff       	call   80103eb0 <myproc>
80105cbe:	8b 55 08             	mov    0x8(%ebp),%edx
80105cc1:	8b 40 18             	mov    0x18(%eax),%eax
80105cc4:	8b 40 44             	mov    0x44(%eax),%eax
80105cc7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105cca:	e8 e1 e1 ff ff       	call   80103eb0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105ccf:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105cd2:	8b 00                	mov    (%eax),%eax
80105cd4:	39 c6                	cmp    %eax,%esi
80105cd6:	73 18                	jae    80105cf0 <argint+0x40>
80105cd8:	8d 53 08             	lea    0x8(%ebx),%edx
80105cdb:	39 d0                	cmp    %edx,%eax
80105cdd:	72 11                	jb     80105cf0 <argint+0x40>
  *ip = *(int*)(addr);
80105cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ce2:	8b 53 04             	mov    0x4(%ebx),%edx
80105ce5:	89 10                	mov    %edx,(%eax)
  return 0;
80105ce7:	31 c0                	xor    %eax,%eax
}
80105ce9:	5b                   	pop    %ebx
80105cea:	5e                   	pop    %esi
80105ceb:	5d                   	pop    %ebp
80105cec:	c3                   	ret    
80105ced:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105cf5:	eb f2                	jmp    80105ce9 <argint+0x39>
80105cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cfe:	66 90                	xchg   %ax,%ax

80105d00 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105d00:	f3 0f 1e fb          	endbr32 
80105d04:	55                   	push   %ebp
80105d05:	89 e5                	mov    %esp,%ebp
80105d07:	56                   	push   %esi
80105d08:	53                   	push   %ebx
80105d09:	83 ec 10             	sub    $0x10,%esp
80105d0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80105d0f:	e8 9c e1 ff ff       	call   80103eb0 <myproc>
 
  if(argint(n, &i) < 0)
80105d14:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105d17:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105d19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d1c:	50                   	push   %eax
80105d1d:	ff 75 08             	pushl  0x8(%ebp)
80105d20:	e8 8b ff ff ff       	call   80105cb0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105d25:	83 c4 10             	add    $0x10,%esp
80105d28:	85 c0                	test   %eax,%eax
80105d2a:	78 24                	js     80105d50 <argptr+0x50>
80105d2c:	85 db                	test   %ebx,%ebx
80105d2e:	78 20                	js     80105d50 <argptr+0x50>
80105d30:	8b 16                	mov    (%esi),%edx
80105d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d35:	39 c2                	cmp    %eax,%edx
80105d37:	76 17                	jbe    80105d50 <argptr+0x50>
80105d39:	01 c3                	add    %eax,%ebx
80105d3b:	39 da                	cmp    %ebx,%edx
80105d3d:	72 11                	jb     80105d50 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80105d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105d42:	89 02                	mov    %eax,(%edx)
  return 0;
80105d44:	31 c0                	xor    %eax,%eax
}
80105d46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d49:	5b                   	pop    %ebx
80105d4a:	5e                   	pop    %esi
80105d4b:	5d                   	pop    %ebp
80105d4c:	c3                   	ret    
80105d4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d55:	eb ef                	jmp    80105d46 <argptr+0x46>
80105d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5e:	66 90                	xchg   %ax,%ax

80105d60 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105d60:	f3 0f 1e fb          	endbr32 
80105d64:	55                   	push   %ebp
80105d65:	89 e5                	mov    %esp,%ebp
80105d67:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105d6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d6d:	50                   	push   %eax
80105d6e:	ff 75 08             	pushl  0x8(%ebp)
80105d71:	e8 3a ff ff ff       	call   80105cb0 <argint>
80105d76:	83 c4 10             	add    $0x10,%esp
80105d79:	85 c0                	test   %eax,%eax
80105d7b:	78 13                	js     80105d90 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105d7d:	83 ec 08             	sub    $0x8,%esp
80105d80:	ff 75 0c             	pushl  0xc(%ebp)
80105d83:	ff 75 f4             	pushl  -0xc(%ebp)
80105d86:	e8 c5 fe ff ff       	call   80105c50 <fetchstr>
80105d8b:	83 c4 10             	add    $0x10,%esp
}
80105d8e:	c9                   	leave  
80105d8f:	c3                   	ret    
80105d90:	c9                   	leave  
    return -1;
80105d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d96:	c3                   	ret    
80105d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9e:	66 90                	xchg   %ax,%ax

80105da0 <syscall>:

};

void
syscall(void)
{
80105da0:	f3 0f 1e fb          	endbr32 
80105da4:	55                   	push   %ebp
80105da5:	89 e5                	mov    %esp,%ebp
80105da7:	53                   	push   %ebx
80105da8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105dab:	e8 00 e1 ff ff       	call   80103eb0 <myproc>
80105db0:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80105db2:	8b 40 18             	mov    0x18(%eax),%eax
80105db5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105db8:	8d 50 ff             	lea    -0x1(%eax),%edx
80105dbb:	83 fa 1c             	cmp    $0x1c,%edx
80105dbe:	77 20                	ja     80105de0 <syscall+0x40>
80105dc0:	8b 14 85 00 90 10 80 	mov    -0x7fef7000(,%eax,4),%edx
80105dc7:	85 d2                	test   %edx,%edx
80105dc9:	74 15                	je     80105de0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105dcb:	ff d2                	call   *%edx
80105dcd:	89 c2                	mov    %eax,%edx
80105dcf:	8b 43 18             	mov    0x18(%ebx),%eax
80105dd2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105dd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105dd8:	c9                   	leave  
80105dd9:	c3                   	ret    
80105dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105de0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105de1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105de4:	50                   	push   %eax
80105de5:	ff 73 10             	pushl  0x10(%ebx)
80105de8:	68 c5 8f 10 80       	push   $0x80108fc5
80105ded:	e8 ce aa ff ff       	call   801008c0 <cprintf>
    curproc->tf->eax = -1;
80105df2:	8b 43 18             	mov    0x18(%ebx),%eax
80105df5:	83 c4 10             	add    $0x10,%esp
80105df8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105dff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e02:	c9                   	leave  
80105e03:	c3                   	ret    
80105e04:	66 90                	xchg   %ax,%ax
80105e06:	66 90                	xchg   %ax,%ax
80105e08:	66 90                	xchg   %ax,%ax
80105e0a:	66 90                	xchg   %ax,%ax
80105e0c:	66 90                	xchg   %ax,%ax
80105e0e:	66 90                	xchg   %ax,%ax

80105e10 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105e10:	55                   	push   %ebp
80105e11:	89 e5                	mov    %esp,%ebp
80105e13:	57                   	push   %edi
80105e14:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105e15:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105e18:	53                   	push   %ebx
80105e19:	83 ec 34             	sub    $0x34,%esp
80105e1c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80105e1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105e22:	57                   	push   %edi
80105e23:	50                   	push   %eax
{
80105e24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105e27:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105e2a:	e8 11 c7 ff ff       	call   80102540 <nameiparent>
80105e2f:	83 c4 10             	add    $0x10,%esp
80105e32:	85 c0                	test   %eax,%eax
80105e34:	0f 84 46 01 00 00    	je     80105f80 <create+0x170>
    return 0;
  ilock(dp);
80105e3a:	83 ec 0c             	sub    $0xc,%esp
80105e3d:	89 c3                	mov    %eax,%ebx
80105e3f:	50                   	push   %eax
80105e40:	e8 0b be ff ff       	call   80101c50 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105e45:	83 c4 0c             	add    $0xc,%esp
80105e48:	6a 00                	push   $0x0
80105e4a:	57                   	push   %edi
80105e4b:	53                   	push   %ebx
80105e4c:	e8 4f c3 ff ff       	call   801021a0 <dirlookup>
80105e51:	83 c4 10             	add    $0x10,%esp
80105e54:	89 c6                	mov    %eax,%esi
80105e56:	85 c0                	test   %eax,%eax
80105e58:	74 56                	je     80105eb0 <create+0xa0>
    iunlockput(dp);
80105e5a:	83 ec 0c             	sub    $0xc,%esp
80105e5d:	53                   	push   %ebx
80105e5e:	e8 8d c0 ff ff       	call   80101ef0 <iunlockput>
    ilock(ip);
80105e63:	89 34 24             	mov    %esi,(%esp)
80105e66:	e8 e5 bd ff ff       	call   80101c50 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105e6b:	83 c4 10             	add    $0x10,%esp
80105e6e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105e73:	75 1b                	jne    80105e90 <create+0x80>
80105e75:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105e7a:	75 14                	jne    80105e90 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e7f:	89 f0                	mov    %esi,%eax
80105e81:	5b                   	pop    %ebx
80105e82:	5e                   	pop    %esi
80105e83:	5f                   	pop    %edi
80105e84:	5d                   	pop    %ebp
80105e85:	c3                   	ret    
80105e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e8d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105e90:	83 ec 0c             	sub    $0xc,%esp
80105e93:	56                   	push   %esi
    return 0;
80105e94:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105e96:	e8 55 c0 ff ff       	call   80101ef0 <iunlockput>
    return 0;
80105e9b:	83 c4 10             	add    $0x10,%esp
}
80105e9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea1:	89 f0                	mov    %esi,%eax
80105ea3:	5b                   	pop    %ebx
80105ea4:	5e                   	pop    %esi
80105ea5:	5f                   	pop    %edi
80105ea6:	5d                   	pop    %ebp
80105ea7:	c3                   	ret    
80105ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eaf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105eb0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105eb4:	83 ec 08             	sub    $0x8,%esp
80105eb7:	50                   	push   %eax
80105eb8:	ff 33                	pushl  (%ebx)
80105eba:	e8 11 bc ff ff       	call   80101ad0 <ialloc>
80105ebf:	83 c4 10             	add    $0x10,%esp
80105ec2:	89 c6                	mov    %eax,%esi
80105ec4:	85 c0                	test   %eax,%eax
80105ec6:	0f 84 cd 00 00 00    	je     80105f99 <create+0x189>
  ilock(ip);
80105ecc:	83 ec 0c             	sub    $0xc,%esp
80105ecf:	50                   	push   %eax
80105ed0:	e8 7b bd ff ff       	call   80101c50 <ilock>
  ip->major = major;
80105ed5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105ed9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80105edd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105ee1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105ee5:	b8 01 00 00 00       	mov    $0x1,%eax
80105eea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80105eee:	89 34 24             	mov    %esi,(%esp)
80105ef1:	e8 9a bc ff ff       	call   80101b90 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105ef6:	83 c4 10             	add    $0x10,%esp
80105ef9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105efe:	74 30                	je     80105f30 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105f00:	83 ec 04             	sub    $0x4,%esp
80105f03:	ff 76 04             	pushl  0x4(%esi)
80105f06:	57                   	push   %edi
80105f07:	53                   	push   %ebx
80105f08:	e8 53 c5 ff ff       	call   80102460 <dirlink>
80105f0d:	83 c4 10             	add    $0x10,%esp
80105f10:	85 c0                	test   %eax,%eax
80105f12:	78 78                	js     80105f8c <create+0x17c>
  iunlockput(dp);
80105f14:	83 ec 0c             	sub    $0xc,%esp
80105f17:	53                   	push   %ebx
80105f18:	e8 d3 bf ff ff       	call   80101ef0 <iunlockput>
  return ip;
80105f1d:	83 c4 10             	add    $0x10,%esp
}
80105f20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f23:	89 f0                	mov    %esi,%eax
80105f25:	5b                   	pop    %ebx
80105f26:	5e                   	pop    %esi
80105f27:	5f                   	pop    %edi
80105f28:	5d                   	pop    %ebp
80105f29:	c3                   	ret    
80105f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105f30:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105f33:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105f38:	53                   	push   %ebx
80105f39:	e8 52 bc ff ff       	call   80101b90 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105f3e:	83 c4 0c             	add    $0xc,%esp
80105f41:	ff 76 04             	pushl  0x4(%esi)
80105f44:	68 94 90 10 80       	push   $0x80109094
80105f49:	56                   	push   %esi
80105f4a:	e8 11 c5 ff ff       	call   80102460 <dirlink>
80105f4f:	83 c4 10             	add    $0x10,%esp
80105f52:	85 c0                	test   %eax,%eax
80105f54:	78 18                	js     80105f6e <create+0x15e>
80105f56:	83 ec 04             	sub    $0x4,%esp
80105f59:	ff 73 04             	pushl  0x4(%ebx)
80105f5c:	68 93 90 10 80       	push   $0x80109093
80105f61:	56                   	push   %esi
80105f62:	e8 f9 c4 ff ff       	call   80102460 <dirlink>
80105f67:	83 c4 10             	add    $0x10,%esp
80105f6a:	85 c0                	test   %eax,%eax
80105f6c:	79 92                	jns    80105f00 <create+0xf0>
      panic("create dots");
80105f6e:	83 ec 0c             	sub    $0xc,%esp
80105f71:	68 87 90 10 80       	push   $0x80109087
80105f76:	e8 15 a4 ff ff       	call   80100390 <panic>
80105f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f7f:	90                   	nop
}
80105f80:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105f83:	31 f6                	xor    %esi,%esi
}
80105f85:	5b                   	pop    %ebx
80105f86:	89 f0                	mov    %esi,%eax
80105f88:	5e                   	pop    %esi
80105f89:	5f                   	pop    %edi
80105f8a:	5d                   	pop    %ebp
80105f8b:	c3                   	ret    
    panic("create: dirlink");
80105f8c:	83 ec 0c             	sub    $0xc,%esp
80105f8f:	68 96 90 10 80       	push   $0x80109096
80105f94:	e8 f7 a3 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105f99:	83 ec 0c             	sub    $0xc,%esp
80105f9c:	68 78 90 10 80       	push   $0x80109078
80105fa1:	e8 ea a3 ff ff       	call   80100390 <panic>
80105fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fad:	8d 76 00             	lea    0x0(%esi),%esi

80105fb0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	56                   	push   %esi
80105fb4:	89 d6                	mov    %edx,%esi
80105fb6:	53                   	push   %ebx
80105fb7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105fb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80105fbc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105fbf:	50                   	push   %eax
80105fc0:	6a 00                	push   $0x0
80105fc2:	e8 e9 fc ff ff       	call   80105cb0 <argint>
80105fc7:	83 c4 10             	add    $0x10,%esp
80105fca:	85 c0                	test   %eax,%eax
80105fcc:	78 2a                	js     80105ff8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105fce:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105fd2:	77 24                	ja     80105ff8 <argfd.constprop.0+0x48>
80105fd4:	e8 d7 de ff ff       	call   80103eb0 <myproc>
80105fd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fdc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105fe0:	85 c0                	test   %eax,%eax
80105fe2:	74 14                	je     80105ff8 <argfd.constprop.0+0x48>
  if(pfd)
80105fe4:	85 db                	test   %ebx,%ebx
80105fe6:	74 02                	je     80105fea <argfd.constprop.0+0x3a>
    *pfd = fd;
80105fe8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80105fea:	89 06                	mov    %eax,(%esi)
  return 0;
80105fec:	31 c0                	xor    %eax,%eax
}
80105fee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ff1:	5b                   	pop    %ebx
80105ff2:	5e                   	pop    %esi
80105ff3:	5d                   	pop    %ebp
80105ff4:	c3                   	ret    
80105ff5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ff8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ffd:	eb ef                	jmp    80105fee <argfd.constprop.0+0x3e>
80105fff:	90                   	nop

80106000 <sys_dup>:
{
80106000:	f3 0f 1e fb          	endbr32 
80106004:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80106005:	31 c0                	xor    %eax,%eax
{
80106007:	89 e5                	mov    %esp,%ebp
80106009:	56                   	push   %esi
8010600a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010600b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010600e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80106011:	e8 9a ff ff ff       	call   80105fb0 <argfd.constprop.0>
80106016:	85 c0                	test   %eax,%eax
80106018:	78 1e                	js     80106038 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010601a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010601d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010601f:	e8 8c de ff ff       	call   80103eb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106028:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010602c:	85 d2                	test   %edx,%edx
8010602e:	74 20                	je     80106050 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80106030:	83 c3 01             	add    $0x1,%ebx
80106033:	83 fb 10             	cmp    $0x10,%ebx
80106036:	75 f0                	jne    80106028 <sys_dup+0x28>
}
80106038:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010603b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80106040:	89 d8                	mov    %ebx,%eax
80106042:	5b                   	pop    %ebx
80106043:	5e                   	pop    %esi
80106044:	5d                   	pop    %ebp
80106045:	c3                   	ret    
80106046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010604d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80106050:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80106054:	83 ec 0c             	sub    $0xc,%esp
80106057:	ff 75 f4             	pushl  -0xc(%ebp)
8010605a:	e8 01 b3 ff ff       	call   80101360 <filedup>
  return fd;
8010605f:	83 c4 10             	add    $0x10,%esp
}
80106062:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106065:	89 d8                	mov    %ebx,%eax
80106067:	5b                   	pop    %ebx
80106068:	5e                   	pop    %esi
80106069:	5d                   	pop    %ebp
8010606a:	c3                   	ret    
8010606b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010606f:	90                   	nop

80106070 <sys_read>:
{
80106070:	f3 0f 1e fb          	endbr32 
80106074:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106075:	31 c0                	xor    %eax,%eax
{
80106077:	89 e5                	mov    %esp,%ebp
80106079:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010607c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010607f:	e8 2c ff ff ff       	call   80105fb0 <argfd.constprop.0>
80106084:	85 c0                	test   %eax,%eax
80106086:	78 48                	js     801060d0 <sys_read+0x60>
80106088:	83 ec 08             	sub    $0x8,%esp
8010608b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010608e:	50                   	push   %eax
8010608f:	6a 02                	push   $0x2
80106091:	e8 1a fc ff ff       	call   80105cb0 <argint>
80106096:	83 c4 10             	add    $0x10,%esp
80106099:	85 c0                	test   %eax,%eax
8010609b:	78 33                	js     801060d0 <sys_read+0x60>
8010609d:	83 ec 04             	sub    $0x4,%esp
801060a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060a3:	ff 75 f0             	pushl  -0x10(%ebp)
801060a6:	50                   	push   %eax
801060a7:	6a 01                	push   $0x1
801060a9:	e8 52 fc ff ff       	call   80105d00 <argptr>
801060ae:	83 c4 10             	add    $0x10,%esp
801060b1:	85 c0                	test   %eax,%eax
801060b3:	78 1b                	js     801060d0 <sys_read+0x60>
  return fileread(f, p, n);
801060b5:	83 ec 04             	sub    $0x4,%esp
801060b8:	ff 75 f0             	pushl  -0x10(%ebp)
801060bb:	ff 75 f4             	pushl  -0xc(%ebp)
801060be:	ff 75 ec             	pushl  -0x14(%ebp)
801060c1:	e8 1a b4 ff ff       	call   801014e0 <fileread>
801060c6:	83 c4 10             	add    $0x10,%esp
}
801060c9:	c9                   	leave  
801060ca:	c3                   	ret    
801060cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060cf:	90                   	nop
801060d0:	c9                   	leave  
    return -1;
801060d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060d6:	c3                   	ret    
801060d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060de:	66 90                	xchg   %ax,%ax

801060e0 <sys_write>:
{
801060e0:	f3 0f 1e fb          	endbr32 
801060e4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801060e5:	31 c0                	xor    %eax,%eax
{
801060e7:	89 e5                	mov    %esp,%ebp
801060e9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801060ec:	8d 55 ec             	lea    -0x14(%ebp),%edx
801060ef:	e8 bc fe ff ff       	call   80105fb0 <argfd.constprop.0>
801060f4:	85 c0                	test   %eax,%eax
801060f6:	78 48                	js     80106140 <sys_write+0x60>
801060f8:	83 ec 08             	sub    $0x8,%esp
801060fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060fe:	50                   	push   %eax
801060ff:	6a 02                	push   $0x2
80106101:	e8 aa fb ff ff       	call   80105cb0 <argint>
80106106:	83 c4 10             	add    $0x10,%esp
80106109:	85 c0                	test   %eax,%eax
8010610b:	78 33                	js     80106140 <sys_write+0x60>
8010610d:	83 ec 04             	sub    $0x4,%esp
80106110:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106113:	ff 75 f0             	pushl  -0x10(%ebp)
80106116:	50                   	push   %eax
80106117:	6a 01                	push   $0x1
80106119:	e8 e2 fb ff ff       	call   80105d00 <argptr>
8010611e:	83 c4 10             	add    $0x10,%esp
80106121:	85 c0                	test   %eax,%eax
80106123:	78 1b                	js     80106140 <sys_write+0x60>
  return filewrite(f, p, n);
80106125:	83 ec 04             	sub    $0x4,%esp
80106128:	ff 75 f0             	pushl  -0x10(%ebp)
8010612b:	ff 75 f4             	pushl  -0xc(%ebp)
8010612e:	ff 75 ec             	pushl  -0x14(%ebp)
80106131:	e8 4a b4 ff ff       	call   80101580 <filewrite>
80106136:	83 c4 10             	add    $0x10,%esp
}
80106139:	c9                   	leave  
8010613a:	c3                   	ret    
8010613b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010613f:	90                   	nop
80106140:	c9                   	leave  
    return -1;
80106141:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106146:	c3                   	ret    
80106147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614e:	66 90                	xchg   %ax,%ax

80106150 <sys_close>:
{
80106150:	f3 0f 1e fb          	endbr32 
80106154:	55                   	push   %ebp
80106155:	89 e5                	mov    %esp,%ebp
80106157:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010615a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010615d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106160:	e8 4b fe ff ff       	call   80105fb0 <argfd.constprop.0>
80106165:	85 c0                	test   %eax,%eax
80106167:	78 27                	js     80106190 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80106169:	e8 42 dd ff ff       	call   80103eb0 <myproc>
8010616e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80106171:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80106174:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010617b:	00 
  fileclose(f);
8010617c:	ff 75 f4             	pushl  -0xc(%ebp)
8010617f:	e8 2c b2 ff ff       	call   801013b0 <fileclose>
  return 0;
80106184:	83 c4 10             	add    $0x10,%esp
80106187:	31 c0                	xor    %eax,%eax
}
80106189:	c9                   	leave  
8010618a:	c3                   	ret    
8010618b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010618f:	90                   	nop
80106190:	c9                   	leave  
    return -1;
80106191:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106196:	c3                   	ret    
80106197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010619e:	66 90                	xchg   %ax,%ax

801061a0 <sys_fstat>:
{
801061a0:	f3 0f 1e fb          	endbr32 
801061a4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801061a5:	31 c0                	xor    %eax,%eax
{
801061a7:	89 e5                	mov    %esp,%ebp
801061a9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801061ac:	8d 55 f0             	lea    -0x10(%ebp),%edx
801061af:	e8 fc fd ff ff       	call   80105fb0 <argfd.constprop.0>
801061b4:	85 c0                	test   %eax,%eax
801061b6:	78 30                	js     801061e8 <sys_fstat+0x48>
801061b8:	83 ec 04             	sub    $0x4,%esp
801061bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061be:	6a 14                	push   $0x14
801061c0:	50                   	push   %eax
801061c1:	6a 01                	push   $0x1
801061c3:	e8 38 fb ff ff       	call   80105d00 <argptr>
801061c8:	83 c4 10             	add    $0x10,%esp
801061cb:	85 c0                	test   %eax,%eax
801061cd:	78 19                	js     801061e8 <sys_fstat+0x48>
  return filestat(f, st);
801061cf:	83 ec 08             	sub    $0x8,%esp
801061d2:	ff 75 f4             	pushl  -0xc(%ebp)
801061d5:	ff 75 f0             	pushl  -0x10(%ebp)
801061d8:	e8 b3 b2 ff ff       	call   80101490 <filestat>
801061dd:	83 c4 10             	add    $0x10,%esp
}
801061e0:	c9                   	leave  
801061e1:	c3                   	ret    
801061e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801061e8:	c9                   	leave  
    return -1;
801061e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061ee:	c3                   	ret    
801061ef:	90                   	nop

801061f0 <sys_link>:
{
801061f0:	f3 0f 1e fb          	endbr32 
801061f4:	55                   	push   %ebp
801061f5:	89 e5                	mov    %esp,%ebp
801061f7:	57                   	push   %edi
801061f8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801061f9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801061fc:	53                   	push   %ebx
801061fd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106200:	50                   	push   %eax
80106201:	6a 00                	push   $0x0
80106203:	e8 58 fb ff ff       	call   80105d60 <argstr>
80106208:	83 c4 10             	add    $0x10,%esp
8010620b:	85 c0                	test   %eax,%eax
8010620d:	0f 88 ff 00 00 00    	js     80106312 <sys_link+0x122>
80106213:	83 ec 08             	sub    $0x8,%esp
80106216:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106219:	50                   	push   %eax
8010621a:	6a 01                	push   $0x1
8010621c:	e8 3f fb ff ff       	call   80105d60 <argstr>
80106221:	83 c4 10             	add    $0x10,%esp
80106224:	85 c0                	test   %eax,%eax
80106226:	0f 88 e6 00 00 00    	js     80106312 <sys_link+0x122>
  begin_op();
8010622c:	e8 ef cf ff ff       	call   80103220 <begin_op>
  if((ip = namei(old)) == 0){
80106231:	83 ec 0c             	sub    $0xc,%esp
80106234:	ff 75 d4             	pushl  -0x2c(%ebp)
80106237:	e8 e4 c2 ff ff       	call   80102520 <namei>
8010623c:	83 c4 10             	add    $0x10,%esp
8010623f:	89 c3                	mov    %eax,%ebx
80106241:	85 c0                	test   %eax,%eax
80106243:	0f 84 e8 00 00 00    	je     80106331 <sys_link+0x141>
  ilock(ip);
80106249:	83 ec 0c             	sub    $0xc,%esp
8010624c:	50                   	push   %eax
8010624d:	e8 fe b9 ff ff       	call   80101c50 <ilock>
  if(ip->type == T_DIR){
80106252:	83 c4 10             	add    $0x10,%esp
80106255:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010625a:	0f 84 b9 00 00 00    	je     80106319 <sys_link+0x129>
  iupdate(ip);
80106260:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80106263:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80106268:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010626b:	53                   	push   %ebx
8010626c:	e8 1f b9 ff ff       	call   80101b90 <iupdate>
  iunlock(ip);
80106271:	89 1c 24             	mov    %ebx,(%esp)
80106274:	e8 b7 ba ff ff       	call   80101d30 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80106279:	58                   	pop    %eax
8010627a:	5a                   	pop    %edx
8010627b:	57                   	push   %edi
8010627c:	ff 75 d0             	pushl  -0x30(%ebp)
8010627f:	e8 bc c2 ff ff       	call   80102540 <nameiparent>
80106284:	83 c4 10             	add    $0x10,%esp
80106287:	89 c6                	mov    %eax,%esi
80106289:	85 c0                	test   %eax,%eax
8010628b:	74 5f                	je     801062ec <sys_link+0xfc>
  ilock(dp);
8010628d:	83 ec 0c             	sub    $0xc,%esp
80106290:	50                   	push   %eax
80106291:	e8 ba b9 ff ff       	call   80101c50 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106296:	8b 03                	mov    (%ebx),%eax
80106298:	83 c4 10             	add    $0x10,%esp
8010629b:	39 06                	cmp    %eax,(%esi)
8010629d:	75 41                	jne    801062e0 <sys_link+0xf0>
8010629f:	83 ec 04             	sub    $0x4,%esp
801062a2:	ff 73 04             	pushl  0x4(%ebx)
801062a5:	57                   	push   %edi
801062a6:	56                   	push   %esi
801062a7:	e8 b4 c1 ff ff       	call   80102460 <dirlink>
801062ac:	83 c4 10             	add    $0x10,%esp
801062af:	85 c0                	test   %eax,%eax
801062b1:	78 2d                	js     801062e0 <sys_link+0xf0>
  iunlockput(dp);
801062b3:	83 ec 0c             	sub    $0xc,%esp
801062b6:	56                   	push   %esi
801062b7:	e8 34 bc ff ff       	call   80101ef0 <iunlockput>
  iput(ip);
801062bc:	89 1c 24             	mov    %ebx,(%esp)
801062bf:	e8 bc ba ff ff       	call   80101d80 <iput>
  end_op();
801062c4:	e8 c7 cf ff ff       	call   80103290 <end_op>
  return 0;
801062c9:	83 c4 10             	add    $0x10,%esp
801062cc:	31 c0                	xor    %eax,%eax
}
801062ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062d1:	5b                   	pop    %ebx
801062d2:	5e                   	pop    %esi
801062d3:	5f                   	pop    %edi
801062d4:	5d                   	pop    %ebp
801062d5:	c3                   	ret    
801062d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062dd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801062e0:	83 ec 0c             	sub    $0xc,%esp
801062e3:	56                   	push   %esi
801062e4:	e8 07 bc ff ff       	call   80101ef0 <iunlockput>
    goto bad;
801062e9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801062ec:	83 ec 0c             	sub    $0xc,%esp
801062ef:	53                   	push   %ebx
801062f0:	e8 5b b9 ff ff       	call   80101c50 <ilock>
  ip->nlink--;
801062f5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801062fa:	89 1c 24             	mov    %ebx,(%esp)
801062fd:	e8 8e b8 ff ff       	call   80101b90 <iupdate>
  iunlockput(ip);
80106302:	89 1c 24             	mov    %ebx,(%esp)
80106305:	e8 e6 bb ff ff       	call   80101ef0 <iunlockput>
  end_op();
8010630a:	e8 81 cf ff ff       	call   80103290 <end_op>
  return -1;
8010630f:	83 c4 10             	add    $0x10,%esp
80106312:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106317:	eb b5                	jmp    801062ce <sys_link+0xde>
    iunlockput(ip);
80106319:	83 ec 0c             	sub    $0xc,%esp
8010631c:	53                   	push   %ebx
8010631d:	e8 ce bb ff ff       	call   80101ef0 <iunlockput>
    end_op();
80106322:	e8 69 cf ff ff       	call   80103290 <end_op>
    return -1;
80106327:	83 c4 10             	add    $0x10,%esp
8010632a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010632f:	eb 9d                	jmp    801062ce <sys_link+0xde>
    end_op();
80106331:	e8 5a cf ff ff       	call   80103290 <end_op>
    return -1;
80106336:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010633b:	eb 91                	jmp    801062ce <sys_link+0xde>
8010633d:	8d 76 00             	lea    0x0(%esi),%esi

80106340 <sys_unlink>:
{
80106340:	f3 0f 1e fb          	endbr32 
80106344:	55                   	push   %ebp
80106345:	89 e5                	mov    %esp,%ebp
80106347:	57                   	push   %edi
80106348:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106349:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010634c:	53                   	push   %ebx
8010634d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80106350:	50                   	push   %eax
80106351:	6a 00                	push   $0x0
80106353:	e8 08 fa ff ff       	call   80105d60 <argstr>
80106358:	83 c4 10             	add    $0x10,%esp
8010635b:	85 c0                	test   %eax,%eax
8010635d:	0f 88 7d 01 00 00    	js     801064e0 <sys_unlink+0x1a0>
  begin_op();
80106363:	e8 b8 ce ff ff       	call   80103220 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106368:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010636b:	83 ec 08             	sub    $0x8,%esp
8010636e:	53                   	push   %ebx
8010636f:	ff 75 c0             	pushl  -0x40(%ebp)
80106372:	e8 c9 c1 ff ff       	call   80102540 <nameiparent>
80106377:	83 c4 10             	add    $0x10,%esp
8010637a:	89 c6                	mov    %eax,%esi
8010637c:	85 c0                	test   %eax,%eax
8010637e:	0f 84 66 01 00 00    	je     801064ea <sys_unlink+0x1aa>
  ilock(dp);
80106384:	83 ec 0c             	sub    $0xc,%esp
80106387:	50                   	push   %eax
80106388:	e8 c3 b8 ff ff       	call   80101c50 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010638d:	58                   	pop    %eax
8010638e:	5a                   	pop    %edx
8010638f:	68 94 90 10 80       	push   $0x80109094
80106394:	53                   	push   %ebx
80106395:	e8 e6 bd ff ff       	call   80102180 <namecmp>
8010639a:	83 c4 10             	add    $0x10,%esp
8010639d:	85 c0                	test   %eax,%eax
8010639f:	0f 84 03 01 00 00    	je     801064a8 <sys_unlink+0x168>
801063a5:	83 ec 08             	sub    $0x8,%esp
801063a8:	68 93 90 10 80       	push   $0x80109093
801063ad:	53                   	push   %ebx
801063ae:	e8 cd bd ff ff       	call   80102180 <namecmp>
801063b3:	83 c4 10             	add    $0x10,%esp
801063b6:	85 c0                	test   %eax,%eax
801063b8:	0f 84 ea 00 00 00    	je     801064a8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801063be:	83 ec 04             	sub    $0x4,%esp
801063c1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801063c4:	50                   	push   %eax
801063c5:	53                   	push   %ebx
801063c6:	56                   	push   %esi
801063c7:	e8 d4 bd ff ff       	call   801021a0 <dirlookup>
801063cc:	83 c4 10             	add    $0x10,%esp
801063cf:	89 c3                	mov    %eax,%ebx
801063d1:	85 c0                	test   %eax,%eax
801063d3:	0f 84 cf 00 00 00    	je     801064a8 <sys_unlink+0x168>
  ilock(ip);
801063d9:	83 ec 0c             	sub    $0xc,%esp
801063dc:	50                   	push   %eax
801063dd:	e8 6e b8 ff ff       	call   80101c50 <ilock>
  if(ip->nlink < 1)
801063e2:	83 c4 10             	add    $0x10,%esp
801063e5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801063ea:	0f 8e 23 01 00 00    	jle    80106513 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801063f0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801063f5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801063f8:	74 66                	je     80106460 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801063fa:	83 ec 04             	sub    $0x4,%esp
801063fd:	6a 10                	push   $0x10
801063ff:	6a 00                	push   $0x0
80106401:	57                   	push   %edi
80106402:	e8 39 f5 ff ff       	call   80105940 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106407:	6a 10                	push   $0x10
80106409:	ff 75 c4             	pushl  -0x3c(%ebp)
8010640c:	57                   	push   %edi
8010640d:	56                   	push   %esi
8010640e:	e8 3d bc ff ff       	call   80102050 <writei>
80106413:	83 c4 20             	add    $0x20,%esp
80106416:	83 f8 10             	cmp    $0x10,%eax
80106419:	0f 85 e7 00 00 00    	jne    80106506 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010641f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106424:	0f 84 96 00 00 00    	je     801064c0 <sys_unlink+0x180>
  iunlockput(dp);
8010642a:	83 ec 0c             	sub    $0xc,%esp
8010642d:	56                   	push   %esi
8010642e:	e8 bd ba ff ff       	call   80101ef0 <iunlockput>
  ip->nlink--;
80106433:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106438:	89 1c 24             	mov    %ebx,(%esp)
8010643b:	e8 50 b7 ff ff       	call   80101b90 <iupdate>
  iunlockput(ip);
80106440:	89 1c 24             	mov    %ebx,(%esp)
80106443:	e8 a8 ba ff ff       	call   80101ef0 <iunlockput>
  end_op();
80106448:	e8 43 ce ff ff       	call   80103290 <end_op>
  return 0;
8010644d:	83 c4 10             	add    $0x10,%esp
80106450:	31 c0                	xor    %eax,%eax
}
80106452:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106455:	5b                   	pop    %ebx
80106456:	5e                   	pop    %esi
80106457:	5f                   	pop    %edi
80106458:	5d                   	pop    %ebp
80106459:	c3                   	ret    
8010645a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106460:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106464:	76 94                	jbe    801063fa <sys_unlink+0xba>
80106466:	ba 20 00 00 00       	mov    $0x20,%edx
8010646b:	eb 0b                	jmp    80106478 <sys_unlink+0x138>
8010646d:	8d 76 00             	lea    0x0(%esi),%esi
80106470:	83 c2 10             	add    $0x10,%edx
80106473:	39 53 58             	cmp    %edx,0x58(%ebx)
80106476:	76 82                	jbe    801063fa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106478:	6a 10                	push   $0x10
8010647a:	52                   	push   %edx
8010647b:	57                   	push   %edi
8010647c:	53                   	push   %ebx
8010647d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80106480:	e8 cb ba ff ff       	call   80101f50 <readi>
80106485:	83 c4 10             	add    $0x10,%esp
80106488:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010648b:	83 f8 10             	cmp    $0x10,%eax
8010648e:	75 69                	jne    801064f9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80106490:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80106495:	74 d9                	je     80106470 <sys_unlink+0x130>
    iunlockput(ip);
80106497:	83 ec 0c             	sub    $0xc,%esp
8010649a:	53                   	push   %ebx
8010649b:	e8 50 ba ff ff       	call   80101ef0 <iunlockput>
    goto bad;
801064a0:	83 c4 10             	add    $0x10,%esp
801064a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801064a7:	90                   	nop
  iunlockput(dp);
801064a8:	83 ec 0c             	sub    $0xc,%esp
801064ab:	56                   	push   %esi
801064ac:	e8 3f ba ff ff       	call   80101ef0 <iunlockput>
  end_op();
801064b1:	e8 da cd ff ff       	call   80103290 <end_op>
  return -1;
801064b6:	83 c4 10             	add    $0x10,%esp
801064b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064be:	eb 92                	jmp    80106452 <sys_unlink+0x112>
    iupdate(dp);
801064c0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801064c3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801064c8:	56                   	push   %esi
801064c9:	e8 c2 b6 ff ff       	call   80101b90 <iupdate>
801064ce:	83 c4 10             	add    $0x10,%esp
801064d1:	e9 54 ff ff ff       	jmp    8010642a <sys_unlink+0xea>
801064d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801064e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064e5:	e9 68 ff ff ff       	jmp    80106452 <sys_unlink+0x112>
    end_op();
801064ea:	e8 a1 cd ff ff       	call   80103290 <end_op>
    return -1;
801064ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064f4:	e9 59 ff ff ff       	jmp    80106452 <sys_unlink+0x112>
      panic("isdirempty: readi");
801064f9:	83 ec 0c             	sub    $0xc,%esp
801064fc:	68 b8 90 10 80       	push   $0x801090b8
80106501:	e8 8a 9e ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80106506:	83 ec 0c             	sub    $0xc,%esp
80106509:	68 ca 90 10 80       	push   $0x801090ca
8010650e:	e8 7d 9e ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80106513:	83 ec 0c             	sub    $0xc,%esp
80106516:	68 a6 90 10 80       	push   $0x801090a6
8010651b:	e8 70 9e ff ff       	call   80100390 <panic>

80106520 <sys_open>:

int
sys_open(void)
{
80106520:	f3 0f 1e fb          	endbr32 
80106524:	55                   	push   %ebp
80106525:	89 e5                	mov    %esp,%ebp
80106527:	57                   	push   %edi
80106528:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106529:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010652c:	53                   	push   %ebx
8010652d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106530:	50                   	push   %eax
80106531:	6a 00                	push   $0x0
80106533:	e8 28 f8 ff ff       	call   80105d60 <argstr>
80106538:	83 c4 10             	add    $0x10,%esp
8010653b:	85 c0                	test   %eax,%eax
8010653d:	0f 88 8a 00 00 00    	js     801065cd <sys_open+0xad>
80106543:	83 ec 08             	sub    $0x8,%esp
80106546:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106549:	50                   	push   %eax
8010654a:	6a 01                	push   $0x1
8010654c:	e8 5f f7 ff ff       	call   80105cb0 <argint>
80106551:	83 c4 10             	add    $0x10,%esp
80106554:	85 c0                	test   %eax,%eax
80106556:	78 75                	js     801065cd <sys_open+0xad>
    return -1;

  begin_op();
80106558:	e8 c3 cc ff ff       	call   80103220 <begin_op>

  if(omode & O_CREATE){
8010655d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106561:	75 75                	jne    801065d8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106563:	83 ec 0c             	sub    $0xc,%esp
80106566:	ff 75 e0             	pushl  -0x20(%ebp)
80106569:	e8 b2 bf ff ff       	call   80102520 <namei>
8010656e:	83 c4 10             	add    $0x10,%esp
80106571:	89 c6                	mov    %eax,%esi
80106573:	85 c0                	test   %eax,%eax
80106575:	74 7e                	je     801065f5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106577:	83 ec 0c             	sub    $0xc,%esp
8010657a:	50                   	push   %eax
8010657b:	e8 d0 b6 ff ff       	call   80101c50 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106580:	83 c4 10             	add    $0x10,%esp
80106583:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106588:	0f 84 c2 00 00 00    	je     80106650 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010658e:	e8 5d ad ff ff       	call   801012f0 <filealloc>
80106593:	89 c7                	mov    %eax,%edi
80106595:	85 c0                	test   %eax,%eax
80106597:	74 23                	je     801065bc <sys_open+0x9c>
  struct proc *curproc = myproc();
80106599:	e8 12 d9 ff ff       	call   80103eb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010659e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801065a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801065a4:	85 d2                	test   %edx,%edx
801065a6:	74 60                	je     80106608 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801065a8:	83 c3 01             	add    $0x1,%ebx
801065ab:	83 fb 10             	cmp    $0x10,%ebx
801065ae:	75 f0                	jne    801065a0 <sys_open+0x80>
    if(f)
      fileclose(f);
801065b0:	83 ec 0c             	sub    $0xc,%esp
801065b3:	57                   	push   %edi
801065b4:	e8 f7 ad ff ff       	call   801013b0 <fileclose>
801065b9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801065bc:	83 ec 0c             	sub    $0xc,%esp
801065bf:	56                   	push   %esi
801065c0:	e8 2b b9 ff ff       	call   80101ef0 <iunlockput>
    end_op();
801065c5:	e8 c6 cc ff ff       	call   80103290 <end_op>
    return -1;
801065ca:	83 c4 10             	add    $0x10,%esp
801065cd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801065d2:	eb 6d                	jmp    80106641 <sys_open+0x121>
801065d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801065d8:	83 ec 0c             	sub    $0xc,%esp
801065db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801065de:	31 c9                	xor    %ecx,%ecx
801065e0:	ba 02 00 00 00       	mov    $0x2,%edx
801065e5:	6a 00                	push   $0x0
801065e7:	e8 24 f8 ff ff       	call   80105e10 <create>
    if(ip == 0){
801065ec:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801065ef:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801065f1:	85 c0                	test   %eax,%eax
801065f3:	75 99                	jne    8010658e <sys_open+0x6e>
      end_op();
801065f5:	e8 96 cc ff ff       	call   80103290 <end_op>
      return -1;
801065fa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801065ff:	eb 40                	jmp    80106641 <sys_open+0x121>
80106601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106608:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010660b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010660f:	56                   	push   %esi
80106610:	e8 1b b7 ff ff       	call   80101d30 <iunlock>
  end_op();
80106615:	e8 76 cc ff ff       	call   80103290 <end_op>

  f->type = FD_INODE;
8010661a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106620:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106623:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106626:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106629:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010662b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106632:	f7 d0                	not    %eax
80106634:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106637:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010663a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010663d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106641:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106644:	89 d8                	mov    %ebx,%eax
80106646:	5b                   	pop    %ebx
80106647:	5e                   	pop    %esi
80106648:	5f                   	pop    %edi
80106649:	5d                   	pop    %ebp
8010664a:	c3                   	ret    
8010664b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010664f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106650:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106653:	85 c9                	test   %ecx,%ecx
80106655:	0f 84 33 ff ff ff    	je     8010658e <sys_open+0x6e>
8010665b:	e9 5c ff ff ff       	jmp    801065bc <sys_open+0x9c>

80106660 <sys_mkdir>:

int
sys_mkdir(void)
{
80106660:	f3 0f 1e fb          	endbr32 
80106664:	55                   	push   %ebp
80106665:	89 e5                	mov    %esp,%ebp
80106667:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010666a:	e8 b1 cb ff ff       	call   80103220 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010666f:	83 ec 08             	sub    $0x8,%esp
80106672:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106675:	50                   	push   %eax
80106676:	6a 00                	push   $0x0
80106678:	e8 e3 f6 ff ff       	call   80105d60 <argstr>
8010667d:	83 c4 10             	add    $0x10,%esp
80106680:	85 c0                	test   %eax,%eax
80106682:	78 34                	js     801066b8 <sys_mkdir+0x58>
80106684:	83 ec 0c             	sub    $0xc,%esp
80106687:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010668a:	31 c9                	xor    %ecx,%ecx
8010668c:	ba 01 00 00 00       	mov    $0x1,%edx
80106691:	6a 00                	push   $0x0
80106693:	e8 78 f7 ff ff       	call   80105e10 <create>
80106698:	83 c4 10             	add    $0x10,%esp
8010669b:	85 c0                	test   %eax,%eax
8010669d:	74 19                	je     801066b8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010669f:	83 ec 0c             	sub    $0xc,%esp
801066a2:	50                   	push   %eax
801066a3:	e8 48 b8 ff ff       	call   80101ef0 <iunlockput>
  end_op();
801066a8:	e8 e3 cb ff ff       	call   80103290 <end_op>
  return 0;
801066ad:	83 c4 10             	add    $0x10,%esp
801066b0:	31 c0                	xor    %eax,%eax
}
801066b2:	c9                   	leave  
801066b3:	c3                   	ret    
801066b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801066b8:	e8 d3 cb ff ff       	call   80103290 <end_op>
    return -1;
801066bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066c2:	c9                   	leave  
801066c3:	c3                   	ret    
801066c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066cf:	90                   	nop

801066d0 <sys_mknod>:

int
sys_mknod(void)
{
801066d0:	f3 0f 1e fb          	endbr32 
801066d4:	55                   	push   %ebp
801066d5:	89 e5                	mov    %esp,%ebp
801066d7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801066da:	e8 41 cb ff ff       	call   80103220 <begin_op>
  if((argstr(0, &path)) < 0 ||
801066df:	83 ec 08             	sub    $0x8,%esp
801066e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801066e5:	50                   	push   %eax
801066e6:	6a 00                	push   $0x0
801066e8:	e8 73 f6 ff ff       	call   80105d60 <argstr>
801066ed:	83 c4 10             	add    $0x10,%esp
801066f0:	85 c0                	test   %eax,%eax
801066f2:	78 64                	js     80106758 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801066f4:	83 ec 08             	sub    $0x8,%esp
801066f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066fa:	50                   	push   %eax
801066fb:	6a 01                	push   $0x1
801066fd:	e8 ae f5 ff ff       	call   80105cb0 <argint>
  if((argstr(0, &path)) < 0 ||
80106702:	83 c4 10             	add    $0x10,%esp
80106705:	85 c0                	test   %eax,%eax
80106707:	78 4f                	js     80106758 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80106709:	83 ec 08             	sub    $0x8,%esp
8010670c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010670f:	50                   	push   %eax
80106710:	6a 02                	push   $0x2
80106712:	e8 99 f5 ff ff       	call   80105cb0 <argint>
     argint(1, &major) < 0 ||
80106717:	83 c4 10             	add    $0x10,%esp
8010671a:	85 c0                	test   %eax,%eax
8010671c:	78 3a                	js     80106758 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010671e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80106722:	83 ec 0c             	sub    $0xc,%esp
80106725:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106729:	ba 03 00 00 00       	mov    $0x3,%edx
8010672e:	50                   	push   %eax
8010672f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106732:	e8 d9 f6 ff ff       	call   80105e10 <create>
     argint(2, &minor) < 0 ||
80106737:	83 c4 10             	add    $0x10,%esp
8010673a:	85 c0                	test   %eax,%eax
8010673c:	74 1a                	je     80106758 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010673e:	83 ec 0c             	sub    $0xc,%esp
80106741:	50                   	push   %eax
80106742:	e8 a9 b7 ff ff       	call   80101ef0 <iunlockput>
  end_op();
80106747:	e8 44 cb ff ff       	call   80103290 <end_op>
  return 0;
8010674c:	83 c4 10             	add    $0x10,%esp
8010674f:	31 c0                	xor    %eax,%eax
}
80106751:	c9                   	leave  
80106752:	c3                   	ret    
80106753:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106757:	90                   	nop
    end_op();
80106758:	e8 33 cb ff ff       	call   80103290 <end_op>
    return -1;
8010675d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106762:	c9                   	leave  
80106763:	c3                   	ret    
80106764:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010676b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010676f:	90                   	nop

80106770 <sys_chdir>:

int
sys_chdir(void)
{
80106770:	f3 0f 1e fb          	endbr32 
80106774:	55                   	push   %ebp
80106775:	89 e5                	mov    %esp,%ebp
80106777:	56                   	push   %esi
80106778:	53                   	push   %ebx
80106779:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010677c:	e8 2f d7 ff ff       	call   80103eb0 <myproc>
80106781:	89 c6                	mov    %eax,%esi
  
  begin_op();
80106783:	e8 98 ca ff ff       	call   80103220 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106788:	83 ec 08             	sub    $0x8,%esp
8010678b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010678e:	50                   	push   %eax
8010678f:	6a 00                	push   $0x0
80106791:	e8 ca f5 ff ff       	call   80105d60 <argstr>
80106796:	83 c4 10             	add    $0x10,%esp
80106799:	85 c0                	test   %eax,%eax
8010679b:	78 73                	js     80106810 <sys_chdir+0xa0>
8010679d:	83 ec 0c             	sub    $0xc,%esp
801067a0:	ff 75 f4             	pushl  -0xc(%ebp)
801067a3:	e8 78 bd ff ff       	call   80102520 <namei>
801067a8:	83 c4 10             	add    $0x10,%esp
801067ab:	89 c3                	mov    %eax,%ebx
801067ad:	85 c0                	test   %eax,%eax
801067af:	74 5f                	je     80106810 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801067b1:	83 ec 0c             	sub    $0xc,%esp
801067b4:	50                   	push   %eax
801067b5:	e8 96 b4 ff ff       	call   80101c50 <ilock>
  if(ip->type != T_DIR){
801067ba:	83 c4 10             	add    $0x10,%esp
801067bd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801067c2:	75 2c                	jne    801067f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801067c4:	83 ec 0c             	sub    $0xc,%esp
801067c7:	53                   	push   %ebx
801067c8:	e8 63 b5 ff ff       	call   80101d30 <iunlock>
  iput(curproc->cwd);
801067cd:	58                   	pop    %eax
801067ce:	ff 76 68             	pushl  0x68(%esi)
801067d1:	e8 aa b5 ff ff       	call   80101d80 <iput>
  end_op();
801067d6:	e8 b5 ca ff ff       	call   80103290 <end_op>
  curproc->cwd = ip;
801067db:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801067de:	83 c4 10             	add    $0x10,%esp
801067e1:	31 c0                	xor    %eax,%eax
}
801067e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801067e6:	5b                   	pop    %ebx
801067e7:	5e                   	pop    %esi
801067e8:	5d                   	pop    %ebp
801067e9:	c3                   	ret    
801067ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801067f0:	83 ec 0c             	sub    $0xc,%esp
801067f3:	53                   	push   %ebx
801067f4:	e8 f7 b6 ff ff       	call   80101ef0 <iunlockput>
    end_op();
801067f9:	e8 92 ca ff ff       	call   80103290 <end_op>
    return -1;
801067fe:	83 c4 10             	add    $0x10,%esp
80106801:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106806:	eb db                	jmp    801067e3 <sys_chdir+0x73>
80106808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010680f:	90                   	nop
    end_op();
80106810:	e8 7b ca ff ff       	call   80103290 <end_op>
    return -1;
80106815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010681a:	eb c7                	jmp    801067e3 <sys_chdir+0x73>
8010681c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106820 <sys_exec>:

int
sys_exec(void)
{
80106820:	f3 0f 1e fb          	endbr32 
80106824:	55                   	push   %ebp
80106825:	89 e5                	mov    %esp,%ebp
80106827:	57                   	push   %edi
80106828:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106829:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010682f:	53                   	push   %ebx
80106830:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106836:	50                   	push   %eax
80106837:	6a 00                	push   $0x0
80106839:	e8 22 f5 ff ff       	call   80105d60 <argstr>
8010683e:	83 c4 10             	add    $0x10,%esp
80106841:	85 c0                	test   %eax,%eax
80106843:	0f 88 8b 00 00 00    	js     801068d4 <sys_exec+0xb4>
80106849:	83 ec 08             	sub    $0x8,%esp
8010684c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106852:	50                   	push   %eax
80106853:	6a 01                	push   $0x1
80106855:	e8 56 f4 ff ff       	call   80105cb0 <argint>
8010685a:	83 c4 10             	add    $0x10,%esp
8010685d:	85 c0                	test   %eax,%eax
8010685f:	78 73                	js     801068d4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106861:	83 ec 04             	sub    $0x4,%esp
80106864:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010686a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010686c:	68 80 00 00 00       	push   $0x80
80106871:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106877:	6a 00                	push   $0x0
80106879:	50                   	push   %eax
8010687a:	e8 c1 f0 ff ff       	call   80105940 <memset>
8010687f:	83 c4 10             	add    $0x10,%esp
80106882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106888:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010688e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106895:	83 ec 08             	sub    $0x8,%esp
80106898:	57                   	push   %edi
80106899:	01 f0                	add    %esi,%eax
8010689b:	50                   	push   %eax
8010689c:	e8 6f f3 ff ff       	call   80105c10 <fetchint>
801068a1:	83 c4 10             	add    $0x10,%esp
801068a4:	85 c0                	test   %eax,%eax
801068a6:	78 2c                	js     801068d4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
801068a8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801068ae:	85 c0                	test   %eax,%eax
801068b0:	74 36                	je     801068e8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801068b2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801068b8:	83 ec 08             	sub    $0x8,%esp
801068bb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801068be:	52                   	push   %edx
801068bf:	50                   	push   %eax
801068c0:	e8 8b f3 ff ff       	call   80105c50 <fetchstr>
801068c5:	83 c4 10             	add    $0x10,%esp
801068c8:	85 c0                	test   %eax,%eax
801068ca:	78 08                	js     801068d4 <sys_exec+0xb4>
  for(i=0;; i++){
801068cc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801068cf:	83 fb 20             	cmp    $0x20,%ebx
801068d2:	75 b4                	jne    80106888 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
801068d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801068d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068dc:	5b                   	pop    %ebx
801068dd:	5e                   	pop    %esi
801068de:	5f                   	pop    %edi
801068df:	5d                   	pop    %ebp
801068e0:	c3                   	ret    
801068e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801068e8:	83 ec 08             	sub    $0x8,%esp
801068eb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801068f1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801068f8:	00 00 00 00 
  return exec(path, argv);
801068fc:	50                   	push   %eax
801068fd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80106903:	e8 68 a6 ff ff       	call   80100f70 <exec>
80106908:	83 c4 10             	add    $0x10,%esp
}
8010690b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010690e:	5b                   	pop    %ebx
8010690f:	5e                   	pop    %esi
80106910:	5f                   	pop    %edi
80106911:	5d                   	pop    %ebp
80106912:	c3                   	ret    
80106913:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010691a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106920 <sys_pipe>:

int
sys_pipe(void)
{
80106920:	f3 0f 1e fb          	endbr32 
80106924:	55                   	push   %ebp
80106925:	89 e5                	mov    %esp,%ebp
80106927:	57                   	push   %edi
80106928:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106929:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010692c:	53                   	push   %ebx
8010692d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106930:	6a 08                	push   $0x8
80106932:	50                   	push   %eax
80106933:	6a 00                	push   $0x0
80106935:	e8 c6 f3 ff ff       	call   80105d00 <argptr>
8010693a:	83 c4 10             	add    $0x10,%esp
8010693d:	85 c0                	test   %eax,%eax
8010693f:	78 4e                	js     8010698f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106941:	83 ec 08             	sub    $0x8,%esp
80106944:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106947:	50                   	push   %eax
80106948:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010694b:	50                   	push   %eax
8010694c:	e8 8f cf ff ff       	call   801038e0 <pipealloc>
80106951:	83 c4 10             	add    $0x10,%esp
80106954:	85 c0                	test   %eax,%eax
80106956:	78 37                	js     8010698f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106958:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010695b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010695d:	e8 4e d5 ff ff       	call   80103eb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80106968:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010696c:	85 f6                	test   %esi,%esi
8010696e:	74 30                	je     801069a0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80106970:	83 c3 01             	add    $0x1,%ebx
80106973:	83 fb 10             	cmp    $0x10,%ebx
80106976:	75 f0                	jne    80106968 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106978:	83 ec 0c             	sub    $0xc,%esp
8010697b:	ff 75 e0             	pushl  -0x20(%ebp)
8010697e:	e8 2d aa ff ff       	call   801013b0 <fileclose>
    fileclose(wf);
80106983:	58                   	pop    %eax
80106984:	ff 75 e4             	pushl  -0x1c(%ebp)
80106987:	e8 24 aa ff ff       	call   801013b0 <fileclose>
    return -1;
8010698c:	83 c4 10             	add    $0x10,%esp
8010698f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106994:	eb 5b                	jmp    801069f1 <sys_pipe+0xd1>
80106996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010699d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801069a0:	8d 73 08             	lea    0x8(%ebx),%esi
801069a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801069a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801069aa:	e8 01 d5 ff ff       	call   80103eb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801069af:	31 d2                	xor    %edx,%edx
801069b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801069b8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801069bc:	85 c9                	test   %ecx,%ecx
801069be:	74 20                	je     801069e0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
801069c0:	83 c2 01             	add    $0x1,%edx
801069c3:	83 fa 10             	cmp    $0x10,%edx
801069c6:	75 f0                	jne    801069b8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
801069c8:	e8 e3 d4 ff ff       	call   80103eb0 <myproc>
801069cd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801069d4:	00 
801069d5:	eb a1                	jmp    80106978 <sys_pipe+0x58>
801069d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801069e0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801069e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801069e7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801069e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801069ec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801069ef:	31 c0                	xor    %eax,%eax
}
801069f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069f4:	5b                   	pop    %ebx
801069f5:	5e                   	pop    %esi
801069f6:	5f                   	pop    %edi
801069f7:	5d                   	pop    %ebp
801069f8:	c3                   	ret    
801069f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a00 <sys_copy_file>:

int 
sys_copy_file(void) {
80106a00:	f3 0f 1e fb          	endbr32 
80106a04:	55                   	push   %ebp
80106a05:	89 e5                	mov    %esp,%ebp
80106a07:	57                   	push   %edi
80106a08:	56                   	push   %esi
  struct inode* ip_dst;
  struct inode* ip_src;
  int bytesRead;
  char buf[1024];

  if (argstr(0, &src_path) < 0 || argstr(1, &dst_path) < 0)
80106a09:	8d 85 e0 fb ff ff    	lea    -0x420(%ebp),%eax
sys_copy_file(void) {
80106a0f:	53                   	push   %ebx
80106a10:	81 ec 34 04 00 00    	sub    $0x434,%esp
  if (argstr(0, &src_path) < 0 || argstr(1, &dst_path) < 0)
80106a16:	50                   	push   %eax
80106a17:	6a 00                	push   $0x0
80106a19:	e8 42 f3 ff ff       	call   80105d60 <argstr>
80106a1e:	83 c4 10             	add    $0x10,%esp
80106a21:	85 c0                	test   %eax,%eax
80106a23:	0f 88 fa 00 00 00    	js     80106b23 <sys_copy_file+0x123>
80106a29:	83 ec 08             	sub    $0x8,%esp
80106a2c:	8d 85 e4 fb ff ff    	lea    -0x41c(%ebp),%eax
80106a32:	50                   	push   %eax
80106a33:	6a 01                	push   $0x1
80106a35:	e8 26 f3 ff ff       	call   80105d60 <argstr>
80106a3a:	83 c4 10             	add    $0x10,%esp
80106a3d:	85 c0                	test   %eax,%eax
80106a3f:	0f 88 de 00 00 00    	js     80106b23 <sys_copy_file+0x123>
    return -1;
  begin_op();
80106a45:	e8 d6 c7 ff ff       	call   80103220 <begin_op>

  if ((ip_src = namei(src_path)) == 0) { // Check if source file exists
80106a4a:	83 ec 0c             	sub    $0xc,%esp
80106a4d:	ff b5 e0 fb ff ff    	pushl  -0x420(%ebp)
80106a53:	e8 c8 ba ff ff       	call   80102520 <namei>
80106a58:	83 c4 10             	add    $0x10,%esp
80106a5b:	89 85 d4 fb ff ff    	mov    %eax,-0x42c(%ebp)
80106a61:	85 c0                	test   %eax,%eax
80106a63:	0f 84 b5 00 00 00    	je     80106b1e <sys_copy_file+0x11e>
    end_op();
    return -1;
  }
 
  ip_dst = namei(dst_path);
80106a69:	83 ec 0c             	sub    $0xc,%esp
80106a6c:	ff b5 e4 fb ff ff    	pushl  -0x41c(%ebp)
80106a72:	e8 a9 ba ff ff       	call   80102520 <namei>
  if (ip_dst > 0) { // Check if destination file already exists
80106a77:	83 c4 10             	add    $0x10,%esp
80106a7a:	85 c0                	test   %eax,%eax
80106a7c:	0f 85 9c 00 00 00    	jne    80106b1e <sys_copy_file+0x11e>
    end_op();
    return -1;
  }
  ip_dst = create(dst_path, T_FILE, 0, 0);
80106a82:	83 ec 0c             	sub    $0xc,%esp
80106a85:	8b 85 e4 fb ff ff    	mov    -0x41c(%ebp),%eax
80106a8b:	31 c9                	xor    %ecx,%ecx
80106a8d:	ba 02 00 00 00       	mov    $0x2,%edx
80106a92:	6a 00                	push   $0x0

  int bytesWrote = 0;
  int readOffset = 0;
  int writeOffset = 0;
80106a94:	31 f6                	xor    %esi,%esi
  int readOffset = 0;
80106a96:	31 db                	xor    %ebx,%ebx
80106a98:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
  ip_dst = create(dst_path, T_FILE, 0, 0);
80106a9e:	e8 6d f3 ff ff       	call   80105e10 <create>
  ilock(ip_src);
80106aa3:	5a                   	pop    %edx
80106aa4:	ff b5 d4 fb ff ff    	pushl  -0x42c(%ebp)
  ip_dst = create(dst_path, T_FILE, 0, 0);
80106aaa:	89 85 d0 fb ff ff    	mov    %eax,-0x430(%ebp)
  ilock(ip_src);
80106ab0:	e8 9b b1 ff ff       	call   80101c50 <ilock>
  while ((bytesRead = readi(ip_src, buf, readOffset, sizeof(buf))) > 0) {
80106ab5:	83 c4 10             	add    $0x10,%esp
80106ab8:	eb 1f                	jmp    80106ad9 <sys_copy_file+0xd9>
80106aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    readOffset += bytesRead;
    if ((bytesWrote = writei(ip_dst , buf,writeOffset,  bytesRead)) <= 0)
80106ac0:	50                   	push   %eax
    readOffset += bytesRead;
80106ac1:	01 c3                	add    %eax,%ebx
    if ((bytesWrote = writei(ip_dst , buf,writeOffset,  bytesRead)) <= 0)
80106ac3:	56                   	push   %esi
80106ac4:	57                   	push   %edi
80106ac5:	ff b5 d0 fb ff ff    	pushl  -0x430(%ebp)
80106acb:	e8 80 b5 ff ff       	call   80102050 <writei>
80106ad0:	83 c4 10             	add    $0x10,%esp
80106ad3:	85 c0                	test   %eax,%eax
80106ad5:	7e 4c                	jle    80106b23 <sys_copy_file+0x123>
      return -1;
    writeOffset += bytesWrote;
80106ad7:	01 c6                	add    %eax,%esi
  while ((bytesRead = readi(ip_src, buf, readOffset, sizeof(buf))) > 0) {
80106ad9:	68 00 04 00 00       	push   $0x400
80106ade:	53                   	push   %ebx
80106adf:	57                   	push   %edi
80106ae0:	ff b5 d4 fb ff ff    	pushl  -0x42c(%ebp)
80106ae6:	e8 65 b4 ff ff       	call   80101f50 <readi>
80106aeb:	83 c4 10             	add    $0x10,%esp
80106aee:	85 c0                	test   %eax,%eax
80106af0:	7f ce                	jg     80106ac0 <sys_copy_file+0xc0>
   
}

  iunlock(ip_src);
80106af2:	83 ec 0c             	sub    $0xc,%esp
80106af5:	ff b5 d4 fb ff ff    	pushl  -0x42c(%ebp)
80106afb:	e8 30 b2 ff ff       	call   80101d30 <iunlock>
  iunlock(ip_dst);
80106b00:	58                   	pop    %eax
80106b01:	ff b5 d0 fb ff ff    	pushl  -0x430(%ebp)
80106b07:	e8 24 b2 ff ff       	call   80101d30 <iunlock>
  end_op();
80106b0c:	e8 7f c7 ff ff       	call   80103290 <end_op>

  return 0;
80106b11:	83 c4 10             	add    $0x10,%esp
}
80106b14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b17:	31 c0                	xor    %eax,%eax
}
80106b19:	5b                   	pop    %ebx
80106b1a:	5e                   	pop    %esi
80106b1b:	5f                   	pop    %edi
80106b1c:	5d                   	pop    %ebp
80106b1d:	c3                   	ret    
    end_op();
80106b1e:	e8 6d c7 ff ff       	call   80103290 <end_op>
}
80106b23:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106b26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b2b:	5b                   	pop    %ebx
80106b2c:	5e                   	pop    %esi
80106b2d:	5f                   	pop    %edi
80106b2e:	5d                   	pop    %ebp
80106b2f:	c3                   	ret    

80106b30 <sys_get_process_lifetime>:
    return -1;
  //cprintf("sysproc.h %d", pid);
  return get_process_lifetime(pid);
}*/

int sys_get_process_lifetime(void){
80106b30:	f3 0f 1e fb          	endbr32 
  return get_process_lifetime();
80106b34:	e9 37 de ff ff       	jmp    80104970 <get_process_lifetime>
80106b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b40 <sys_get_uncle_count>:
}

int sys_get_uncle_count(void){
80106b40:	f3 0f 1e fb          	endbr32 
80106b44:	55                   	push   %ebp
80106b45:	89 e5                	mov    %esp,%ebp
80106b47:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if(argint(0, &pid) < 0){
80106b4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b4d:	50                   	push   %eax
80106b4e:	6a 00                	push   $0x0
80106b50:	e8 5b f1 ff ff       	call   80105cb0 <argint>
80106b55:	83 c4 10             	add    $0x10,%esp
80106b58:	85 c0                	test   %eax,%eax
80106b5a:	78 14                	js     80106b70 <sys_get_uncle_count+0x30>
    return -1;
  }
  return get_uncle_count(pid);
80106b5c:	83 ec 0c             	sub    $0xc,%esp
80106b5f:	ff 75 f4             	pushl  -0xc(%ebp)
80106b62:	e8 e9 db ff ff       	call   80104750 <get_uncle_count>
80106b67:	83 c4 10             	add    $0x10,%esp
}
80106b6a:	c9                   	leave  
80106b6b:	c3                   	ret    
80106b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b70:	c9                   	leave  
    return -1;
80106b71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b76:	c3                   	ret    
80106b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b7e:	66 90                	xchg   %ax,%ax

80106b80 <sys_fork>:

int
sys_fork(void)
{
80106b80:	f3 0f 1e fb          	endbr32 
  return fork();
80106b84:	e9 b7 df ff ff       	jmp    80104b40 <fork>
80106b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b90 <sys_exit>:
}

int
sys_exit(void)
{
80106b90:	f3 0f 1e fb          	endbr32 
80106b94:	55                   	push   %ebp
80106b95:	89 e5                	mov    %esp,%ebp
80106b97:	83 ec 08             	sub    $0x8,%esp
  exit();
80106b9a:	e8 61 d7 ff ff       	call   80104300 <exit>
  return 0;  // not reached
}
80106b9f:	31 c0                	xor    %eax,%eax
80106ba1:	c9                   	leave  
80106ba2:	c3                   	ret    
80106ba3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106bb0 <sys_wait>:

int
sys_wait(void)
{
80106bb0:	f3 0f 1e fb          	endbr32 
  return wait();
80106bb4:	e9 97 d9 ff ff       	jmp    80104550 <wait>
80106bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106bc0 <sys_kill>:
}

int
sys_kill(void)
{
80106bc0:	f3 0f 1e fb          	endbr32 
80106bc4:	55                   	push   %ebp
80106bc5:	89 e5                	mov    %esp,%ebp
80106bc7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106bca:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bcd:	50                   	push   %eax
80106bce:	6a 00                	push   $0x0
80106bd0:	e8 db f0 ff ff       	call   80105cb0 <argint>
80106bd5:	83 c4 10             	add    $0x10,%esp
80106bd8:	85 c0                	test   %eax,%eax
80106bda:	78 14                	js     80106bf0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106bdc:	83 ec 0c             	sub    $0xc,%esp
80106bdf:	ff 75 f4             	pushl  -0xc(%ebp)
80106be2:	e8 d9 da ff ff       	call   801046c0 <kill>
80106be7:	83 c4 10             	add    $0x10,%esp
}
80106bea:	c9                   	leave  
80106beb:	c3                   	ret    
80106bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106bf0:	c9                   	leave  
    return -1;
80106bf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bf6:	c3                   	ret    
80106bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bfe:	66 90                	xchg   %ax,%ax

80106c00 <sys_getpid>:

int
sys_getpid(void)
{
80106c00:	f3 0f 1e fb          	endbr32 
80106c04:	55                   	push   %ebp
80106c05:	89 e5                	mov    %esp,%ebp
80106c07:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106c0a:	e8 a1 d2 ff ff       	call   80103eb0 <myproc>
80106c0f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106c12:	c9                   	leave  
80106c13:	c3                   	ret    
80106c14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c1f:	90                   	nop

80106c20 <sys_sbrk>:

int
sys_sbrk(void)
{
80106c20:	f3 0f 1e fb          	endbr32 
80106c24:	55                   	push   %ebp
80106c25:	89 e5                	mov    %esp,%ebp
80106c27:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106c28:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106c2b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106c2e:	50                   	push   %eax
80106c2f:	6a 00                	push   $0x0
80106c31:	e8 7a f0 ff ff       	call   80105cb0 <argint>
80106c36:	83 c4 10             	add    $0x10,%esp
80106c39:	85 c0                	test   %eax,%eax
80106c3b:	78 23                	js     80106c60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106c3d:	e8 6e d2 ff ff       	call   80103eb0 <myproc>
  if(growproc(n) < 0)
80106c42:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106c45:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106c47:	ff 75 f4             	pushl  -0xc(%ebp)
80106c4a:	e8 91 d2 ff ff       	call   80103ee0 <growproc>
80106c4f:	83 c4 10             	add    $0x10,%esp
80106c52:	85 c0                	test   %eax,%eax
80106c54:	78 0a                	js     80106c60 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106c56:	89 d8                	mov    %ebx,%eax
80106c58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106c5b:	c9                   	leave  
80106c5c:	c3                   	ret    
80106c5d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106c60:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106c65:	eb ef                	jmp    80106c56 <sys_sbrk+0x36>
80106c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c6e:	66 90                	xchg   %ax,%ax

80106c70 <sys_sleep>:

int
sys_sleep(void)
{
80106c70:	f3 0f 1e fb          	endbr32 
80106c74:	55                   	push   %ebp
80106c75:	89 e5                	mov    %esp,%ebp
80106c77:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106c78:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106c7b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106c7e:	50                   	push   %eax
80106c7f:	6a 00                	push   $0x0
80106c81:	e8 2a f0 ff ff       	call   80105cb0 <argint>
80106c86:	83 c4 10             	add    $0x10,%esp
80106c89:	85 c0                	test   %eax,%eax
80106c8b:	0f 88 86 00 00 00    	js     80106d17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106c91:	83 ec 0c             	sub    $0xc,%esp
80106c94:	68 00 7e 11 80       	push   $0x80117e00
80106c99:	e8 92 eb ff ff       	call   80105830 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106c9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106ca1:	8b 1d 40 86 11 80    	mov    0x80118640,%ebx
  while(ticks - ticks0 < n){
80106ca7:	83 c4 10             	add    $0x10,%esp
80106caa:	85 d2                	test   %edx,%edx
80106cac:	75 23                	jne    80106cd1 <sys_sleep+0x61>
80106cae:	eb 50                	jmp    80106d00 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106cb0:	83 ec 08             	sub    $0x8,%esp
80106cb3:	68 00 7e 11 80       	push   $0x80117e00
80106cb8:	68 40 86 11 80       	push   $0x80118640
80106cbd:	e8 ce d7 ff ff       	call   80104490 <sleep>
  while(ticks - ticks0 < n){
80106cc2:	a1 40 86 11 80       	mov    0x80118640,%eax
80106cc7:	83 c4 10             	add    $0x10,%esp
80106cca:	29 d8                	sub    %ebx,%eax
80106ccc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106ccf:	73 2f                	jae    80106d00 <sys_sleep+0x90>
    if(myproc()->killed){
80106cd1:	e8 da d1 ff ff       	call   80103eb0 <myproc>
80106cd6:	8b 40 24             	mov    0x24(%eax),%eax
80106cd9:	85 c0                	test   %eax,%eax
80106cdb:	74 d3                	je     80106cb0 <sys_sleep+0x40>
      release(&tickslock);
80106cdd:	83 ec 0c             	sub    $0xc,%esp
80106ce0:	68 00 7e 11 80       	push   $0x80117e00
80106ce5:	e8 06 ec ff ff       	call   801058f0 <release>
  }
  release(&tickslock);
  return 0;
}
80106cea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80106ced:	83 c4 10             	add    $0x10,%esp
80106cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cf5:	c9                   	leave  
80106cf6:	c3                   	ret    
80106cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cfe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106d00:	83 ec 0c             	sub    $0xc,%esp
80106d03:	68 00 7e 11 80       	push   $0x80117e00
80106d08:	e8 e3 eb ff ff       	call   801058f0 <release>
  return 0;
80106d0d:	83 c4 10             	add    $0x10,%esp
80106d10:	31 c0                	xor    %eax,%eax
}
80106d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106d15:	c9                   	leave  
80106d16:	c3                   	ret    
    return -1;
80106d17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d1c:	eb f4                	jmp    80106d12 <sys_sleep+0xa2>
80106d1e:	66 90                	xchg   %ax,%ax

80106d20 <sys_change_sched_Q>:
int
sys_change_sched_Q(void)
{
80106d20:	f3 0f 1e fb          	endbr32 
80106d24:	55                   	push   %ebp
80106d25:	89 e5                	mov    %esp,%ebp
80106d27:	83 ec 20             	sub    $0x20,%esp
  int queue_number, pid;
  if(argint(0, &pid) < 0 || argint(1, &queue_number) < 0)
80106d2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d2d:	50                   	push   %eax
80106d2e:	6a 00                	push   $0x0
80106d30:	e8 7b ef ff ff       	call   80105cb0 <argint>
80106d35:	83 c4 10             	add    $0x10,%esp
80106d38:	85 c0                	test   %eax,%eax
80106d3a:	78 34                	js     80106d70 <sys_change_sched_Q+0x50>
80106d3c:	83 ec 08             	sub    $0x8,%esp
80106d3f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d42:	50                   	push   %eax
80106d43:	6a 01                	push   $0x1
80106d45:	e8 66 ef ff ff       	call   80105cb0 <argint>
80106d4a:	83 c4 10             	add    $0x10,%esp
80106d4d:	85 c0                	test   %eax,%eax
80106d4f:	78 1f                	js     80106d70 <sys_change_sched_Q+0x50>
    return -1;

  if(queue_number < ROUND_ROBIN || queue_number > BJF)
80106d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d54:	8d 50 ff             	lea    -0x1(%eax),%edx
80106d57:	83 fa 02             	cmp    $0x2,%edx
80106d5a:	77 14                	ja     80106d70 <sys_change_sched_Q+0x50>
    return -1;

  return change_Q(pid, queue_number);
80106d5c:	83 ec 08             	sub    $0x8,%esp
80106d5f:	50                   	push   %eax
80106d60:	ff 75 f4             	pushl  -0xc(%ebp)
80106d63:	e8 38 dc ff ff       	call   801049a0 <change_Q>
80106d68:	83 c4 10             	add    $0x10,%esp
}
80106d6b:	c9                   	leave  
80106d6c:	c3                   	ret    
80106d6d:	8d 76 00             	lea    0x0(%esi),%esi
80106d70:	c9                   	leave  
    return -1;
80106d71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d76:	c3                   	ret    
80106d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d7e:	66 90                	xchg   %ax,%ax

80106d80 <sys_show_process_info>:

void sys_show_process_info(void) {
80106d80:	f3 0f 1e fb          	endbr32 
  show_process_info();
80106d84:	e9 17 e1 ff ff       	jmp    80104ea0 <show_process_info>
80106d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d90 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106d90:	f3 0f 1e fb          	endbr32 
80106d94:	55                   	push   %ebp
80106d95:	89 e5                	mov    %esp,%ebp
80106d97:	53                   	push   %ebx
80106d98:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106d9b:	68 00 7e 11 80       	push   $0x80117e00
80106da0:	e8 8b ea ff ff       	call   80105830 <acquire>
  xticks = ticks;
80106da5:	8b 1d 40 86 11 80    	mov    0x80118640,%ebx
  release(&tickslock);
80106dab:	c7 04 24 00 7e 11 80 	movl   $0x80117e00,(%esp)
80106db2:	e8 39 eb ff ff       	call   801058f0 <release>
  return xticks;
}
80106db7:	89 d8                	mov    %ebx,%eax
80106db9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106dbc:	c9                   	leave  
80106dbd:	c3                   	ret    
80106dbe:	66 90                	xchg   %ax,%ax

80106dc0 <sys_find_digital_root>:

int
sys_find_digital_root(void)
{
80106dc0:	f3 0f 1e fb          	endbr32 
80106dc4:	55                   	push   %ebp
80106dc5:	89 e5                	mov    %esp,%ebp
80106dc7:	53                   	push   %ebx
80106dc8:	83 ec 04             	sub    $0x4,%esp
  int n = myproc()->tf->ebx;
80106dcb:	e8 e0 d0 ff ff       	call   80103eb0 <myproc>
  cprintf("KERNEL: sys_find_digital_root(%d)\n", n);
80106dd0:	83 ec 08             	sub    $0x8,%esp
  int n = myproc()->tf->ebx;
80106dd3:	8b 40 18             	mov    0x18(%eax),%eax
80106dd6:	8b 58 10             	mov    0x10(%eax),%ebx
  cprintf("KERNEL: sys_find_digital_root(%d)\n", n);
80106dd9:	53                   	push   %ebx
80106dda:	68 dc 90 10 80       	push   $0x801090dc
80106ddf:	e8 dc 9a ff ff       	call   801008c0 <cprintf>
  return find_digital_root(n);
80106de4:	89 1c 24             	mov    %ebx,(%esp)
80106de7:	e8 24 db ff ff       	call   80104910 <find_digital_root>

}
80106dec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106def:	c9                   	leave  
80106df0:	c3                   	ret    
80106df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dff:	90                   	nop

80106e00 <sys_set_proc_bjf_params>:
//   return 0;
// }

int
sys_set_proc_bjf_params(void)
{
80106e00:	f3 0f 1e fb          	endbr32 
80106e04:	55                   	push   %ebp
80106e05:	89 e5                	mov    %esp,%ebp
80106e07:	83 ec 30             	sub    $0x30,%esp
  int pid;
  float priority_ratio, arrival_time_ratio, executed_cycle_ratio, process_size_ratio;
  if(argint(0, &pid) < 0 ||
80106e0a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106e0d:	50                   	push   %eax
80106e0e:	6a 00                	push   $0x0
80106e10:	e8 9b ee ff ff       	call   80105cb0 <argint>
80106e15:	83 c4 10             	add    $0x10,%esp
80106e18:	85 c0                	test   %eax,%eax
80106e1a:	78 74                	js     80106e90 <sys_set_proc_bjf_params+0x90>
     argfloat(1, &priority_ratio) < 0 ||
80106e1c:	83 ec 08             	sub    $0x8,%esp
80106e1f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106e22:	50                   	push   %eax
80106e23:	6a 01                	push   $0x1
80106e25:	e8 96 ed ff ff       	call   80105bc0 <argfloat>
  if(argint(0, &pid) < 0 ||
80106e2a:	83 c4 10             	add    $0x10,%esp
80106e2d:	85 c0                	test   %eax,%eax
80106e2f:	78 5f                	js     80106e90 <sys_set_proc_bjf_params+0x90>
     argfloat(2, &arrival_time_ratio) < 0 ||
80106e31:	83 ec 08             	sub    $0x8,%esp
80106e34:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106e37:	50                   	push   %eax
80106e38:	6a 02                	push   $0x2
80106e3a:	e8 81 ed ff ff       	call   80105bc0 <argfloat>
     argfloat(1, &priority_ratio) < 0 ||
80106e3f:	83 c4 10             	add    $0x10,%esp
80106e42:	85 c0                	test   %eax,%eax
80106e44:	78 4a                	js     80106e90 <sys_set_proc_bjf_params+0x90>
     argfloat(3, &executed_cycle_ratio) < 0||
80106e46:	83 ec 08             	sub    $0x8,%esp
80106e49:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106e4c:	50                   	push   %eax
80106e4d:	6a 03                	push   $0x3
80106e4f:	e8 6c ed ff ff       	call   80105bc0 <argfloat>
     argfloat(2, &arrival_time_ratio) < 0 ||
80106e54:	83 c4 10             	add    $0x10,%esp
80106e57:	85 c0                	test   %eax,%eax
80106e59:	78 35                	js     80106e90 <sys_set_proc_bjf_params+0x90>
     argfloat(4, &process_size_ratio)<0 ){
80106e5b:	83 ec 08             	sub    $0x8,%esp
80106e5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e61:	50                   	push   %eax
80106e62:	6a 04                	push   $0x4
80106e64:	e8 57 ed ff ff       	call   80105bc0 <argfloat>
     argfloat(3, &executed_cycle_ratio) < 0||
80106e69:	83 c4 10             	add    $0x10,%esp
80106e6c:	85 c0                	test   %eax,%eax
80106e6e:	78 20                	js     80106e90 <sys_set_proc_bjf_params+0x90>
    return -1;
  }

  return set_proc_bjf_params(pid, priority_ratio, arrival_time_ratio, executed_cycle_ratio,process_size_ratio);
80106e70:	83 ec 0c             	sub    $0xc,%esp
80106e73:	ff 75 f4             	pushl  -0xc(%ebp)
80106e76:	ff 75 f0             	pushl  -0x10(%ebp)
80106e79:	ff 75 ec             	pushl  -0x14(%ebp)
80106e7c:	ff 75 e8             	pushl  -0x18(%ebp)
80106e7f:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e82:	e8 09 df ff ff       	call   80104d90 <set_proc_bjf_params>
80106e87:	83 c4 20             	add    $0x20,%esp
}
80106e8a:	c9                   	leave  
80106e8b:	c3                   	ret    
80106e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e90:	c9                   	leave  
    return -1;
80106e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e96:	c3                   	ret    
80106e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e9e:	66 90                	xchg   %ax,%ax

80106ea0 <sys_set_system_bjf_params>:

int
sys_set_system_bjf_params(void)
{
80106ea0:	f3 0f 1e fb          	endbr32 
80106ea4:	55                   	push   %ebp
80106ea5:	89 e5                	mov    %esp,%ebp
80106ea7:	83 ec 20             	sub    $0x20,%esp
  float priority_ratio, arrival_time_ratio, executed_cycle_ratio,process_size_ratio;
  if(argfloat(0, &priority_ratio) < 0 ||
80106eaa:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106ead:	50                   	push   %eax
80106eae:	6a 00                	push   $0x0
80106eb0:	e8 0b ed ff ff       	call   80105bc0 <argfloat>
80106eb5:	83 c4 10             	add    $0x10,%esp
80106eb8:	85 c0                	test   %eax,%eax
80106eba:	78 5c                	js     80106f18 <sys_set_system_bjf_params+0x78>
     argfloat(1, &arrival_time_ratio) < 0 ||
80106ebc:	83 ec 08             	sub    $0x8,%esp
80106ebf:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106ec2:	50                   	push   %eax
80106ec3:	6a 01                	push   $0x1
80106ec5:	e8 f6 ec ff ff       	call   80105bc0 <argfloat>
  if(argfloat(0, &priority_ratio) < 0 ||
80106eca:	83 c4 10             	add    $0x10,%esp
80106ecd:	85 c0                	test   %eax,%eax
80106ecf:	78 47                	js     80106f18 <sys_set_system_bjf_params+0x78>
     argfloat(2, &executed_cycle_ratio) < 0||
80106ed1:	83 ec 08             	sub    $0x8,%esp
80106ed4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ed7:	50                   	push   %eax
80106ed8:	6a 02                	push   $0x2
80106eda:	e8 e1 ec ff ff       	call   80105bc0 <argfloat>
     argfloat(1, &arrival_time_ratio) < 0 ||
80106edf:	83 c4 10             	add    $0x10,%esp
80106ee2:	85 c0                	test   %eax,%eax
80106ee4:	78 32                	js     80106f18 <sys_set_system_bjf_params+0x78>
     argfloat(3,&process_size_ratio)<0){
80106ee6:	83 ec 08             	sub    $0x8,%esp
80106ee9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106eec:	50                   	push   %eax
80106eed:	6a 03                	push   $0x3
80106eef:	e8 cc ec ff ff       	call   80105bc0 <argfloat>
     argfloat(2, &executed_cycle_ratio) < 0||
80106ef4:	83 c4 10             	add    $0x10,%esp
80106ef7:	85 c0                	test   %eax,%eax
80106ef9:	78 1d                	js     80106f18 <sys_set_system_bjf_params+0x78>
    return -1;
  }

  set_system_bjf_params(priority_ratio, arrival_time_ratio, executed_cycle_ratio,process_size_ratio);
80106efb:	ff 75 f4             	pushl  -0xc(%ebp)
80106efe:	ff 75 f0             	pushl  -0x10(%ebp)
80106f01:	ff 75 ec             	pushl  -0x14(%ebp)
80106f04:	ff 75 e8             	pushl  -0x18(%ebp)
80106f07:	e8 24 df ff ff       	call   80104e30 <set_system_bjf_params>
  return 0;
80106f0c:	83 c4 10             	add    $0x10,%esp
80106f0f:	31 c0                	xor    %eax,%eax
}
80106f11:	c9                   	leave  
80106f12:	c3                   	ret    
80106f13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f17:	90                   	nop
80106f18:	c9                   	leave  
    return -1;
80106f19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f1e:	c3                   	ret    

80106f1f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106f1f:	1e                   	push   %ds
  pushl %es
80106f20:	06                   	push   %es
  pushl %fs
80106f21:	0f a0                	push   %fs
  pushl %gs
80106f23:	0f a8                	push   %gs
  pushal
80106f25:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106f26:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106f2a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106f2c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106f2e:	54                   	push   %esp
  call trap
80106f2f:	e8 cc 00 00 00       	call   80107000 <trap>
  addl $4, %esp
80106f34:	83 c4 04             	add    $0x4,%esp

80106f37 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106f37:	61                   	popa   
  popl %gs
80106f38:	0f a9                	pop    %gs
  popl %fs
80106f3a:	0f a1                	pop    %fs
  popl %es
80106f3c:	07                   	pop    %es
  popl %ds
80106f3d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106f3e:	83 c4 08             	add    $0x8,%esp
  iret
80106f41:	cf                   	iret   
80106f42:	66 90                	xchg   %ax,%ax
80106f44:	66 90                	xchg   %ax,%ax
80106f46:	66 90                	xchg   %ax,%ax
80106f48:	66 90                	xchg   %ax,%ax
80106f4a:	66 90                	xchg   %ax,%ax
80106f4c:	66 90                	xchg   %ax,%ax
80106f4e:	66 90                	xchg   %ax,%ax

80106f50 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106f50:	f3 0f 1e fb          	endbr32 
80106f54:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106f55:	31 c0                	xor    %eax,%eax
{
80106f57:	89 e5                	mov    %esp,%ebp
80106f59:	83 ec 08             	sub    $0x8,%esp
80106f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106f60:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106f67:	c7 04 c5 42 7e 11 80 	movl   $0x8e000008,-0x7fee81be(,%eax,8)
80106f6e:	08 00 00 8e 
80106f72:	66 89 14 c5 40 7e 11 	mov    %dx,-0x7fee81c0(,%eax,8)
80106f79:	80 
80106f7a:	c1 ea 10             	shr    $0x10,%edx
80106f7d:	66 89 14 c5 46 7e 11 	mov    %dx,-0x7fee81ba(,%eax,8)
80106f84:	80 
  for(i = 0; i < 256; i++)
80106f85:	83 c0 01             	add    $0x1,%eax
80106f88:	3d 00 01 00 00       	cmp    $0x100,%eax
80106f8d:	75 d1                	jne    80106f60 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80106f8f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106f92:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80106f97:	c7 05 42 80 11 80 08 	movl   $0xef000008,0x80118042
80106f9e:	00 00 ef 
  initlock(&tickslock, "time");
80106fa1:	68 ff 90 10 80       	push   $0x801090ff
80106fa6:	68 00 7e 11 80       	push   $0x80117e00
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106fab:	66 a3 40 80 11 80    	mov    %ax,0x80118040
80106fb1:	c1 e8 10             	shr    $0x10,%eax
80106fb4:	66 a3 46 80 11 80    	mov    %ax,0x80118046
  initlock(&tickslock, "time");
80106fba:	e8 f1 e6 ff ff       	call   801056b0 <initlock>
}
80106fbf:	83 c4 10             	add    $0x10,%esp
80106fc2:	c9                   	leave  
80106fc3:	c3                   	ret    
80106fc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fcf:	90                   	nop

80106fd0 <idtinit>:

void
idtinit(void)
{
80106fd0:	f3 0f 1e fb          	endbr32 
80106fd4:	55                   	push   %ebp
  pd[0] = size-1;
80106fd5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106fda:	89 e5                	mov    %esp,%ebp
80106fdc:	83 ec 10             	sub    $0x10,%esp
80106fdf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106fe3:	b8 40 7e 11 80       	mov    $0x80117e40,%eax
80106fe8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106fec:	c1 e8 10             	shr    $0x10,%eax
80106fef:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106ff3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106ff6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106ff9:	c9                   	leave  
80106ffa:	c3                   	ret    
80106ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fff:	90                   	nop

80107000 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107000:	f3 0f 1e fb          	endbr32 
80107004:	55                   	push   %ebp
80107005:	89 e5                	mov    %esp,%ebp
80107007:	57                   	push   %edi
80107008:	56                   	push   %esi
80107009:	53                   	push   %ebx
8010700a:	83 ec 1c             	sub    $0x1c,%esp
8010700d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80107010:	8b 43 30             	mov    0x30(%ebx),%eax
80107013:	83 f8 40             	cmp    $0x40,%eax
80107016:	0f 84 cc 01 00 00    	je     801071e8 <trap+0x1e8>
    if(myproc()->killed)
      exit();
    return;
  }
  int os_tick;
  switch(tf->trapno){
8010701c:	83 e8 20             	sub    $0x20,%eax
8010701f:	83 f8 1f             	cmp    $0x1f,%eax
80107022:	77 08                	ja     8010702c <trap+0x2c>
80107024:	3e ff 24 85 a8 91 10 	notrack jmp *-0x7fef6e58(,%eax,4)
8010702b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010702c:	e8 7f ce ff ff       	call   80103eb0 <myproc>
80107031:	8b 7b 38             	mov    0x38(%ebx),%edi
80107034:	85 c0                	test   %eax,%eax
80107036:	0f 84 fb 01 00 00    	je     80107237 <trap+0x237>
8010703c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80107040:	0f 84 f1 01 00 00    	je     80107237 <trap+0x237>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107046:	0f 20 d1             	mov    %cr2,%ecx
80107049:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010704c:	e8 3f ce ff ff       	call   80103e90 <cpuid>
80107051:	8b 73 30             	mov    0x30(%ebx),%esi
80107054:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107057:	8b 43 34             	mov    0x34(%ebx),%eax
8010705a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010705d:	e8 4e ce ff ff       	call   80103eb0 <myproc>
80107062:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107065:	e8 46 ce ff ff       	call   80103eb0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010706a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010706d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107070:	51                   	push   %ecx
80107071:	57                   	push   %edi
80107072:	52                   	push   %edx
80107073:	ff 75 e4             	pushl  -0x1c(%ebp)
80107076:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80107077:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010707a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010707d:	56                   	push   %esi
8010707e:	ff 70 10             	pushl  0x10(%eax)
80107081:	68 64 91 10 80       	push   $0x80109164
80107086:	e8 35 98 ff ff       	call   801008c0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010708b:	83 c4 20             	add    $0x20,%esp
8010708e:	e8 1d ce ff ff       	call   80103eb0 <myproc>
80107093:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010709a:	e8 11 ce ff ff       	call   80103eb0 <myproc>
8010709f:	85 c0                	test   %eax,%eax
801070a1:	74 1d                	je     801070c0 <trap+0xc0>
801070a3:	e8 08 ce ff ff       	call   80103eb0 <myproc>
801070a8:	8b 50 24             	mov    0x24(%eax),%edx
801070ab:	85 d2                	test   %edx,%edx
801070ad:	74 11                	je     801070c0 <trap+0xc0>
801070af:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801070b3:	83 e0 03             	and    $0x3,%eax
801070b6:	66 83 f8 03          	cmp    $0x3,%ax
801070ba:	0f 84 60 01 00 00    	je     80107220 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801070c0:	e8 eb cd ff ff       	call   80103eb0 <myproc>
801070c5:	85 c0                	test   %eax,%eax
801070c7:	74 0f                	je     801070d8 <trap+0xd8>
801070c9:	e8 e2 cd ff ff       	call   80103eb0 <myproc>
801070ce:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801070d2:	0f 84 f8 00 00 00    	je     801071d0 <trap+0x1d0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801070d8:	e8 d3 cd ff ff       	call   80103eb0 <myproc>
801070dd:	85 c0                	test   %eax,%eax
801070df:	74 1d                	je     801070fe <trap+0xfe>
801070e1:	e8 ca cd ff ff       	call   80103eb0 <myproc>
801070e6:	8b 40 24             	mov    0x24(%eax),%eax
801070e9:	85 c0                	test   %eax,%eax
801070eb:	74 11                	je     801070fe <trap+0xfe>
801070ed:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801070f1:	83 e0 03             	and    $0x3,%eax
801070f4:	66 83 f8 03          	cmp    $0x3,%ax
801070f8:	0f 84 13 01 00 00    	je     80107211 <trap+0x211>
    exit();
}
801070fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107101:	5b                   	pop    %ebx
80107102:	5e                   	pop    %esi
80107103:	5f                   	pop    %edi
80107104:	5d                   	pop    %ebp
80107105:	c3                   	ret    
    ideintr();
80107106:	e8 c5 b5 ff ff       	call   801026d0 <ideintr>
    lapiceoi();
8010710b:	e8 a0 bc ff ff       	call   80102db0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107110:	e8 9b cd ff ff       	call   80103eb0 <myproc>
80107115:	85 c0                	test   %eax,%eax
80107117:	75 8a                	jne    801070a3 <trap+0xa3>
80107119:	eb a5                	jmp    801070c0 <trap+0xc0>
    if(cpuid() == 0){
8010711b:	e8 70 cd ff ff       	call   80103e90 <cpuid>
80107120:	85 c0                	test   %eax,%eax
80107122:	75 e7                	jne    8010710b <trap+0x10b>
      acquire(&tickslock);
80107124:	83 ec 0c             	sub    $0xc,%esp
80107127:	68 00 7e 11 80       	push   $0x80117e00
8010712c:	e8 ff e6 ff ff       	call   80105830 <acquire>
      ticks++;
80107131:	a1 40 86 11 80       	mov    0x80118640,%eax
      wakeup(&ticks);
80107136:	c7 04 24 40 86 11 80 	movl   $0x80118640,(%esp)
      ticks++;
8010713d:	8d 70 01             	lea    0x1(%eax),%esi
80107140:	89 35 40 86 11 80    	mov    %esi,0x80118640
      wakeup(&ticks);
80107146:	e8 05 d5 ff ff       	call   80104650 <wakeup>
      release(&tickslock);
8010714b:	c7 04 24 00 7e 11 80 	movl   $0x80117e00,(%esp)
80107152:	e8 99 e7 ff ff       	call   801058f0 <release>
      ageprocs(os_tick);
80107157:	89 34 24             	mov    %esi,(%esp)
8010715a:	e8 11 db ff ff       	call   80104c70 <ageprocs>
8010715f:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80107162:	eb a7                	jmp    8010710b <trap+0x10b>
    kbdintr();
80107164:	e8 07 bb ff ff       	call   80102c70 <kbdintr>
    lapiceoi();
80107169:	e8 42 bc ff ff       	call   80102db0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010716e:	e8 3d cd ff ff       	call   80103eb0 <myproc>
80107173:	85 c0                	test   %eax,%eax
80107175:	0f 85 28 ff ff ff    	jne    801070a3 <trap+0xa3>
8010717b:	e9 40 ff ff ff       	jmp    801070c0 <trap+0xc0>
    uartintr();
80107180:	e8 4b 02 00 00       	call   801073d0 <uartintr>
    lapiceoi();
80107185:	e8 26 bc ff ff       	call   80102db0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010718a:	e8 21 cd ff ff       	call   80103eb0 <myproc>
8010718f:	85 c0                	test   %eax,%eax
80107191:	0f 85 0c ff ff ff    	jne    801070a3 <trap+0xa3>
80107197:	e9 24 ff ff ff       	jmp    801070c0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010719c:	8b 7b 38             	mov    0x38(%ebx),%edi
8010719f:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801071a3:	e8 e8 cc ff ff       	call   80103e90 <cpuid>
801071a8:	57                   	push   %edi
801071a9:	56                   	push   %esi
801071aa:	50                   	push   %eax
801071ab:	68 0c 91 10 80       	push   $0x8010910c
801071b0:	e8 0b 97 ff ff       	call   801008c0 <cprintf>
    lapiceoi();
801071b5:	e8 f6 bb ff ff       	call   80102db0 <lapiceoi>
    break;
801071ba:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801071bd:	e8 ee cc ff ff       	call   80103eb0 <myproc>
801071c2:	85 c0                	test   %eax,%eax
801071c4:	0f 85 d9 fe ff ff    	jne    801070a3 <trap+0xa3>
801071ca:	e9 f1 fe ff ff       	jmp    801070c0 <trap+0xc0>
801071cf:	90                   	nop
  if(myproc() && myproc()->state == RUNNING &&
801071d0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801071d4:	0f 85 fe fe ff ff    	jne    801070d8 <trap+0xd8>
    yield();
801071da:	e8 61 d2 ff ff       	call   80104440 <yield>
801071df:	e9 f4 fe ff ff       	jmp    801070d8 <trap+0xd8>
801071e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801071e8:	e8 c3 cc ff ff       	call   80103eb0 <myproc>
801071ed:	8b 70 24             	mov    0x24(%eax),%esi
801071f0:	85 f6                	test   %esi,%esi
801071f2:	75 3c                	jne    80107230 <trap+0x230>
    myproc()->tf = tf;
801071f4:	e8 b7 cc ff ff       	call   80103eb0 <myproc>
801071f9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801071fc:	e8 9f eb ff ff       	call   80105da0 <syscall>
    if(myproc()->killed)
80107201:	e8 aa cc ff ff       	call   80103eb0 <myproc>
80107206:	8b 48 24             	mov    0x24(%eax),%ecx
80107209:	85 c9                	test   %ecx,%ecx
8010720b:	0f 84 ed fe ff ff    	je     801070fe <trap+0xfe>
}
80107211:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107214:	5b                   	pop    %ebx
80107215:	5e                   	pop    %esi
80107216:	5f                   	pop    %edi
80107217:	5d                   	pop    %ebp
      exit();
80107218:	e9 e3 d0 ff ff       	jmp    80104300 <exit>
8010721d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80107220:	e8 db d0 ff ff       	call   80104300 <exit>
80107225:	e9 96 fe ff ff       	jmp    801070c0 <trap+0xc0>
8010722a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80107230:	e8 cb d0 ff ff       	call   80104300 <exit>
80107235:	eb bd                	jmp    801071f4 <trap+0x1f4>
80107237:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010723a:	e8 51 cc ff ff       	call   80103e90 <cpuid>
8010723f:	83 ec 0c             	sub    $0xc,%esp
80107242:	56                   	push   %esi
80107243:	57                   	push   %edi
80107244:	50                   	push   %eax
80107245:	ff 73 30             	pushl  0x30(%ebx)
80107248:	68 30 91 10 80       	push   $0x80109130
8010724d:	e8 6e 96 ff ff       	call   801008c0 <cprintf>
      panic("trap");
80107252:	83 c4 14             	add    $0x14,%esp
80107255:	68 04 91 10 80       	push   $0x80109104
8010725a:	e8 31 91 ff ff       	call   80100390 <panic>
8010725f:	90                   	nop

80107260 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80107260:	f3 0f 1e fb          	endbr32 
  if(!uart)
80107264:	a1 bc c5 10 80       	mov    0x8010c5bc,%eax
80107269:	85 c0                	test   %eax,%eax
8010726b:	74 1b                	je     80107288 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010726d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107272:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80107273:	a8 01                	test   $0x1,%al
80107275:	74 11                	je     80107288 <uartgetc+0x28>
80107277:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010727c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010727d:	0f b6 c0             	movzbl %al,%eax
80107280:	c3                   	ret    
80107281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80107288:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010728d:	c3                   	ret    
8010728e:	66 90                	xchg   %ax,%ax

80107290 <uartputc.part.0>:
uartputc(int c)
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	57                   	push   %edi
80107294:	89 c7                	mov    %eax,%edi
80107296:	56                   	push   %esi
80107297:	be fd 03 00 00       	mov    $0x3fd,%esi
8010729c:	53                   	push   %ebx
8010729d:	bb 80 00 00 00       	mov    $0x80,%ebx
801072a2:	83 ec 0c             	sub    $0xc,%esp
801072a5:	eb 1b                	jmp    801072c2 <uartputc.part.0+0x32>
801072a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ae:	66 90                	xchg   %ax,%ax
    microdelay(10);
801072b0:	83 ec 0c             	sub    $0xc,%esp
801072b3:	6a 0a                	push   $0xa
801072b5:	e8 16 bb ff ff       	call   80102dd0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801072ba:	83 c4 10             	add    $0x10,%esp
801072bd:	83 eb 01             	sub    $0x1,%ebx
801072c0:	74 07                	je     801072c9 <uartputc.part.0+0x39>
801072c2:	89 f2                	mov    %esi,%edx
801072c4:	ec                   	in     (%dx),%al
801072c5:	a8 20                	test   $0x20,%al
801072c7:	74 e7                	je     801072b0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801072c9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801072ce:	89 f8                	mov    %edi,%eax
801072d0:	ee                   	out    %al,(%dx)
}
801072d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072d4:	5b                   	pop    %ebx
801072d5:	5e                   	pop    %esi
801072d6:	5f                   	pop    %edi
801072d7:	5d                   	pop    %ebp
801072d8:	c3                   	ret    
801072d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072e0 <uartinit>:
{
801072e0:	f3 0f 1e fb          	endbr32 
801072e4:	55                   	push   %ebp
801072e5:	31 c9                	xor    %ecx,%ecx
801072e7:	89 c8                	mov    %ecx,%eax
801072e9:	89 e5                	mov    %esp,%ebp
801072eb:	57                   	push   %edi
801072ec:	56                   	push   %esi
801072ed:	53                   	push   %ebx
801072ee:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801072f3:	89 da                	mov    %ebx,%edx
801072f5:	83 ec 0c             	sub    $0xc,%esp
801072f8:	ee                   	out    %al,(%dx)
801072f9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801072fe:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80107303:	89 fa                	mov    %edi,%edx
80107305:	ee                   	out    %al,(%dx)
80107306:	b8 0c 00 00 00       	mov    $0xc,%eax
8010730b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107310:	ee                   	out    %al,(%dx)
80107311:	be f9 03 00 00       	mov    $0x3f9,%esi
80107316:	89 c8                	mov    %ecx,%eax
80107318:	89 f2                	mov    %esi,%edx
8010731a:	ee                   	out    %al,(%dx)
8010731b:	b8 03 00 00 00       	mov    $0x3,%eax
80107320:	89 fa                	mov    %edi,%edx
80107322:	ee                   	out    %al,(%dx)
80107323:	ba fc 03 00 00       	mov    $0x3fc,%edx
80107328:	89 c8                	mov    %ecx,%eax
8010732a:	ee                   	out    %al,(%dx)
8010732b:	b8 01 00 00 00       	mov    $0x1,%eax
80107330:	89 f2                	mov    %esi,%edx
80107332:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107333:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107338:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107339:	3c ff                	cmp    $0xff,%al
8010733b:	74 52                	je     8010738f <uartinit+0xaf>
  uart = 1;
8010733d:	c7 05 bc c5 10 80 01 	movl   $0x1,0x8010c5bc
80107344:	00 00 00 
80107347:	89 da                	mov    %ebx,%edx
80107349:	ec                   	in     (%dx),%al
8010734a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010734f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80107350:	83 ec 08             	sub    $0x8,%esp
80107353:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80107358:	bb 28 92 10 80       	mov    $0x80109228,%ebx
  ioapicenable(IRQ_COM1, 0);
8010735d:	6a 00                	push   $0x0
8010735f:	6a 04                	push   $0x4
80107361:	e8 ba b5 ff ff       	call   80102920 <ioapicenable>
80107366:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80107369:	b8 78 00 00 00       	mov    $0x78,%eax
8010736e:	eb 04                	jmp    80107374 <uartinit+0x94>
80107370:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80107374:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
8010737a:	85 d2                	test   %edx,%edx
8010737c:	74 08                	je     80107386 <uartinit+0xa6>
    uartputc(*p);
8010737e:	0f be c0             	movsbl %al,%eax
80107381:	e8 0a ff ff ff       	call   80107290 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80107386:	89 f0                	mov    %esi,%eax
80107388:	83 c3 01             	add    $0x1,%ebx
8010738b:	84 c0                	test   %al,%al
8010738d:	75 e1                	jne    80107370 <uartinit+0x90>
}
8010738f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107392:	5b                   	pop    %ebx
80107393:	5e                   	pop    %esi
80107394:	5f                   	pop    %edi
80107395:	5d                   	pop    %ebp
80107396:	c3                   	ret    
80107397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010739e:	66 90                	xchg   %ax,%ax

801073a0 <uartputc>:
{
801073a0:	f3 0f 1e fb          	endbr32 
801073a4:	55                   	push   %ebp
  if(!uart)
801073a5:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
{
801073ab:	89 e5                	mov    %esp,%ebp
801073ad:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801073b0:	85 d2                	test   %edx,%edx
801073b2:	74 0c                	je     801073c0 <uartputc+0x20>
}
801073b4:	5d                   	pop    %ebp
801073b5:	e9 d6 fe ff ff       	jmp    80107290 <uartputc.part.0>
801073ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073c0:	5d                   	pop    %ebp
801073c1:	c3                   	ret    
801073c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073d0 <uartintr>:

void
uartintr(void)
{
801073d0:	f3 0f 1e fb          	endbr32 
801073d4:	55                   	push   %ebp
801073d5:	89 e5                	mov    %esp,%ebp
801073d7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801073da:	68 60 72 10 80       	push   $0x80107260
801073df:	e8 8c 96 ff ff       	call   80100a70 <consoleintr>
}
801073e4:	83 c4 10             	add    $0x10,%esp
801073e7:	c9                   	leave  
801073e8:	c3                   	ret    

801073e9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801073e9:	6a 00                	push   $0x0
  pushl $0
801073eb:	6a 00                	push   $0x0
  jmp alltraps
801073ed:	e9 2d fb ff ff       	jmp    80106f1f <alltraps>

801073f2 <vector1>:
.globl vector1
vector1:
  pushl $0
801073f2:	6a 00                	push   $0x0
  pushl $1
801073f4:	6a 01                	push   $0x1
  jmp alltraps
801073f6:	e9 24 fb ff ff       	jmp    80106f1f <alltraps>

801073fb <vector2>:
.globl vector2
vector2:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $2
801073fd:	6a 02                	push   $0x2
  jmp alltraps
801073ff:	e9 1b fb ff ff       	jmp    80106f1f <alltraps>

80107404 <vector3>:
.globl vector3
vector3:
  pushl $0
80107404:	6a 00                	push   $0x0
  pushl $3
80107406:	6a 03                	push   $0x3
  jmp alltraps
80107408:	e9 12 fb ff ff       	jmp    80106f1f <alltraps>

8010740d <vector4>:
.globl vector4
vector4:
  pushl $0
8010740d:	6a 00                	push   $0x0
  pushl $4
8010740f:	6a 04                	push   $0x4
  jmp alltraps
80107411:	e9 09 fb ff ff       	jmp    80106f1f <alltraps>

80107416 <vector5>:
.globl vector5
vector5:
  pushl $0
80107416:	6a 00                	push   $0x0
  pushl $5
80107418:	6a 05                	push   $0x5
  jmp alltraps
8010741a:	e9 00 fb ff ff       	jmp    80106f1f <alltraps>

8010741f <vector6>:
.globl vector6
vector6:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $6
80107421:	6a 06                	push   $0x6
  jmp alltraps
80107423:	e9 f7 fa ff ff       	jmp    80106f1f <alltraps>

80107428 <vector7>:
.globl vector7
vector7:
  pushl $0
80107428:	6a 00                	push   $0x0
  pushl $7
8010742a:	6a 07                	push   $0x7
  jmp alltraps
8010742c:	e9 ee fa ff ff       	jmp    80106f1f <alltraps>

80107431 <vector8>:
.globl vector8
vector8:
  pushl $8
80107431:	6a 08                	push   $0x8
  jmp alltraps
80107433:	e9 e7 fa ff ff       	jmp    80106f1f <alltraps>

80107438 <vector9>:
.globl vector9
vector9:
  pushl $0
80107438:	6a 00                	push   $0x0
  pushl $9
8010743a:	6a 09                	push   $0x9
  jmp alltraps
8010743c:	e9 de fa ff ff       	jmp    80106f1f <alltraps>

80107441 <vector10>:
.globl vector10
vector10:
  pushl $10
80107441:	6a 0a                	push   $0xa
  jmp alltraps
80107443:	e9 d7 fa ff ff       	jmp    80106f1f <alltraps>

80107448 <vector11>:
.globl vector11
vector11:
  pushl $11
80107448:	6a 0b                	push   $0xb
  jmp alltraps
8010744a:	e9 d0 fa ff ff       	jmp    80106f1f <alltraps>

8010744f <vector12>:
.globl vector12
vector12:
  pushl $12
8010744f:	6a 0c                	push   $0xc
  jmp alltraps
80107451:	e9 c9 fa ff ff       	jmp    80106f1f <alltraps>

80107456 <vector13>:
.globl vector13
vector13:
  pushl $13
80107456:	6a 0d                	push   $0xd
  jmp alltraps
80107458:	e9 c2 fa ff ff       	jmp    80106f1f <alltraps>

8010745d <vector14>:
.globl vector14
vector14:
  pushl $14
8010745d:	6a 0e                	push   $0xe
  jmp alltraps
8010745f:	e9 bb fa ff ff       	jmp    80106f1f <alltraps>

80107464 <vector15>:
.globl vector15
vector15:
  pushl $0
80107464:	6a 00                	push   $0x0
  pushl $15
80107466:	6a 0f                	push   $0xf
  jmp alltraps
80107468:	e9 b2 fa ff ff       	jmp    80106f1f <alltraps>

8010746d <vector16>:
.globl vector16
vector16:
  pushl $0
8010746d:	6a 00                	push   $0x0
  pushl $16
8010746f:	6a 10                	push   $0x10
  jmp alltraps
80107471:	e9 a9 fa ff ff       	jmp    80106f1f <alltraps>

80107476 <vector17>:
.globl vector17
vector17:
  pushl $17
80107476:	6a 11                	push   $0x11
  jmp alltraps
80107478:	e9 a2 fa ff ff       	jmp    80106f1f <alltraps>

8010747d <vector18>:
.globl vector18
vector18:
  pushl $0
8010747d:	6a 00                	push   $0x0
  pushl $18
8010747f:	6a 12                	push   $0x12
  jmp alltraps
80107481:	e9 99 fa ff ff       	jmp    80106f1f <alltraps>

80107486 <vector19>:
.globl vector19
vector19:
  pushl $0
80107486:	6a 00                	push   $0x0
  pushl $19
80107488:	6a 13                	push   $0x13
  jmp alltraps
8010748a:	e9 90 fa ff ff       	jmp    80106f1f <alltraps>

8010748f <vector20>:
.globl vector20
vector20:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $20
80107491:	6a 14                	push   $0x14
  jmp alltraps
80107493:	e9 87 fa ff ff       	jmp    80106f1f <alltraps>

80107498 <vector21>:
.globl vector21
vector21:
  pushl $0
80107498:	6a 00                	push   $0x0
  pushl $21
8010749a:	6a 15                	push   $0x15
  jmp alltraps
8010749c:	e9 7e fa ff ff       	jmp    80106f1f <alltraps>

801074a1 <vector22>:
.globl vector22
vector22:
  pushl $0
801074a1:	6a 00                	push   $0x0
  pushl $22
801074a3:	6a 16                	push   $0x16
  jmp alltraps
801074a5:	e9 75 fa ff ff       	jmp    80106f1f <alltraps>

801074aa <vector23>:
.globl vector23
vector23:
  pushl $0
801074aa:	6a 00                	push   $0x0
  pushl $23
801074ac:	6a 17                	push   $0x17
  jmp alltraps
801074ae:	e9 6c fa ff ff       	jmp    80106f1f <alltraps>

801074b3 <vector24>:
.globl vector24
vector24:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $24
801074b5:	6a 18                	push   $0x18
  jmp alltraps
801074b7:	e9 63 fa ff ff       	jmp    80106f1f <alltraps>

801074bc <vector25>:
.globl vector25
vector25:
  pushl $0
801074bc:	6a 00                	push   $0x0
  pushl $25
801074be:	6a 19                	push   $0x19
  jmp alltraps
801074c0:	e9 5a fa ff ff       	jmp    80106f1f <alltraps>

801074c5 <vector26>:
.globl vector26
vector26:
  pushl $0
801074c5:	6a 00                	push   $0x0
  pushl $26
801074c7:	6a 1a                	push   $0x1a
  jmp alltraps
801074c9:	e9 51 fa ff ff       	jmp    80106f1f <alltraps>

801074ce <vector27>:
.globl vector27
vector27:
  pushl $0
801074ce:	6a 00                	push   $0x0
  pushl $27
801074d0:	6a 1b                	push   $0x1b
  jmp alltraps
801074d2:	e9 48 fa ff ff       	jmp    80106f1f <alltraps>

801074d7 <vector28>:
.globl vector28
vector28:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $28
801074d9:	6a 1c                	push   $0x1c
  jmp alltraps
801074db:	e9 3f fa ff ff       	jmp    80106f1f <alltraps>

801074e0 <vector29>:
.globl vector29
vector29:
  pushl $0
801074e0:	6a 00                	push   $0x0
  pushl $29
801074e2:	6a 1d                	push   $0x1d
  jmp alltraps
801074e4:	e9 36 fa ff ff       	jmp    80106f1f <alltraps>

801074e9 <vector30>:
.globl vector30
vector30:
  pushl $0
801074e9:	6a 00                	push   $0x0
  pushl $30
801074eb:	6a 1e                	push   $0x1e
  jmp alltraps
801074ed:	e9 2d fa ff ff       	jmp    80106f1f <alltraps>

801074f2 <vector31>:
.globl vector31
vector31:
  pushl $0
801074f2:	6a 00                	push   $0x0
  pushl $31
801074f4:	6a 1f                	push   $0x1f
  jmp alltraps
801074f6:	e9 24 fa ff ff       	jmp    80106f1f <alltraps>

801074fb <vector32>:
.globl vector32
vector32:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $32
801074fd:	6a 20                	push   $0x20
  jmp alltraps
801074ff:	e9 1b fa ff ff       	jmp    80106f1f <alltraps>

80107504 <vector33>:
.globl vector33
vector33:
  pushl $0
80107504:	6a 00                	push   $0x0
  pushl $33
80107506:	6a 21                	push   $0x21
  jmp alltraps
80107508:	e9 12 fa ff ff       	jmp    80106f1f <alltraps>

8010750d <vector34>:
.globl vector34
vector34:
  pushl $0
8010750d:	6a 00                	push   $0x0
  pushl $34
8010750f:	6a 22                	push   $0x22
  jmp alltraps
80107511:	e9 09 fa ff ff       	jmp    80106f1f <alltraps>

80107516 <vector35>:
.globl vector35
vector35:
  pushl $0
80107516:	6a 00                	push   $0x0
  pushl $35
80107518:	6a 23                	push   $0x23
  jmp alltraps
8010751a:	e9 00 fa ff ff       	jmp    80106f1f <alltraps>

8010751f <vector36>:
.globl vector36
vector36:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $36
80107521:	6a 24                	push   $0x24
  jmp alltraps
80107523:	e9 f7 f9 ff ff       	jmp    80106f1f <alltraps>

80107528 <vector37>:
.globl vector37
vector37:
  pushl $0
80107528:	6a 00                	push   $0x0
  pushl $37
8010752a:	6a 25                	push   $0x25
  jmp alltraps
8010752c:	e9 ee f9 ff ff       	jmp    80106f1f <alltraps>

80107531 <vector38>:
.globl vector38
vector38:
  pushl $0
80107531:	6a 00                	push   $0x0
  pushl $38
80107533:	6a 26                	push   $0x26
  jmp alltraps
80107535:	e9 e5 f9 ff ff       	jmp    80106f1f <alltraps>

8010753a <vector39>:
.globl vector39
vector39:
  pushl $0
8010753a:	6a 00                	push   $0x0
  pushl $39
8010753c:	6a 27                	push   $0x27
  jmp alltraps
8010753e:	e9 dc f9 ff ff       	jmp    80106f1f <alltraps>

80107543 <vector40>:
.globl vector40
vector40:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $40
80107545:	6a 28                	push   $0x28
  jmp alltraps
80107547:	e9 d3 f9 ff ff       	jmp    80106f1f <alltraps>

8010754c <vector41>:
.globl vector41
vector41:
  pushl $0
8010754c:	6a 00                	push   $0x0
  pushl $41
8010754e:	6a 29                	push   $0x29
  jmp alltraps
80107550:	e9 ca f9 ff ff       	jmp    80106f1f <alltraps>

80107555 <vector42>:
.globl vector42
vector42:
  pushl $0
80107555:	6a 00                	push   $0x0
  pushl $42
80107557:	6a 2a                	push   $0x2a
  jmp alltraps
80107559:	e9 c1 f9 ff ff       	jmp    80106f1f <alltraps>

8010755e <vector43>:
.globl vector43
vector43:
  pushl $0
8010755e:	6a 00                	push   $0x0
  pushl $43
80107560:	6a 2b                	push   $0x2b
  jmp alltraps
80107562:	e9 b8 f9 ff ff       	jmp    80106f1f <alltraps>

80107567 <vector44>:
.globl vector44
vector44:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $44
80107569:	6a 2c                	push   $0x2c
  jmp alltraps
8010756b:	e9 af f9 ff ff       	jmp    80106f1f <alltraps>

80107570 <vector45>:
.globl vector45
vector45:
  pushl $0
80107570:	6a 00                	push   $0x0
  pushl $45
80107572:	6a 2d                	push   $0x2d
  jmp alltraps
80107574:	e9 a6 f9 ff ff       	jmp    80106f1f <alltraps>

80107579 <vector46>:
.globl vector46
vector46:
  pushl $0
80107579:	6a 00                	push   $0x0
  pushl $46
8010757b:	6a 2e                	push   $0x2e
  jmp alltraps
8010757d:	e9 9d f9 ff ff       	jmp    80106f1f <alltraps>

80107582 <vector47>:
.globl vector47
vector47:
  pushl $0
80107582:	6a 00                	push   $0x0
  pushl $47
80107584:	6a 2f                	push   $0x2f
  jmp alltraps
80107586:	e9 94 f9 ff ff       	jmp    80106f1f <alltraps>

8010758b <vector48>:
.globl vector48
vector48:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $48
8010758d:	6a 30                	push   $0x30
  jmp alltraps
8010758f:	e9 8b f9 ff ff       	jmp    80106f1f <alltraps>

80107594 <vector49>:
.globl vector49
vector49:
  pushl $0
80107594:	6a 00                	push   $0x0
  pushl $49
80107596:	6a 31                	push   $0x31
  jmp alltraps
80107598:	e9 82 f9 ff ff       	jmp    80106f1f <alltraps>

8010759d <vector50>:
.globl vector50
vector50:
  pushl $0
8010759d:	6a 00                	push   $0x0
  pushl $50
8010759f:	6a 32                	push   $0x32
  jmp alltraps
801075a1:	e9 79 f9 ff ff       	jmp    80106f1f <alltraps>

801075a6 <vector51>:
.globl vector51
vector51:
  pushl $0
801075a6:	6a 00                	push   $0x0
  pushl $51
801075a8:	6a 33                	push   $0x33
  jmp alltraps
801075aa:	e9 70 f9 ff ff       	jmp    80106f1f <alltraps>

801075af <vector52>:
.globl vector52
vector52:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $52
801075b1:	6a 34                	push   $0x34
  jmp alltraps
801075b3:	e9 67 f9 ff ff       	jmp    80106f1f <alltraps>

801075b8 <vector53>:
.globl vector53
vector53:
  pushl $0
801075b8:	6a 00                	push   $0x0
  pushl $53
801075ba:	6a 35                	push   $0x35
  jmp alltraps
801075bc:	e9 5e f9 ff ff       	jmp    80106f1f <alltraps>

801075c1 <vector54>:
.globl vector54
vector54:
  pushl $0
801075c1:	6a 00                	push   $0x0
  pushl $54
801075c3:	6a 36                	push   $0x36
  jmp alltraps
801075c5:	e9 55 f9 ff ff       	jmp    80106f1f <alltraps>

801075ca <vector55>:
.globl vector55
vector55:
  pushl $0
801075ca:	6a 00                	push   $0x0
  pushl $55
801075cc:	6a 37                	push   $0x37
  jmp alltraps
801075ce:	e9 4c f9 ff ff       	jmp    80106f1f <alltraps>

801075d3 <vector56>:
.globl vector56
vector56:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $56
801075d5:	6a 38                	push   $0x38
  jmp alltraps
801075d7:	e9 43 f9 ff ff       	jmp    80106f1f <alltraps>

801075dc <vector57>:
.globl vector57
vector57:
  pushl $0
801075dc:	6a 00                	push   $0x0
  pushl $57
801075de:	6a 39                	push   $0x39
  jmp alltraps
801075e0:	e9 3a f9 ff ff       	jmp    80106f1f <alltraps>

801075e5 <vector58>:
.globl vector58
vector58:
  pushl $0
801075e5:	6a 00                	push   $0x0
  pushl $58
801075e7:	6a 3a                	push   $0x3a
  jmp alltraps
801075e9:	e9 31 f9 ff ff       	jmp    80106f1f <alltraps>

801075ee <vector59>:
.globl vector59
vector59:
  pushl $0
801075ee:	6a 00                	push   $0x0
  pushl $59
801075f0:	6a 3b                	push   $0x3b
  jmp alltraps
801075f2:	e9 28 f9 ff ff       	jmp    80106f1f <alltraps>

801075f7 <vector60>:
.globl vector60
vector60:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $60
801075f9:	6a 3c                	push   $0x3c
  jmp alltraps
801075fb:	e9 1f f9 ff ff       	jmp    80106f1f <alltraps>

80107600 <vector61>:
.globl vector61
vector61:
  pushl $0
80107600:	6a 00                	push   $0x0
  pushl $61
80107602:	6a 3d                	push   $0x3d
  jmp alltraps
80107604:	e9 16 f9 ff ff       	jmp    80106f1f <alltraps>

80107609 <vector62>:
.globl vector62
vector62:
  pushl $0
80107609:	6a 00                	push   $0x0
  pushl $62
8010760b:	6a 3e                	push   $0x3e
  jmp alltraps
8010760d:	e9 0d f9 ff ff       	jmp    80106f1f <alltraps>

80107612 <vector63>:
.globl vector63
vector63:
  pushl $0
80107612:	6a 00                	push   $0x0
  pushl $63
80107614:	6a 3f                	push   $0x3f
  jmp alltraps
80107616:	e9 04 f9 ff ff       	jmp    80106f1f <alltraps>

8010761b <vector64>:
.globl vector64
vector64:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $64
8010761d:	6a 40                	push   $0x40
  jmp alltraps
8010761f:	e9 fb f8 ff ff       	jmp    80106f1f <alltraps>

80107624 <vector65>:
.globl vector65
vector65:
  pushl $0
80107624:	6a 00                	push   $0x0
  pushl $65
80107626:	6a 41                	push   $0x41
  jmp alltraps
80107628:	e9 f2 f8 ff ff       	jmp    80106f1f <alltraps>

8010762d <vector66>:
.globl vector66
vector66:
  pushl $0
8010762d:	6a 00                	push   $0x0
  pushl $66
8010762f:	6a 42                	push   $0x42
  jmp alltraps
80107631:	e9 e9 f8 ff ff       	jmp    80106f1f <alltraps>

80107636 <vector67>:
.globl vector67
vector67:
  pushl $0
80107636:	6a 00                	push   $0x0
  pushl $67
80107638:	6a 43                	push   $0x43
  jmp alltraps
8010763a:	e9 e0 f8 ff ff       	jmp    80106f1f <alltraps>

8010763f <vector68>:
.globl vector68
vector68:
  pushl $0
8010763f:	6a 00                	push   $0x0
  pushl $68
80107641:	6a 44                	push   $0x44
  jmp alltraps
80107643:	e9 d7 f8 ff ff       	jmp    80106f1f <alltraps>

80107648 <vector69>:
.globl vector69
vector69:
  pushl $0
80107648:	6a 00                	push   $0x0
  pushl $69
8010764a:	6a 45                	push   $0x45
  jmp alltraps
8010764c:	e9 ce f8 ff ff       	jmp    80106f1f <alltraps>

80107651 <vector70>:
.globl vector70
vector70:
  pushl $0
80107651:	6a 00                	push   $0x0
  pushl $70
80107653:	6a 46                	push   $0x46
  jmp alltraps
80107655:	e9 c5 f8 ff ff       	jmp    80106f1f <alltraps>

8010765a <vector71>:
.globl vector71
vector71:
  pushl $0
8010765a:	6a 00                	push   $0x0
  pushl $71
8010765c:	6a 47                	push   $0x47
  jmp alltraps
8010765e:	e9 bc f8 ff ff       	jmp    80106f1f <alltraps>

80107663 <vector72>:
.globl vector72
vector72:
  pushl $0
80107663:	6a 00                	push   $0x0
  pushl $72
80107665:	6a 48                	push   $0x48
  jmp alltraps
80107667:	e9 b3 f8 ff ff       	jmp    80106f1f <alltraps>

8010766c <vector73>:
.globl vector73
vector73:
  pushl $0
8010766c:	6a 00                	push   $0x0
  pushl $73
8010766e:	6a 49                	push   $0x49
  jmp alltraps
80107670:	e9 aa f8 ff ff       	jmp    80106f1f <alltraps>

80107675 <vector74>:
.globl vector74
vector74:
  pushl $0
80107675:	6a 00                	push   $0x0
  pushl $74
80107677:	6a 4a                	push   $0x4a
  jmp alltraps
80107679:	e9 a1 f8 ff ff       	jmp    80106f1f <alltraps>

8010767e <vector75>:
.globl vector75
vector75:
  pushl $0
8010767e:	6a 00                	push   $0x0
  pushl $75
80107680:	6a 4b                	push   $0x4b
  jmp alltraps
80107682:	e9 98 f8 ff ff       	jmp    80106f1f <alltraps>

80107687 <vector76>:
.globl vector76
vector76:
  pushl $0
80107687:	6a 00                	push   $0x0
  pushl $76
80107689:	6a 4c                	push   $0x4c
  jmp alltraps
8010768b:	e9 8f f8 ff ff       	jmp    80106f1f <alltraps>

80107690 <vector77>:
.globl vector77
vector77:
  pushl $0
80107690:	6a 00                	push   $0x0
  pushl $77
80107692:	6a 4d                	push   $0x4d
  jmp alltraps
80107694:	e9 86 f8 ff ff       	jmp    80106f1f <alltraps>

80107699 <vector78>:
.globl vector78
vector78:
  pushl $0
80107699:	6a 00                	push   $0x0
  pushl $78
8010769b:	6a 4e                	push   $0x4e
  jmp alltraps
8010769d:	e9 7d f8 ff ff       	jmp    80106f1f <alltraps>

801076a2 <vector79>:
.globl vector79
vector79:
  pushl $0
801076a2:	6a 00                	push   $0x0
  pushl $79
801076a4:	6a 4f                	push   $0x4f
  jmp alltraps
801076a6:	e9 74 f8 ff ff       	jmp    80106f1f <alltraps>

801076ab <vector80>:
.globl vector80
vector80:
  pushl $0
801076ab:	6a 00                	push   $0x0
  pushl $80
801076ad:	6a 50                	push   $0x50
  jmp alltraps
801076af:	e9 6b f8 ff ff       	jmp    80106f1f <alltraps>

801076b4 <vector81>:
.globl vector81
vector81:
  pushl $0
801076b4:	6a 00                	push   $0x0
  pushl $81
801076b6:	6a 51                	push   $0x51
  jmp alltraps
801076b8:	e9 62 f8 ff ff       	jmp    80106f1f <alltraps>

801076bd <vector82>:
.globl vector82
vector82:
  pushl $0
801076bd:	6a 00                	push   $0x0
  pushl $82
801076bf:	6a 52                	push   $0x52
  jmp alltraps
801076c1:	e9 59 f8 ff ff       	jmp    80106f1f <alltraps>

801076c6 <vector83>:
.globl vector83
vector83:
  pushl $0
801076c6:	6a 00                	push   $0x0
  pushl $83
801076c8:	6a 53                	push   $0x53
  jmp alltraps
801076ca:	e9 50 f8 ff ff       	jmp    80106f1f <alltraps>

801076cf <vector84>:
.globl vector84
vector84:
  pushl $0
801076cf:	6a 00                	push   $0x0
  pushl $84
801076d1:	6a 54                	push   $0x54
  jmp alltraps
801076d3:	e9 47 f8 ff ff       	jmp    80106f1f <alltraps>

801076d8 <vector85>:
.globl vector85
vector85:
  pushl $0
801076d8:	6a 00                	push   $0x0
  pushl $85
801076da:	6a 55                	push   $0x55
  jmp alltraps
801076dc:	e9 3e f8 ff ff       	jmp    80106f1f <alltraps>

801076e1 <vector86>:
.globl vector86
vector86:
  pushl $0
801076e1:	6a 00                	push   $0x0
  pushl $86
801076e3:	6a 56                	push   $0x56
  jmp alltraps
801076e5:	e9 35 f8 ff ff       	jmp    80106f1f <alltraps>

801076ea <vector87>:
.globl vector87
vector87:
  pushl $0
801076ea:	6a 00                	push   $0x0
  pushl $87
801076ec:	6a 57                	push   $0x57
  jmp alltraps
801076ee:	e9 2c f8 ff ff       	jmp    80106f1f <alltraps>

801076f3 <vector88>:
.globl vector88
vector88:
  pushl $0
801076f3:	6a 00                	push   $0x0
  pushl $88
801076f5:	6a 58                	push   $0x58
  jmp alltraps
801076f7:	e9 23 f8 ff ff       	jmp    80106f1f <alltraps>

801076fc <vector89>:
.globl vector89
vector89:
  pushl $0
801076fc:	6a 00                	push   $0x0
  pushl $89
801076fe:	6a 59                	push   $0x59
  jmp alltraps
80107700:	e9 1a f8 ff ff       	jmp    80106f1f <alltraps>

80107705 <vector90>:
.globl vector90
vector90:
  pushl $0
80107705:	6a 00                	push   $0x0
  pushl $90
80107707:	6a 5a                	push   $0x5a
  jmp alltraps
80107709:	e9 11 f8 ff ff       	jmp    80106f1f <alltraps>

8010770e <vector91>:
.globl vector91
vector91:
  pushl $0
8010770e:	6a 00                	push   $0x0
  pushl $91
80107710:	6a 5b                	push   $0x5b
  jmp alltraps
80107712:	e9 08 f8 ff ff       	jmp    80106f1f <alltraps>

80107717 <vector92>:
.globl vector92
vector92:
  pushl $0
80107717:	6a 00                	push   $0x0
  pushl $92
80107719:	6a 5c                	push   $0x5c
  jmp alltraps
8010771b:	e9 ff f7 ff ff       	jmp    80106f1f <alltraps>

80107720 <vector93>:
.globl vector93
vector93:
  pushl $0
80107720:	6a 00                	push   $0x0
  pushl $93
80107722:	6a 5d                	push   $0x5d
  jmp alltraps
80107724:	e9 f6 f7 ff ff       	jmp    80106f1f <alltraps>

80107729 <vector94>:
.globl vector94
vector94:
  pushl $0
80107729:	6a 00                	push   $0x0
  pushl $94
8010772b:	6a 5e                	push   $0x5e
  jmp alltraps
8010772d:	e9 ed f7 ff ff       	jmp    80106f1f <alltraps>

80107732 <vector95>:
.globl vector95
vector95:
  pushl $0
80107732:	6a 00                	push   $0x0
  pushl $95
80107734:	6a 5f                	push   $0x5f
  jmp alltraps
80107736:	e9 e4 f7 ff ff       	jmp    80106f1f <alltraps>

8010773b <vector96>:
.globl vector96
vector96:
  pushl $0
8010773b:	6a 00                	push   $0x0
  pushl $96
8010773d:	6a 60                	push   $0x60
  jmp alltraps
8010773f:	e9 db f7 ff ff       	jmp    80106f1f <alltraps>

80107744 <vector97>:
.globl vector97
vector97:
  pushl $0
80107744:	6a 00                	push   $0x0
  pushl $97
80107746:	6a 61                	push   $0x61
  jmp alltraps
80107748:	e9 d2 f7 ff ff       	jmp    80106f1f <alltraps>

8010774d <vector98>:
.globl vector98
vector98:
  pushl $0
8010774d:	6a 00                	push   $0x0
  pushl $98
8010774f:	6a 62                	push   $0x62
  jmp alltraps
80107751:	e9 c9 f7 ff ff       	jmp    80106f1f <alltraps>

80107756 <vector99>:
.globl vector99
vector99:
  pushl $0
80107756:	6a 00                	push   $0x0
  pushl $99
80107758:	6a 63                	push   $0x63
  jmp alltraps
8010775a:	e9 c0 f7 ff ff       	jmp    80106f1f <alltraps>

8010775f <vector100>:
.globl vector100
vector100:
  pushl $0
8010775f:	6a 00                	push   $0x0
  pushl $100
80107761:	6a 64                	push   $0x64
  jmp alltraps
80107763:	e9 b7 f7 ff ff       	jmp    80106f1f <alltraps>

80107768 <vector101>:
.globl vector101
vector101:
  pushl $0
80107768:	6a 00                	push   $0x0
  pushl $101
8010776a:	6a 65                	push   $0x65
  jmp alltraps
8010776c:	e9 ae f7 ff ff       	jmp    80106f1f <alltraps>

80107771 <vector102>:
.globl vector102
vector102:
  pushl $0
80107771:	6a 00                	push   $0x0
  pushl $102
80107773:	6a 66                	push   $0x66
  jmp alltraps
80107775:	e9 a5 f7 ff ff       	jmp    80106f1f <alltraps>

8010777a <vector103>:
.globl vector103
vector103:
  pushl $0
8010777a:	6a 00                	push   $0x0
  pushl $103
8010777c:	6a 67                	push   $0x67
  jmp alltraps
8010777e:	e9 9c f7 ff ff       	jmp    80106f1f <alltraps>

80107783 <vector104>:
.globl vector104
vector104:
  pushl $0
80107783:	6a 00                	push   $0x0
  pushl $104
80107785:	6a 68                	push   $0x68
  jmp alltraps
80107787:	e9 93 f7 ff ff       	jmp    80106f1f <alltraps>

8010778c <vector105>:
.globl vector105
vector105:
  pushl $0
8010778c:	6a 00                	push   $0x0
  pushl $105
8010778e:	6a 69                	push   $0x69
  jmp alltraps
80107790:	e9 8a f7 ff ff       	jmp    80106f1f <alltraps>

80107795 <vector106>:
.globl vector106
vector106:
  pushl $0
80107795:	6a 00                	push   $0x0
  pushl $106
80107797:	6a 6a                	push   $0x6a
  jmp alltraps
80107799:	e9 81 f7 ff ff       	jmp    80106f1f <alltraps>

8010779e <vector107>:
.globl vector107
vector107:
  pushl $0
8010779e:	6a 00                	push   $0x0
  pushl $107
801077a0:	6a 6b                	push   $0x6b
  jmp alltraps
801077a2:	e9 78 f7 ff ff       	jmp    80106f1f <alltraps>

801077a7 <vector108>:
.globl vector108
vector108:
  pushl $0
801077a7:	6a 00                	push   $0x0
  pushl $108
801077a9:	6a 6c                	push   $0x6c
  jmp alltraps
801077ab:	e9 6f f7 ff ff       	jmp    80106f1f <alltraps>

801077b0 <vector109>:
.globl vector109
vector109:
  pushl $0
801077b0:	6a 00                	push   $0x0
  pushl $109
801077b2:	6a 6d                	push   $0x6d
  jmp alltraps
801077b4:	e9 66 f7 ff ff       	jmp    80106f1f <alltraps>

801077b9 <vector110>:
.globl vector110
vector110:
  pushl $0
801077b9:	6a 00                	push   $0x0
  pushl $110
801077bb:	6a 6e                	push   $0x6e
  jmp alltraps
801077bd:	e9 5d f7 ff ff       	jmp    80106f1f <alltraps>

801077c2 <vector111>:
.globl vector111
vector111:
  pushl $0
801077c2:	6a 00                	push   $0x0
  pushl $111
801077c4:	6a 6f                	push   $0x6f
  jmp alltraps
801077c6:	e9 54 f7 ff ff       	jmp    80106f1f <alltraps>

801077cb <vector112>:
.globl vector112
vector112:
  pushl $0
801077cb:	6a 00                	push   $0x0
  pushl $112
801077cd:	6a 70                	push   $0x70
  jmp alltraps
801077cf:	e9 4b f7 ff ff       	jmp    80106f1f <alltraps>

801077d4 <vector113>:
.globl vector113
vector113:
  pushl $0
801077d4:	6a 00                	push   $0x0
  pushl $113
801077d6:	6a 71                	push   $0x71
  jmp alltraps
801077d8:	e9 42 f7 ff ff       	jmp    80106f1f <alltraps>

801077dd <vector114>:
.globl vector114
vector114:
  pushl $0
801077dd:	6a 00                	push   $0x0
  pushl $114
801077df:	6a 72                	push   $0x72
  jmp alltraps
801077e1:	e9 39 f7 ff ff       	jmp    80106f1f <alltraps>

801077e6 <vector115>:
.globl vector115
vector115:
  pushl $0
801077e6:	6a 00                	push   $0x0
  pushl $115
801077e8:	6a 73                	push   $0x73
  jmp alltraps
801077ea:	e9 30 f7 ff ff       	jmp    80106f1f <alltraps>

801077ef <vector116>:
.globl vector116
vector116:
  pushl $0
801077ef:	6a 00                	push   $0x0
  pushl $116
801077f1:	6a 74                	push   $0x74
  jmp alltraps
801077f3:	e9 27 f7 ff ff       	jmp    80106f1f <alltraps>

801077f8 <vector117>:
.globl vector117
vector117:
  pushl $0
801077f8:	6a 00                	push   $0x0
  pushl $117
801077fa:	6a 75                	push   $0x75
  jmp alltraps
801077fc:	e9 1e f7 ff ff       	jmp    80106f1f <alltraps>

80107801 <vector118>:
.globl vector118
vector118:
  pushl $0
80107801:	6a 00                	push   $0x0
  pushl $118
80107803:	6a 76                	push   $0x76
  jmp alltraps
80107805:	e9 15 f7 ff ff       	jmp    80106f1f <alltraps>

8010780a <vector119>:
.globl vector119
vector119:
  pushl $0
8010780a:	6a 00                	push   $0x0
  pushl $119
8010780c:	6a 77                	push   $0x77
  jmp alltraps
8010780e:	e9 0c f7 ff ff       	jmp    80106f1f <alltraps>

80107813 <vector120>:
.globl vector120
vector120:
  pushl $0
80107813:	6a 00                	push   $0x0
  pushl $120
80107815:	6a 78                	push   $0x78
  jmp alltraps
80107817:	e9 03 f7 ff ff       	jmp    80106f1f <alltraps>

8010781c <vector121>:
.globl vector121
vector121:
  pushl $0
8010781c:	6a 00                	push   $0x0
  pushl $121
8010781e:	6a 79                	push   $0x79
  jmp alltraps
80107820:	e9 fa f6 ff ff       	jmp    80106f1f <alltraps>

80107825 <vector122>:
.globl vector122
vector122:
  pushl $0
80107825:	6a 00                	push   $0x0
  pushl $122
80107827:	6a 7a                	push   $0x7a
  jmp alltraps
80107829:	e9 f1 f6 ff ff       	jmp    80106f1f <alltraps>

8010782e <vector123>:
.globl vector123
vector123:
  pushl $0
8010782e:	6a 00                	push   $0x0
  pushl $123
80107830:	6a 7b                	push   $0x7b
  jmp alltraps
80107832:	e9 e8 f6 ff ff       	jmp    80106f1f <alltraps>

80107837 <vector124>:
.globl vector124
vector124:
  pushl $0
80107837:	6a 00                	push   $0x0
  pushl $124
80107839:	6a 7c                	push   $0x7c
  jmp alltraps
8010783b:	e9 df f6 ff ff       	jmp    80106f1f <alltraps>

80107840 <vector125>:
.globl vector125
vector125:
  pushl $0
80107840:	6a 00                	push   $0x0
  pushl $125
80107842:	6a 7d                	push   $0x7d
  jmp alltraps
80107844:	e9 d6 f6 ff ff       	jmp    80106f1f <alltraps>

80107849 <vector126>:
.globl vector126
vector126:
  pushl $0
80107849:	6a 00                	push   $0x0
  pushl $126
8010784b:	6a 7e                	push   $0x7e
  jmp alltraps
8010784d:	e9 cd f6 ff ff       	jmp    80106f1f <alltraps>

80107852 <vector127>:
.globl vector127
vector127:
  pushl $0
80107852:	6a 00                	push   $0x0
  pushl $127
80107854:	6a 7f                	push   $0x7f
  jmp alltraps
80107856:	e9 c4 f6 ff ff       	jmp    80106f1f <alltraps>

8010785b <vector128>:
.globl vector128
vector128:
  pushl $0
8010785b:	6a 00                	push   $0x0
  pushl $128
8010785d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107862:	e9 b8 f6 ff ff       	jmp    80106f1f <alltraps>

80107867 <vector129>:
.globl vector129
vector129:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $129
80107869:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010786e:	e9 ac f6 ff ff       	jmp    80106f1f <alltraps>

80107873 <vector130>:
.globl vector130
vector130:
  pushl $0
80107873:	6a 00                	push   $0x0
  pushl $130
80107875:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010787a:	e9 a0 f6 ff ff       	jmp    80106f1f <alltraps>

8010787f <vector131>:
.globl vector131
vector131:
  pushl $0
8010787f:	6a 00                	push   $0x0
  pushl $131
80107881:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107886:	e9 94 f6 ff ff       	jmp    80106f1f <alltraps>

8010788b <vector132>:
.globl vector132
vector132:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $132
8010788d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107892:	e9 88 f6 ff ff       	jmp    80106f1f <alltraps>

80107897 <vector133>:
.globl vector133
vector133:
  pushl $0
80107897:	6a 00                	push   $0x0
  pushl $133
80107899:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010789e:	e9 7c f6 ff ff       	jmp    80106f1f <alltraps>

801078a3 <vector134>:
.globl vector134
vector134:
  pushl $0
801078a3:	6a 00                	push   $0x0
  pushl $134
801078a5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801078aa:	e9 70 f6 ff ff       	jmp    80106f1f <alltraps>

801078af <vector135>:
.globl vector135
vector135:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $135
801078b1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801078b6:	e9 64 f6 ff ff       	jmp    80106f1f <alltraps>

801078bb <vector136>:
.globl vector136
vector136:
  pushl $0
801078bb:	6a 00                	push   $0x0
  pushl $136
801078bd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801078c2:	e9 58 f6 ff ff       	jmp    80106f1f <alltraps>

801078c7 <vector137>:
.globl vector137
vector137:
  pushl $0
801078c7:	6a 00                	push   $0x0
  pushl $137
801078c9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801078ce:	e9 4c f6 ff ff       	jmp    80106f1f <alltraps>

801078d3 <vector138>:
.globl vector138
vector138:
  pushl $0
801078d3:	6a 00                	push   $0x0
  pushl $138
801078d5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801078da:	e9 40 f6 ff ff       	jmp    80106f1f <alltraps>

801078df <vector139>:
.globl vector139
vector139:
  pushl $0
801078df:	6a 00                	push   $0x0
  pushl $139
801078e1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801078e6:	e9 34 f6 ff ff       	jmp    80106f1f <alltraps>

801078eb <vector140>:
.globl vector140
vector140:
  pushl $0
801078eb:	6a 00                	push   $0x0
  pushl $140
801078ed:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801078f2:	e9 28 f6 ff ff       	jmp    80106f1f <alltraps>

801078f7 <vector141>:
.globl vector141
vector141:
  pushl $0
801078f7:	6a 00                	push   $0x0
  pushl $141
801078f9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801078fe:	e9 1c f6 ff ff       	jmp    80106f1f <alltraps>

80107903 <vector142>:
.globl vector142
vector142:
  pushl $0
80107903:	6a 00                	push   $0x0
  pushl $142
80107905:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010790a:	e9 10 f6 ff ff       	jmp    80106f1f <alltraps>

8010790f <vector143>:
.globl vector143
vector143:
  pushl $0
8010790f:	6a 00                	push   $0x0
  pushl $143
80107911:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107916:	e9 04 f6 ff ff       	jmp    80106f1f <alltraps>

8010791b <vector144>:
.globl vector144
vector144:
  pushl $0
8010791b:	6a 00                	push   $0x0
  pushl $144
8010791d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107922:	e9 f8 f5 ff ff       	jmp    80106f1f <alltraps>

80107927 <vector145>:
.globl vector145
vector145:
  pushl $0
80107927:	6a 00                	push   $0x0
  pushl $145
80107929:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010792e:	e9 ec f5 ff ff       	jmp    80106f1f <alltraps>

80107933 <vector146>:
.globl vector146
vector146:
  pushl $0
80107933:	6a 00                	push   $0x0
  pushl $146
80107935:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010793a:	e9 e0 f5 ff ff       	jmp    80106f1f <alltraps>

8010793f <vector147>:
.globl vector147
vector147:
  pushl $0
8010793f:	6a 00                	push   $0x0
  pushl $147
80107941:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107946:	e9 d4 f5 ff ff       	jmp    80106f1f <alltraps>

8010794b <vector148>:
.globl vector148
vector148:
  pushl $0
8010794b:	6a 00                	push   $0x0
  pushl $148
8010794d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107952:	e9 c8 f5 ff ff       	jmp    80106f1f <alltraps>

80107957 <vector149>:
.globl vector149
vector149:
  pushl $0
80107957:	6a 00                	push   $0x0
  pushl $149
80107959:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010795e:	e9 bc f5 ff ff       	jmp    80106f1f <alltraps>

80107963 <vector150>:
.globl vector150
vector150:
  pushl $0
80107963:	6a 00                	push   $0x0
  pushl $150
80107965:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010796a:	e9 b0 f5 ff ff       	jmp    80106f1f <alltraps>

8010796f <vector151>:
.globl vector151
vector151:
  pushl $0
8010796f:	6a 00                	push   $0x0
  pushl $151
80107971:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107976:	e9 a4 f5 ff ff       	jmp    80106f1f <alltraps>

8010797b <vector152>:
.globl vector152
vector152:
  pushl $0
8010797b:	6a 00                	push   $0x0
  pushl $152
8010797d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107982:	e9 98 f5 ff ff       	jmp    80106f1f <alltraps>

80107987 <vector153>:
.globl vector153
vector153:
  pushl $0
80107987:	6a 00                	push   $0x0
  pushl $153
80107989:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010798e:	e9 8c f5 ff ff       	jmp    80106f1f <alltraps>

80107993 <vector154>:
.globl vector154
vector154:
  pushl $0
80107993:	6a 00                	push   $0x0
  pushl $154
80107995:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010799a:	e9 80 f5 ff ff       	jmp    80106f1f <alltraps>

8010799f <vector155>:
.globl vector155
vector155:
  pushl $0
8010799f:	6a 00                	push   $0x0
  pushl $155
801079a1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801079a6:	e9 74 f5 ff ff       	jmp    80106f1f <alltraps>

801079ab <vector156>:
.globl vector156
vector156:
  pushl $0
801079ab:	6a 00                	push   $0x0
  pushl $156
801079ad:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801079b2:	e9 68 f5 ff ff       	jmp    80106f1f <alltraps>

801079b7 <vector157>:
.globl vector157
vector157:
  pushl $0
801079b7:	6a 00                	push   $0x0
  pushl $157
801079b9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801079be:	e9 5c f5 ff ff       	jmp    80106f1f <alltraps>

801079c3 <vector158>:
.globl vector158
vector158:
  pushl $0
801079c3:	6a 00                	push   $0x0
  pushl $158
801079c5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801079ca:	e9 50 f5 ff ff       	jmp    80106f1f <alltraps>

801079cf <vector159>:
.globl vector159
vector159:
  pushl $0
801079cf:	6a 00                	push   $0x0
  pushl $159
801079d1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801079d6:	e9 44 f5 ff ff       	jmp    80106f1f <alltraps>

801079db <vector160>:
.globl vector160
vector160:
  pushl $0
801079db:	6a 00                	push   $0x0
  pushl $160
801079dd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801079e2:	e9 38 f5 ff ff       	jmp    80106f1f <alltraps>

801079e7 <vector161>:
.globl vector161
vector161:
  pushl $0
801079e7:	6a 00                	push   $0x0
  pushl $161
801079e9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801079ee:	e9 2c f5 ff ff       	jmp    80106f1f <alltraps>

801079f3 <vector162>:
.globl vector162
vector162:
  pushl $0
801079f3:	6a 00                	push   $0x0
  pushl $162
801079f5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801079fa:	e9 20 f5 ff ff       	jmp    80106f1f <alltraps>

801079ff <vector163>:
.globl vector163
vector163:
  pushl $0
801079ff:	6a 00                	push   $0x0
  pushl $163
80107a01:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107a06:	e9 14 f5 ff ff       	jmp    80106f1f <alltraps>

80107a0b <vector164>:
.globl vector164
vector164:
  pushl $0
80107a0b:	6a 00                	push   $0x0
  pushl $164
80107a0d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107a12:	e9 08 f5 ff ff       	jmp    80106f1f <alltraps>

80107a17 <vector165>:
.globl vector165
vector165:
  pushl $0
80107a17:	6a 00                	push   $0x0
  pushl $165
80107a19:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107a1e:	e9 fc f4 ff ff       	jmp    80106f1f <alltraps>

80107a23 <vector166>:
.globl vector166
vector166:
  pushl $0
80107a23:	6a 00                	push   $0x0
  pushl $166
80107a25:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107a2a:	e9 f0 f4 ff ff       	jmp    80106f1f <alltraps>

80107a2f <vector167>:
.globl vector167
vector167:
  pushl $0
80107a2f:	6a 00                	push   $0x0
  pushl $167
80107a31:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107a36:	e9 e4 f4 ff ff       	jmp    80106f1f <alltraps>

80107a3b <vector168>:
.globl vector168
vector168:
  pushl $0
80107a3b:	6a 00                	push   $0x0
  pushl $168
80107a3d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107a42:	e9 d8 f4 ff ff       	jmp    80106f1f <alltraps>

80107a47 <vector169>:
.globl vector169
vector169:
  pushl $0
80107a47:	6a 00                	push   $0x0
  pushl $169
80107a49:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107a4e:	e9 cc f4 ff ff       	jmp    80106f1f <alltraps>

80107a53 <vector170>:
.globl vector170
vector170:
  pushl $0
80107a53:	6a 00                	push   $0x0
  pushl $170
80107a55:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107a5a:	e9 c0 f4 ff ff       	jmp    80106f1f <alltraps>

80107a5f <vector171>:
.globl vector171
vector171:
  pushl $0
80107a5f:	6a 00                	push   $0x0
  pushl $171
80107a61:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107a66:	e9 b4 f4 ff ff       	jmp    80106f1f <alltraps>

80107a6b <vector172>:
.globl vector172
vector172:
  pushl $0
80107a6b:	6a 00                	push   $0x0
  pushl $172
80107a6d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107a72:	e9 a8 f4 ff ff       	jmp    80106f1f <alltraps>

80107a77 <vector173>:
.globl vector173
vector173:
  pushl $0
80107a77:	6a 00                	push   $0x0
  pushl $173
80107a79:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107a7e:	e9 9c f4 ff ff       	jmp    80106f1f <alltraps>

80107a83 <vector174>:
.globl vector174
vector174:
  pushl $0
80107a83:	6a 00                	push   $0x0
  pushl $174
80107a85:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107a8a:	e9 90 f4 ff ff       	jmp    80106f1f <alltraps>

80107a8f <vector175>:
.globl vector175
vector175:
  pushl $0
80107a8f:	6a 00                	push   $0x0
  pushl $175
80107a91:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107a96:	e9 84 f4 ff ff       	jmp    80106f1f <alltraps>

80107a9b <vector176>:
.globl vector176
vector176:
  pushl $0
80107a9b:	6a 00                	push   $0x0
  pushl $176
80107a9d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107aa2:	e9 78 f4 ff ff       	jmp    80106f1f <alltraps>

80107aa7 <vector177>:
.globl vector177
vector177:
  pushl $0
80107aa7:	6a 00                	push   $0x0
  pushl $177
80107aa9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107aae:	e9 6c f4 ff ff       	jmp    80106f1f <alltraps>

80107ab3 <vector178>:
.globl vector178
vector178:
  pushl $0
80107ab3:	6a 00                	push   $0x0
  pushl $178
80107ab5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107aba:	e9 60 f4 ff ff       	jmp    80106f1f <alltraps>

80107abf <vector179>:
.globl vector179
vector179:
  pushl $0
80107abf:	6a 00                	push   $0x0
  pushl $179
80107ac1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107ac6:	e9 54 f4 ff ff       	jmp    80106f1f <alltraps>

80107acb <vector180>:
.globl vector180
vector180:
  pushl $0
80107acb:	6a 00                	push   $0x0
  pushl $180
80107acd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107ad2:	e9 48 f4 ff ff       	jmp    80106f1f <alltraps>

80107ad7 <vector181>:
.globl vector181
vector181:
  pushl $0
80107ad7:	6a 00                	push   $0x0
  pushl $181
80107ad9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107ade:	e9 3c f4 ff ff       	jmp    80106f1f <alltraps>

80107ae3 <vector182>:
.globl vector182
vector182:
  pushl $0
80107ae3:	6a 00                	push   $0x0
  pushl $182
80107ae5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107aea:	e9 30 f4 ff ff       	jmp    80106f1f <alltraps>

80107aef <vector183>:
.globl vector183
vector183:
  pushl $0
80107aef:	6a 00                	push   $0x0
  pushl $183
80107af1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107af6:	e9 24 f4 ff ff       	jmp    80106f1f <alltraps>

80107afb <vector184>:
.globl vector184
vector184:
  pushl $0
80107afb:	6a 00                	push   $0x0
  pushl $184
80107afd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107b02:	e9 18 f4 ff ff       	jmp    80106f1f <alltraps>

80107b07 <vector185>:
.globl vector185
vector185:
  pushl $0
80107b07:	6a 00                	push   $0x0
  pushl $185
80107b09:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107b0e:	e9 0c f4 ff ff       	jmp    80106f1f <alltraps>

80107b13 <vector186>:
.globl vector186
vector186:
  pushl $0
80107b13:	6a 00                	push   $0x0
  pushl $186
80107b15:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107b1a:	e9 00 f4 ff ff       	jmp    80106f1f <alltraps>

80107b1f <vector187>:
.globl vector187
vector187:
  pushl $0
80107b1f:	6a 00                	push   $0x0
  pushl $187
80107b21:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107b26:	e9 f4 f3 ff ff       	jmp    80106f1f <alltraps>

80107b2b <vector188>:
.globl vector188
vector188:
  pushl $0
80107b2b:	6a 00                	push   $0x0
  pushl $188
80107b2d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107b32:	e9 e8 f3 ff ff       	jmp    80106f1f <alltraps>

80107b37 <vector189>:
.globl vector189
vector189:
  pushl $0
80107b37:	6a 00                	push   $0x0
  pushl $189
80107b39:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107b3e:	e9 dc f3 ff ff       	jmp    80106f1f <alltraps>

80107b43 <vector190>:
.globl vector190
vector190:
  pushl $0
80107b43:	6a 00                	push   $0x0
  pushl $190
80107b45:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107b4a:	e9 d0 f3 ff ff       	jmp    80106f1f <alltraps>

80107b4f <vector191>:
.globl vector191
vector191:
  pushl $0
80107b4f:	6a 00                	push   $0x0
  pushl $191
80107b51:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107b56:	e9 c4 f3 ff ff       	jmp    80106f1f <alltraps>

80107b5b <vector192>:
.globl vector192
vector192:
  pushl $0
80107b5b:	6a 00                	push   $0x0
  pushl $192
80107b5d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107b62:	e9 b8 f3 ff ff       	jmp    80106f1f <alltraps>

80107b67 <vector193>:
.globl vector193
vector193:
  pushl $0
80107b67:	6a 00                	push   $0x0
  pushl $193
80107b69:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107b6e:	e9 ac f3 ff ff       	jmp    80106f1f <alltraps>

80107b73 <vector194>:
.globl vector194
vector194:
  pushl $0
80107b73:	6a 00                	push   $0x0
  pushl $194
80107b75:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107b7a:	e9 a0 f3 ff ff       	jmp    80106f1f <alltraps>

80107b7f <vector195>:
.globl vector195
vector195:
  pushl $0
80107b7f:	6a 00                	push   $0x0
  pushl $195
80107b81:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107b86:	e9 94 f3 ff ff       	jmp    80106f1f <alltraps>

80107b8b <vector196>:
.globl vector196
vector196:
  pushl $0
80107b8b:	6a 00                	push   $0x0
  pushl $196
80107b8d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107b92:	e9 88 f3 ff ff       	jmp    80106f1f <alltraps>

80107b97 <vector197>:
.globl vector197
vector197:
  pushl $0
80107b97:	6a 00                	push   $0x0
  pushl $197
80107b99:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107b9e:	e9 7c f3 ff ff       	jmp    80106f1f <alltraps>

80107ba3 <vector198>:
.globl vector198
vector198:
  pushl $0
80107ba3:	6a 00                	push   $0x0
  pushl $198
80107ba5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107baa:	e9 70 f3 ff ff       	jmp    80106f1f <alltraps>

80107baf <vector199>:
.globl vector199
vector199:
  pushl $0
80107baf:	6a 00                	push   $0x0
  pushl $199
80107bb1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107bb6:	e9 64 f3 ff ff       	jmp    80106f1f <alltraps>

80107bbb <vector200>:
.globl vector200
vector200:
  pushl $0
80107bbb:	6a 00                	push   $0x0
  pushl $200
80107bbd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107bc2:	e9 58 f3 ff ff       	jmp    80106f1f <alltraps>

80107bc7 <vector201>:
.globl vector201
vector201:
  pushl $0
80107bc7:	6a 00                	push   $0x0
  pushl $201
80107bc9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107bce:	e9 4c f3 ff ff       	jmp    80106f1f <alltraps>

80107bd3 <vector202>:
.globl vector202
vector202:
  pushl $0
80107bd3:	6a 00                	push   $0x0
  pushl $202
80107bd5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107bda:	e9 40 f3 ff ff       	jmp    80106f1f <alltraps>

80107bdf <vector203>:
.globl vector203
vector203:
  pushl $0
80107bdf:	6a 00                	push   $0x0
  pushl $203
80107be1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107be6:	e9 34 f3 ff ff       	jmp    80106f1f <alltraps>

80107beb <vector204>:
.globl vector204
vector204:
  pushl $0
80107beb:	6a 00                	push   $0x0
  pushl $204
80107bed:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107bf2:	e9 28 f3 ff ff       	jmp    80106f1f <alltraps>

80107bf7 <vector205>:
.globl vector205
vector205:
  pushl $0
80107bf7:	6a 00                	push   $0x0
  pushl $205
80107bf9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107bfe:	e9 1c f3 ff ff       	jmp    80106f1f <alltraps>

80107c03 <vector206>:
.globl vector206
vector206:
  pushl $0
80107c03:	6a 00                	push   $0x0
  pushl $206
80107c05:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107c0a:	e9 10 f3 ff ff       	jmp    80106f1f <alltraps>

80107c0f <vector207>:
.globl vector207
vector207:
  pushl $0
80107c0f:	6a 00                	push   $0x0
  pushl $207
80107c11:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107c16:	e9 04 f3 ff ff       	jmp    80106f1f <alltraps>

80107c1b <vector208>:
.globl vector208
vector208:
  pushl $0
80107c1b:	6a 00                	push   $0x0
  pushl $208
80107c1d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107c22:	e9 f8 f2 ff ff       	jmp    80106f1f <alltraps>

80107c27 <vector209>:
.globl vector209
vector209:
  pushl $0
80107c27:	6a 00                	push   $0x0
  pushl $209
80107c29:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107c2e:	e9 ec f2 ff ff       	jmp    80106f1f <alltraps>

80107c33 <vector210>:
.globl vector210
vector210:
  pushl $0
80107c33:	6a 00                	push   $0x0
  pushl $210
80107c35:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107c3a:	e9 e0 f2 ff ff       	jmp    80106f1f <alltraps>

80107c3f <vector211>:
.globl vector211
vector211:
  pushl $0
80107c3f:	6a 00                	push   $0x0
  pushl $211
80107c41:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107c46:	e9 d4 f2 ff ff       	jmp    80106f1f <alltraps>

80107c4b <vector212>:
.globl vector212
vector212:
  pushl $0
80107c4b:	6a 00                	push   $0x0
  pushl $212
80107c4d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107c52:	e9 c8 f2 ff ff       	jmp    80106f1f <alltraps>

80107c57 <vector213>:
.globl vector213
vector213:
  pushl $0
80107c57:	6a 00                	push   $0x0
  pushl $213
80107c59:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107c5e:	e9 bc f2 ff ff       	jmp    80106f1f <alltraps>

80107c63 <vector214>:
.globl vector214
vector214:
  pushl $0
80107c63:	6a 00                	push   $0x0
  pushl $214
80107c65:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107c6a:	e9 b0 f2 ff ff       	jmp    80106f1f <alltraps>

80107c6f <vector215>:
.globl vector215
vector215:
  pushl $0
80107c6f:	6a 00                	push   $0x0
  pushl $215
80107c71:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107c76:	e9 a4 f2 ff ff       	jmp    80106f1f <alltraps>

80107c7b <vector216>:
.globl vector216
vector216:
  pushl $0
80107c7b:	6a 00                	push   $0x0
  pushl $216
80107c7d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107c82:	e9 98 f2 ff ff       	jmp    80106f1f <alltraps>

80107c87 <vector217>:
.globl vector217
vector217:
  pushl $0
80107c87:	6a 00                	push   $0x0
  pushl $217
80107c89:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107c8e:	e9 8c f2 ff ff       	jmp    80106f1f <alltraps>

80107c93 <vector218>:
.globl vector218
vector218:
  pushl $0
80107c93:	6a 00                	push   $0x0
  pushl $218
80107c95:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107c9a:	e9 80 f2 ff ff       	jmp    80106f1f <alltraps>

80107c9f <vector219>:
.globl vector219
vector219:
  pushl $0
80107c9f:	6a 00                	push   $0x0
  pushl $219
80107ca1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107ca6:	e9 74 f2 ff ff       	jmp    80106f1f <alltraps>

80107cab <vector220>:
.globl vector220
vector220:
  pushl $0
80107cab:	6a 00                	push   $0x0
  pushl $220
80107cad:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107cb2:	e9 68 f2 ff ff       	jmp    80106f1f <alltraps>

80107cb7 <vector221>:
.globl vector221
vector221:
  pushl $0
80107cb7:	6a 00                	push   $0x0
  pushl $221
80107cb9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107cbe:	e9 5c f2 ff ff       	jmp    80106f1f <alltraps>

80107cc3 <vector222>:
.globl vector222
vector222:
  pushl $0
80107cc3:	6a 00                	push   $0x0
  pushl $222
80107cc5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107cca:	e9 50 f2 ff ff       	jmp    80106f1f <alltraps>

80107ccf <vector223>:
.globl vector223
vector223:
  pushl $0
80107ccf:	6a 00                	push   $0x0
  pushl $223
80107cd1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107cd6:	e9 44 f2 ff ff       	jmp    80106f1f <alltraps>

80107cdb <vector224>:
.globl vector224
vector224:
  pushl $0
80107cdb:	6a 00                	push   $0x0
  pushl $224
80107cdd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107ce2:	e9 38 f2 ff ff       	jmp    80106f1f <alltraps>

80107ce7 <vector225>:
.globl vector225
vector225:
  pushl $0
80107ce7:	6a 00                	push   $0x0
  pushl $225
80107ce9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107cee:	e9 2c f2 ff ff       	jmp    80106f1f <alltraps>

80107cf3 <vector226>:
.globl vector226
vector226:
  pushl $0
80107cf3:	6a 00                	push   $0x0
  pushl $226
80107cf5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107cfa:	e9 20 f2 ff ff       	jmp    80106f1f <alltraps>

80107cff <vector227>:
.globl vector227
vector227:
  pushl $0
80107cff:	6a 00                	push   $0x0
  pushl $227
80107d01:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107d06:	e9 14 f2 ff ff       	jmp    80106f1f <alltraps>

80107d0b <vector228>:
.globl vector228
vector228:
  pushl $0
80107d0b:	6a 00                	push   $0x0
  pushl $228
80107d0d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107d12:	e9 08 f2 ff ff       	jmp    80106f1f <alltraps>

80107d17 <vector229>:
.globl vector229
vector229:
  pushl $0
80107d17:	6a 00                	push   $0x0
  pushl $229
80107d19:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107d1e:	e9 fc f1 ff ff       	jmp    80106f1f <alltraps>

80107d23 <vector230>:
.globl vector230
vector230:
  pushl $0
80107d23:	6a 00                	push   $0x0
  pushl $230
80107d25:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107d2a:	e9 f0 f1 ff ff       	jmp    80106f1f <alltraps>

80107d2f <vector231>:
.globl vector231
vector231:
  pushl $0
80107d2f:	6a 00                	push   $0x0
  pushl $231
80107d31:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107d36:	e9 e4 f1 ff ff       	jmp    80106f1f <alltraps>

80107d3b <vector232>:
.globl vector232
vector232:
  pushl $0
80107d3b:	6a 00                	push   $0x0
  pushl $232
80107d3d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107d42:	e9 d8 f1 ff ff       	jmp    80106f1f <alltraps>

80107d47 <vector233>:
.globl vector233
vector233:
  pushl $0
80107d47:	6a 00                	push   $0x0
  pushl $233
80107d49:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107d4e:	e9 cc f1 ff ff       	jmp    80106f1f <alltraps>

80107d53 <vector234>:
.globl vector234
vector234:
  pushl $0
80107d53:	6a 00                	push   $0x0
  pushl $234
80107d55:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107d5a:	e9 c0 f1 ff ff       	jmp    80106f1f <alltraps>

80107d5f <vector235>:
.globl vector235
vector235:
  pushl $0
80107d5f:	6a 00                	push   $0x0
  pushl $235
80107d61:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107d66:	e9 b4 f1 ff ff       	jmp    80106f1f <alltraps>

80107d6b <vector236>:
.globl vector236
vector236:
  pushl $0
80107d6b:	6a 00                	push   $0x0
  pushl $236
80107d6d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107d72:	e9 a8 f1 ff ff       	jmp    80106f1f <alltraps>

80107d77 <vector237>:
.globl vector237
vector237:
  pushl $0
80107d77:	6a 00                	push   $0x0
  pushl $237
80107d79:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107d7e:	e9 9c f1 ff ff       	jmp    80106f1f <alltraps>

80107d83 <vector238>:
.globl vector238
vector238:
  pushl $0
80107d83:	6a 00                	push   $0x0
  pushl $238
80107d85:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107d8a:	e9 90 f1 ff ff       	jmp    80106f1f <alltraps>

80107d8f <vector239>:
.globl vector239
vector239:
  pushl $0
80107d8f:	6a 00                	push   $0x0
  pushl $239
80107d91:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107d96:	e9 84 f1 ff ff       	jmp    80106f1f <alltraps>

80107d9b <vector240>:
.globl vector240
vector240:
  pushl $0
80107d9b:	6a 00                	push   $0x0
  pushl $240
80107d9d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107da2:	e9 78 f1 ff ff       	jmp    80106f1f <alltraps>

80107da7 <vector241>:
.globl vector241
vector241:
  pushl $0
80107da7:	6a 00                	push   $0x0
  pushl $241
80107da9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107dae:	e9 6c f1 ff ff       	jmp    80106f1f <alltraps>

80107db3 <vector242>:
.globl vector242
vector242:
  pushl $0
80107db3:	6a 00                	push   $0x0
  pushl $242
80107db5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107dba:	e9 60 f1 ff ff       	jmp    80106f1f <alltraps>

80107dbf <vector243>:
.globl vector243
vector243:
  pushl $0
80107dbf:	6a 00                	push   $0x0
  pushl $243
80107dc1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107dc6:	e9 54 f1 ff ff       	jmp    80106f1f <alltraps>

80107dcb <vector244>:
.globl vector244
vector244:
  pushl $0
80107dcb:	6a 00                	push   $0x0
  pushl $244
80107dcd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107dd2:	e9 48 f1 ff ff       	jmp    80106f1f <alltraps>

80107dd7 <vector245>:
.globl vector245
vector245:
  pushl $0
80107dd7:	6a 00                	push   $0x0
  pushl $245
80107dd9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107dde:	e9 3c f1 ff ff       	jmp    80106f1f <alltraps>

80107de3 <vector246>:
.globl vector246
vector246:
  pushl $0
80107de3:	6a 00                	push   $0x0
  pushl $246
80107de5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107dea:	e9 30 f1 ff ff       	jmp    80106f1f <alltraps>

80107def <vector247>:
.globl vector247
vector247:
  pushl $0
80107def:	6a 00                	push   $0x0
  pushl $247
80107df1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107df6:	e9 24 f1 ff ff       	jmp    80106f1f <alltraps>

80107dfb <vector248>:
.globl vector248
vector248:
  pushl $0
80107dfb:	6a 00                	push   $0x0
  pushl $248
80107dfd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107e02:	e9 18 f1 ff ff       	jmp    80106f1f <alltraps>

80107e07 <vector249>:
.globl vector249
vector249:
  pushl $0
80107e07:	6a 00                	push   $0x0
  pushl $249
80107e09:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107e0e:	e9 0c f1 ff ff       	jmp    80106f1f <alltraps>

80107e13 <vector250>:
.globl vector250
vector250:
  pushl $0
80107e13:	6a 00                	push   $0x0
  pushl $250
80107e15:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107e1a:	e9 00 f1 ff ff       	jmp    80106f1f <alltraps>

80107e1f <vector251>:
.globl vector251
vector251:
  pushl $0
80107e1f:	6a 00                	push   $0x0
  pushl $251
80107e21:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107e26:	e9 f4 f0 ff ff       	jmp    80106f1f <alltraps>

80107e2b <vector252>:
.globl vector252
vector252:
  pushl $0
80107e2b:	6a 00                	push   $0x0
  pushl $252
80107e2d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107e32:	e9 e8 f0 ff ff       	jmp    80106f1f <alltraps>

80107e37 <vector253>:
.globl vector253
vector253:
  pushl $0
80107e37:	6a 00                	push   $0x0
  pushl $253
80107e39:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107e3e:	e9 dc f0 ff ff       	jmp    80106f1f <alltraps>

80107e43 <vector254>:
.globl vector254
vector254:
  pushl $0
80107e43:	6a 00                	push   $0x0
  pushl $254
80107e45:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107e4a:	e9 d0 f0 ff ff       	jmp    80106f1f <alltraps>

80107e4f <vector255>:
.globl vector255
vector255:
  pushl $0
80107e4f:	6a 00                	push   $0x0
  pushl $255
80107e51:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107e56:	e9 c4 f0 ff ff       	jmp    80106f1f <alltraps>
80107e5b:	66 90                	xchg   %ax,%ax
80107e5d:	66 90                	xchg   %ax,%ax
80107e5f:	90                   	nop

80107e60 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107e60:	55                   	push   %ebp
80107e61:	89 e5                	mov    %esp,%ebp
80107e63:	57                   	push   %edi
80107e64:	56                   	push   %esi
80107e65:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107e67:	c1 ea 16             	shr    $0x16,%edx
{
80107e6a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80107e6b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80107e6e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107e71:	8b 1f                	mov    (%edi),%ebx
80107e73:	f6 c3 01             	test   $0x1,%bl
80107e76:	74 28                	je     80107ea0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107e78:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107e7e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107e84:	89 f0                	mov    %esi,%eax
}
80107e86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107e89:	c1 e8 0a             	shr    $0xa,%eax
80107e8c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107e91:	01 d8                	add    %ebx,%eax
}
80107e93:	5b                   	pop    %ebx
80107e94:	5e                   	pop    %esi
80107e95:	5f                   	pop    %edi
80107e96:	5d                   	pop    %ebp
80107e97:	c3                   	ret    
80107e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e9f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107ea0:	85 c9                	test   %ecx,%ecx
80107ea2:	74 2c                	je     80107ed0 <walkpgdir+0x70>
80107ea4:	e8 77 ac ff ff       	call   80102b20 <kalloc>
80107ea9:	89 c3                	mov    %eax,%ebx
80107eab:	85 c0                	test   %eax,%eax
80107ead:	74 21                	je     80107ed0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80107eaf:	83 ec 04             	sub    $0x4,%esp
80107eb2:	68 00 10 00 00       	push   $0x1000
80107eb7:	6a 00                	push   $0x0
80107eb9:	50                   	push   %eax
80107eba:	e8 81 da ff ff       	call   80105940 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107ebf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107ec5:	83 c4 10             	add    $0x10,%esp
80107ec8:	83 c8 07             	or     $0x7,%eax
80107ecb:	89 07                	mov    %eax,(%edi)
80107ecd:	eb b5                	jmp    80107e84 <walkpgdir+0x24>
80107ecf:	90                   	nop
}
80107ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107ed3:	31 c0                	xor    %eax,%eax
}
80107ed5:	5b                   	pop    %ebx
80107ed6:	5e                   	pop    %esi
80107ed7:	5f                   	pop    %edi
80107ed8:	5d                   	pop    %ebp
80107ed9:	c3                   	ret    
80107eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107ee0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107ee0:	55                   	push   %ebp
80107ee1:	89 e5                	mov    %esp,%ebp
80107ee3:	57                   	push   %edi
80107ee4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107ee6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80107eea:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107eeb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107ef0:	89 d6                	mov    %edx,%esi
{
80107ef2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107ef3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107ef9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107efc:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107eff:	8b 45 08             	mov    0x8(%ebp),%eax
80107f02:	29 f0                	sub    %esi,%eax
80107f04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107f07:	eb 1f                	jmp    80107f28 <mappages+0x48>
80107f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107f10:	f6 00 01             	testb  $0x1,(%eax)
80107f13:	75 45                	jne    80107f5a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107f15:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107f18:	83 cb 01             	or     $0x1,%ebx
80107f1b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80107f1d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107f20:	74 2e                	je     80107f50 <mappages+0x70>
      break;
    a += PGSIZE;
80107f22:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107f28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107f2b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107f30:	89 f2                	mov    %esi,%edx
80107f32:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107f35:	89 f8                	mov    %edi,%eax
80107f37:	e8 24 ff ff ff       	call   80107e60 <walkpgdir>
80107f3c:	85 c0                	test   %eax,%eax
80107f3e:	75 d0                	jne    80107f10 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107f40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107f43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107f48:	5b                   	pop    %ebx
80107f49:	5e                   	pop    %esi
80107f4a:	5f                   	pop    %edi
80107f4b:	5d                   	pop    %ebp
80107f4c:	c3                   	ret    
80107f4d:	8d 76 00             	lea    0x0(%esi),%esi
80107f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107f53:	31 c0                	xor    %eax,%eax
}
80107f55:	5b                   	pop    %ebx
80107f56:	5e                   	pop    %esi
80107f57:	5f                   	pop    %edi
80107f58:	5d                   	pop    %ebp
80107f59:	c3                   	ret    
      panic("remap");
80107f5a:	83 ec 0c             	sub    $0xc,%esp
80107f5d:	68 30 92 10 80       	push   $0x80109230
80107f62:	e8 29 84 ff ff       	call   80100390 <panic>
80107f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f6e:	66 90                	xchg   %ax,%ax

80107f70 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107f70:	55                   	push   %ebp
80107f71:	89 e5                	mov    %esp,%ebp
80107f73:	57                   	push   %edi
80107f74:	56                   	push   %esi
80107f75:	89 c6                	mov    %eax,%esi
80107f77:	53                   	push   %ebx
80107f78:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107f7a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107f80:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107f86:	83 ec 1c             	sub    $0x1c,%esp
80107f89:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107f8c:	39 da                	cmp    %ebx,%edx
80107f8e:	73 5b                	jae    80107feb <deallocuvm.part.0+0x7b>
80107f90:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107f93:	89 d7                	mov    %edx,%edi
80107f95:	eb 14                	jmp    80107fab <deallocuvm.part.0+0x3b>
80107f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f9e:	66 90                	xchg   %ax,%ax
80107fa0:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107fa6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107fa9:	76 40                	jbe    80107feb <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107fab:	31 c9                	xor    %ecx,%ecx
80107fad:	89 fa                	mov    %edi,%edx
80107faf:	89 f0                	mov    %esi,%eax
80107fb1:	e8 aa fe ff ff       	call   80107e60 <walkpgdir>
80107fb6:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107fb8:	85 c0                	test   %eax,%eax
80107fba:	74 44                	je     80108000 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107fbc:	8b 00                	mov    (%eax),%eax
80107fbe:	a8 01                	test   $0x1,%al
80107fc0:	74 de                	je     80107fa0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107fc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fc7:	74 47                	je     80108010 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107fc9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107fcc:	05 00 00 00 80       	add    $0x80000000,%eax
80107fd1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107fd7:	50                   	push   %eax
80107fd8:	e8 83 a9 ff ff       	call   80102960 <kfree>
      *pte = 0;
80107fdd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107fe3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107fe6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107fe9:	77 c0                	ja     80107fab <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80107feb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107fee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ff1:	5b                   	pop    %ebx
80107ff2:	5e                   	pop    %esi
80107ff3:	5f                   	pop    %edi
80107ff4:	5d                   	pop    %ebp
80107ff5:	c3                   	ret    
80107ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ffd:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80108000:	89 fa                	mov    %edi,%edx
80108002:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80108008:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010800e:	eb 96                	jmp    80107fa6 <deallocuvm.part.0+0x36>
        panic("kfree");
80108010:	83 ec 0c             	sub    $0xc,%esp
80108013:	68 5e 8a 10 80       	push   $0x80108a5e
80108018:	e8 73 83 ff ff       	call   80100390 <panic>
8010801d:	8d 76 00             	lea    0x0(%esi),%esi

80108020 <seginit>:
{
80108020:	f3 0f 1e fb          	endbr32 
80108024:	55                   	push   %ebp
80108025:	89 e5                	mov    %esp,%ebp
80108027:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010802a:	e8 61 be ff ff       	call   80103e90 <cpuid>
  pd[0] = size-1;
8010802f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80108034:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010803a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010803e:	c7 80 98 4d 11 80 ff 	movl   $0xffff,-0x7feeb268(%eax)
80108045:	ff 00 00 
80108048:	c7 80 9c 4d 11 80 00 	movl   $0xcf9a00,-0x7feeb264(%eax)
8010804f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108052:	c7 80 a0 4d 11 80 ff 	movl   $0xffff,-0x7feeb260(%eax)
80108059:	ff 00 00 
8010805c:	c7 80 a4 4d 11 80 00 	movl   $0xcf9200,-0x7feeb25c(%eax)
80108063:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108066:	c7 80 a8 4d 11 80 ff 	movl   $0xffff,-0x7feeb258(%eax)
8010806d:	ff 00 00 
80108070:	c7 80 ac 4d 11 80 00 	movl   $0xcffa00,-0x7feeb254(%eax)
80108077:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010807a:	c7 80 b0 4d 11 80 ff 	movl   $0xffff,-0x7feeb250(%eax)
80108081:	ff 00 00 
80108084:	c7 80 b4 4d 11 80 00 	movl   $0xcff200,-0x7feeb24c(%eax)
8010808b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010808e:	05 90 4d 11 80       	add    $0x80114d90,%eax
  pd[1] = (uint)p;
80108093:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80108097:	c1 e8 10             	shr    $0x10,%eax
8010809a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010809e:	8d 45 f2             	lea    -0xe(%ebp),%eax
801080a1:	0f 01 10             	lgdtl  (%eax)
}
801080a4:	c9                   	leave  
801080a5:	c3                   	ret    
801080a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801080ad:	8d 76 00             	lea    0x0(%esi),%esi

801080b0 <switchkvm>:
{
801080b0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801080b4:	a1 44 86 11 80       	mov    0x80118644,%eax
801080b9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801080be:	0f 22 d8             	mov    %eax,%cr3
}
801080c1:	c3                   	ret    
801080c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801080c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801080d0 <switchuvm>:
{
801080d0:	f3 0f 1e fb          	endbr32 
801080d4:	55                   	push   %ebp
801080d5:	89 e5                	mov    %esp,%ebp
801080d7:	57                   	push   %edi
801080d8:	56                   	push   %esi
801080d9:	53                   	push   %ebx
801080da:	83 ec 1c             	sub    $0x1c,%esp
801080dd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801080e0:	85 f6                	test   %esi,%esi
801080e2:	0f 84 cb 00 00 00    	je     801081b3 <switchuvm+0xe3>
  if(p->kstack == 0)
801080e8:	8b 46 08             	mov    0x8(%esi),%eax
801080eb:	85 c0                	test   %eax,%eax
801080ed:	0f 84 da 00 00 00    	je     801081cd <switchuvm+0xfd>
  if(p->pgdir == 0)
801080f3:	8b 46 04             	mov    0x4(%esi),%eax
801080f6:	85 c0                	test   %eax,%eax
801080f8:	0f 84 c2 00 00 00    	je     801081c0 <switchuvm+0xf0>
  pushcli();
801080fe:	e8 2d d6 ff ff       	call   80105730 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80108103:	e8 18 bd ff ff       	call   80103e20 <mycpu>
80108108:	89 c3                	mov    %eax,%ebx
8010810a:	e8 11 bd ff ff       	call   80103e20 <mycpu>
8010810f:	89 c7                	mov    %eax,%edi
80108111:	e8 0a bd ff ff       	call   80103e20 <mycpu>
80108116:	83 c7 08             	add    $0x8,%edi
80108119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010811c:	e8 ff bc ff ff       	call   80103e20 <mycpu>
80108121:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80108124:	ba 67 00 00 00       	mov    $0x67,%edx
80108129:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80108130:	83 c0 08             	add    $0x8,%eax
80108133:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010813a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010813f:	83 c1 08             	add    $0x8,%ecx
80108142:	c1 e8 18             	shr    $0x18,%eax
80108145:	c1 e9 10             	shr    $0x10,%ecx
80108148:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010814e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80108154:	b9 99 40 00 00       	mov    $0x4099,%ecx
80108159:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108160:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80108165:	e8 b6 bc ff ff       	call   80103e20 <mycpu>
8010816a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108171:	e8 aa bc ff ff       	call   80103e20 <mycpu>
80108176:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010817a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010817d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108183:	e8 98 bc ff ff       	call   80103e20 <mycpu>
80108188:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010818b:	e8 90 bc ff ff       	call   80103e20 <mycpu>
80108190:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80108194:	b8 28 00 00 00       	mov    $0x28,%eax
80108199:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010819c:	8b 46 04             	mov    0x4(%esi),%eax
8010819f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801081a4:	0f 22 d8             	mov    %eax,%cr3
}
801081a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081aa:	5b                   	pop    %ebx
801081ab:	5e                   	pop    %esi
801081ac:	5f                   	pop    %edi
801081ad:	5d                   	pop    %ebp
  popcli();
801081ae:	e9 cd d5 ff ff       	jmp    80105780 <popcli>
    panic("switchuvm: no process");
801081b3:	83 ec 0c             	sub    $0xc,%esp
801081b6:	68 36 92 10 80       	push   $0x80109236
801081bb:	e8 d0 81 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801081c0:	83 ec 0c             	sub    $0xc,%esp
801081c3:	68 61 92 10 80       	push   $0x80109261
801081c8:	e8 c3 81 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801081cd:	83 ec 0c             	sub    $0xc,%esp
801081d0:	68 4c 92 10 80       	push   $0x8010924c
801081d5:	e8 b6 81 ff ff       	call   80100390 <panic>
801081da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801081e0 <inituvm>:
{
801081e0:	f3 0f 1e fb          	endbr32 
801081e4:	55                   	push   %ebp
801081e5:	89 e5                	mov    %esp,%ebp
801081e7:	57                   	push   %edi
801081e8:	56                   	push   %esi
801081e9:	53                   	push   %ebx
801081ea:	83 ec 1c             	sub    $0x1c,%esp
801081ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801081f0:	8b 75 10             	mov    0x10(%ebp),%esi
801081f3:	8b 7d 08             	mov    0x8(%ebp),%edi
801081f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801081f9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801081ff:	77 4b                	ja     8010824c <inituvm+0x6c>
  mem = kalloc();
80108201:	e8 1a a9 ff ff       	call   80102b20 <kalloc>
  memset(mem, 0, PGSIZE);
80108206:	83 ec 04             	sub    $0x4,%esp
80108209:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010820e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80108210:	6a 00                	push   $0x0
80108212:	50                   	push   %eax
80108213:	e8 28 d7 ff ff       	call   80105940 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108218:	58                   	pop    %eax
80108219:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010821f:	5a                   	pop    %edx
80108220:	6a 06                	push   $0x6
80108222:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108227:	31 d2                	xor    %edx,%edx
80108229:	50                   	push   %eax
8010822a:	89 f8                	mov    %edi,%eax
8010822c:	e8 af fc ff ff       	call   80107ee0 <mappages>
  memmove(mem, init, sz);
80108231:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108234:	89 75 10             	mov    %esi,0x10(%ebp)
80108237:	83 c4 10             	add    $0x10,%esp
8010823a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010823d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80108240:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108243:	5b                   	pop    %ebx
80108244:	5e                   	pop    %esi
80108245:	5f                   	pop    %edi
80108246:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80108247:	e9 94 d7 ff ff       	jmp    801059e0 <memmove>
    panic("inituvm: more than a page");
8010824c:	83 ec 0c             	sub    $0xc,%esp
8010824f:	68 75 92 10 80       	push   $0x80109275
80108254:	e8 37 81 ff ff       	call   80100390 <panic>
80108259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108260 <loaduvm>:
{
80108260:	f3 0f 1e fb          	endbr32 
80108264:	55                   	push   %ebp
80108265:	89 e5                	mov    %esp,%ebp
80108267:	57                   	push   %edi
80108268:	56                   	push   %esi
80108269:	53                   	push   %ebx
8010826a:	83 ec 1c             	sub    $0x1c,%esp
8010826d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108270:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80108273:	a9 ff 0f 00 00       	test   $0xfff,%eax
80108278:	0f 85 99 00 00 00    	jne    80108317 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010827e:	01 f0                	add    %esi,%eax
80108280:	89 f3                	mov    %esi,%ebx
80108282:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108285:	8b 45 14             	mov    0x14(%ebp),%eax
80108288:	01 f0                	add    %esi,%eax
8010828a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010828d:	85 f6                	test   %esi,%esi
8010828f:	75 15                	jne    801082a6 <loaduvm+0x46>
80108291:	eb 6d                	jmp    80108300 <loaduvm+0xa0>
80108293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108297:	90                   	nop
80108298:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010829e:	89 f0                	mov    %esi,%eax
801082a0:	29 d8                	sub    %ebx,%eax
801082a2:	39 c6                	cmp    %eax,%esi
801082a4:	76 5a                	jbe    80108300 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801082a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801082a9:	8b 45 08             	mov    0x8(%ebp),%eax
801082ac:	31 c9                	xor    %ecx,%ecx
801082ae:	29 da                	sub    %ebx,%edx
801082b0:	e8 ab fb ff ff       	call   80107e60 <walkpgdir>
801082b5:	85 c0                	test   %eax,%eax
801082b7:	74 51                	je     8010830a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801082b9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801082bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801082be:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801082c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801082c8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801082ce:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801082d1:	29 d9                	sub    %ebx,%ecx
801082d3:	05 00 00 00 80       	add    $0x80000000,%eax
801082d8:	57                   	push   %edi
801082d9:	51                   	push   %ecx
801082da:	50                   	push   %eax
801082db:	ff 75 10             	pushl  0x10(%ebp)
801082de:	e8 6d 9c ff ff       	call   80101f50 <readi>
801082e3:	83 c4 10             	add    $0x10,%esp
801082e6:	39 f8                	cmp    %edi,%eax
801082e8:	74 ae                	je     80108298 <loaduvm+0x38>
}
801082ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801082ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801082f2:	5b                   	pop    %ebx
801082f3:	5e                   	pop    %esi
801082f4:	5f                   	pop    %edi
801082f5:	5d                   	pop    %ebp
801082f6:	c3                   	ret    
801082f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082fe:	66 90                	xchg   %ax,%ax
80108300:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108303:	31 c0                	xor    %eax,%eax
}
80108305:	5b                   	pop    %ebx
80108306:	5e                   	pop    %esi
80108307:	5f                   	pop    %edi
80108308:	5d                   	pop    %ebp
80108309:	c3                   	ret    
      panic("loaduvm: address should exist");
8010830a:	83 ec 0c             	sub    $0xc,%esp
8010830d:	68 8f 92 10 80       	push   $0x8010928f
80108312:	e8 79 80 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80108317:	83 ec 0c             	sub    $0xc,%esp
8010831a:	68 30 93 10 80       	push   $0x80109330
8010831f:	e8 6c 80 ff ff       	call   80100390 <panic>
80108324:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010832b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010832f:	90                   	nop

80108330 <allocuvm>:
{
80108330:	f3 0f 1e fb          	endbr32 
80108334:	55                   	push   %ebp
80108335:	89 e5                	mov    %esp,%ebp
80108337:	57                   	push   %edi
80108338:	56                   	push   %esi
80108339:	53                   	push   %ebx
8010833a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010833d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80108340:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80108343:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108346:	85 c0                	test   %eax,%eax
80108348:	0f 88 b2 00 00 00    	js     80108400 <allocuvm+0xd0>
  if(newsz < oldsz)
8010834e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80108351:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80108354:	0f 82 96 00 00 00    	jb     801083f0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010835a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80108360:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80108366:	39 75 10             	cmp    %esi,0x10(%ebp)
80108369:	77 40                	ja     801083ab <allocuvm+0x7b>
8010836b:	e9 83 00 00 00       	jmp    801083f3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80108370:	83 ec 04             	sub    $0x4,%esp
80108373:	68 00 10 00 00       	push   $0x1000
80108378:	6a 00                	push   $0x0
8010837a:	50                   	push   %eax
8010837b:	e8 c0 d5 ff ff       	call   80105940 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108380:	58                   	pop    %eax
80108381:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108387:	5a                   	pop    %edx
80108388:	6a 06                	push   $0x6
8010838a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010838f:	89 f2                	mov    %esi,%edx
80108391:	50                   	push   %eax
80108392:	89 f8                	mov    %edi,%eax
80108394:	e8 47 fb ff ff       	call   80107ee0 <mappages>
80108399:	83 c4 10             	add    $0x10,%esp
8010839c:	85 c0                	test   %eax,%eax
8010839e:	78 78                	js     80108418 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801083a0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801083a6:	39 75 10             	cmp    %esi,0x10(%ebp)
801083a9:	76 48                	jbe    801083f3 <allocuvm+0xc3>
    mem = kalloc();
801083ab:	e8 70 a7 ff ff       	call   80102b20 <kalloc>
801083b0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801083b2:	85 c0                	test   %eax,%eax
801083b4:	75 ba                	jne    80108370 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801083b6:	83 ec 0c             	sub    $0xc,%esp
801083b9:	68 ad 92 10 80       	push   $0x801092ad
801083be:	e8 fd 84 ff ff       	call   801008c0 <cprintf>
  if(newsz >= oldsz)
801083c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801083c6:	83 c4 10             	add    $0x10,%esp
801083c9:	39 45 10             	cmp    %eax,0x10(%ebp)
801083cc:	74 32                	je     80108400 <allocuvm+0xd0>
801083ce:	8b 55 10             	mov    0x10(%ebp),%edx
801083d1:	89 c1                	mov    %eax,%ecx
801083d3:	89 f8                	mov    %edi,%eax
801083d5:	e8 96 fb ff ff       	call   80107f70 <deallocuvm.part.0>
      return 0;
801083da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801083e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801083e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083e7:	5b                   	pop    %ebx
801083e8:	5e                   	pop    %esi
801083e9:	5f                   	pop    %edi
801083ea:	5d                   	pop    %ebp
801083eb:	c3                   	ret    
801083ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801083f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801083f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801083f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083f9:	5b                   	pop    %ebx
801083fa:	5e                   	pop    %esi
801083fb:	5f                   	pop    %edi
801083fc:	5d                   	pop    %ebp
801083fd:	c3                   	ret    
801083fe:	66 90                	xchg   %ax,%ax
    return 0;
80108400:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010840a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010840d:	5b                   	pop    %ebx
8010840e:	5e                   	pop    %esi
8010840f:	5f                   	pop    %edi
80108410:	5d                   	pop    %ebp
80108411:	c3                   	ret    
80108412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108418:	83 ec 0c             	sub    $0xc,%esp
8010841b:	68 c5 92 10 80       	push   $0x801092c5
80108420:	e8 9b 84 ff ff       	call   801008c0 <cprintf>
  if(newsz >= oldsz)
80108425:	8b 45 0c             	mov    0xc(%ebp),%eax
80108428:	83 c4 10             	add    $0x10,%esp
8010842b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010842e:	74 0c                	je     8010843c <allocuvm+0x10c>
80108430:	8b 55 10             	mov    0x10(%ebp),%edx
80108433:	89 c1                	mov    %eax,%ecx
80108435:	89 f8                	mov    %edi,%eax
80108437:	e8 34 fb ff ff       	call   80107f70 <deallocuvm.part.0>
      kfree(mem);
8010843c:	83 ec 0c             	sub    $0xc,%esp
8010843f:	53                   	push   %ebx
80108440:	e8 1b a5 ff ff       	call   80102960 <kfree>
      return 0;
80108445:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010844c:	83 c4 10             	add    $0x10,%esp
}
8010844f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108452:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108455:	5b                   	pop    %ebx
80108456:	5e                   	pop    %esi
80108457:	5f                   	pop    %edi
80108458:	5d                   	pop    %ebp
80108459:	c3                   	ret    
8010845a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108460 <deallocuvm>:
{
80108460:	f3 0f 1e fb          	endbr32 
80108464:	55                   	push   %ebp
80108465:	89 e5                	mov    %esp,%ebp
80108467:	8b 55 0c             	mov    0xc(%ebp),%edx
8010846a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010846d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80108470:	39 d1                	cmp    %edx,%ecx
80108472:	73 0c                	jae    80108480 <deallocuvm+0x20>
}
80108474:	5d                   	pop    %ebp
80108475:	e9 f6 fa ff ff       	jmp    80107f70 <deallocuvm.part.0>
8010847a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108480:	89 d0                	mov    %edx,%eax
80108482:	5d                   	pop    %ebp
80108483:	c3                   	ret    
80108484:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010848b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010848f:	90                   	nop

80108490 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108490:	f3 0f 1e fb          	endbr32 
80108494:	55                   	push   %ebp
80108495:	89 e5                	mov    %esp,%ebp
80108497:	57                   	push   %edi
80108498:	56                   	push   %esi
80108499:	53                   	push   %ebx
8010849a:	83 ec 0c             	sub    $0xc,%esp
8010849d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801084a0:	85 f6                	test   %esi,%esi
801084a2:	74 55                	je     801084f9 <freevm+0x69>
  if(newsz >= oldsz)
801084a4:	31 c9                	xor    %ecx,%ecx
801084a6:	ba 00 00 00 80       	mov    $0x80000000,%edx
801084ab:	89 f0                	mov    %esi,%eax
801084ad:	89 f3                	mov    %esi,%ebx
801084af:	e8 bc fa ff ff       	call   80107f70 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801084b4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801084ba:	eb 0b                	jmp    801084c7 <freevm+0x37>
801084bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801084c0:	83 c3 04             	add    $0x4,%ebx
801084c3:	39 df                	cmp    %ebx,%edi
801084c5:	74 23                	je     801084ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801084c7:	8b 03                	mov    (%ebx),%eax
801084c9:	a8 01                	test   $0x1,%al
801084cb:	74 f3                	je     801084c0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801084cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801084d2:	83 ec 0c             	sub    $0xc,%esp
801084d5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801084d8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801084dd:	50                   	push   %eax
801084de:	e8 7d a4 ff ff       	call   80102960 <kfree>
801084e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801084e6:	39 df                	cmp    %ebx,%edi
801084e8:	75 dd                	jne    801084c7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801084ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801084ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084f0:	5b                   	pop    %ebx
801084f1:	5e                   	pop    %esi
801084f2:	5f                   	pop    %edi
801084f3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801084f4:	e9 67 a4 ff ff       	jmp    80102960 <kfree>
    panic("freevm: no pgdir");
801084f9:	83 ec 0c             	sub    $0xc,%esp
801084fc:	68 e1 92 10 80       	push   $0x801092e1
80108501:	e8 8a 7e ff ff       	call   80100390 <panic>
80108506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010850d:	8d 76 00             	lea    0x0(%esi),%esi

80108510 <setupkvm>:
{
80108510:	f3 0f 1e fb          	endbr32 
80108514:	55                   	push   %ebp
80108515:	89 e5                	mov    %esp,%ebp
80108517:	56                   	push   %esi
80108518:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108519:	e8 02 a6 ff ff       	call   80102b20 <kalloc>
8010851e:	89 c6                	mov    %eax,%esi
80108520:	85 c0                	test   %eax,%eax
80108522:	74 42                	je     80108566 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80108524:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108527:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
8010852c:	68 00 10 00 00       	push   $0x1000
80108531:	6a 00                	push   $0x0
80108533:	50                   	push   %eax
80108534:	e8 07 d4 ff ff       	call   80105940 <memset>
80108539:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010853c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010853f:	83 ec 08             	sub    $0x8,%esp
80108542:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108545:	ff 73 0c             	pushl  0xc(%ebx)
80108548:	8b 13                	mov    (%ebx),%edx
8010854a:	50                   	push   %eax
8010854b:	29 c1                	sub    %eax,%ecx
8010854d:	89 f0                	mov    %esi,%eax
8010854f:	e8 8c f9 ff ff       	call   80107ee0 <mappages>
80108554:	83 c4 10             	add    $0x10,%esp
80108557:	85 c0                	test   %eax,%eax
80108559:	78 15                	js     80108570 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010855b:	83 c3 10             	add    $0x10,%ebx
8010855e:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80108564:	75 d6                	jne    8010853c <setupkvm+0x2c>
}
80108566:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108569:	89 f0                	mov    %esi,%eax
8010856b:	5b                   	pop    %ebx
8010856c:	5e                   	pop    %esi
8010856d:	5d                   	pop    %ebp
8010856e:	c3                   	ret    
8010856f:	90                   	nop
      freevm(pgdir);
80108570:	83 ec 0c             	sub    $0xc,%esp
80108573:	56                   	push   %esi
      return 0;
80108574:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108576:	e8 15 ff ff ff       	call   80108490 <freevm>
      return 0;
8010857b:	83 c4 10             	add    $0x10,%esp
}
8010857e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108581:	89 f0                	mov    %esi,%eax
80108583:	5b                   	pop    %ebx
80108584:	5e                   	pop    %esi
80108585:	5d                   	pop    %ebp
80108586:	c3                   	ret    
80108587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010858e:	66 90                	xchg   %ax,%ax

80108590 <kvmalloc>:
{
80108590:	f3 0f 1e fb          	endbr32 
80108594:	55                   	push   %ebp
80108595:	89 e5                	mov    %esp,%ebp
80108597:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010859a:	e8 71 ff ff ff       	call   80108510 <setupkvm>
8010859f:	a3 44 86 11 80       	mov    %eax,0x80118644
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801085a4:	05 00 00 00 80       	add    $0x80000000,%eax
801085a9:	0f 22 d8             	mov    %eax,%cr3
}
801085ac:	c9                   	leave  
801085ad:	c3                   	ret    
801085ae:	66 90                	xchg   %ax,%ax

801085b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801085b0:	f3 0f 1e fb          	endbr32 
801085b4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801085b5:	31 c9                	xor    %ecx,%ecx
{
801085b7:	89 e5                	mov    %esp,%ebp
801085b9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801085bc:	8b 55 0c             	mov    0xc(%ebp),%edx
801085bf:	8b 45 08             	mov    0x8(%ebp),%eax
801085c2:	e8 99 f8 ff ff       	call   80107e60 <walkpgdir>
  if(pte == 0)
801085c7:	85 c0                	test   %eax,%eax
801085c9:	74 05                	je     801085d0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801085cb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801085ce:	c9                   	leave  
801085cf:	c3                   	ret    
    panic("clearpteu");
801085d0:	83 ec 0c             	sub    $0xc,%esp
801085d3:	68 f2 92 10 80       	push   $0x801092f2
801085d8:	e8 b3 7d ff ff       	call   80100390 <panic>
801085dd:	8d 76 00             	lea    0x0(%esi),%esi

801085e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801085e0:	f3 0f 1e fb          	endbr32 
801085e4:	55                   	push   %ebp
801085e5:	89 e5                	mov    %esp,%ebp
801085e7:	57                   	push   %edi
801085e8:	56                   	push   %esi
801085e9:	53                   	push   %ebx
801085ea:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801085ed:	e8 1e ff ff ff       	call   80108510 <setupkvm>
801085f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801085f5:	85 c0                	test   %eax,%eax
801085f7:	0f 84 9b 00 00 00    	je     80108698 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801085fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80108600:	85 c9                	test   %ecx,%ecx
80108602:	0f 84 90 00 00 00    	je     80108698 <copyuvm+0xb8>
80108608:	31 f6                	xor    %esi,%esi
8010860a:	eb 46                	jmp    80108652 <copyuvm+0x72>
8010860c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108610:	83 ec 04             	sub    $0x4,%esp
80108613:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108619:	68 00 10 00 00       	push   $0x1000
8010861e:	57                   	push   %edi
8010861f:	50                   	push   %eax
80108620:	e8 bb d3 ff ff       	call   801059e0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108625:	58                   	pop    %eax
80108626:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010862c:	5a                   	pop    %edx
8010862d:	ff 75 e4             	pushl  -0x1c(%ebp)
80108630:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108635:	89 f2                	mov    %esi,%edx
80108637:	50                   	push   %eax
80108638:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010863b:	e8 a0 f8 ff ff       	call   80107ee0 <mappages>
80108640:	83 c4 10             	add    $0x10,%esp
80108643:	85 c0                	test   %eax,%eax
80108645:	78 61                	js     801086a8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80108647:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010864d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108650:	76 46                	jbe    80108698 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108652:	8b 45 08             	mov    0x8(%ebp),%eax
80108655:	31 c9                	xor    %ecx,%ecx
80108657:	89 f2                	mov    %esi,%edx
80108659:	e8 02 f8 ff ff       	call   80107e60 <walkpgdir>
8010865e:	85 c0                	test   %eax,%eax
80108660:	74 61                	je     801086c3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80108662:	8b 00                	mov    (%eax),%eax
80108664:	a8 01                	test   $0x1,%al
80108666:	74 4e                	je     801086b6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80108668:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010866a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010866f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80108672:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108678:	e8 a3 a4 ff ff       	call   80102b20 <kalloc>
8010867d:	89 c3                	mov    %eax,%ebx
8010867f:	85 c0                	test   %eax,%eax
80108681:	75 8d                	jne    80108610 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80108683:	83 ec 0c             	sub    $0xc,%esp
80108686:	ff 75 e0             	pushl  -0x20(%ebp)
80108689:	e8 02 fe ff ff       	call   80108490 <freevm>
  return 0;
8010868e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108695:	83 c4 10             	add    $0x10,%esp
}
80108698:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010869b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010869e:	5b                   	pop    %ebx
8010869f:	5e                   	pop    %esi
801086a0:	5f                   	pop    %edi
801086a1:	5d                   	pop    %ebp
801086a2:	c3                   	ret    
801086a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801086a7:	90                   	nop
      kfree(mem);
801086a8:	83 ec 0c             	sub    $0xc,%esp
801086ab:	53                   	push   %ebx
801086ac:	e8 af a2 ff ff       	call   80102960 <kfree>
      goto bad;
801086b1:	83 c4 10             	add    $0x10,%esp
801086b4:	eb cd                	jmp    80108683 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801086b6:	83 ec 0c             	sub    $0xc,%esp
801086b9:	68 16 93 10 80       	push   $0x80109316
801086be:	e8 cd 7c ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801086c3:	83 ec 0c             	sub    $0xc,%esp
801086c6:	68 fc 92 10 80       	push   $0x801092fc
801086cb:	e8 c0 7c ff ff       	call   80100390 <panic>

801086d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801086d0:	f3 0f 1e fb          	endbr32 
801086d4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801086d5:	31 c9                	xor    %ecx,%ecx
{
801086d7:	89 e5                	mov    %esp,%ebp
801086d9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801086dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801086df:	8b 45 08             	mov    0x8(%ebp),%eax
801086e2:	e8 79 f7 ff ff       	call   80107e60 <walkpgdir>
  if((*pte & PTE_P) == 0)
801086e7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801086e9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801086ea:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801086ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801086f1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801086f4:	05 00 00 00 80       	add    $0x80000000,%eax
801086f9:	83 fa 05             	cmp    $0x5,%edx
801086fc:	ba 00 00 00 00       	mov    $0x0,%edx
80108701:	0f 45 c2             	cmovne %edx,%eax
}
80108704:	c3                   	ret    
80108705:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010870c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108710 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108710:	f3 0f 1e fb          	endbr32 
80108714:	55                   	push   %ebp
80108715:	89 e5                	mov    %esp,%ebp
80108717:	57                   	push   %edi
80108718:	56                   	push   %esi
80108719:	53                   	push   %ebx
8010871a:	83 ec 0c             	sub    $0xc,%esp
8010871d:	8b 75 14             	mov    0x14(%ebp),%esi
80108720:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108723:	85 f6                	test   %esi,%esi
80108725:	75 3c                	jne    80108763 <copyout+0x53>
80108727:	eb 67                	jmp    80108790 <copyout+0x80>
80108729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108730:	8b 55 0c             	mov    0xc(%ebp),%edx
80108733:	89 fb                	mov    %edi,%ebx
80108735:	29 d3                	sub    %edx,%ebx
80108737:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010873d:	39 f3                	cmp    %esi,%ebx
8010873f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108742:	29 fa                	sub    %edi,%edx
80108744:	83 ec 04             	sub    $0x4,%esp
80108747:	01 c2                	add    %eax,%edx
80108749:	53                   	push   %ebx
8010874a:	ff 75 10             	pushl  0x10(%ebp)
8010874d:	52                   	push   %edx
8010874e:	e8 8d d2 ff ff       	call   801059e0 <memmove>
    len -= n;
    buf += n;
80108753:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80108756:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010875c:	83 c4 10             	add    $0x10,%esp
8010875f:	29 de                	sub    %ebx,%esi
80108761:	74 2d                	je     80108790 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80108763:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108765:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80108768:	89 55 0c             	mov    %edx,0xc(%ebp)
8010876b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108771:	57                   	push   %edi
80108772:	ff 75 08             	pushl  0x8(%ebp)
80108775:	e8 56 ff ff ff       	call   801086d0 <uva2ka>
    if(pa0 == 0)
8010877a:	83 c4 10             	add    $0x10,%esp
8010877d:	85 c0                	test   %eax,%eax
8010877f:	75 af                	jne    80108730 <copyout+0x20>
  }
  return 0;
}
80108781:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108784:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108789:	5b                   	pop    %ebx
8010878a:	5e                   	pop    %esi
8010878b:	5f                   	pop    %edi
8010878c:	5d                   	pop    %ebp
8010878d:	c3                   	ret    
8010878e:	66 90                	xchg   %ax,%ax
80108790:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108793:	31 c0                	xor    %eax,%eax
}
80108795:	5b                   	pop    %ebx
80108796:	5e                   	pop    %esi
80108797:	5f                   	pop    %edi
80108798:	5d                   	pop    %ebp
80108799:	c3                   	ret    
