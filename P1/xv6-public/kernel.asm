
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 35 10 80       	mov    $0x80103510,%eax
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
80100048:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 c0 75 10 80       	push   $0x801075c0
80100055:	68 c0 b5 10 80       	push   $0x8010b5c0
8010005a:	e8 51 48 00 00       	call   801048b0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006e:	fc 10 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100078:	fc 10 80 
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
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 75 10 80       	push   $0x801075c7
80100097:	50                   	push   %eax
80100098:	e8 d3 46 00 00       	call   80104770 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
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
801000e3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e8:	e8 43 49 00 00       	call   80104a30 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 89 49 00 00       	call   80104af0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 46 00 00       	call   801047b0 <acquiresleep>
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
8010018c:	e8 bf 25 00 00       	call   80102750 <iderw>
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
801001a3:	68 ce 75 10 80       	push   $0x801075ce
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
801001c2:	e8 89 46 00 00       	call   80104850 <holdingsleep>
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
801001d8:	e9 73 25 00 00       	jmp    80102750 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 df 75 10 80       	push   $0x801075df
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
80100203:	e8 48 46 00 00       	call   80104850 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 f8 45 00 00       	call   80104810 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021f:	e8 0c 48 00 00       	call   80104a30 <acquire>
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
80100246:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 7b 48 00 00       	jmp    80104af0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 e6 75 10 80       	push   $0x801075e6
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
801002a5:	e8 66 1a 00 00       	call   80101d10 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002b1:	e8 7a 47 00 00       	call   80104a30 <acquire>
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
801002c6:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cb:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 a5 10 80       	push   $0x8010a520
801002e0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002e5:	e8 06 41 00 00       	call   801043f0 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 31 3b 00 00       	call   80103e30 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 a5 10 80       	push   $0x8010a520
8010030e:	e8 dd 47 00 00       	call   80104af0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 14 19 00 00       	call   80101c30 <ilock>
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
80100333:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
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
80100360:	68 20 a5 10 80       	push   $0x8010a520
80100365:	e8 86 47 00 00       	call   80104af0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 bd 18 00 00       	call   80101c30 <ilock>
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
80100386:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
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
8010039d:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 be 29 00 00       	call   80102d70 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ed 75 10 80       	push   $0x801075ed
801003bb:	e8 e0 04 00 00       	call   801008a0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 d7 04 00 00       	call   801008a0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 77 7f 10 80 	movl   $0x80107f77,(%esp)
801003d0:	e8 cb 04 00 00       	call   801008a0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ef 44 00 00       	call   801048d0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 01 76 10 80       	push   $0x80107601
801003f1:	e8 aa 04 00 00       	call   801008a0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 5c a5 10 80 01 	movl   $0x1,0x8010a55c
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
8010042a:	e8 81 5d 00 00       	call   801061b0 <uartputc>
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
80100468:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
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
801004ce:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
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
80100560:	c7 05 58 a5 10 80 00 	movl   $0x0,0x8010a558
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
8010058d:	e8 1e 5c 00 00       	call   801061b0 <uartputc>
80100592:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100599:	e8 12 5c 00 00       	call   801061b0 <uartputc>
8010059e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005a5:	e8 06 5c 00 00       	call   801061b0 <uartputc>
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
801005cf:	e8 0c 46 00 00       	call   80104be0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005d4:	b8 80 07 00 00       	mov    $0x780,%eax
801005d9:	83 c4 0c             	add    $0xc,%esp
801005dc:	29 d8                	sub    %ebx,%eax
801005de:	01 c0                	add    %eax,%eax
801005e0:	50                   	push   %eax
801005e1:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
801005e8:	6a 00                	push   $0x0
801005ea:	50                   	push   %eax
801005eb:	e8 50 45 00 00       	call   80104b40 <memset>
801005f0:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801005f6:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801005fa:	83 c4 10             	add    $0x10,%esp
801005fd:	01 df                	add    %ebx,%edi
801005ff:	e9 d7 fe ff ff       	jmp    801004db <consputc.part.0+0xcb>
    panic("pos under/overflow");
80100604:	83 ec 0c             	sub    $0xc,%esp
80100607:	68 05 76 10 80       	push   $0x80107605
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
80100649:	0f b6 92 88 76 10 80 	movzbl -0x7fef8978(%edx),%edx
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
80100683:	8b 15 5c a5 10 80    	mov    0x8010a55c,%edx
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
801006cc:	a1 58 a5 10 80       	mov    0x8010a558,%eax
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
8010072f:	c7 05 58 a5 10 80 00 	movl   $0x0,0x8010a558
80100736:	00 00 00 
  for ( int i = input.e ; i > input.w ; i-- ){
80100739:	8b 1d a8 ff 10 80    	mov    0x8010ffa8,%ebx
8010073f:	3b 1d a4 ff 10 80    	cmp    0x8010ffa4,%ebx
80100745:	76 2b                	jbe    80100772 <arrow+0xb2>
    if (input.buf[i - 1] != '\n'){
80100747:	83 eb 01             	sub    $0x1,%ebx
8010074a:	80 bb 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%ebx)
80100751:	74 17                	je     8010076a <arrow+0xaa>
  if(panicked){
80100753:	8b 15 5c a5 10 80    	mov    0x8010a55c,%edx
80100759:	85 d2                	test   %edx,%edx
8010075b:	74 03                	je     80100760 <arrow+0xa0>
  asm volatile("cli");
8010075d:	fa                   	cli    
    for(;;)
8010075e:	eb fe                	jmp    8010075e <arrow+0x9e>
80100760:	b8 00 01 00 00       	mov    $0x100,%eax
80100765:	e8 a6 fc ff ff       	call   80100410 <consputc.part.0>
  for ( int i = input.e ; i > input.w ; i-- ){
8010076a:	39 1d a4 ff 10 80    	cmp    %ebx,0x8010ffa4
80100770:	72 d5                	jb     80100747 <arrow+0x87>
  if (arr == UP){
80100772:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100775:	a1 38 05 11 80       	mov    0x80110538,%eax
8010077a:	85 c9                	test   %ecx,%ecx
8010077c:	74 35                	je     801007b3 <arrow+0xf3>
  if ((arr == DOWN)&&(history.index < 9)&&(history.index < history.last )){
8010077e:	83 f8 08             	cmp    $0x8,%eax
80100781:	0f 8f 98 00 00 00    	jg     8010081f <arrow+0x15f>
80100787:	39 05 40 05 11 80    	cmp    %eax,0x80110540
8010078d:	0f 8e 8c 00 00 00    	jle    8010081f <arrow+0x15f>
    input = history.hist[history.index + 2 ];
80100793:	8d 70 02             	lea    0x2(%eax),%esi
80100796:	bf 20 ff 10 80       	mov    $0x8010ff20,%edi
8010079b:	b9 23 00 00 00       	mov    $0x23,%ecx
    history.index ++ ;
801007a0:	83 c0 01             	add    $0x1,%eax
    input = history.hist[history.index + 2 ];
801007a3:	69 f6 8c 00 00 00    	imul   $0x8c,%esi,%esi
801007a9:	81 c6 c0 ff 10 80    	add    $0x8010ffc0,%esi
801007af:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    history.index ++ ;
801007b1:	eb 1b                	jmp    801007ce <arrow+0x10e>
    input = history.hist[history.index ];
801007b3:	69 f0 8c 00 00 00    	imul   $0x8c,%eax,%esi
801007b9:	bf 20 ff 10 80       	mov    $0x8010ff20,%edi
801007be:	b9 23 00 00 00       	mov    $0x23,%ecx
    history.index -- ;
801007c3:	83 e8 01             	sub    $0x1,%eax
    input = history.hist[history.index ];
801007c6:	81 c6 c0 ff 10 80    	add    $0x8010ffc0,%esi
801007cc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    input.e -- ;
801007ce:	8b 15 a8 ff 10 80    	mov    0x8010ffa8,%edx
    history.index ++ ;
801007d4:	a3 38 05 11 80       	mov    %eax,0x80110538
    input.e -- ;
801007d9:	8d 42 ff             	lea    -0x1(%edx),%eax
    input.buf[input.e] = '\0';
801007dc:	c6 82 1f ff 10 80 00 	movb   $0x0,-0x7fef00e1(%edx)
    input.e -- ;
801007e3:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  for (int i = input.w ; i < input.e; i++)
801007e8:	8b 1d a4 ff 10 80    	mov    0x8010ffa4,%ebx
801007ee:	39 d8                	cmp    %ebx,%eax
801007f0:	76 25                	jbe    80100817 <arrow+0x157>
  if(panicked){
801007f2:	a1 5c a5 10 80       	mov    0x8010a55c,%eax
801007f7:	85 c0                	test   %eax,%eax
801007f9:	74 05                	je     80100800 <arrow+0x140>
801007fb:	fa                   	cli    
    for(;;)
801007fc:	eb fe                	jmp    801007fc <arrow+0x13c>
801007fe:	66 90                	xchg   %ax,%ax
    consputc(input.buf[i]);
80100800:	0f be 83 20 ff 10 80 	movsbl -0x7fef00e0(%ebx),%eax
  for (int i = input.w ; i < input.e; i++)
80100807:	83 c3 01             	add    $0x1,%ebx
8010080a:	e8 01 fc ff ff       	call   80100410 <consputc.part.0>
8010080f:	39 1d a8 ff 10 80    	cmp    %ebx,0x8010ffa8
80100815:	77 db                	ja     801007f2 <arrow+0x132>
}
80100817:	83 c4 1c             	add    $0x1c,%esp
8010081a:	5b                   	pop    %ebx
8010081b:	5e                   	pop    %esi
8010081c:	5f                   	pop    %edi
8010081d:	5d                   	pop    %ebp
8010081e:	c3                   	ret    
8010081f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100824:	eb c2                	jmp    801007e8 <arrow+0x128>
80100826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010082d:	8d 76 00             	lea    0x0(%esi),%esi

80100830 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100830:	f3 0f 1e fb          	endbr32 
80100834:	55                   	push   %ebp
80100835:	89 e5                	mov    %esp,%ebp
80100837:	57                   	push   %edi
80100838:	56                   	push   %esi
80100839:	53                   	push   %ebx
8010083a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010083d:	ff 75 08             	pushl  0x8(%ebp)
{
80100840:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100843:	e8 c8 14 00 00       	call   80101d10 <iunlock>
  acquire(&cons.lock);
80100848:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010084f:	e8 dc 41 00 00       	call   80104a30 <acquire>
  for(i = 0; i < n; i++)
80100854:	83 c4 10             	add    $0x10,%esp
80100857:	85 db                	test   %ebx,%ebx
80100859:	7e 24                	jle    8010087f <consolewrite+0x4f>
8010085b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010085e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100861:	8b 15 5c a5 10 80    	mov    0x8010a55c,%edx
80100867:	85 d2                	test   %edx,%edx
80100869:	74 05                	je     80100870 <consolewrite+0x40>
8010086b:	fa                   	cli    
    for(;;)
8010086c:	eb fe                	jmp    8010086c <consolewrite+0x3c>
8010086e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100870:	0f b6 07             	movzbl (%edi),%eax
80100873:	83 c7 01             	add    $0x1,%edi
80100876:	e8 95 fb ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010087b:	39 fe                	cmp    %edi,%esi
8010087d:	75 e2                	jne    80100861 <consolewrite+0x31>
  release(&cons.lock);
8010087f:	83 ec 0c             	sub    $0xc,%esp
80100882:	68 20 a5 10 80       	push   $0x8010a520
80100887:	e8 64 42 00 00       	call   80104af0 <release>
  ilock(ip);
8010088c:	58                   	pop    %eax
8010088d:	ff 75 08             	pushl  0x8(%ebp)
80100890:	e8 9b 13 00 00       	call   80101c30 <ilock>

  return n;
}
80100895:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100898:	89 d8                	mov    %ebx,%eax
8010089a:	5b                   	pop    %ebx
8010089b:	5e                   	pop    %esi
8010089c:	5f                   	pop    %edi
8010089d:	5d                   	pop    %ebp
8010089e:	c3                   	ret    
8010089f:	90                   	nop

801008a0 <cprintf>:
{
801008a0:	f3 0f 1e fb          	endbr32 
801008a4:	55                   	push   %ebp
801008a5:	89 e5                	mov    %esp,%ebp
801008a7:	57                   	push   %edi
801008a8:	56                   	push   %esi
801008a9:	53                   	push   %ebx
801008aa:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801008ad:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801008b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801008b5:	85 c0                	test   %eax,%eax
801008b7:	0f 85 e8 00 00 00    	jne    801009a5 <cprintf+0x105>
  if (fmt == 0)
801008bd:	8b 45 08             	mov    0x8(%ebp),%eax
801008c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801008c3:	85 c0                	test   %eax,%eax
801008c5:	0f 84 5a 01 00 00    	je     80100a25 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008cb:	0f b6 00             	movzbl (%eax),%eax
801008ce:	85 c0                	test   %eax,%eax
801008d0:	74 36                	je     80100908 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801008d2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008d5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801008d7:	83 f8 25             	cmp    $0x25,%eax
801008da:	74 44                	je     80100920 <cprintf+0x80>
  if(panicked){
801008dc:	8b 0d 5c a5 10 80    	mov    0x8010a55c,%ecx
801008e2:	85 c9                	test   %ecx,%ecx
801008e4:	74 0f                	je     801008f5 <cprintf+0x55>
801008e6:	fa                   	cli    
    for(;;)
801008e7:	eb fe                	jmp    801008e7 <cprintf+0x47>
801008e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801008f0:	b8 25 00 00 00       	mov    $0x25,%eax
801008f5:	e8 16 fb ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801008fd:	83 c6 01             	add    $0x1,%esi
80100900:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100904:	85 c0                	test   %eax,%eax
80100906:	75 cf                	jne    801008d7 <cprintf+0x37>
  if(locking)
80100908:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010090b:	85 c0                	test   %eax,%eax
8010090d:	0f 85 fd 00 00 00    	jne    80100a10 <cprintf+0x170>
}
80100913:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100916:	5b                   	pop    %ebx
80100917:	5e                   	pop    %esi
80100918:	5f                   	pop    %edi
80100919:	5d                   	pop    %ebp
8010091a:	c3                   	ret    
8010091b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010091f:	90                   	nop
    c = fmt[++i] & 0xff;
80100920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100923:	83 c6 01             	add    $0x1,%esi
80100926:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010092a:	85 ff                	test   %edi,%edi
8010092c:	74 da                	je     80100908 <cprintf+0x68>
    switch(c){
8010092e:	83 ff 70             	cmp    $0x70,%edi
80100931:	74 5a                	je     8010098d <cprintf+0xed>
80100933:	7f 2a                	jg     8010095f <cprintf+0xbf>
80100935:	83 ff 25             	cmp    $0x25,%edi
80100938:	0f 84 92 00 00 00    	je     801009d0 <cprintf+0x130>
8010093e:	83 ff 64             	cmp    $0x64,%edi
80100941:	0f 85 a1 00 00 00    	jne    801009e8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100947:	8b 03                	mov    (%ebx),%eax
80100949:	8d 7b 04             	lea    0x4(%ebx),%edi
8010094c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100951:	ba 0a 00 00 00       	mov    $0xa,%edx
80100956:	89 fb                	mov    %edi,%ebx
80100958:	e8 c3 fc ff ff       	call   80100620 <printint>
      break;
8010095d:	eb 9b                	jmp    801008fa <cprintf+0x5a>
    switch(c){
8010095f:	83 ff 73             	cmp    $0x73,%edi
80100962:	75 24                	jne    80100988 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100964:	8d 7b 04             	lea    0x4(%ebx),%edi
80100967:	8b 1b                	mov    (%ebx),%ebx
80100969:	85 db                	test   %ebx,%ebx
8010096b:	75 55                	jne    801009c2 <cprintf+0x122>
        s = "(null)";
8010096d:	bb 18 76 10 80       	mov    $0x80107618,%ebx
      for(; *s; s++)
80100972:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100977:	8b 15 5c a5 10 80    	mov    0x8010a55c,%edx
8010097d:	85 d2                	test   %edx,%edx
8010097f:	74 39                	je     801009ba <cprintf+0x11a>
80100981:	fa                   	cli    
    for(;;)
80100982:	eb fe                	jmp    80100982 <cprintf+0xe2>
80100984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100988:	83 ff 78             	cmp    $0x78,%edi
8010098b:	75 5b                	jne    801009e8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010098d:	8b 03                	mov    (%ebx),%eax
8010098f:	8d 7b 04             	lea    0x4(%ebx),%edi
80100992:	31 c9                	xor    %ecx,%ecx
80100994:	ba 10 00 00 00       	mov    $0x10,%edx
80100999:	89 fb                	mov    %edi,%ebx
8010099b:	e8 80 fc ff ff       	call   80100620 <printint>
      break;
801009a0:	e9 55 ff ff ff       	jmp    801008fa <cprintf+0x5a>
    acquire(&cons.lock);
801009a5:	83 ec 0c             	sub    $0xc,%esp
801009a8:	68 20 a5 10 80       	push   $0x8010a520
801009ad:	e8 7e 40 00 00       	call   80104a30 <acquire>
801009b2:	83 c4 10             	add    $0x10,%esp
801009b5:	e9 03 ff ff ff       	jmp    801008bd <cprintf+0x1d>
801009ba:	e8 51 fa ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801009bf:	83 c3 01             	add    $0x1,%ebx
801009c2:	0f be 03             	movsbl (%ebx),%eax
801009c5:	84 c0                	test   %al,%al
801009c7:	75 ae                	jne    80100977 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801009c9:	89 fb                	mov    %edi,%ebx
801009cb:	e9 2a ff ff ff       	jmp    801008fa <cprintf+0x5a>
  if(panicked){
801009d0:	8b 3d 5c a5 10 80    	mov    0x8010a55c,%edi
801009d6:	85 ff                	test   %edi,%edi
801009d8:	0f 84 12 ff ff ff    	je     801008f0 <cprintf+0x50>
801009de:	fa                   	cli    
    for(;;)
801009df:	eb fe                	jmp    801009df <cprintf+0x13f>
801009e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801009e8:	8b 0d 5c a5 10 80    	mov    0x8010a55c,%ecx
801009ee:	85 c9                	test   %ecx,%ecx
801009f0:	74 06                	je     801009f8 <cprintf+0x158>
801009f2:	fa                   	cli    
    for(;;)
801009f3:	eb fe                	jmp    801009f3 <cprintf+0x153>
801009f5:	8d 76 00             	lea    0x0(%esi),%esi
801009f8:	b8 25 00 00 00       	mov    $0x25,%eax
801009fd:	e8 0e fa ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100a02:	8b 15 5c a5 10 80    	mov    0x8010a55c,%edx
80100a08:	85 d2                	test   %edx,%edx
80100a0a:	74 2c                	je     80100a38 <cprintf+0x198>
80100a0c:	fa                   	cli    
    for(;;)
80100a0d:	eb fe                	jmp    80100a0d <cprintf+0x16d>
80100a0f:	90                   	nop
    release(&cons.lock);
80100a10:	83 ec 0c             	sub    $0xc,%esp
80100a13:	68 20 a5 10 80       	push   $0x8010a520
80100a18:	e8 d3 40 00 00       	call   80104af0 <release>
80100a1d:	83 c4 10             	add    $0x10,%esp
}
80100a20:	e9 ee fe ff ff       	jmp    80100913 <cprintf+0x73>
    panic("null fmt");
80100a25:	83 ec 0c             	sub    $0xc,%esp
80100a28:	68 1f 76 10 80       	push   $0x8010761f
80100a2d:	e8 5e f9 ff ff       	call   80100390 <panic>
80100a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100a38:	89 f8                	mov    %edi,%eax
80100a3a:	e8 d1 f9 ff ff       	call   80100410 <consputc.part.0>
80100a3f:	e9 b6 fe ff ff       	jmp    801008fa <cprintf+0x5a>
80100a44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a4f:	90                   	nop

80100a50 <consoleintr>:
{
80100a50:	f3 0f 1e fb          	endbr32 
80100a54:	55                   	push   %ebp
80100a55:	89 e5                	mov    %esp,%ebp
80100a57:	57                   	push   %edi
80100a58:	56                   	push   %esi
80100a59:	53                   	push   %ebx
  int c, doprocdump = 0;
80100a5a:	31 db                	xor    %ebx,%ebx
{
80100a5c:	83 ec 28             	sub    $0x28,%esp
80100a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
80100a62:	68 20 a5 10 80       	push   $0x8010a520
{
80100a67:	89 45 dc             	mov    %eax,-0x24(%ebp)
  acquire(&cons.lock);
80100a6a:	e8 c1 3f 00 00       	call   80104a30 <acquire>
  while((c = getc()) >= 0){
80100a6f:	83 c4 10             	add    $0x10,%esp
80100a72:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100a75:	ff d0                	call   *%eax
80100a77:	89 c6                	mov    %eax,%esi
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	0f 88 bc 02 00 00    	js     80100d3d <consoleintr+0x2ed>
    switch(c){
80100a81:	83 fe 15             	cmp    $0x15,%esi
80100a84:	7f 5a                	jg     80100ae0 <consoleintr+0x90>
80100a86:	83 fe 01             	cmp    $0x1,%esi
80100a89:	0f 8e b1 01 00 00    	jle    80100c40 <consoleintr+0x1f0>
80100a8f:	83 fe 15             	cmp    $0x15,%esi
80100a92:	0f 87 a8 01 00 00    	ja     80100c40 <consoleintr+0x1f0>
80100a98:	3e ff 24 b5 30 76 10 	notrack jmp *-0x7fef89d0(,%esi,4)
80100a9f:	80 
80100aa0:	bb 01 00 00 00       	mov    $0x1,%ebx
80100aa5:	eb cb                	jmp    80100a72 <consoleintr+0x22>
80100aa7:	b8 00 01 00 00       	mov    $0x100,%eax
80100aac:	e8 5f f9 ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
80100ab1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100ab6:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100abc:	74 b4                	je     80100a72 <consoleintr+0x22>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100abe:	83 e8 01             	sub    $0x1,%eax
80100ac1:	89 c2                	mov    %eax,%edx
80100ac3:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100ac6:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100acd:	74 a3                	je     80100a72 <consoleintr+0x22>
        input.e--;
80100acf:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100ad4:	a1 5c a5 10 80       	mov    0x8010a55c,%eax
80100ad9:	85 c0                	test   %eax,%eax
80100adb:	74 ca                	je     80100aa7 <consoleintr+0x57>
80100add:	fa                   	cli    
    for(;;)
80100ade:	eb fe                	jmp    80100ade <consoleintr+0x8e>
    switch(c){
80100ae0:	81 fe e2 00 00 00    	cmp    $0xe2,%esi
80100ae6:	0f 84 24 02 00 00    	je     80100d10 <consoleintr+0x2c0>
80100aec:	81 fe e3 00 00 00    	cmp    $0xe3,%esi
80100af2:	75 34                	jne    80100b28 <consoleintr+0xd8>
      if ((history.count != 0 ) && (history.last - history.index > 0))
80100af4:	a1 3c 05 11 80       	mov    0x8011053c,%eax
80100af9:	85 c0                	test   %eax,%eax
80100afb:	0f 84 71 ff ff ff    	je     80100a72 <consoleintr+0x22>
80100b01:	a1 40 05 11 80       	mov    0x80110540,%eax
80100b06:	2b 05 38 05 11 80    	sub    0x80110538,%eax
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	0f 8e 5e ff ff ff    	jle    80100a72 <consoleintr+0x22>
        arrow(DOWN);
80100b14:	b8 01 00 00 00       	mov    $0x1,%eax
80100b19:	e8 a2 fb ff ff       	call   801006c0 <arrow>
80100b1e:	e9 4f ff ff ff       	jmp    80100a72 <consoleintr+0x22>
80100b23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b27:	90                   	nop
    switch(c){
80100b28:	83 fe 7f             	cmp    $0x7f,%esi
80100b2b:	0f 85 17 01 00 00    	jne    80100c48 <consoleintr+0x1f8>
      if(input.e != input.w){
80100b31:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100b36:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100b3c:	0f 84 30 ff ff ff    	je     80100a72 <consoleintr+0x22>
        input.e--;  
80100b42:	83 e8 01             	sub    $0x1,%eax
80100b45:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100b4a:	a1 5c a5 10 80       	mov    0x8010a55c,%eax
80100b4f:	85 c0                	test   %eax,%eax
80100b51:	0f 84 06 02 00 00    	je     80100d5d <consoleintr+0x30d>
80100b57:	fa                   	cli    
    for(;;)
80100b58:	eb fe                	jmp    80100b58 <consoleintr+0x108>
      if (backs > 0) {
80100b5a:	a1 58 a5 10 80       	mov    0x8010a558,%eax
80100b5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100b62:	85 c0                	test   %eax,%eax
80100b64:	0f 8e 08 ff ff ff    	jle    80100a72 <consoleintr+0x22>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b6a:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100b6f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100b74:	89 fa                	mov    %edi,%edx
80100b76:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b77:	be d5 03 00 00       	mov    $0x3d5,%esi
80100b7c:	89 f2                	mov    %esi,%edx
80100b7e:	ec                   	in     (%dx),%al
80100b7f:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b82:	89 fa                	mov    %edi,%edx
80100b84:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT + 1) << 8;
80100b89:	c1 e1 08             	shl    $0x8,%ecx
80100b8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b8d:	89 f2                	mov    %esi,%edx
80100b8f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100b90:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b93:	89 fa                	mov    %edi,%edx
80100b95:	09 c1                	or     %eax,%ecx
80100b97:	b8 0e 00 00 00       	mov    $0xe,%eax
    pos++;
80100b9c:	83 c1 01             	add    $0x1,%ecx
80100b9f:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100ba0:	89 ca                	mov    %ecx,%edx
80100ba2:	c1 fa 08             	sar    $0x8,%edx
80100ba5:	89 d0                	mov    %edx,%eax
80100ba7:	89 f2                	mov    %esi,%edx
80100ba9:	ee                   	out    %al,(%dx)
80100baa:	b8 0f 00 00 00       	mov    $0xf,%eax
80100baf:	89 fa                	mov    %edi,%edx
80100bb1:	ee                   	out    %al,(%dx)
80100bb2:	89 c8                	mov    %ecx,%eax
80100bb4:	89 f2                	mov    %esi,%edx
80100bb6:	ee                   	out    %al,(%dx)
        backs--;
80100bb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100bba:	83 e8 01             	sub    $0x1,%eax
80100bbd:	a3 58 a5 10 80       	mov    %eax,0x8010a558
80100bc2:	e9 ab fe ff ff       	jmp    80100a72 <consoleintr+0x22>
      if ((input.e - backs) > input.w)
80100bc7:	a1 58 a5 10 80       	mov    0x8010a558,%eax
80100bcc:	8b 3d a8 ff 10 80    	mov    0x8010ffa8,%edi
80100bd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100bd5:	29 c7                	sub    %eax,%edi
80100bd7:	3b 3d a4 ff 10 80    	cmp    0x8010ffa4,%edi
80100bdd:	0f 86 8f fe ff ff    	jbe    80100a72 <consoleintr+0x22>
80100be3:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100be8:	b8 0e 00 00 00       	mov    $0xe,%eax
80100bed:	89 fa                	mov    %edi,%edx
80100bef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100bf0:	be d5 03 00 00       	mov    $0x3d5,%esi
80100bf5:	89 f2                	mov    %esi,%edx
80100bf7:	ec                   	in     (%dx),%al
80100bf8:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100bfb:	89 fa                	mov    %edi,%edx
80100bfd:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT + 1) << 8;
80100c02:	c1 e1 08             	shl    $0x8,%ecx
80100c05:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c06:	89 f2                	mov    %esi,%edx
80100c08:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100c09:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c0c:	89 fa                	mov    %edi,%edx
80100c0e:	09 c1                	or     %eax,%ecx
80100c10:	b8 0e 00 00 00       	mov    $0xe,%eax
    pos--;
80100c15:	83 e9 01             	sub    $0x1,%ecx
80100c18:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100c19:	89 ca                	mov    %ecx,%edx
80100c1b:	c1 fa 08             	sar    $0x8,%edx
80100c1e:	89 d0                	mov    %edx,%eax
80100c20:	89 f2                	mov    %esi,%edx
80100c22:	ee                   	out    %al,(%dx)
80100c23:	b8 0f 00 00 00       	mov    $0xf,%eax
80100c28:	89 fa                	mov    %edi,%edx
80100c2a:	ee                   	out    %al,(%dx)
80100c2b:	89 c8                	mov    %ecx,%eax
80100c2d:	89 f2                	mov    %esi,%edx
80100c2f:	ee                   	out    %al,(%dx)
        backs++;
80100c30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c33:	83 c0 01             	add    $0x1,%eax
80100c36:	a3 58 a5 10 80       	mov    %eax,0x8010a558
80100c3b:	e9 32 fe ff ff       	jmp    80100a72 <consoleintr+0x22>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100c40:	85 f6                	test   %esi,%esi
80100c42:	0f 84 2a fe ff ff    	je     80100a72 <consoleintr+0x22>
80100c48:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100c4d:	89 c2                	mov    %eax,%edx
80100c4f:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100c55:	83 fa 7f             	cmp    $0x7f,%edx
80100c58:	0f 87 14 fe ff ff    	ja     80100a72 <consoleintr+0x22>
        c = (c == '\r') ? '\n' : c;
80100c5e:	8d 48 01             	lea    0x1(%eax),%ecx
80100c61:	8b 15 5c a5 10 80    	mov    0x8010a55c,%edx
80100c67:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
80100c6a:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
80100c70:	83 fe 0d             	cmp    $0xd,%esi
80100c73:	0f 84 f3 00 00 00    	je     80100d6c <consoleintr+0x31c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100c79:	89 f1                	mov    %esi,%ecx
80100c7b:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
  if(panicked){
80100c81:	85 d2                	test   %edx,%edx
80100c83:	0f 84 d7 01 00 00    	je     80100e60 <consoleintr+0x410>
  asm volatile("cli");
80100c89:	fa                   	cli    
    for(;;)
80100c8a:	eb fe                	jmp    80100c8a <consoleintr+0x23a>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c8c:	be d4 03 00 00       	mov    $0x3d4,%esi
80100c91:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c96:	89 f2                	mov    %esi,%edx
80100c98:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c99:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100c9e:	89 ca                	mov    %ecx,%edx
80100ca0:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100ca1:	b8 0f 00 00 00       	mov    $0xf,%eax
80100ca6:	89 f2                	mov    %esi,%edx
80100ca8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100ca9:	89 ca                	mov    %ecx,%edx
80100cab:	ec                   	in     (%dx),%al
80100cac:	be d0 07 00 00       	mov    $0x7d0,%esi
  if(panicked){
80100cb1:	8b 3d 5c a5 10 80    	mov    0x8010a55c,%edi
80100cb7:	85 ff                	test   %edi,%edi
80100cb9:	74 05                	je     80100cc0 <consoleintr+0x270>
  asm volatile("cli");
80100cbb:	fa                   	cli    
    for(;;)
80100cbc:	eb fe                	jmp    80100cbc <consoleintr+0x26c>
80100cbe:	66 90                	xchg   %ax,%ax
80100cc0:	b8 00 01 00 00       	mov    $0x100,%eax
80100cc5:	e8 46 f7 ff ff       	call   80100410 <consputc.part.0>
  for (int pos = 0; pos < SCREEN_SIZE ; pos++){
80100cca:	83 ee 01             	sub    $0x1,%esi
80100ccd:	75 e2                	jne    80100cb1 <consoleintr+0x261>
  if(panicked){
80100ccf:	8b 0d 5c a5 10 80    	mov    0x8010a55c,%ecx
  backs = 0;
80100cd5:	c7 05 58 a5 10 80 00 	movl   $0x0,0x8010a558
80100cdc:	00 00 00 
  input.e = input.w = input.r = 0;
80100cdf:	c7 05 a0 ff 10 80 00 	movl   $0x0,0x8010ffa0
80100ce6:	00 00 00 
80100ce9:	c7 05 a4 ff 10 80 00 	movl   $0x0,0x8010ffa4
80100cf0:	00 00 00 
80100cf3:	c7 05 a8 ff 10 80 00 	movl   $0x0,0x8010ffa8
80100cfa:	00 00 00 
  if(panicked){
80100cfd:	85 c9                	test   %ecx,%ecx
80100cff:	0f 84 fb 00 00 00    	je     80100e00 <consoleintr+0x3b0>
80100d05:	fa                   	cli    
    for(;;)
80100d06:	eb fe                	jmp    80100d06 <consoleintr+0x2b6>
80100d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d0f:	90                   	nop
      if ((history.count != 0)  && (history.last - history.index < history.count))
80100d10:	8b 15 3c 05 11 80    	mov    0x8011053c,%edx
80100d16:	85 d2                	test   %edx,%edx
80100d18:	0f 84 54 fd ff ff    	je     80100a72 <consoleintr+0x22>
80100d1e:	a1 40 05 11 80       	mov    0x80110540,%eax
80100d23:	2b 05 38 05 11 80    	sub    0x80110538,%eax
80100d29:	39 c2                	cmp    %eax,%edx
80100d2b:	0f 8e 41 fd ff ff    	jle    80100a72 <consoleintr+0x22>
        arrow(UP);
80100d31:	31 c0                	xor    %eax,%eax
80100d33:	e8 88 f9 ff ff       	call   801006c0 <arrow>
80100d38:	e9 35 fd ff ff       	jmp    80100a72 <consoleintr+0x22>
  release(&cons.lock);
80100d3d:	83 ec 0c             	sub    $0xc,%esp
80100d40:	68 20 a5 10 80       	push   $0x8010a520
80100d45:	e8 a6 3d 00 00       	call   80104af0 <release>
  if(doprocdump) {
80100d4a:	83 c4 10             	add    $0x10,%esp
80100d4d:	85 db                	test   %ebx,%ebx
80100d4f:	0f 85 40 01 00 00    	jne    80100e95 <consoleintr+0x445>
}
80100d55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d58:	5b                   	pop    %ebx
80100d59:	5e                   	pop    %esi
80100d5a:	5f                   	pop    %edi
80100d5b:	5d                   	pop    %ebp
80100d5c:	c3                   	ret    
80100d5d:	b8 00 01 00 00       	mov    $0x100,%eax
80100d62:	e8 a9 f6 ff ff       	call   80100410 <consputc.part.0>
80100d67:	e9 06 fd ff ff       	jmp    80100a72 <consoleintr+0x22>
        input.buf[input.e++ % INPUT_BUF] = c;
80100d6c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
80100d73:	85 d2                	test   %edx,%edx
80100d75:	0f 85 0e ff ff ff    	jne    80100c89 <consoleintr+0x239>
80100d7b:	b8 0a 00 00 00       	mov    $0xa,%eax
80100d80:	e8 8b f6 ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100d85:	8b 15 a8 ff 10 80    	mov    0x8010ffa8,%edx
          if (history.count < 9){
80100d8b:	a1 3c 05 11 80       	mov    0x8011053c,%eax
80100d90:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100d93:	83 f8 08             	cmp    $0x8,%eax
80100d96:	0f 8f 05 01 00 00    	jg     80100ea1 <consoleintr+0x451>
            history.hist[history.last + 1] = input;
80100d9c:	8b 3d 40 05 11 80    	mov    0x80110540,%edi
80100da2:	b9 23 00 00 00       	mov    $0x23,%ecx
80100da7:	be 20 ff 10 80       	mov    $0x8010ff20,%esi
80100dac:	83 c7 01             	add    $0x1,%edi
80100daf:	69 c7 8c 00 00 00    	imul   $0x8c,%edi,%eax
80100db5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80100db8:	05 c0 ff 10 80       	add    $0x8010ffc0,%eax
80100dbd:	89 c7                	mov    %eax,%edi
            history.count ++ ;
80100dbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
            history.hist[history.last + 1] = input;
80100dc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            history.last ++ ;
80100dc4:	8b 7d e0             	mov    -0x20(%ebp),%edi
            history.count ++ ;
80100dc7:	83 c0 01             	add    $0x1,%eax
            history.last ++ ;
80100dca:	89 3d 40 05 11 80    	mov    %edi,0x80110540
            history.index = history.last;
80100dd0:	89 3d 38 05 11 80    	mov    %edi,0x80110538
            history.count ++ ;
80100dd6:	a3 3c 05 11 80       	mov    %eax,0x8011053c
          wakeup(&input.r);
80100ddb:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100dde:	89 15 a4 ff 10 80    	mov    %edx,0x8010ffa4
          wakeup(&input.r);
80100de4:	68 a0 ff 10 80       	push   $0x8010ffa0
          backs = 0;
80100de9:	c7 05 58 a5 10 80 00 	movl   $0x0,0x8010a558
80100df0:	00 00 00 
          wakeup(&input.r);
80100df3:	e8 b8 37 00 00       	call   801045b0 <wakeup>
80100df8:	83 c4 10             	add    $0x10,%esp
80100dfb:	e9 72 fc ff ff       	jmp    80100a72 <consoleintr+0x22>
80100e00:	b8 24 00 00 00       	mov    $0x24,%eax
80100e05:	e8 06 f6 ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100e0a:	8b 15 5c a5 10 80    	mov    0x8010a55c,%edx
80100e10:	85 d2                	test   %edx,%edx
80100e12:	74 0c                	je     80100e20 <consoleintr+0x3d0>
80100e14:	fa                   	cli    
    for(;;)
80100e15:	eb fe                	jmp    80100e15 <consoleintr+0x3c5>
80100e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e1e:	66 90                	xchg   %ax,%ax
80100e20:	b8 20 00 00 00       	mov    $0x20,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100e25:	be d4 03 00 00       	mov    $0x3d4,%esi
80100e2a:	e8 e1 f5 ff ff       	call   80100410 <consputc.part.0>
80100e2f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100e34:	89 f2                	mov    %esi,%edx
80100e36:	ee                   	out    %al,(%dx)
80100e37:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100e3c:	31 c0                	xor    %eax,%eax
80100e3e:	89 ca                	mov    %ecx,%edx
80100e40:	ee                   	out    %al,(%dx)
80100e41:	b8 0f 00 00 00       	mov    $0xf,%eax
80100e46:	89 f2                	mov    %esi,%edx
80100e48:	ee                   	out    %al,(%dx)
80100e49:	b8 02 00 00 00       	mov    $0x2,%eax
80100e4e:	89 ca                	mov    %ecx,%edx
80100e50:	ee                   	out    %al,(%dx)
}
80100e51:	e9 1c fc ff ff       	jmp    80100a72 <consoleintr+0x22>
80100e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e5d:	8d 76 00             	lea    0x0(%esi),%esi
80100e60:	89 f0                	mov    %esi,%eax
80100e62:	e8 a9 f5 ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100e67:	83 fe 0a             	cmp    $0xa,%esi
80100e6a:	0f 84 15 ff ff ff    	je     80100d85 <consoleintr+0x335>
80100e70:	83 fe 04             	cmp    $0x4,%esi
80100e73:	0f 84 0c ff ff ff    	je     80100d85 <consoleintr+0x335>
80100e79:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
80100e7e:	8d 90 80 00 00 00    	lea    0x80(%eax),%edx
80100e84:	39 15 a8 ff 10 80    	cmp    %edx,0x8010ffa8
80100e8a:	0f 85 e2 fb ff ff    	jne    80100a72 <consoleintr+0x22>
80100e90:	e9 f6 fe ff ff       	jmp    80100d8b <consoleintr+0x33b>
}
80100e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e98:	5b                   	pop    %ebx
80100e99:	5e                   	pop    %esi
80100e9a:	5f                   	pop    %edi
80100e9b:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100e9c:	e9 ff 37 00 00       	jmp    801046a0 <procdump>
80100ea1:	b8 c0 ff 10 80       	mov    $0x8010ffc0,%eax
              history.hist[h] = history.hist[h+1]; 
80100ea6:	8d b0 8c 00 00 00    	lea    0x8c(%eax),%esi
80100eac:	89 c7                	mov    %eax,%edi
80100eae:	b9 23 00 00 00       	mov    $0x23,%ecx
80100eb3:	05 8c 00 00 00       	add    $0x8c,%eax
80100eb8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            for (int h = 0; h < 9; h++) {
80100eba:	bf ac 04 11 80       	mov    $0x801104ac,%edi
80100ebf:	39 c7                	cmp    %eax,%edi
80100ec1:	75 e3                	jne    80100ea6 <consoleintr+0x456>
            history.hist[9] = input;
80100ec3:	b9 23 00 00 00       	mov    $0x23,%ecx
80100ec8:	be 20 ff 10 80       	mov    $0x8010ff20,%esi
            history.index = 9;
80100ecd:	c7 05 38 05 11 80 09 	movl   $0x9,0x80110538
80100ed4:	00 00 00 
            history.hist[9] = input;
80100ed7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            history.last = 9;
80100ed9:	c7 05 40 05 11 80 09 	movl   $0x9,0x80110540
80100ee0:	00 00 00 
            history.count = 10;
80100ee3:	c7 05 3c 05 11 80 0a 	movl   $0xa,0x8011053c
80100eea:	00 00 00 
80100eed:	e9 e9 fe ff ff       	jmp    80100ddb <consoleintr+0x38b>
80100ef2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f00 <consoleinit>:

void
consoleinit(void)
{
80100f00:	f3 0f 1e fb          	endbr32 
80100f04:	55                   	push   %ebp
80100f05:	89 e5                	mov    %esp,%ebp
80100f07:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100f0a:	68 28 76 10 80       	push   $0x80107628
80100f0f:	68 20 a5 10 80       	push   $0x8010a520
80100f14:	e8 97 39 00 00       	call   801048b0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100f19:	58                   	pop    %eax
80100f1a:	5a                   	pop    %edx
80100f1b:	6a 00                	push   $0x0
80100f1d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100f1f:	c7 05 0c 0f 11 80 30 	movl   $0x80100830,0x80110f0c
80100f26:	08 10 80 
  devsw[CONSOLE].read = consoleread;
80100f29:	c7 05 08 0f 11 80 90 	movl   $0x80100290,0x80110f08
80100f30:	02 10 80 
  cons.locking = 1;
80100f33:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100f3a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100f3d:	e8 be 19 00 00       	call   80102900 <ioapicenable>
}
80100f42:	83 c4 10             	add    $0x10,%esp
80100f45:	c9                   	leave  
80100f46:	c3                   	ret    
80100f47:	66 90                	xchg   %ax,%ax
80100f49:	66 90                	xchg   %ax,%ax
80100f4b:	66 90                	xchg   %ax,%ax
80100f4d:	66 90                	xchg   %ax,%ax
80100f4f:	90                   	nop

80100f50 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100f50:	f3 0f 1e fb          	endbr32 
80100f54:	55                   	push   %ebp
80100f55:	89 e5                	mov    %esp,%ebp
80100f57:	57                   	push   %edi
80100f58:	56                   	push   %esi
80100f59:	53                   	push   %ebx
80100f5a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100f60:	e8 cb 2e 00 00       	call   80103e30 <myproc>
80100f65:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100f6b:	e8 90 22 00 00       	call   80103200 <begin_op>

  if((ip = namei(path)) == 0){
80100f70:	83 ec 0c             	sub    $0xc,%esp
80100f73:	ff 75 08             	pushl  0x8(%ebp)
80100f76:	e8 85 15 00 00       	call   80102500 <namei>
80100f7b:	83 c4 10             	add    $0x10,%esp
80100f7e:	85 c0                	test   %eax,%eax
80100f80:	0f 84 fe 02 00 00    	je     80101284 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100f86:	83 ec 0c             	sub    $0xc,%esp
80100f89:	89 c3                	mov    %eax,%ebx
80100f8b:	50                   	push   %eax
80100f8c:	e8 9f 0c 00 00       	call   80101c30 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100f91:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100f97:	6a 34                	push   $0x34
80100f99:	6a 00                	push   $0x0
80100f9b:	50                   	push   %eax
80100f9c:	53                   	push   %ebx
80100f9d:	e8 8e 0f 00 00       	call   80101f30 <readi>
80100fa2:	83 c4 20             	add    $0x20,%esp
80100fa5:	83 f8 34             	cmp    $0x34,%eax
80100fa8:	74 26                	je     80100fd0 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100faa:	83 ec 0c             	sub    $0xc,%esp
80100fad:	53                   	push   %ebx
80100fae:	e8 1d 0f 00 00       	call   80101ed0 <iunlockput>
    end_op();
80100fb3:	e8 b8 22 00 00       	call   80103270 <end_op>
80100fb8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100fbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc3:	5b                   	pop    %ebx
80100fc4:	5e                   	pop    %esi
80100fc5:	5f                   	pop    %edi
80100fc6:	5d                   	pop    %ebp
80100fc7:	c3                   	ret    
80100fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcf:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100fd0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100fd7:	45 4c 46 
80100fda:	75 ce                	jne    80100faa <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100fdc:	e8 3f 63 00 00       	call   80107320 <setupkvm>
80100fe1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100fe7:	85 c0                	test   %eax,%eax
80100fe9:	74 bf                	je     80100faa <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100feb:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100ff2:	00 
80100ff3:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100ff9:	0f 84 a4 02 00 00    	je     801012a3 <exec+0x353>
  sz = 0;
80100fff:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101006:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101009:	31 ff                	xor    %edi,%edi
8010100b:	e9 86 00 00 00       	jmp    80101096 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80101010:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101017:	75 6c                	jne    80101085 <exec+0x135>
    if(ph.memsz < ph.filesz)
80101019:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010101f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101025:	0f 82 87 00 00 00    	jb     801010b2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
8010102b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101031:	72 7f                	jb     801010b2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101033:	83 ec 04             	sub    $0x4,%esp
80101036:	50                   	push   %eax
80101037:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
8010103d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101043:	e8 f8 60 00 00       	call   80107140 <allocuvm>
80101048:	83 c4 10             	add    $0x10,%esp
8010104b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101051:	85 c0                	test   %eax,%eax
80101053:	74 5d                	je     801010b2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101055:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010105b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101060:	75 50                	jne    801010b2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101062:	83 ec 0c             	sub    $0xc,%esp
80101065:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
8010106b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80101071:	53                   	push   %ebx
80101072:	50                   	push   %eax
80101073:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101079:	e8 f2 5f 00 00       	call   80107070 <loaduvm>
8010107e:	83 c4 20             	add    $0x20,%esp
80101081:	85 c0                	test   %eax,%eax
80101083:	78 2d                	js     801010b2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101085:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010108c:	83 c7 01             	add    $0x1,%edi
8010108f:	83 c6 20             	add    $0x20,%esi
80101092:	39 f8                	cmp    %edi,%eax
80101094:	7e 3a                	jle    801010d0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101096:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010109c:	6a 20                	push   $0x20
8010109e:	56                   	push   %esi
8010109f:	50                   	push   %eax
801010a0:	53                   	push   %ebx
801010a1:	e8 8a 0e 00 00       	call   80101f30 <readi>
801010a6:	83 c4 10             	add    $0x10,%esp
801010a9:	83 f8 20             	cmp    $0x20,%eax
801010ac:	0f 84 5e ff ff ff    	je     80101010 <exec+0xc0>
    freevm(pgdir);
801010b2:	83 ec 0c             	sub    $0xc,%esp
801010b5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801010bb:	e8 e0 61 00 00       	call   801072a0 <freevm>
  if(ip){
801010c0:	83 c4 10             	add    $0x10,%esp
801010c3:	e9 e2 fe ff ff       	jmp    80100faa <exec+0x5a>
801010c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010cf:	90                   	nop
801010d0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801010d6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
801010dc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801010e2:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
801010e8:	83 ec 0c             	sub    $0xc,%esp
801010eb:	53                   	push   %ebx
801010ec:	e8 df 0d 00 00       	call   80101ed0 <iunlockput>
  end_op();
801010f1:	e8 7a 21 00 00       	call   80103270 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801010f6:	83 c4 0c             	add    $0xc,%esp
801010f9:	56                   	push   %esi
801010fa:	57                   	push   %edi
801010fb:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101101:	57                   	push   %edi
80101102:	e8 39 60 00 00       	call   80107140 <allocuvm>
80101107:	83 c4 10             	add    $0x10,%esp
8010110a:	89 c6                	mov    %eax,%esi
8010110c:	85 c0                	test   %eax,%eax
8010110e:	0f 84 94 00 00 00    	je     801011a8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101114:	83 ec 08             	sub    $0x8,%esp
80101117:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
8010111d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010111f:	50                   	push   %eax
80101120:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80101121:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101123:	e8 98 62 00 00       	call   801073c0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101128:	8b 45 0c             	mov    0xc(%ebp),%eax
8010112b:	83 c4 10             	add    $0x10,%esp
8010112e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101134:	8b 00                	mov    (%eax),%eax
80101136:	85 c0                	test   %eax,%eax
80101138:	0f 84 8b 00 00 00    	je     801011c9 <exec+0x279>
8010113e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101144:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
8010114a:	eb 23                	jmp    8010116f <exec+0x21f>
8010114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101150:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101153:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010115a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010115d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101163:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101166:	85 c0                	test   %eax,%eax
80101168:	74 59                	je     801011c3 <exec+0x273>
    if(argc >= MAXARG)
8010116a:	83 ff 20             	cmp    $0x20,%edi
8010116d:	74 39                	je     801011a8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010116f:	83 ec 0c             	sub    $0xc,%esp
80101172:	50                   	push   %eax
80101173:	e8 c8 3b 00 00       	call   80104d40 <strlen>
80101178:	f7 d0                	not    %eax
8010117a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010117c:	58                   	pop    %eax
8010117d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101180:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101183:	ff 34 b8             	pushl  (%eax,%edi,4)
80101186:	e8 b5 3b 00 00       	call   80104d40 <strlen>
8010118b:	83 c0 01             	add    $0x1,%eax
8010118e:	50                   	push   %eax
8010118f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101192:	ff 34 b8             	pushl  (%eax,%edi,4)
80101195:	53                   	push   %ebx
80101196:	56                   	push   %esi
80101197:	e8 84 63 00 00       	call   80107520 <copyout>
8010119c:	83 c4 20             	add    $0x20,%esp
8010119f:	85 c0                	test   %eax,%eax
801011a1:	79 ad                	jns    80101150 <exec+0x200>
801011a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011a7:	90                   	nop
    freevm(pgdir);
801011a8:	83 ec 0c             	sub    $0xc,%esp
801011ab:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801011b1:	e8 ea 60 00 00       	call   801072a0 <freevm>
801011b6:	83 c4 10             	add    $0x10,%esp
  return -1;
801011b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011be:	e9 fd fd ff ff       	jmp    80100fc0 <exec+0x70>
801011c3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801011c9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
801011d0:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
801011d2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
801011d9:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801011dd:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
801011df:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
801011e2:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
801011e8:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801011ea:	50                   	push   %eax
801011eb:	52                   	push   %edx
801011ec:	53                   	push   %ebx
801011ed:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
801011f3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801011fa:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801011fd:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101203:	e8 18 63 00 00       	call   80107520 <copyout>
80101208:	83 c4 10             	add    $0x10,%esp
8010120b:	85 c0                	test   %eax,%eax
8010120d:	78 99                	js     801011a8 <exec+0x258>
  for(last=s=path; *s; s++)
8010120f:	8b 45 08             	mov    0x8(%ebp),%eax
80101212:	8b 55 08             	mov    0x8(%ebp),%edx
80101215:	0f b6 00             	movzbl (%eax),%eax
80101218:	84 c0                	test   %al,%al
8010121a:	74 13                	je     8010122f <exec+0x2df>
8010121c:	89 d1                	mov    %edx,%ecx
8010121e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80101220:	83 c1 01             	add    $0x1,%ecx
80101223:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101225:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80101228:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010122b:	84 c0                	test   %al,%al
8010122d:	75 f1                	jne    80101220 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010122f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101235:	83 ec 04             	sub    $0x4,%esp
80101238:	6a 10                	push   $0x10
8010123a:	89 f8                	mov    %edi,%eax
8010123c:	52                   	push   %edx
8010123d:	83 c0 6c             	add    $0x6c,%eax
80101240:	50                   	push   %eax
80101241:	e8 ba 3a 00 00       	call   80104d00 <safestrcpy>
  curproc->pgdir = pgdir;
80101246:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010124c:	89 f8                	mov    %edi,%eax
8010124e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101251:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101253:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101256:	89 c1                	mov    %eax,%ecx
80101258:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010125e:	8b 40 18             	mov    0x18(%eax),%eax
80101261:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101264:	8b 41 18             	mov    0x18(%ecx),%eax
80101267:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010126a:	89 0c 24             	mov    %ecx,(%esp)
8010126d:	e8 6e 5c 00 00       	call   80106ee0 <switchuvm>
  freevm(oldpgdir);
80101272:	89 3c 24             	mov    %edi,(%esp)
80101275:	e8 26 60 00 00       	call   801072a0 <freevm>
  return 0;
8010127a:	83 c4 10             	add    $0x10,%esp
8010127d:	31 c0                	xor    %eax,%eax
8010127f:	e9 3c fd ff ff       	jmp    80100fc0 <exec+0x70>
    end_op();
80101284:	e8 e7 1f 00 00       	call   80103270 <end_op>
    cprintf("exec: fail\n");
80101289:	83 ec 0c             	sub    $0xc,%esp
8010128c:	68 99 76 10 80       	push   $0x80107699
80101291:	e8 0a f6 ff ff       	call   801008a0 <cprintf>
    return -1;
80101296:	83 c4 10             	add    $0x10,%esp
80101299:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010129e:	e9 1d fd ff ff       	jmp    80100fc0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801012a3:	31 ff                	xor    %edi,%edi
801012a5:	be 00 20 00 00       	mov    $0x2000,%esi
801012aa:	e9 39 fe ff ff       	jmp    801010e8 <exec+0x198>
801012af:	90                   	nop

801012b0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801012b0:	f3 0f 1e fb          	endbr32 
801012b4:	55                   	push   %ebp
801012b5:	89 e5                	mov    %esp,%ebp
801012b7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801012ba:	68 a5 76 10 80       	push   $0x801076a5
801012bf:	68 60 05 11 80       	push   $0x80110560
801012c4:	e8 e7 35 00 00       	call   801048b0 <initlock>
}
801012c9:	83 c4 10             	add    $0x10,%esp
801012cc:	c9                   	leave  
801012cd:	c3                   	ret    
801012ce:	66 90                	xchg   %ax,%ax

801012d0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801012d0:	f3 0f 1e fb          	endbr32 
801012d4:	55                   	push   %ebp
801012d5:	89 e5                	mov    %esp,%ebp
801012d7:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801012d8:	bb 94 05 11 80       	mov    $0x80110594,%ebx
{
801012dd:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801012e0:	68 60 05 11 80       	push   $0x80110560
801012e5:	e8 46 37 00 00       	call   80104a30 <acquire>
801012ea:	83 c4 10             	add    $0x10,%esp
801012ed:	eb 0c                	jmp    801012fb <filealloc+0x2b>
801012ef:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801012f0:	83 c3 18             	add    $0x18,%ebx
801012f3:	81 fb f4 0e 11 80    	cmp    $0x80110ef4,%ebx
801012f9:	74 25                	je     80101320 <filealloc+0x50>
    if(f->ref == 0){
801012fb:	8b 43 04             	mov    0x4(%ebx),%eax
801012fe:	85 c0                	test   %eax,%eax
80101300:	75 ee                	jne    801012f0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101302:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101305:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010130c:	68 60 05 11 80       	push   $0x80110560
80101311:	e8 da 37 00 00       	call   80104af0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101316:	89 d8                	mov    %ebx,%eax
      return f;
80101318:	83 c4 10             	add    $0x10,%esp
}
8010131b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010131e:	c9                   	leave  
8010131f:	c3                   	ret    
  release(&ftable.lock);
80101320:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101323:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101325:	68 60 05 11 80       	push   $0x80110560
8010132a:	e8 c1 37 00 00       	call   80104af0 <release>
}
8010132f:	89 d8                	mov    %ebx,%eax
  return 0;
80101331:	83 c4 10             	add    $0x10,%esp
}
80101334:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101337:	c9                   	leave  
80101338:	c3                   	ret    
80101339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101340 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101340:	f3 0f 1e fb          	endbr32 
80101344:	55                   	push   %ebp
80101345:	89 e5                	mov    %esp,%ebp
80101347:	53                   	push   %ebx
80101348:	83 ec 10             	sub    $0x10,%esp
8010134b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010134e:	68 60 05 11 80       	push   $0x80110560
80101353:	e8 d8 36 00 00       	call   80104a30 <acquire>
  if(f->ref < 1)
80101358:	8b 43 04             	mov    0x4(%ebx),%eax
8010135b:	83 c4 10             	add    $0x10,%esp
8010135e:	85 c0                	test   %eax,%eax
80101360:	7e 1a                	jle    8010137c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80101362:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101365:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101368:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
8010136b:	68 60 05 11 80       	push   $0x80110560
80101370:	e8 7b 37 00 00       	call   80104af0 <release>
  return f;
}
80101375:	89 d8                	mov    %ebx,%eax
80101377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010137a:	c9                   	leave  
8010137b:	c3                   	ret    
    panic("filedup");
8010137c:	83 ec 0c             	sub    $0xc,%esp
8010137f:	68 ac 76 10 80       	push   $0x801076ac
80101384:	e8 07 f0 ff ff       	call   80100390 <panic>
80101389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101390 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101390:	f3 0f 1e fb          	endbr32 
80101394:	55                   	push   %ebp
80101395:	89 e5                	mov    %esp,%ebp
80101397:	57                   	push   %edi
80101398:	56                   	push   %esi
80101399:	53                   	push   %ebx
8010139a:	83 ec 28             	sub    $0x28,%esp
8010139d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801013a0:	68 60 05 11 80       	push   $0x80110560
801013a5:	e8 86 36 00 00       	call   80104a30 <acquire>
  if(f->ref < 1)
801013aa:	8b 53 04             	mov    0x4(%ebx),%edx
801013ad:	83 c4 10             	add    $0x10,%esp
801013b0:	85 d2                	test   %edx,%edx
801013b2:	0f 8e a1 00 00 00    	jle    80101459 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801013b8:	83 ea 01             	sub    $0x1,%edx
801013bb:	89 53 04             	mov    %edx,0x4(%ebx)
801013be:	75 40                	jne    80101400 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801013c0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801013c4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801013c7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801013c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801013cf:	8b 73 0c             	mov    0xc(%ebx),%esi
801013d2:	88 45 e7             	mov    %al,-0x19(%ebp)
801013d5:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801013d8:	68 60 05 11 80       	push   $0x80110560
  ff = *f;
801013dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801013e0:	e8 0b 37 00 00       	call   80104af0 <release>

  if(ff.type == FD_PIPE)
801013e5:	83 c4 10             	add    $0x10,%esp
801013e8:	83 ff 01             	cmp    $0x1,%edi
801013eb:	74 53                	je     80101440 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801013ed:	83 ff 02             	cmp    $0x2,%edi
801013f0:	74 26                	je     80101418 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801013f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f5:	5b                   	pop    %ebx
801013f6:	5e                   	pop    %esi
801013f7:	5f                   	pop    %edi
801013f8:	5d                   	pop    %ebp
801013f9:	c3                   	ret    
801013fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101400:	c7 45 08 60 05 11 80 	movl   $0x80110560,0x8(%ebp)
}
80101407:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010140a:	5b                   	pop    %ebx
8010140b:	5e                   	pop    %esi
8010140c:	5f                   	pop    %edi
8010140d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010140e:	e9 dd 36 00 00       	jmp    80104af0 <release>
80101413:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101417:	90                   	nop
    begin_op();
80101418:	e8 e3 1d 00 00       	call   80103200 <begin_op>
    iput(ff.ip);
8010141d:	83 ec 0c             	sub    $0xc,%esp
80101420:	ff 75 e0             	pushl  -0x20(%ebp)
80101423:	e8 38 09 00 00       	call   80101d60 <iput>
    end_op();
80101428:	83 c4 10             	add    $0x10,%esp
}
8010142b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010142e:	5b                   	pop    %ebx
8010142f:	5e                   	pop    %esi
80101430:	5f                   	pop    %edi
80101431:	5d                   	pop    %ebp
    end_op();
80101432:	e9 39 1e 00 00       	jmp    80103270 <end_op>
80101437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010143e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101440:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101444:	83 ec 08             	sub    $0x8,%esp
80101447:	53                   	push   %ebx
80101448:	56                   	push   %esi
80101449:	e8 82 25 00 00       	call   801039d0 <pipeclose>
8010144e:	83 c4 10             	add    $0x10,%esp
}
80101451:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101454:	5b                   	pop    %ebx
80101455:	5e                   	pop    %esi
80101456:	5f                   	pop    %edi
80101457:	5d                   	pop    %ebp
80101458:	c3                   	ret    
    panic("fileclose");
80101459:	83 ec 0c             	sub    $0xc,%esp
8010145c:	68 b4 76 10 80       	push   $0x801076b4
80101461:	e8 2a ef ff ff       	call   80100390 <panic>
80101466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010146d:	8d 76 00             	lea    0x0(%esi),%esi

80101470 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101470:	f3 0f 1e fb          	endbr32 
80101474:	55                   	push   %ebp
80101475:	89 e5                	mov    %esp,%ebp
80101477:	53                   	push   %ebx
80101478:	83 ec 04             	sub    $0x4,%esp
8010147b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010147e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101481:	75 2d                	jne    801014b0 <filestat+0x40>
    ilock(f->ip);
80101483:	83 ec 0c             	sub    $0xc,%esp
80101486:	ff 73 10             	pushl  0x10(%ebx)
80101489:	e8 a2 07 00 00       	call   80101c30 <ilock>
    stati(f->ip, st);
8010148e:	58                   	pop    %eax
8010148f:	5a                   	pop    %edx
80101490:	ff 75 0c             	pushl  0xc(%ebp)
80101493:	ff 73 10             	pushl  0x10(%ebx)
80101496:	e8 65 0a 00 00       	call   80101f00 <stati>
    iunlock(f->ip);
8010149b:	59                   	pop    %ecx
8010149c:	ff 73 10             	pushl  0x10(%ebx)
8010149f:	e8 6c 08 00 00       	call   80101d10 <iunlock>
    return 0;
  }
  return -1;
}
801014a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801014a7:	83 c4 10             	add    $0x10,%esp
801014aa:	31 c0                	xor    %eax,%eax
}
801014ac:	c9                   	leave  
801014ad:	c3                   	ret    
801014ae:	66 90                	xchg   %ax,%ax
801014b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801014b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801014b8:	c9                   	leave  
801014b9:	c3                   	ret    
801014ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801014c0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801014c0:	f3 0f 1e fb          	endbr32 
801014c4:	55                   	push   %ebp
801014c5:	89 e5                	mov    %esp,%ebp
801014c7:	57                   	push   %edi
801014c8:	56                   	push   %esi
801014c9:	53                   	push   %ebx
801014ca:	83 ec 0c             	sub    $0xc,%esp
801014cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
801014d0:	8b 75 0c             	mov    0xc(%ebp),%esi
801014d3:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801014d6:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801014da:	74 64                	je     80101540 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
801014dc:	8b 03                	mov    (%ebx),%eax
801014de:	83 f8 01             	cmp    $0x1,%eax
801014e1:	74 45                	je     80101528 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801014e3:	83 f8 02             	cmp    $0x2,%eax
801014e6:	75 5f                	jne    80101547 <fileread+0x87>
    ilock(f->ip);
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	ff 73 10             	pushl  0x10(%ebx)
801014ee:	e8 3d 07 00 00       	call   80101c30 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801014f3:	57                   	push   %edi
801014f4:	ff 73 14             	pushl  0x14(%ebx)
801014f7:	56                   	push   %esi
801014f8:	ff 73 10             	pushl  0x10(%ebx)
801014fb:	e8 30 0a 00 00       	call   80101f30 <readi>
80101500:	83 c4 20             	add    $0x20,%esp
80101503:	89 c6                	mov    %eax,%esi
80101505:	85 c0                	test   %eax,%eax
80101507:	7e 03                	jle    8010150c <fileread+0x4c>
      f->off += r;
80101509:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010150c:	83 ec 0c             	sub    $0xc,%esp
8010150f:	ff 73 10             	pushl  0x10(%ebx)
80101512:	e8 f9 07 00 00       	call   80101d10 <iunlock>
    return r;
80101517:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010151a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010151d:	89 f0                	mov    %esi,%eax
8010151f:	5b                   	pop    %ebx
80101520:	5e                   	pop    %esi
80101521:	5f                   	pop    %edi
80101522:	5d                   	pop    %ebp
80101523:	c3                   	ret    
80101524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101528:	8b 43 0c             	mov    0xc(%ebx),%eax
8010152b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010152e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101531:	5b                   	pop    %ebx
80101532:	5e                   	pop    %esi
80101533:	5f                   	pop    %edi
80101534:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101535:	e9 36 26 00 00       	jmp    80103b70 <piperead>
8010153a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101540:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101545:	eb d3                	jmp    8010151a <fileread+0x5a>
  panic("fileread");
80101547:	83 ec 0c             	sub    $0xc,%esp
8010154a:	68 be 76 10 80       	push   $0x801076be
8010154f:	e8 3c ee ff ff       	call   80100390 <panic>
80101554:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010155f:	90                   	nop

80101560 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101560:	f3 0f 1e fb          	endbr32 
80101564:	55                   	push   %ebp
80101565:	89 e5                	mov    %esp,%ebp
80101567:	57                   	push   %edi
80101568:	56                   	push   %esi
80101569:	53                   	push   %ebx
8010156a:	83 ec 1c             	sub    $0x1c,%esp
8010156d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101570:	8b 75 08             	mov    0x8(%ebp),%esi
80101573:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101576:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101579:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010157d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101580:	0f 84 c1 00 00 00    	je     80101647 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101586:	8b 06                	mov    (%esi),%eax
80101588:	83 f8 01             	cmp    $0x1,%eax
8010158b:	0f 84 c3 00 00 00    	je     80101654 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101591:	83 f8 02             	cmp    $0x2,%eax
80101594:	0f 85 cc 00 00 00    	jne    80101666 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010159a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010159d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010159f:	85 c0                	test   %eax,%eax
801015a1:	7f 34                	jg     801015d7 <filewrite+0x77>
801015a3:	e9 98 00 00 00       	jmp    80101640 <filewrite+0xe0>
801015a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015af:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801015b0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801015b3:	83 ec 0c             	sub    $0xc,%esp
801015b6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801015b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801015bc:	e8 4f 07 00 00       	call   80101d10 <iunlock>
      end_op();
801015c1:	e8 aa 1c 00 00       	call   80103270 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801015c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801015c9:	83 c4 10             	add    $0x10,%esp
801015cc:	39 c3                	cmp    %eax,%ebx
801015ce:	75 60                	jne    80101630 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
801015d0:	01 df                	add    %ebx,%edi
    while(i < n){
801015d2:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801015d5:	7e 69                	jle    80101640 <filewrite+0xe0>
      int n1 = n - i;
801015d7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801015da:	b8 00 06 00 00       	mov    $0x600,%eax
801015df:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
801015e1:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801015e7:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801015ea:	e8 11 1c 00 00       	call   80103200 <begin_op>
      ilock(f->ip);
801015ef:	83 ec 0c             	sub    $0xc,%esp
801015f2:	ff 76 10             	pushl  0x10(%esi)
801015f5:	e8 36 06 00 00       	call   80101c30 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801015fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
801015fd:	53                   	push   %ebx
801015fe:	ff 76 14             	pushl  0x14(%esi)
80101601:	01 f8                	add    %edi,%eax
80101603:	50                   	push   %eax
80101604:	ff 76 10             	pushl  0x10(%esi)
80101607:	e8 24 0a 00 00       	call   80102030 <writei>
8010160c:	83 c4 20             	add    $0x20,%esp
8010160f:	85 c0                	test   %eax,%eax
80101611:	7f 9d                	jg     801015b0 <filewrite+0x50>
      iunlock(f->ip);
80101613:	83 ec 0c             	sub    $0xc,%esp
80101616:	ff 76 10             	pushl  0x10(%esi)
80101619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010161c:	e8 ef 06 00 00       	call   80101d10 <iunlock>
      end_op();
80101621:	e8 4a 1c 00 00       	call   80103270 <end_op>
      if(r < 0)
80101626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101629:	83 c4 10             	add    $0x10,%esp
8010162c:	85 c0                	test   %eax,%eax
8010162e:	75 17                	jne    80101647 <filewrite+0xe7>
        panic("short filewrite");
80101630:	83 ec 0c             	sub    $0xc,%esp
80101633:	68 c7 76 10 80       	push   $0x801076c7
80101638:	e8 53 ed ff ff       	call   80100390 <panic>
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101640:	89 f8                	mov    %edi,%eax
80101642:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101645:	74 05                	je     8010164c <filewrite+0xec>
80101647:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010164c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010164f:	5b                   	pop    %ebx
80101650:	5e                   	pop    %esi
80101651:	5f                   	pop    %edi
80101652:	5d                   	pop    %ebp
80101653:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101654:	8b 46 0c             	mov    0xc(%esi),%eax
80101657:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010165a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010165d:	5b                   	pop    %ebx
8010165e:	5e                   	pop    %esi
8010165f:	5f                   	pop    %edi
80101660:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101661:	e9 0a 24 00 00       	jmp    80103a70 <pipewrite>
  panic("filewrite");
80101666:	83 ec 0c             	sub    $0xc,%esp
80101669:	68 cd 76 10 80       	push   $0x801076cd
8010166e:	e8 1d ed ff ff       	call   80100390 <panic>
80101673:	66 90                	xchg   %ax,%ax
80101675:	66 90                	xchg   %ax,%ax
80101677:	66 90                	xchg   %ax,%ax
80101679:	66 90                	xchg   %ax,%ax
8010167b:	66 90                	xchg   %ax,%ax
8010167d:	66 90                	xchg   %ax,%ax
8010167f:	90                   	nop

80101680 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101680:	55                   	push   %ebp
80101681:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101683:	89 d0                	mov    %edx,%eax
80101685:	c1 e8 0c             	shr    $0xc,%eax
80101688:	03 05 78 0f 11 80    	add    0x80110f78,%eax
{
8010168e:	89 e5                	mov    %esp,%ebp
80101690:	56                   	push   %esi
80101691:	53                   	push   %ebx
80101692:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101694:	83 ec 08             	sub    $0x8,%esp
80101697:	50                   	push   %eax
80101698:	51                   	push   %ecx
80101699:	e8 32 ea ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010169e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801016a0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801016a3:	ba 01 00 00 00       	mov    $0x1,%edx
801016a8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801016ab:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801016b1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801016b4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801016b6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801016bb:	85 d1                	test   %edx,%ecx
801016bd:	74 25                	je     801016e4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801016bf:	f7 d2                	not    %edx
  log_write(bp);
801016c1:	83 ec 0c             	sub    $0xc,%esp
801016c4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801016c6:	21 ca                	and    %ecx,%edx
801016c8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801016cc:	50                   	push   %eax
801016cd:	e8 0e 1d 00 00       	call   801033e0 <log_write>
  brelse(bp);
801016d2:	89 34 24             	mov    %esi,(%esp)
801016d5:	e8 16 eb ff ff       	call   801001f0 <brelse>
}
801016da:	83 c4 10             	add    $0x10,%esp
801016dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016e0:	5b                   	pop    %ebx
801016e1:	5e                   	pop    %esi
801016e2:	5d                   	pop    %ebp
801016e3:	c3                   	ret    
    panic("freeing free block");
801016e4:	83 ec 0c             	sub    $0xc,%esp
801016e7:	68 d7 76 10 80       	push   $0x801076d7
801016ec:	e8 9f ec ff ff       	call   80100390 <panic>
801016f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016ff:	90                   	nop

80101700 <balloc>:
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	57                   	push   %edi
80101704:	56                   	push   %esi
80101705:	53                   	push   %ebx
80101706:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101709:	8b 0d 60 0f 11 80    	mov    0x80110f60,%ecx
{
8010170f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101712:	85 c9                	test   %ecx,%ecx
80101714:	0f 84 87 00 00 00    	je     801017a1 <balloc+0xa1>
8010171a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101721:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101724:	83 ec 08             	sub    $0x8,%esp
80101727:	89 f0                	mov    %esi,%eax
80101729:	c1 f8 0c             	sar    $0xc,%eax
8010172c:	03 05 78 0f 11 80    	add    0x80110f78,%eax
80101732:	50                   	push   %eax
80101733:	ff 75 d8             	pushl  -0x28(%ebp)
80101736:	e8 95 e9 ff ff       	call   801000d0 <bread>
8010173b:	83 c4 10             	add    $0x10,%esp
8010173e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101741:	a1 60 0f 11 80       	mov    0x80110f60,%eax
80101746:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101749:	31 c0                	xor    %eax,%eax
8010174b:	eb 2f                	jmp    8010177c <balloc+0x7c>
8010174d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101750:	89 c1                	mov    %eax,%ecx
80101752:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101757:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010175a:	83 e1 07             	and    $0x7,%ecx
8010175d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010175f:	89 c1                	mov    %eax,%ecx
80101761:	c1 f9 03             	sar    $0x3,%ecx
80101764:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101769:	89 fa                	mov    %edi,%edx
8010176b:	85 df                	test   %ebx,%edi
8010176d:	74 41                	je     801017b0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010176f:	83 c0 01             	add    $0x1,%eax
80101772:	83 c6 01             	add    $0x1,%esi
80101775:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010177a:	74 05                	je     80101781 <balloc+0x81>
8010177c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010177f:	77 cf                	ja     80101750 <balloc+0x50>
    brelse(bp);
80101781:	83 ec 0c             	sub    $0xc,%esp
80101784:	ff 75 e4             	pushl  -0x1c(%ebp)
80101787:	e8 64 ea ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010178c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101793:	83 c4 10             	add    $0x10,%esp
80101796:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101799:	39 05 60 0f 11 80    	cmp    %eax,0x80110f60
8010179f:	77 80                	ja     80101721 <balloc+0x21>
  panic("balloc: out of blocks");
801017a1:	83 ec 0c             	sub    $0xc,%esp
801017a4:	68 ea 76 10 80       	push   $0x801076ea
801017a9:	e8 e2 eb ff ff       	call   80100390 <panic>
801017ae:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801017b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801017b3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801017b6:	09 da                	or     %ebx,%edx
801017b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801017bc:	57                   	push   %edi
801017bd:	e8 1e 1c 00 00       	call   801033e0 <log_write>
        brelse(bp);
801017c2:	89 3c 24             	mov    %edi,(%esp)
801017c5:	e8 26 ea ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801017ca:	58                   	pop    %eax
801017cb:	5a                   	pop    %edx
801017cc:	56                   	push   %esi
801017cd:	ff 75 d8             	pushl  -0x28(%ebp)
801017d0:	e8 fb e8 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801017d5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801017d8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801017da:	8d 40 5c             	lea    0x5c(%eax),%eax
801017dd:	68 00 02 00 00       	push   $0x200
801017e2:	6a 00                	push   $0x0
801017e4:	50                   	push   %eax
801017e5:	e8 56 33 00 00       	call   80104b40 <memset>
  log_write(bp);
801017ea:	89 1c 24             	mov    %ebx,(%esp)
801017ed:	e8 ee 1b 00 00       	call   801033e0 <log_write>
  brelse(bp);
801017f2:	89 1c 24             	mov    %ebx,(%esp)
801017f5:	e8 f6 e9 ff ff       	call   801001f0 <brelse>
}
801017fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fd:	89 f0                	mov    %esi,%eax
801017ff:	5b                   	pop    %ebx
80101800:	5e                   	pop    %esi
80101801:	5f                   	pop    %edi
80101802:	5d                   	pop    %ebp
80101803:	c3                   	ret    
80101804:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010180b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010180f:	90                   	nop

80101810 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	57                   	push   %edi
80101814:	89 c7                	mov    %eax,%edi
80101816:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101817:	31 f6                	xor    %esi,%esi
{
80101819:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010181a:	bb b4 0f 11 80       	mov    $0x80110fb4,%ebx
{
8010181f:	83 ec 28             	sub    $0x28,%esp
80101822:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101825:	68 80 0f 11 80       	push   $0x80110f80
8010182a:	e8 01 32 00 00       	call   80104a30 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010182f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101832:	83 c4 10             	add    $0x10,%esp
80101835:	eb 1b                	jmp    80101852 <iget+0x42>
80101837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101840:	39 3b                	cmp    %edi,(%ebx)
80101842:	74 6c                	je     801018b0 <iget+0xa0>
80101844:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010184a:	81 fb d4 2b 11 80    	cmp    $0x80112bd4,%ebx
80101850:	73 26                	jae    80101878 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101852:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101855:	85 c9                	test   %ecx,%ecx
80101857:	7f e7                	jg     80101840 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101859:	85 f6                	test   %esi,%esi
8010185b:	75 e7                	jne    80101844 <iget+0x34>
8010185d:	89 d8                	mov    %ebx,%eax
8010185f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101865:	85 c9                	test   %ecx,%ecx
80101867:	75 6e                	jne    801018d7 <iget+0xc7>
80101869:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010186b:	81 fb d4 2b 11 80    	cmp    $0x80112bd4,%ebx
80101871:	72 df                	jb     80101852 <iget+0x42>
80101873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101877:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101878:	85 f6                	test   %esi,%esi
8010187a:	74 73                	je     801018ef <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010187c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010187f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101881:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101884:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010188b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101892:	68 80 0f 11 80       	push   $0x80110f80
80101897:	e8 54 32 00 00       	call   80104af0 <release>

  return ip;
8010189c:	83 c4 10             	add    $0x10,%esp
}
8010189f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018a2:	89 f0                	mov    %esi,%eax
801018a4:	5b                   	pop    %ebx
801018a5:	5e                   	pop    %esi
801018a6:	5f                   	pop    %edi
801018a7:	5d                   	pop    %ebp
801018a8:	c3                   	ret    
801018a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018b0:	39 53 04             	cmp    %edx,0x4(%ebx)
801018b3:	75 8f                	jne    80101844 <iget+0x34>
      release(&icache.lock);
801018b5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801018b8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801018bb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801018bd:	68 80 0f 11 80       	push   $0x80110f80
      ip->ref++;
801018c2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801018c5:	e8 26 32 00 00       	call   80104af0 <release>
      return ip;
801018ca:	83 c4 10             	add    $0x10,%esp
}
801018cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018d0:	89 f0                	mov    %esi,%eax
801018d2:	5b                   	pop    %ebx
801018d3:	5e                   	pop    %esi
801018d4:	5f                   	pop    %edi
801018d5:	5d                   	pop    %ebp
801018d6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018d7:	81 fb d4 2b 11 80    	cmp    $0x80112bd4,%ebx
801018dd:	73 10                	jae    801018ef <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018df:	8b 4b 08             	mov    0x8(%ebx),%ecx
801018e2:	85 c9                	test   %ecx,%ecx
801018e4:	0f 8f 56 ff ff ff    	jg     80101840 <iget+0x30>
801018ea:	e9 6e ff ff ff       	jmp    8010185d <iget+0x4d>
    panic("iget: no inodes");
801018ef:	83 ec 0c             	sub    $0xc,%esp
801018f2:	68 00 77 10 80       	push   $0x80107700
801018f7:	e8 94 ea ff ff       	call   80100390 <panic>
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101900 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	57                   	push   %edi
80101904:	56                   	push   %esi
80101905:	89 c6                	mov    %eax,%esi
80101907:	53                   	push   %ebx
80101908:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010190b:	83 fa 0b             	cmp    $0xb,%edx
8010190e:	0f 86 84 00 00 00    	jbe    80101998 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101914:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101917:	83 fb 7f             	cmp    $0x7f,%ebx
8010191a:	0f 87 98 00 00 00    	ja     801019b8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101920:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101926:	8b 16                	mov    (%esi),%edx
80101928:	85 c0                	test   %eax,%eax
8010192a:	74 54                	je     80101980 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010192c:	83 ec 08             	sub    $0x8,%esp
8010192f:	50                   	push   %eax
80101930:	52                   	push   %edx
80101931:	e8 9a e7 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101936:	83 c4 10             	add    $0x10,%esp
80101939:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010193d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010193f:	8b 1a                	mov    (%edx),%ebx
80101941:	85 db                	test   %ebx,%ebx
80101943:	74 1b                	je     80101960 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101945:	83 ec 0c             	sub    $0xc,%esp
80101948:	57                   	push   %edi
80101949:	e8 a2 e8 ff ff       	call   801001f0 <brelse>
    return addr;
8010194e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101951:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101954:	89 d8                	mov    %ebx,%eax
80101956:	5b                   	pop    %ebx
80101957:	5e                   	pop    %esi
80101958:	5f                   	pop    %edi
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010195f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101960:	8b 06                	mov    (%esi),%eax
80101962:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101965:	e8 96 fd ff ff       	call   80101700 <balloc>
8010196a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010196d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101970:	89 c3                	mov    %eax,%ebx
80101972:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101974:	57                   	push   %edi
80101975:	e8 66 1a 00 00       	call   801033e0 <log_write>
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	eb c6                	jmp    80101945 <bmap+0x45>
8010197f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101980:	89 d0                	mov    %edx,%eax
80101982:	e8 79 fd ff ff       	call   80101700 <balloc>
80101987:	8b 16                	mov    (%esi),%edx
80101989:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010198f:	eb 9b                	jmp    8010192c <bmap+0x2c>
80101991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101998:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010199b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010199e:	85 db                	test   %ebx,%ebx
801019a0:	75 af                	jne    80101951 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801019a2:	8b 00                	mov    (%eax),%eax
801019a4:	e8 57 fd ff ff       	call   80101700 <balloc>
801019a9:	89 47 5c             	mov    %eax,0x5c(%edi)
801019ac:	89 c3                	mov    %eax,%ebx
}
801019ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019b1:	89 d8                	mov    %ebx,%eax
801019b3:	5b                   	pop    %ebx
801019b4:	5e                   	pop    %esi
801019b5:	5f                   	pop    %edi
801019b6:	5d                   	pop    %ebp
801019b7:	c3                   	ret    
  panic("bmap: out of range");
801019b8:	83 ec 0c             	sub    $0xc,%esp
801019bb:	68 10 77 10 80       	push   $0x80107710
801019c0:	e8 cb e9 ff ff       	call   80100390 <panic>
801019c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019d0 <readsb>:
{
801019d0:	f3 0f 1e fb          	endbr32 
801019d4:	55                   	push   %ebp
801019d5:	89 e5                	mov    %esp,%ebp
801019d7:	56                   	push   %esi
801019d8:	53                   	push   %ebx
801019d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801019dc:	83 ec 08             	sub    $0x8,%esp
801019df:	6a 01                	push   $0x1
801019e1:	ff 75 08             	pushl  0x8(%ebp)
801019e4:	e8 e7 e6 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801019e9:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801019ec:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801019ee:	8d 40 5c             	lea    0x5c(%eax),%eax
801019f1:	6a 1c                	push   $0x1c
801019f3:	50                   	push   %eax
801019f4:	56                   	push   %esi
801019f5:	e8 e6 31 00 00       	call   80104be0 <memmove>
  brelse(bp);
801019fa:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019fd:	83 c4 10             	add    $0x10,%esp
}
80101a00:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a03:	5b                   	pop    %ebx
80101a04:	5e                   	pop    %esi
80101a05:	5d                   	pop    %ebp
  brelse(bp);
80101a06:	e9 e5 e7 ff ff       	jmp    801001f0 <brelse>
80101a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a0f:	90                   	nop

80101a10 <iinit>:
{
80101a10:	f3 0f 1e fb          	endbr32 
80101a14:	55                   	push   %ebp
80101a15:	89 e5                	mov    %esp,%ebp
80101a17:	53                   	push   %ebx
80101a18:	bb c0 0f 11 80       	mov    $0x80110fc0,%ebx
80101a1d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101a20:	68 23 77 10 80       	push   $0x80107723
80101a25:	68 80 0f 11 80       	push   $0x80110f80
80101a2a:	e8 81 2e 00 00       	call   801048b0 <initlock>
  for(i = 0; i < NINODE; i++) {
80101a2f:	83 c4 10             	add    $0x10,%esp
80101a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101a38:	83 ec 08             	sub    $0x8,%esp
80101a3b:	68 2a 77 10 80       	push   $0x8010772a
80101a40:	53                   	push   %ebx
80101a41:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101a47:	e8 24 2d 00 00       	call   80104770 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101a4c:	83 c4 10             	add    $0x10,%esp
80101a4f:	81 fb e0 2b 11 80    	cmp    $0x80112be0,%ebx
80101a55:	75 e1                	jne    80101a38 <iinit+0x28>
  readsb(dev, &sb);
80101a57:	83 ec 08             	sub    $0x8,%esp
80101a5a:	68 60 0f 11 80       	push   $0x80110f60
80101a5f:	ff 75 08             	pushl  0x8(%ebp)
80101a62:	e8 69 ff ff ff       	call   801019d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101a67:	ff 35 78 0f 11 80    	pushl  0x80110f78
80101a6d:	ff 35 74 0f 11 80    	pushl  0x80110f74
80101a73:	ff 35 70 0f 11 80    	pushl  0x80110f70
80101a79:	ff 35 6c 0f 11 80    	pushl  0x80110f6c
80101a7f:	ff 35 68 0f 11 80    	pushl  0x80110f68
80101a85:	ff 35 64 0f 11 80    	pushl  0x80110f64
80101a8b:	ff 35 60 0f 11 80    	pushl  0x80110f60
80101a91:	68 90 77 10 80       	push   $0x80107790
80101a96:	e8 05 ee ff ff       	call   801008a0 <cprintf>
}
80101a9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a9e:	83 c4 30             	add    $0x30,%esp
80101aa1:	c9                   	leave  
80101aa2:	c3                   	ret    
80101aa3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ab0 <ialloc>:
{
80101ab0:	f3 0f 1e fb          	endbr32 
80101ab4:	55                   	push   %ebp
80101ab5:	89 e5                	mov    %esp,%ebp
80101ab7:	57                   	push   %edi
80101ab8:	56                   	push   %esi
80101ab9:	53                   	push   %ebx
80101aba:	83 ec 1c             	sub    $0x1c,%esp
80101abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101ac0:	83 3d 68 0f 11 80 01 	cmpl   $0x1,0x80110f68
{
80101ac7:	8b 75 08             	mov    0x8(%ebp),%esi
80101aca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101acd:	0f 86 8d 00 00 00    	jbe    80101b60 <ialloc+0xb0>
80101ad3:	bf 01 00 00 00       	mov    $0x1,%edi
80101ad8:	eb 1d                	jmp    80101af7 <ialloc+0x47>
80101ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101ae0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101ae3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101ae6:	53                   	push   %ebx
80101ae7:	e8 04 e7 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101aec:	83 c4 10             	add    $0x10,%esp
80101aef:	3b 3d 68 0f 11 80    	cmp    0x80110f68,%edi
80101af5:	73 69                	jae    80101b60 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101af7:	89 f8                	mov    %edi,%eax
80101af9:	83 ec 08             	sub    $0x8,%esp
80101afc:	c1 e8 03             	shr    $0x3,%eax
80101aff:	03 05 74 0f 11 80    	add    0x80110f74,%eax
80101b05:	50                   	push   %eax
80101b06:	56                   	push   %esi
80101b07:	e8 c4 e5 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101b0c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101b0f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101b11:	89 f8                	mov    %edi,%eax
80101b13:	83 e0 07             	and    $0x7,%eax
80101b16:	c1 e0 06             	shl    $0x6,%eax
80101b19:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101b1d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101b21:	75 bd                	jne    80101ae0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101b23:	83 ec 04             	sub    $0x4,%esp
80101b26:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101b29:	6a 40                	push   $0x40
80101b2b:	6a 00                	push   $0x0
80101b2d:	51                   	push   %ecx
80101b2e:	e8 0d 30 00 00       	call   80104b40 <memset>
      dip->type = type;
80101b33:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101b37:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b3a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101b3d:	89 1c 24             	mov    %ebx,(%esp)
80101b40:	e8 9b 18 00 00       	call   801033e0 <log_write>
      brelse(bp);
80101b45:	89 1c 24             	mov    %ebx,(%esp)
80101b48:	e8 a3 e6 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101b4d:	83 c4 10             	add    $0x10,%esp
}
80101b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101b53:	89 fa                	mov    %edi,%edx
}
80101b55:	5b                   	pop    %ebx
      return iget(dev, inum);
80101b56:	89 f0                	mov    %esi,%eax
}
80101b58:	5e                   	pop    %esi
80101b59:	5f                   	pop    %edi
80101b5a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101b5b:	e9 b0 fc ff ff       	jmp    80101810 <iget>
  panic("ialloc: no inodes");
80101b60:	83 ec 0c             	sub    $0xc,%esp
80101b63:	68 30 77 10 80       	push   $0x80107730
80101b68:	e8 23 e8 ff ff       	call   80100390 <panic>
80101b6d:	8d 76 00             	lea    0x0(%esi),%esi

80101b70 <iupdate>:
{
80101b70:	f3 0f 1e fb          	endbr32 
80101b74:	55                   	push   %ebp
80101b75:	89 e5                	mov    %esp,%ebp
80101b77:	56                   	push   %esi
80101b78:	53                   	push   %ebx
80101b79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b7c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101b7f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b82:	83 ec 08             	sub    $0x8,%esp
80101b85:	c1 e8 03             	shr    $0x3,%eax
80101b88:	03 05 74 0f 11 80    	add    0x80110f74,%eax
80101b8e:	50                   	push   %eax
80101b8f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101b92:	e8 39 e5 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101b97:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101b9b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b9e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101ba0:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101ba3:	83 e0 07             	and    $0x7,%eax
80101ba6:	c1 e0 06             	shl    $0x6,%eax
80101ba9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101bad:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101bb0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bb4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101bb7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101bbb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101bbf:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101bc3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101bc7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101bcb:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101bce:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bd1:	6a 34                	push   $0x34
80101bd3:	53                   	push   %ebx
80101bd4:	50                   	push   %eax
80101bd5:	e8 06 30 00 00       	call   80104be0 <memmove>
  log_write(bp);
80101bda:	89 34 24             	mov    %esi,(%esp)
80101bdd:	e8 fe 17 00 00       	call   801033e0 <log_write>
  brelse(bp);
80101be2:	89 75 08             	mov    %esi,0x8(%ebp)
80101be5:	83 c4 10             	add    $0x10,%esp
}
80101be8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101beb:	5b                   	pop    %ebx
80101bec:	5e                   	pop    %esi
80101bed:	5d                   	pop    %ebp
  brelse(bp);
80101bee:	e9 fd e5 ff ff       	jmp    801001f0 <brelse>
80101bf3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c00 <idup>:
{
80101c00:	f3 0f 1e fb          	endbr32 
80101c04:	55                   	push   %ebp
80101c05:	89 e5                	mov    %esp,%ebp
80101c07:	53                   	push   %ebx
80101c08:	83 ec 10             	sub    $0x10,%esp
80101c0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101c0e:	68 80 0f 11 80       	push   $0x80110f80
80101c13:	e8 18 2e 00 00       	call   80104a30 <acquire>
  ip->ref++;
80101c18:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c1c:	c7 04 24 80 0f 11 80 	movl   $0x80110f80,(%esp)
80101c23:	e8 c8 2e 00 00       	call   80104af0 <release>
}
80101c28:	89 d8                	mov    %ebx,%eax
80101c2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c2d:	c9                   	leave  
80101c2e:	c3                   	ret    
80101c2f:	90                   	nop

80101c30 <ilock>:
{
80101c30:	f3 0f 1e fb          	endbr32 
80101c34:	55                   	push   %ebp
80101c35:	89 e5                	mov    %esp,%ebp
80101c37:	56                   	push   %esi
80101c38:	53                   	push   %ebx
80101c39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101c3c:	85 db                	test   %ebx,%ebx
80101c3e:	0f 84 b3 00 00 00    	je     80101cf7 <ilock+0xc7>
80101c44:	8b 53 08             	mov    0x8(%ebx),%edx
80101c47:	85 d2                	test   %edx,%edx
80101c49:	0f 8e a8 00 00 00    	jle    80101cf7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101c4f:	83 ec 0c             	sub    $0xc,%esp
80101c52:	8d 43 0c             	lea    0xc(%ebx),%eax
80101c55:	50                   	push   %eax
80101c56:	e8 55 2b 00 00       	call   801047b0 <acquiresleep>
  if(ip->valid == 0){
80101c5b:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101c5e:	83 c4 10             	add    $0x10,%esp
80101c61:	85 c0                	test   %eax,%eax
80101c63:	74 0b                	je     80101c70 <ilock+0x40>
}
80101c65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c68:	5b                   	pop    %ebx
80101c69:	5e                   	pop    %esi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c70:	8b 43 04             	mov    0x4(%ebx),%eax
80101c73:	83 ec 08             	sub    $0x8,%esp
80101c76:	c1 e8 03             	shr    $0x3,%eax
80101c79:	03 05 74 0f 11 80    	add    0x80110f74,%eax
80101c7f:	50                   	push   %eax
80101c80:	ff 33                	pushl  (%ebx)
80101c82:	e8 49 e4 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c87:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c8a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101c8c:	8b 43 04             	mov    0x4(%ebx),%eax
80101c8f:	83 e0 07             	and    $0x7,%eax
80101c92:	c1 e0 06             	shl    $0x6,%eax
80101c95:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101c99:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c9c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101c9f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101ca3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101ca7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101cab:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101caf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101cb3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101cb7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101cbb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101cbe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101cc1:	6a 34                	push   $0x34
80101cc3:	50                   	push   %eax
80101cc4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101cc7:	50                   	push   %eax
80101cc8:	e8 13 2f 00 00       	call   80104be0 <memmove>
    brelse(bp);
80101ccd:	89 34 24             	mov    %esi,(%esp)
80101cd0:	e8 1b e5 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101cd5:	83 c4 10             	add    $0x10,%esp
80101cd8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101cdd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101ce4:	0f 85 7b ff ff ff    	jne    80101c65 <ilock+0x35>
      panic("ilock: no type");
80101cea:	83 ec 0c             	sub    $0xc,%esp
80101ced:	68 48 77 10 80       	push   $0x80107748
80101cf2:	e8 99 e6 ff ff       	call   80100390 <panic>
    panic("ilock");
80101cf7:	83 ec 0c             	sub    $0xc,%esp
80101cfa:	68 42 77 10 80       	push   $0x80107742
80101cff:	e8 8c e6 ff ff       	call   80100390 <panic>
80101d04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d0f:	90                   	nop

80101d10 <iunlock>:
{
80101d10:	f3 0f 1e fb          	endbr32 
80101d14:	55                   	push   %ebp
80101d15:	89 e5                	mov    %esp,%ebp
80101d17:	56                   	push   %esi
80101d18:	53                   	push   %ebx
80101d19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d1c:	85 db                	test   %ebx,%ebx
80101d1e:	74 28                	je     80101d48 <iunlock+0x38>
80101d20:	83 ec 0c             	sub    $0xc,%esp
80101d23:	8d 73 0c             	lea    0xc(%ebx),%esi
80101d26:	56                   	push   %esi
80101d27:	e8 24 2b 00 00       	call   80104850 <holdingsleep>
80101d2c:	83 c4 10             	add    $0x10,%esp
80101d2f:	85 c0                	test   %eax,%eax
80101d31:	74 15                	je     80101d48 <iunlock+0x38>
80101d33:	8b 43 08             	mov    0x8(%ebx),%eax
80101d36:	85 c0                	test   %eax,%eax
80101d38:	7e 0e                	jle    80101d48 <iunlock+0x38>
  releasesleep(&ip->lock);
80101d3a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101d3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d40:	5b                   	pop    %ebx
80101d41:	5e                   	pop    %esi
80101d42:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101d43:	e9 c8 2a 00 00       	jmp    80104810 <releasesleep>
    panic("iunlock");
80101d48:	83 ec 0c             	sub    $0xc,%esp
80101d4b:	68 57 77 10 80       	push   $0x80107757
80101d50:	e8 3b e6 ff ff       	call   80100390 <panic>
80101d55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d60 <iput>:
{
80101d60:	f3 0f 1e fb          	endbr32 
80101d64:	55                   	push   %ebp
80101d65:	89 e5                	mov    %esp,%ebp
80101d67:	57                   	push   %edi
80101d68:	56                   	push   %esi
80101d69:	53                   	push   %ebx
80101d6a:	83 ec 28             	sub    $0x28,%esp
80101d6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101d70:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101d73:	57                   	push   %edi
80101d74:	e8 37 2a 00 00       	call   801047b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101d79:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101d7c:	83 c4 10             	add    $0x10,%esp
80101d7f:	85 d2                	test   %edx,%edx
80101d81:	74 07                	je     80101d8a <iput+0x2a>
80101d83:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101d88:	74 36                	je     80101dc0 <iput+0x60>
  releasesleep(&ip->lock);
80101d8a:	83 ec 0c             	sub    $0xc,%esp
80101d8d:	57                   	push   %edi
80101d8e:	e8 7d 2a 00 00       	call   80104810 <releasesleep>
  acquire(&icache.lock);
80101d93:	c7 04 24 80 0f 11 80 	movl   $0x80110f80,(%esp)
80101d9a:	e8 91 2c 00 00       	call   80104a30 <acquire>
  ip->ref--;
80101d9f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101da3:	83 c4 10             	add    $0x10,%esp
80101da6:	c7 45 08 80 0f 11 80 	movl   $0x80110f80,0x8(%ebp)
}
80101dad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db0:	5b                   	pop    %ebx
80101db1:	5e                   	pop    %esi
80101db2:	5f                   	pop    %edi
80101db3:	5d                   	pop    %ebp
  release(&icache.lock);
80101db4:	e9 37 2d 00 00       	jmp    80104af0 <release>
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	68 80 0f 11 80       	push   $0x80110f80
80101dc8:	e8 63 2c 00 00       	call   80104a30 <acquire>
    int r = ip->ref;
80101dcd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101dd0:	c7 04 24 80 0f 11 80 	movl   $0x80110f80,(%esp)
80101dd7:	e8 14 2d 00 00       	call   80104af0 <release>
    if(r == 1){
80101ddc:	83 c4 10             	add    $0x10,%esp
80101ddf:	83 fe 01             	cmp    $0x1,%esi
80101de2:	75 a6                	jne    80101d8a <iput+0x2a>
80101de4:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101dea:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101ded:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101df0:	89 cf                	mov    %ecx,%edi
80101df2:	eb 0b                	jmp    80101dff <iput+0x9f>
80101df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101df8:	83 c6 04             	add    $0x4,%esi
80101dfb:	39 fe                	cmp    %edi,%esi
80101dfd:	74 19                	je     80101e18 <iput+0xb8>
    if(ip->addrs[i]){
80101dff:	8b 16                	mov    (%esi),%edx
80101e01:	85 d2                	test   %edx,%edx
80101e03:	74 f3                	je     80101df8 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101e05:	8b 03                	mov    (%ebx),%eax
80101e07:	e8 74 f8 ff ff       	call   80101680 <bfree>
      ip->addrs[i] = 0;
80101e0c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101e12:	eb e4                	jmp    80101df8 <iput+0x98>
80101e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101e18:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101e1e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101e21:	85 c0                	test   %eax,%eax
80101e23:	75 33                	jne    80101e58 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101e25:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101e28:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101e2f:	53                   	push   %ebx
80101e30:	e8 3b fd ff ff       	call   80101b70 <iupdate>
      ip->type = 0;
80101e35:	31 c0                	xor    %eax,%eax
80101e37:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101e3b:	89 1c 24             	mov    %ebx,(%esp)
80101e3e:	e8 2d fd ff ff       	call   80101b70 <iupdate>
      ip->valid = 0;
80101e43:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101e4a:	83 c4 10             	add    $0x10,%esp
80101e4d:	e9 38 ff ff ff       	jmp    80101d8a <iput+0x2a>
80101e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e58:	83 ec 08             	sub    $0x8,%esp
80101e5b:	50                   	push   %eax
80101e5c:	ff 33                	pushl  (%ebx)
80101e5e:	e8 6d e2 ff ff       	call   801000d0 <bread>
80101e63:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101e66:	83 c4 10             	add    $0x10,%esp
80101e69:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101e6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e72:	8d 70 5c             	lea    0x5c(%eax),%esi
80101e75:	89 cf                	mov    %ecx,%edi
80101e77:	eb 0e                	jmp    80101e87 <iput+0x127>
80101e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e80:	83 c6 04             	add    $0x4,%esi
80101e83:	39 f7                	cmp    %esi,%edi
80101e85:	74 19                	je     80101ea0 <iput+0x140>
      if(a[j])
80101e87:	8b 16                	mov    (%esi),%edx
80101e89:	85 d2                	test   %edx,%edx
80101e8b:	74 f3                	je     80101e80 <iput+0x120>
        bfree(ip->dev, a[j]);
80101e8d:	8b 03                	mov    (%ebx),%eax
80101e8f:	e8 ec f7 ff ff       	call   80101680 <bfree>
80101e94:	eb ea                	jmp    80101e80 <iput+0x120>
80101e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e9d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101ea0:	83 ec 0c             	sub    $0xc,%esp
80101ea3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea6:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ea9:	e8 42 e3 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101eae:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101eb4:	8b 03                	mov    (%ebx),%eax
80101eb6:	e8 c5 f7 ff ff       	call   80101680 <bfree>
    ip->addrs[NDIRECT] = 0;
80101ebb:	83 c4 10             	add    $0x10,%esp
80101ebe:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101ec5:	00 00 00 
80101ec8:	e9 58 ff ff ff       	jmp    80101e25 <iput+0xc5>
80101ecd:	8d 76 00             	lea    0x0(%esi),%esi

80101ed0 <iunlockput>:
{
80101ed0:	f3 0f 1e fb          	endbr32 
80101ed4:	55                   	push   %ebp
80101ed5:	89 e5                	mov    %esp,%ebp
80101ed7:	53                   	push   %ebx
80101ed8:	83 ec 10             	sub    $0x10,%esp
80101edb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101ede:	53                   	push   %ebx
80101edf:	e8 2c fe ff ff       	call   80101d10 <iunlock>
  iput(ip);
80101ee4:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ee7:	83 c4 10             	add    $0x10,%esp
}
80101eea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101eed:	c9                   	leave  
  iput(ip);
80101eee:	e9 6d fe ff ff       	jmp    80101d60 <iput>
80101ef3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f00 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f00:	f3 0f 1e fb          	endbr32 
80101f04:	55                   	push   %ebp
80101f05:	89 e5                	mov    %esp,%ebp
80101f07:	8b 55 08             	mov    0x8(%ebp),%edx
80101f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101f0d:	8b 0a                	mov    (%edx),%ecx
80101f0f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101f12:	8b 4a 04             	mov    0x4(%edx),%ecx
80101f15:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101f18:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101f1c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101f1f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101f23:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101f27:	8b 52 58             	mov    0x58(%edx),%edx
80101f2a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f2d:	5d                   	pop    %ebp
80101f2e:	c3                   	ret    
80101f2f:	90                   	nop

80101f30 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f30:	f3 0f 1e fb          	endbr32 
80101f34:	55                   	push   %ebp
80101f35:	89 e5                	mov    %esp,%ebp
80101f37:	57                   	push   %edi
80101f38:	56                   	push   %esi
80101f39:	53                   	push   %ebx
80101f3a:	83 ec 1c             	sub    $0x1c,%esp
80101f3d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101f40:	8b 45 08             	mov    0x8(%ebp),%eax
80101f43:	8b 75 10             	mov    0x10(%ebp),%esi
80101f46:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101f49:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f4c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101f51:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101f54:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101f57:	0f 84 a3 00 00 00    	je     80102000 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101f5d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f60:	8b 40 58             	mov    0x58(%eax),%eax
80101f63:	39 c6                	cmp    %eax,%esi
80101f65:	0f 87 b6 00 00 00    	ja     80102021 <readi+0xf1>
80101f6b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101f6e:	31 c9                	xor    %ecx,%ecx
80101f70:	89 da                	mov    %ebx,%edx
80101f72:	01 f2                	add    %esi,%edx
80101f74:	0f 92 c1             	setb   %cl
80101f77:	89 cf                	mov    %ecx,%edi
80101f79:	0f 82 a2 00 00 00    	jb     80102021 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101f7f:	89 c1                	mov    %eax,%ecx
80101f81:	29 f1                	sub    %esi,%ecx
80101f83:	39 d0                	cmp    %edx,%eax
80101f85:	0f 43 cb             	cmovae %ebx,%ecx
80101f88:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f8b:	85 c9                	test   %ecx,%ecx
80101f8d:	74 63                	je     80101ff2 <readi+0xc2>
80101f8f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f90:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101f93:	89 f2                	mov    %esi,%edx
80101f95:	c1 ea 09             	shr    $0x9,%edx
80101f98:	89 d8                	mov    %ebx,%eax
80101f9a:	e8 61 f9 ff ff       	call   80101900 <bmap>
80101f9f:	83 ec 08             	sub    $0x8,%esp
80101fa2:	50                   	push   %eax
80101fa3:	ff 33                	pushl  (%ebx)
80101fa5:	e8 26 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101faa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101fad:	b9 00 02 00 00       	mov    $0x200,%ecx
80101fb2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fb5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101fb7:	89 f0                	mov    %esi,%eax
80101fb9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fbe:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101fc0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fc3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101fc5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101fc9:	39 d9                	cmp    %ebx,%ecx
80101fcb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101fce:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fcf:	01 df                	add    %ebx,%edi
80101fd1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101fd3:	50                   	push   %eax
80101fd4:	ff 75 e0             	pushl  -0x20(%ebp)
80101fd7:	e8 04 2c 00 00       	call   80104be0 <memmove>
    brelse(bp);
80101fdc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101fdf:	89 14 24             	mov    %edx,(%esp)
80101fe2:	e8 09 e2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fe7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101fea:	83 c4 10             	add    $0x10,%esp
80101fed:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ff0:	77 9e                	ja     80101f90 <readi+0x60>
  }
  return n;
80101ff2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
80101ffd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102000:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102004:	66 83 f8 09          	cmp    $0x9,%ax
80102008:	77 17                	ja     80102021 <readi+0xf1>
8010200a:	8b 04 c5 00 0f 11 80 	mov    -0x7feef100(,%eax,8),%eax
80102011:	85 c0                	test   %eax,%eax
80102013:	74 0c                	je     80102021 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102015:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010201b:	5b                   	pop    %ebx
8010201c:	5e                   	pop    %esi
8010201d:	5f                   	pop    %edi
8010201e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010201f:	ff e0                	jmp    *%eax
      return -1;
80102021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102026:	eb cd                	jmp    80101ff5 <readi+0xc5>
80102028:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010202f:	90                   	nop

80102030 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
80102035:	89 e5                	mov    %esp,%ebp
80102037:	57                   	push   %edi
80102038:	56                   	push   %esi
80102039:	53                   	push   %ebx
8010203a:	83 ec 1c             	sub    $0x1c,%esp
8010203d:	8b 45 08             	mov    0x8(%ebp),%eax
80102040:	8b 75 0c             	mov    0xc(%ebp),%esi
80102043:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102046:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
8010204b:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010204e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102051:	8b 75 10             	mov    0x10(%ebp),%esi
80102054:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80102057:	0f 84 b3 00 00 00    	je     80102110 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
8010205d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102060:	39 70 58             	cmp    %esi,0x58(%eax)
80102063:	0f 82 e3 00 00 00    	jb     8010214c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102069:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010206c:	89 f8                	mov    %edi,%eax
8010206e:	01 f0                	add    %esi,%eax
80102070:	0f 82 d6 00 00 00    	jb     8010214c <writei+0x11c>
80102076:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010207b:	0f 87 cb 00 00 00    	ja     8010214c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102081:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102088:	85 ff                	test   %edi,%edi
8010208a:	74 75                	je     80102101 <writei+0xd1>
8010208c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102090:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102093:	89 f2                	mov    %esi,%edx
80102095:	c1 ea 09             	shr    $0x9,%edx
80102098:	89 f8                	mov    %edi,%eax
8010209a:	e8 61 f8 ff ff       	call   80101900 <bmap>
8010209f:	83 ec 08             	sub    $0x8,%esp
801020a2:	50                   	push   %eax
801020a3:	ff 37                	pushl  (%edi)
801020a5:	e8 26 e0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801020aa:	b9 00 02 00 00       	mov    $0x200,%ecx
801020af:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801020b2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020b5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
801020b7:	89 f0                	mov    %esi,%eax
801020b9:	83 c4 0c             	add    $0xc,%esp
801020bc:	25 ff 01 00 00       	and    $0x1ff,%eax
801020c1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
801020c3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801020c7:	39 d9                	cmp    %ebx,%ecx
801020c9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
801020cc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020cd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
801020cf:	ff 75 dc             	pushl  -0x24(%ebp)
801020d2:	50                   	push   %eax
801020d3:	e8 08 2b 00 00       	call   80104be0 <memmove>
    log_write(bp);
801020d8:	89 3c 24             	mov    %edi,(%esp)
801020db:	e8 00 13 00 00       	call   801033e0 <log_write>
    brelse(bp);
801020e0:	89 3c 24             	mov    %edi,(%esp)
801020e3:	e8 08 e1 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020e8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801020eb:	83 c4 10             	add    $0x10,%esp
801020ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801020f1:	01 5d dc             	add    %ebx,-0x24(%ebp)
801020f4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801020f7:	77 97                	ja     80102090 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
801020f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801020fc:	3b 70 58             	cmp    0x58(%eax),%esi
801020ff:	77 37                	ja     80102138 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102101:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102104:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102107:	5b                   	pop    %ebx
80102108:	5e                   	pop    %esi
80102109:	5f                   	pop    %edi
8010210a:	5d                   	pop    %ebp
8010210b:	c3                   	ret    
8010210c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102110:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102114:	66 83 f8 09          	cmp    $0x9,%ax
80102118:	77 32                	ja     8010214c <writei+0x11c>
8010211a:	8b 04 c5 04 0f 11 80 	mov    -0x7feef0fc(,%eax,8),%eax
80102121:	85 c0                	test   %eax,%eax
80102123:	74 27                	je     8010214c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102125:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102128:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010212b:	5b                   	pop    %ebx
8010212c:	5e                   	pop    %esi
8010212d:	5f                   	pop    %edi
8010212e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010212f:	ff e0                	jmp    *%eax
80102131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102138:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010213b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010213e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102141:	50                   	push   %eax
80102142:	e8 29 fa ff ff       	call   80101b70 <iupdate>
80102147:	83 c4 10             	add    $0x10,%esp
8010214a:	eb b5                	jmp    80102101 <writei+0xd1>
      return -1;
8010214c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102151:	eb b1                	jmp    80102104 <writei+0xd4>
80102153:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010215a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102160 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102160:	f3 0f 1e fb          	endbr32 
80102164:	55                   	push   %ebp
80102165:	89 e5                	mov    %esp,%ebp
80102167:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010216a:	6a 0e                	push   $0xe
8010216c:	ff 75 0c             	pushl  0xc(%ebp)
8010216f:	ff 75 08             	pushl  0x8(%ebp)
80102172:	e8 d9 2a 00 00       	call   80104c50 <strncmp>
}
80102177:	c9                   	leave  
80102178:	c3                   	ret    
80102179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102180 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102180:	f3 0f 1e fb          	endbr32 
80102184:	55                   	push   %ebp
80102185:	89 e5                	mov    %esp,%ebp
80102187:	57                   	push   %edi
80102188:	56                   	push   %esi
80102189:	53                   	push   %ebx
8010218a:	83 ec 1c             	sub    $0x1c,%esp
8010218d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102190:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102195:	0f 85 89 00 00 00    	jne    80102224 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010219b:	8b 53 58             	mov    0x58(%ebx),%edx
8010219e:	31 ff                	xor    %edi,%edi
801021a0:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021a3:	85 d2                	test   %edx,%edx
801021a5:	74 42                	je     801021e9 <dirlookup+0x69>
801021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ae:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021b0:	6a 10                	push   $0x10
801021b2:	57                   	push   %edi
801021b3:	56                   	push   %esi
801021b4:	53                   	push   %ebx
801021b5:	e8 76 fd ff ff       	call   80101f30 <readi>
801021ba:	83 c4 10             	add    $0x10,%esp
801021bd:	83 f8 10             	cmp    $0x10,%eax
801021c0:	75 55                	jne    80102217 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
801021c2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801021c7:	74 18                	je     801021e1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
801021c9:	83 ec 04             	sub    $0x4,%esp
801021cc:	8d 45 da             	lea    -0x26(%ebp),%eax
801021cf:	6a 0e                	push   $0xe
801021d1:	50                   	push   %eax
801021d2:	ff 75 0c             	pushl  0xc(%ebp)
801021d5:	e8 76 2a 00 00       	call   80104c50 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801021da:	83 c4 10             	add    $0x10,%esp
801021dd:	85 c0                	test   %eax,%eax
801021df:	74 17                	je     801021f8 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
801021e1:	83 c7 10             	add    $0x10,%edi
801021e4:	3b 7b 58             	cmp    0x58(%ebx),%edi
801021e7:	72 c7                	jb     801021b0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801021e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801021ec:	31 c0                	xor    %eax,%eax
}
801021ee:	5b                   	pop    %ebx
801021ef:	5e                   	pop    %esi
801021f0:	5f                   	pop    %edi
801021f1:	5d                   	pop    %ebp
801021f2:	c3                   	ret    
801021f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021f7:	90                   	nop
      if(poff)
801021f8:	8b 45 10             	mov    0x10(%ebp),%eax
801021fb:	85 c0                	test   %eax,%eax
801021fd:	74 05                	je     80102204 <dirlookup+0x84>
        *poff = off;
801021ff:	8b 45 10             	mov    0x10(%ebp),%eax
80102202:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80102204:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102208:	8b 03                	mov    (%ebx),%eax
8010220a:	e8 01 f6 ff ff       	call   80101810 <iget>
}
8010220f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102212:	5b                   	pop    %ebx
80102213:	5e                   	pop    %esi
80102214:	5f                   	pop    %edi
80102215:	5d                   	pop    %ebp
80102216:	c3                   	ret    
      panic("dirlookup read");
80102217:	83 ec 0c             	sub    $0xc,%esp
8010221a:	68 71 77 10 80       	push   $0x80107771
8010221f:	e8 6c e1 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80102224:	83 ec 0c             	sub    $0xc,%esp
80102227:	68 5f 77 10 80       	push   $0x8010775f
8010222c:	e8 5f e1 ff ff       	call   80100390 <panic>
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	89 c3                	mov    %eax,%ebx
80102248:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010224b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010224e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102251:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102254:	0f 84 86 01 00 00    	je     801023e0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010225a:	e8 d1 1b 00 00       	call   80103e30 <myproc>
  acquire(&icache.lock);
8010225f:	83 ec 0c             	sub    $0xc,%esp
80102262:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102264:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102267:	68 80 0f 11 80       	push   $0x80110f80
8010226c:	e8 bf 27 00 00       	call   80104a30 <acquire>
  ip->ref++;
80102271:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102275:	c7 04 24 80 0f 11 80 	movl   $0x80110f80,(%esp)
8010227c:	e8 6f 28 00 00       	call   80104af0 <release>
80102281:	83 c4 10             	add    $0x10,%esp
80102284:	eb 0d                	jmp    80102293 <namex+0x53>
80102286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80102290:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102293:	0f b6 07             	movzbl (%edi),%eax
80102296:	3c 2f                	cmp    $0x2f,%al
80102298:	74 f6                	je     80102290 <namex+0x50>
  if(*path == 0)
8010229a:	84 c0                	test   %al,%al
8010229c:	0f 84 ee 00 00 00    	je     80102390 <namex+0x150>
  while(*path != '/' && *path != 0)
801022a2:	0f b6 07             	movzbl (%edi),%eax
801022a5:	84 c0                	test   %al,%al
801022a7:	0f 84 fb 00 00 00    	je     801023a8 <namex+0x168>
801022ad:	89 fb                	mov    %edi,%ebx
801022af:	3c 2f                	cmp    $0x2f,%al
801022b1:	0f 84 f1 00 00 00    	je     801023a8 <namex+0x168>
801022b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022be:	66 90                	xchg   %ax,%ax
801022c0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
801022c4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
801022c7:	3c 2f                	cmp    $0x2f,%al
801022c9:	74 04                	je     801022cf <namex+0x8f>
801022cb:	84 c0                	test   %al,%al
801022cd:	75 f1                	jne    801022c0 <namex+0x80>
  len = path - s;
801022cf:	89 d8                	mov    %ebx,%eax
801022d1:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
801022d3:	83 f8 0d             	cmp    $0xd,%eax
801022d6:	0f 8e 84 00 00 00    	jle    80102360 <namex+0x120>
    memmove(name, s, DIRSIZ);
801022dc:	83 ec 04             	sub    $0x4,%esp
801022df:	6a 0e                	push   $0xe
801022e1:	57                   	push   %edi
    path++;
801022e2:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
801022e4:	ff 75 e4             	pushl  -0x1c(%ebp)
801022e7:	e8 f4 28 00 00       	call   80104be0 <memmove>
801022ec:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801022ef:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801022f2:	75 0c                	jne    80102300 <namex+0xc0>
801022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801022f8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
801022fb:	80 3f 2f             	cmpb   $0x2f,(%edi)
801022fe:	74 f8                	je     801022f8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102300:	83 ec 0c             	sub    $0xc,%esp
80102303:	56                   	push   %esi
80102304:	e8 27 f9 ff ff       	call   80101c30 <ilock>
    if(ip->type != T_DIR){
80102309:	83 c4 10             	add    $0x10,%esp
8010230c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102311:	0f 85 a1 00 00 00    	jne    801023b8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102317:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010231a:	85 d2                	test   %edx,%edx
8010231c:	74 09                	je     80102327 <namex+0xe7>
8010231e:	80 3f 00             	cmpb   $0x0,(%edi)
80102321:	0f 84 d9 00 00 00    	je     80102400 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102327:	83 ec 04             	sub    $0x4,%esp
8010232a:	6a 00                	push   $0x0
8010232c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010232f:	56                   	push   %esi
80102330:	e8 4b fe ff ff       	call   80102180 <dirlookup>
80102335:	83 c4 10             	add    $0x10,%esp
80102338:	89 c3                	mov    %eax,%ebx
8010233a:	85 c0                	test   %eax,%eax
8010233c:	74 7a                	je     801023b8 <namex+0x178>
  iunlock(ip);
8010233e:	83 ec 0c             	sub    $0xc,%esp
80102341:	56                   	push   %esi
80102342:	e8 c9 f9 ff ff       	call   80101d10 <iunlock>
  iput(ip);
80102347:	89 34 24             	mov    %esi,(%esp)
8010234a:	89 de                	mov    %ebx,%esi
8010234c:	e8 0f fa ff ff       	call   80101d60 <iput>
80102351:	83 c4 10             	add    $0x10,%esp
80102354:	e9 3a ff ff ff       	jmp    80102293 <namex+0x53>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102360:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102363:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102366:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102369:	83 ec 04             	sub    $0x4,%esp
8010236c:	50                   	push   %eax
8010236d:	57                   	push   %edi
    name[len] = 0;
8010236e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102370:	ff 75 e4             	pushl  -0x1c(%ebp)
80102373:	e8 68 28 00 00       	call   80104be0 <memmove>
    name[len] = 0;
80102378:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010237b:	83 c4 10             	add    $0x10,%esp
8010237e:	c6 00 00             	movb   $0x0,(%eax)
80102381:	e9 69 ff ff ff       	jmp    801022ef <namex+0xaf>
80102386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010238d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102390:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102393:	85 c0                	test   %eax,%eax
80102395:	0f 85 85 00 00 00    	jne    80102420 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010239b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010239e:	89 f0                	mov    %esi,%eax
801023a0:	5b                   	pop    %ebx
801023a1:	5e                   	pop    %esi
801023a2:	5f                   	pop    %edi
801023a3:	5d                   	pop    %ebp
801023a4:	c3                   	ret    
801023a5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
801023a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801023ab:	89 fb                	mov    %edi,%ebx
801023ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
801023b0:	31 c0                	xor    %eax,%eax
801023b2:	eb b5                	jmp    80102369 <namex+0x129>
801023b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801023b8:	83 ec 0c             	sub    $0xc,%esp
801023bb:	56                   	push   %esi
801023bc:	e8 4f f9 ff ff       	call   80101d10 <iunlock>
  iput(ip);
801023c1:	89 34 24             	mov    %esi,(%esp)
      return 0;
801023c4:	31 f6                	xor    %esi,%esi
  iput(ip);
801023c6:	e8 95 f9 ff ff       	call   80101d60 <iput>
      return 0;
801023cb:	83 c4 10             	add    $0x10,%esp
}
801023ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023d1:	89 f0                	mov    %esi,%eax
801023d3:	5b                   	pop    %ebx
801023d4:	5e                   	pop    %esi
801023d5:	5f                   	pop    %edi
801023d6:	5d                   	pop    %ebp
801023d7:	c3                   	ret    
801023d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023df:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
801023e0:	ba 01 00 00 00       	mov    $0x1,%edx
801023e5:	b8 01 00 00 00       	mov    $0x1,%eax
801023ea:	89 df                	mov    %ebx,%edi
801023ec:	e8 1f f4 ff ff       	call   80101810 <iget>
801023f1:	89 c6                	mov    %eax,%esi
801023f3:	e9 9b fe ff ff       	jmp    80102293 <namex+0x53>
801023f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ff:	90                   	nop
      iunlock(ip);
80102400:	83 ec 0c             	sub    $0xc,%esp
80102403:	56                   	push   %esi
80102404:	e8 07 f9 ff ff       	call   80101d10 <iunlock>
      return ip;
80102409:	83 c4 10             	add    $0x10,%esp
}
8010240c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010240f:	89 f0                	mov    %esi,%eax
80102411:	5b                   	pop    %ebx
80102412:	5e                   	pop    %esi
80102413:	5f                   	pop    %edi
80102414:	5d                   	pop    %ebp
80102415:	c3                   	ret    
80102416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010241d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80102420:	83 ec 0c             	sub    $0xc,%esp
80102423:	56                   	push   %esi
    return 0;
80102424:	31 f6                	xor    %esi,%esi
    iput(ip);
80102426:	e8 35 f9 ff ff       	call   80101d60 <iput>
    return 0;
8010242b:	83 c4 10             	add    $0x10,%esp
8010242e:	e9 68 ff ff ff       	jmp    8010239b <namex+0x15b>
80102433:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102440 <dirlink>:
{
80102440:	f3 0f 1e fb          	endbr32 
80102444:	55                   	push   %ebp
80102445:	89 e5                	mov    %esp,%ebp
80102447:	57                   	push   %edi
80102448:	56                   	push   %esi
80102449:	53                   	push   %ebx
8010244a:	83 ec 20             	sub    $0x20,%esp
8010244d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102450:	6a 00                	push   $0x0
80102452:	ff 75 0c             	pushl  0xc(%ebp)
80102455:	53                   	push   %ebx
80102456:	e8 25 fd ff ff       	call   80102180 <dirlookup>
8010245b:	83 c4 10             	add    $0x10,%esp
8010245e:	85 c0                	test   %eax,%eax
80102460:	75 6b                	jne    801024cd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102462:	8b 7b 58             	mov    0x58(%ebx),%edi
80102465:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102468:	85 ff                	test   %edi,%edi
8010246a:	74 2d                	je     80102499 <dirlink+0x59>
8010246c:	31 ff                	xor    %edi,%edi
8010246e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102471:	eb 0d                	jmp    80102480 <dirlink+0x40>
80102473:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102477:	90                   	nop
80102478:	83 c7 10             	add    $0x10,%edi
8010247b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010247e:	73 19                	jae    80102499 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102480:	6a 10                	push   $0x10
80102482:	57                   	push   %edi
80102483:	56                   	push   %esi
80102484:	53                   	push   %ebx
80102485:	e8 a6 fa ff ff       	call   80101f30 <readi>
8010248a:	83 c4 10             	add    $0x10,%esp
8010248d:	83 f8 10             	cmp    $0x10,%eax
80102490:	75 4e                	jne    801024e0 <dirlink+0xa0>
    if(de.inum == 0)
80102492:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102497:	75 df                	jne    80102478 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102499:	83 ec 04             	sub    $0x4,%esp
8010249c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010249f:	6a 0e                	push   $0xe
801024a1:	ff 75 0c             	pushl  0xc(%ebp)
801024a4:	50                   	push   %eax
801024a5:	e8 f6 27 00 00       	call   80104ca0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024aa:	6a 10                	push   $0x10
  de.inum = inum;
801024ac:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024af:	57                   	push   %edi
801024b0:	56                   	push   %esi
801024b1:	53                   	push   %ebx
  de.inum = inum;
801024b2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024b6:	e8 75 fb ff ff       	call   80102030 <writei>
801024bb:	83 c4 20             	add    $0x20,%esp
801024be:	83 f8 10             	cmp    $0x10,%eax
801024c1:	75 2a                	jne    801024ed <dirlink+0xad>
  return 0;
801024c3:	31 c0                	xor    %eax,%eax
}
801024c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024c8:	5b                   	pop    %ebx
801024c9:	5e                   	pop    %esi
801024ca:	5f                   	pop    %edi
801024cb:	5d                   	pop    %ebp
801024cc:	c3                   	ret    
    iput(ip);
801024cd:	83 ec 0c             	sub    $0xc,%esp
801024d0:	50                   	push   %eax
801024d1:	e8 8a f8 ff ff       	call   80101d60 <iput>
    return -1;
801024d6:	83 c4 10             	add    $0x10,%esp
801024d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024de:	eb e5                	jmp    801024c5 <dirlink+0x85>
      panic("dirlink read");
801024e0:	83 ec 0c             	sub    $0xc,%esp
801024e3:	68 80 77 10 80       	push   $0x80107780
801024e8:	e8 a3 de ff ff       	call   80100390 <panic>
    panic("dirlink");
801024ed:	83 ec 0c             	sub    $0xc,%esp
801024f0:	68 5e 7d 10 80       	push   $0x80107d5e
801024f5:	e8 96 de ff ff       	call   80100390 <panic>
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102500 <namei>:

struct inode*
namei(char *path)
{
80102500:	f3 0f 1e fb          	endbr32 
80102504:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102505:	31 d2                	xor    %edx,%edx
{
80102507:	89 e5                	mov    %esp,%ebp
80102509:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010250c:	8b 45 08             	mov    0x8(%ebp),%eax
8010250f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102512:	e8 29 fd ff ff       	call   80102240 <namex>
}
80102517:	c9                   	leave  
80102518:	c3                   	ret    
80102519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102520 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102520:	f3 0f 1e fb          	endbr32 
80102524:	55                   	push   %ebp
  return namex(path, 1, name);
80102525:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010252a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010252c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010252f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102532:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102533:	e9 08 fd ff ff       	jmp    80102240 <namex>
80102538:	66 90                	xchg   %ax,%ax
8010253a:	66 90                	xchg   %ax,%ax
8010253c:	66 90                	xchg   %ax,%ax
8010253e:	66 90                	xchg   %ax,%ax

80102540 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	57                   	push   %edi
80102544:	56                   	push   %esi
80102545:	53                   	push   %ebx
80102546:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102549:	85 c0                	test   %eax,%eax
8010254b:	0f 84 b4 00 00 00    	je     80102605 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102551:	8b 70 08             	mov    0x8(%eax),%esi
80102554:	89 c3                	mov    %eax,%ebx
80102556:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010255c:	0f 87 96 00 00 00    	ja     801025f8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102562:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010256e:	66 90                	xchg   %ax,%ax
80102570:	89 ca                	mov    %ecx,%edx
80102572:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102573:	83 e0 c0             	and    $0xffffffc0,%eax
80102576:	3c 40                	cmp    $0x40,%al
80102578:	75 f6                	jne    80102570 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010257a:	31 ff                	xor    %edi,%edi
8010257c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102581:	89 f8                	mov    %edi,%eax
80102583:	ee                   	out    %al,(%dx)
80102584:	b8 01 00 00 00       	mov    $0x1,%eax
80102589:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010258e:	ee                   	out    %al,(%dx)
8010258f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102594:	89 f0                	mov    %esi,%eax
80102596:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102597:	89 f0                	mov    %esi,%eax
80102599:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010259e:	c1 f8 08             	sar    $0x8,%eax
801025a1:	ee                   	out    %al,(%dx)
801025a2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801025a7:	89 f8                	mov    %edi,%eax
801025a9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801025aa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801025ae:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025b3:	c1 e0 04             	shl    $0x4,%eax
801025b6:	83 e0 10             	and    $0x10,%eax
801025b9:	83 c8 e0             	or     $0xffffffe0,%eax
801025bc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801025bd:	f6 03 04             	testb  $0x4,(%ebx)
801025c0:	75 16                	jne    801025d8 <idestart+0x98>
801025c2:	b8 20 00 00 00       	mov    $0x20,%eax
801025c7:	89 ca                	mov    %ecx,%edx
801025c9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801025ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025cd:	5b                   	pop    %ebx
801025ce:	5e                   	pop    %esi
801025cf:	5f                   	pop    %edi
801025d0:	5d                   	pop    %ebp
801025d1:	c3                   	ret    
801025d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025d8:	b8 30 00 00 00       	mov    $0x30,%eax
801025dd:	89 ca                	mov    %ecx,%edx
801025df:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801025e0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801025e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801025e8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801025ed:	fc                   	cld    
801025ee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801025f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025f3:	5b                   	pop    %ebx
801025f4:	5e                   	pop    %esi
801025f5:	5f                   	pop    %edi
801025f6:	5d                   	pop    %ebp
801025f7:	c3                   	ret    
    panic("incorrect blockno");
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	68 ec 77 10 80       	push   $0x801077ec
80102600:	e8 8b dd ff ff       	call   80100390 <panic>
    panic("idestart");
80102605:	83 ec 0c             	sub    $0xc,%esp
80102608:	68 e3 77 10 80       	push   $0x801077e3
8010260d:	e8 7e dd ff ff       	call   80100390 <panic>
80102612:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102620 <ideinit>:
{
80102620:	f3 0f 1e fb          	endbr32 
80102624:	55                   	push   %ebp
80102625:	89 e5                	mov    %esp,%ebp
80102627:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010262a:	68 fe 77 10 80       	push   $0x801077fe
8010262f:	68 80 a5 10 80       	push   $0x8010a580
80102634:	e8 77 22 00 00       	call   801048b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102639:	58                   	pop    %eax
8010263a:	a1 a0 32 11 80       	mov    0x801132a0,%eax
8010263f:	5a                   	pop    %edx
80102640:	83 e8 01             	sub    $0x1,%eax
80102643:	50                   	push   %eax
80102644:	6a 0e                	push   $0xe
80102646:	e8 b5 02 00 00       	call   80102900 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010264b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010264e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102653:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102657:	90                   	nop
80102658:	ec                   	in     (%dx),%al
80102659:	83 e0 c0             	and    $0xffffffc0,%eax
8010265c:	3c 40                	cmp    $0x40,%al
8010265e:	75 f8                	jne    80102658 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102660:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102665:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010266a:	ee                   	out    %al,(%dx)
8010266b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102670:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102675:	eb 0e                	jmp    80102685 <ideinit+0x65>
80102677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102680:	83 e9 01             	sub    $0x1,%ecx
80102683:	74 0f                	je     80102694 <ideinit+0x74>
80102685:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102686:	84 c0                	test   %al,%al
80102688:	74 f6                	je     80102680 <ideinit+0x60>
      havedisk1 = 1;
8010268a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102691:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102694:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102699:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010269e:	ee                   	out    %al,(%dx)
}
8010269f:	c9                   	leave  
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026af:	90                   	nop

801026b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026b0:	f3 0f 1e fb          	endbr32 
801026b4:	55                   	push   %ebp
801026b5:	89 e5                	mov    %esp,%ebp
801026b7:	57                   	push   %edi
801026b8:	56                   	push   %esi
801026b9:	53                   	push   %ebx
801026ba:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026bd:	68 80 a5 10 80       	push   $0x8010a580
801026c2:	e8 69 23 00 00       	call   80104a30 <acquire>

  if((b = idequeue) == 0){
801026c7:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801026cd:	83 c4 10             	add    $0x10,%esp
801026d0:	85 db                	test   %ebx,%ebx
801026d2:	74 5f                	je     80102733 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801026d4:	8b 43 58             	mov    0x58(%ebx),%eax
801026d7:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801026dc:	8b 33                	mov    (%ebx),%esi
801026de:	f7 c6 04 00 00 00    	test   $0x4,%esi
801026e4:	75 2b                	jne    80102711 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026e6:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026ef:	90                   	nop
801026f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801026f1:	89 c1                	mov    %eax,%ecx
801026f3:	83 e1 c0             	and    $0xffffffc0,%ecx
801026f6:	80 f9 40             	cmp    $0x40,%cl
801026f9:	75 f5                	jne    801026f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801026fb:	a8 21                	test   $0x21,%al
801026fd:	75 12                	jne    80102711 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801026ff:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102702:	b9 80 00 00 00       	mov    $0x80,%ecx
80102707:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010270c:	fc                   	cld    
8010270d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010270f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102711:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102714:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102717:	83 ce 02             	or     $0x2,%esi
8010271a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010271c:	53                   	push   %ebx
8010271d:	e8 8e 1e 00 00       	call   801045b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102722:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102727:	83 c4 10             	add    $0x10,%esp
8010272a:	85 c0                	test   %eax,%eax
8010272c:	74 05                	je     80102733 <ideintr+0x83>
    idestart(idequeue);
8010272e:	e8 0d fe ff ff       	call   80102540 <idestart>
    release(&idelock);
80102733:	83 ec 0c             	sub    $0xc,%esp
80102736:	68 80 a5 10 80       	push   $0x8010a580
8010273b:	e8 b0 23 00 00       	call   80104af0 <release>

  release(&idelock);
}
80102740:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102743:	5b                   	pop    %ebx
80102744:	5e                   	pop    %esi
80102745:	5f                   	pop    %edi
80102746:	5d                   	pop    %ebp
80102747:	c3                   	ret    
80102748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010274f:	90                   	nop

80102750 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102750:	f3 0f 1e fb          	endbr32 
80102754:	55                   	push   %ebp
80102755:	89 e5                	mov    %esp,%ebp
80102757:	53                   	push   %ebx
80102758:	83 ec 10             	sub    $0x10,%esp
8010275b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010275e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102761:	50                   	push   %eax
80102762:	e8 e9 20 00 00       	call   80104850 <holdingsleep>
80102767:	83 c4 10             	add    $0x10,%esp
8010276a:	85 c0                	test   %eax,%eax
8010276c:	0f 84 cf 00 00 00    	je     80102841 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102772:	8b 03                	mov    (%ebx),%eax
80102774:	83 e0 06             	and    $0x6,%eax
80102777:	83 f8 02             	cmp    $0x2,%eax
8010277a:	0f 84 b4 00 00 00    	je     80102834 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102780:	8b 53 04             	mov    0x4(%ebx),%edx
80102783:	85 d2                	test   %edx,%edx
80102785:	74 0d                	je     80102794 <iderw+0x44>
80102787:	a1 60 a5 10 80       	mov    0x8010a560,%eax
8010278c:	85 c0                	test   %eax,%eax
8010278e:	0f 84 93 00 00 00    	je     80102827 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102794:	83 ec 0c             	sub    $0xc,%esp
80102797:	68 80 a5 10 80       	push   $0x8010a580
8010279c:	e8 8f 22 00 00       	call   80104a30 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027a1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801027a6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027ad:	83 c4 10             	add    $0x10,%esp
801027b0:	85 c0                	test   %eax,%eax
801027b2:	74 6c                	je     80102820 <iderw+0xd0>
801027b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b8:	89 c2                	mov    %eax,%edx
801027ba:	8b 40 58             	mov    0x58(%eax),%eax
801027bd:	85 c0                	test   %eax,%eax
801027bf:	75 f7                	jne    801027b8 <iderw+0x68>
801027c1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801027c4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801027c6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801027cc:	74 42                	je     80102810 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801027ce:	8b 03                	mov    (%ebx),%eax
801027d0:	83 e0 06             	and    $0x6,%eax
801027d3:	83 f8 02             	cmp    $0x2,%eax
801027d6:	74 23                	je     801027fb <iderw+0xab>
801027d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027df:	90                   	nop
    sleep(b, &idelock);
801027e0:	83 ec 08             	sub    $0x8,%esp
801027e3:	68 80 a5 10 80       	push   $0x8010a580
801027e8:	53                   	push   %ebx
801027e9:	e8 02 1c 00 00       	call   801043f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801027ee:	8b 03                	mov    (%ebx),%eax
801027f0:	83 c4 10             	add    $0x10,%esp
801027f3:	83 e0 06             	and    $0x6,%eax
801027f6:	83 f8 02             	cmp    $0x2,%eax
801027f9:	75 e5                	jne    801027e0 <iderw+0x90>
  }


  release(&idelock);
801027fb:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102802:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102805:	c9                   	leave  
  release(&idelock);
80102806:	e9 e5 22 00 00       	jmp    80104af0 <release>
8010280b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010280f:	90                   	nop
    idestart(b);
80102810:	89 d8                	mov    %ebx,%eax
80102812:	e8 29 fd ff ff       	call   80102540 <idestart>
80102817:	eb b5                	jmp    801027ce <iderw+0x7e>
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102820:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102825:	eb 9d                	jmp    801027c4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102827:	83 ec 0c             	sub    $0xc,%esp
8010282a:	68 2d 78 10 80       	push   $0x8010782d
8010282f:	e8 5c db ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102834:	83 ec 0c             	sub    $0xc,%esp
80102837:	68 18 78 10 80       	push   $0x80107818
8010283c:	e8 4f db ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102841:	83 ec 0c             	sub    $0xc,%esp
80102844:	68 02 78 10 80       	push   $0x80107802
80102849:	e8 42 db ff ff       	call   80100390 <panic>
8010284e:	66 90                	xchg   %ax,%ax

80102850 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102850:	f3 0f 1e fb          	endbr32 
80102854:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102855:	c7 05 d4 2b 11 80 00 	movl   $0xfec00000,0x80112bd4
8010285c:	00 c0 fe 
{
8010285f:	89 e5                	mov    %esp,%ebp
80102861:	56                   	push   %esi
80102862:	53                   	push   %ebx
  ioapic->reg = reg;
80102863:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010286a:	00 00 00 
  return ioapic->data;
8010286d:	8b 15 d4 2b 11 80    	mov    0x80112bd4,%edx
80102873:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102876:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010287c:	8b 0d d4 2b 11 80    	mov    0x80112bd4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102882:	0f b6 15 00 2d 11 80 	movzbl 0x80112d00,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102889:	c1 ee 10             	shr    $0x10,%esi
8010288c:	89 f0                	mov    %esi,%eax
8010288e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102891:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102894:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102897:	39 c2                	cmp    %eax,%edx
80102899:	74 16                	je     801028b1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010289b:	83 ec 0c             	sub    $0xc,%esp
8010289e:	68 4c 78 10 80       	push   $0x8010784c
801028a3:	e8 f8 df ff ff       	call   801008a0 <cprintf>
801028a8:	8b 0d d4 2b 11 80    	mov    0x80112bd4,%ecx
801028ae:	83 c4 10             	add    $0x10,%esp
801028b1:	83 c6 21             	add    $0x21,%esi
{
801028b4:	ba 10 00 00 00       	mov    $0x10,%edx
801028b9:	b8 20 00 00 00       	mov    $0x20,%eax
801028be:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801028c0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801028c2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801028c4:	8b 0d d4 2b 11 80    	mov    0x80112bd4,%ecx
801028ca:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801028cd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801028d3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801028d6:	8d 5a 01             	lea    0x1(%edx),%ebx
801028d9:	83 c2 02             	add    $0x2,%edx
801028dc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801028de:	8b 0d d4 2b 11 80    	mov    0x80112bd4,%ecx
801028e4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801028eb:	39 f0                	cmp    %esi,%eax
801028ed:	75 d1                	jne    801028c0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801028ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028f2:	5b                   	pop    %ebx
801028f3:	5e                   	pop    %esi
801028f4:	5d                   	pop    %ebp
801028f5:	c3                   	ret    
801028f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fd:	8d 76 00             	lea    0x0(%esi),%esi

80102900 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102900:	f3 0f 1e fb          	endbr32 
80102904:	55                   	push   %ebp
  ioapic->reg = reg;
80102905:	8b 0d d4 2b 11 80    	mov    0x80112bd4,%ecx
{
8010290b:	89 e5                	mov    %esp,%ebp
8010290d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102910:	8d 50 20             	lea    0x20(%eax),%edx
80102913:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102917:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102919:	8b 0d d4 2b 11 80    	mov    0x80112bd4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010291f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102922:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102925:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102928:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010292a:	a1 d4 2b 11 80       	mov    0x80112bd4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010292f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102932:	89 50 10             	mov    %edx,0x10(%eax)
}
80102935:	5d                   	pop    %ebp
80102936:	c3                   	ret    
80102937:	66 90                	xchg   %ax,%ax
80102939:	66 90                	xchg   %ax,%ax
8010293b:	66 90                	xchg   %ax,%ax
8010293d:	66 90                	xchg   %ax,%ax
8010293f:	90                   	nop

80102940 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102940:	f3 0f 1e fb          	endbr32 
80102944:	55                   	push   %ebp
80102945:	89 e5                	mov    %esp,%ebp
80102947:	53                   	push   %ebx
80102948:	83 ec 04             	sub    $0x4,%esp
8010294b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010294e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102954:	75 7a                	jne    801029d0 <kfree+0x90>
80102956:	81 fb 48 5a 11 80    	cmp    $0x80115a48,%ebx
8010295c:	72 72                	jb     801029d0 <kfree+0x90>
8010295e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102964:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102969:	77 65                	ja     801029d0 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010296b:	83 ec 04             	sub    $0x4,%esp
8010296e:	68 00 10 00 00       	push   $0x1000
80102973:	6a 01                	push   $0x1
80102975:	53                   	push   %ebx
80102976:	e8 c5 21 00 00       	call   80104b40 <memset>

  if(kmem.use_lock)
8010297b:	8b 15 14 2c 11 80    	mov    0x80112c14,%edx
80102981:	83 c4 10             	add    $0x10,%esp
80102984:	85 d2                	test   %edx,%edx
80102986:	75 20                	jne    801029a8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102988:	a1 18 2c 11 80       	mov    0x80112c18,%eax
8010298d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010298f:	a1 14 2c 11 80       	mov    0x80112c14,%eax
  kmem.freelist = r;
80102994:	89 1d 18 2c 11 80    	mov    %ebx,0x80112c18
  if(kmem.use_lock)
8010299a:	85 c0                	test   %eax,%eax
8010299c:	75 22                	jne    801029c0 <kfree+0x80>
    release(&kmem.lock);
}
8010299e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029a1:	c9                   	leave  
801029a2:	c3                   	ret    
801029a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029a7:	90                   	nop
    acquire(&kmem.lock);
801029a8:	83 ec 0c             	sub    $0xc,%esp
801029ab:	68 e0 2b 11 80       	push   $0x80112be0
801029b0:	e8 7b 20 00 00       	call   80104a30 <acquire>
801029b5:	83 c4 10             	add    $0x10,%esp
801029b8:	eb ce                	jmp    80102988 <kfree+0x48>
801029ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801029c0:	c7 45 08 e0 2b 11 80 	movl   $0x80112be0,0x8(%ebp)
}
801029c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ca:	c9                   	leave  
    release(&kmem.lock);
801029cb:	e9 20 21 00 00       	jmp    80104af0 <release>
    panic("kfree");
801029d0:	83 ec 0c             	sub    $0xc,%esp
801029d3:	68 7e 78 10 80       	push   $0x8010787e
801029d8:	e8 b3 d9 ff ff       	call   80100390 <panic>
801029dd:	8d 76 00             	lea    0x0(%esi),%esi

801029e0 <freerange>:
{
801029e0:	f3 0f 1e fb          	endbr32 
801029e4:	55                   	push   %ebp
801029e5:	89 e5                	mov    %esp,%ebp
801029e7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801029e8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801029eb:	8b 75 0c             	mov    0xc(%ebp),%esi
801029ee:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801029ef:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801029f5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a01:	39 de                	cmp    %ebx,%esi
80102a03:	72 1f                	jb     80102a24 <freerange+0x44>
80102a05:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102a08:	83 ec 0c             	sub    $0xc,%esp
80102a0b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a11:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a17:	50                   	push   %eax
80102a18:	e8 23 ff ff ff       	call   80102940 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a1d:	83 c4 10             	add    $0x10,%esp
80102a20:	39 f3                	cmp    %esi,%ebx
80102a22:	76 e4                	jbe    80102a08 <freerange+0x28>
}
80102a24:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a27:	5b                   	pop    %ebx
80102a28:	5e                   	pop    %esi
80102a29:	5d                   	pop    %ebp
80102a2a:	c3                   	ret    
80102a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a2f:	90                   	nop

80102a30 <kinit1>:
{
80102a30:	f3 0f 1e fb          	endbr32 
80102a34:	55                   	push   %ebp
80102a35:	89 e5                	mov    %esp,%ebp
80102a37:	56                   	push   %esi
80102a38:	53                   	push   %ebx
80102a39:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102a3c:	83 ec 08             	sub    $0x8,%esp
80102a3f:	68 84 78 10 80       	push   $0x80107884
80102a44:	68 e0 2b 11 80       	push   $0x80112be0
80102a49:	e8 62 1e 00 00       	call   801048b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a51:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102a54:	c7 05 14 2c 11 80 00 	movl   $0x0,0x80112c14
80102a5b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102a5e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a64:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a6a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a70:	39 de                	cmp    %ebx,%esi
80102a72:	72 20                	jb     80102a94 <kinit1+0x64>
80102a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102a78:	83 ec 0c             	sub    $0xc,%esp
80102a7b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a81:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a87:	50                   	push   %eax
80102a88:	e8 b3 fe ff ff       	call   80102940 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a8d:	83 c4 10             	add    $0x10,%esp
80102a90:	39 de                	cmp    %ebx,%esi
80102a92:	73 e4                	jae    80102a78 <kinit1+0x48>
}
80102a94:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a97:	5b                   	pop    %ebx
80102a98:	5e                   	pop    %esi
80102a99:	5d                   	pop    %ebp
80102a9a:	c3                   	ret    
80102a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a9f:	90                   	nop

80102aa0 <kinit2>:
{
80102aa0:	f3 0f 1e fb          	endbr32 
80102aa4:	55                   	push   %ebp
80102aa5:	89 e5                	mov    %esp,%ebp
80102aa7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102aa8:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102aab:	8b 75 0c             	mov    0xc(%ebp),%esi
80102aae:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102aaf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ab5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102abb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102ac1:	39 de                	cmp    %ebx,%esi
80102ac3:	72 1f                	jb     80102ae4 <kinit2+0x44>
80102ac5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102ac8:	83 ec 0c             	sub    $0xc,%esp
80102acb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ad1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102ad7:	50                   	push   %eax
80102ad8:	e8 63 fe ff ff       	call   80102940 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102add:	83 c4 10             	add    $0x10,%esp
80102ae0:	39 de                	cmp    %ebx,%esi
80102ae2:	73 e4                	jae    80102ac8 <kinit2+0x28>
  kmem.use_lock = 1;
80102ae4:	c7 05 14 2c 11 80 01 	movl   $0x1,0x80112c14
80102aeb:	00 00 00 
}
80102aee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102af1:	5b                   	pop    %ebx
80102af2:	5e                   	pop    %esi
80102af3:	5d                   	pop    %ebp
80102af4:	c3                   	ret    
80102af5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b00:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102b04:	a1 14 2c 11 80       	mov    0x80112c14,%eax
80102b09:	85 c0                	test   %eax,%eax
80102b0b:	75 1b                	jne    80102b28 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102b0d:	a1 18 2c 11 80       	mov    0x80112c18,%eax
  if(r)
80102b12:	85 c0                	test   %eax,%eax
80102b14:	74 0a                	je     80102b20 <kalloc+0x20>
    kmem.freelist = r->next;
80102b16:	8b 10                	mov    (%eax),%edx
80102b18:	89 15 18 2c 11 80    	mov    %edx,0x80112c18
  if(kmem.use_lock)
80102b1e:	c3                   	ret    
80102b1f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102b20:	c3                   	ret    
80102b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102b28:	55                   	push   %ebp
80102b29:	89 e5                	mov    %esp,%ebp
80102b2b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102b2e:	68 e0 2b 11 80       	push   $0x80112be0
80102b33:	e8 f8 1e 00 00       	call   80104a30 <acquire>
  r = kmem.freelist;
80102b38:	a1 18 2c 11 80       	mov    0x80112c18,%eax
  if(r)
80102b3d:	8b 15 14 2c 11 80    	mov    0x80112c14,%edx
80102b43:	83 c4 10             	add    $0x10,%esp
80102b46:	85 c0                	test   %eax,%eax
80102b48:	74 08                	je     80102b52 <kalloc+0x52>
    kmem.freelist = r->next;
80102b4a:	8b 08                	mov    (%eax),%ecx
80102b4c:	89 0d 18 2c 11 80    	mov    %ecx,0x80112c18
  if(kmem.use_lock)
80102b52:	85 d2                	test   %edx,%edx
80102b54:	74 16                	je     80102b6c <kalloc+0x6c>
    release(&kmem.lock);
80102b56:	83 ec 0c             	sub    $0xc,%esp
80102b59:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b5c:	68 e0 2b 11 80       	push   $0x80112be0
80102b61:	e8 8a 1f 00 00       	call   80104af0 <release>
  return (char*)r;
80102b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102b69:	83 c4 10             	add    $0x10,%esp
}
80102b6c:	c9                   	leave  
80102b6d:	c3                   	ret    
80102b6e:	66 90                	xchg   %ax,%ax

80102b70 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b70:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b74:	ba 64 00 00 00       	mov    $0x64,%edx
80102b79:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102b7a:	a8 01                	test   $0x1,%al
80102b7c:	0f 84 be 00 00 00    	je     80102c40 <kbdgetc+0xd0>
{
80102b82:	55                   	push   %ebp
80102b83:	ba 60 00 00 00       	mov    $0x60,%edx
80102b88:	89 e5                	mov    %esp,%ebp
80102b8a:	53                   	push   %ebx
80102b8b:	ec                   	in     (%dx),%al
  return data;
80102b8c:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102b92:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102b95:	3c e0                	cmp    $0xe0,%al
80102b97:	74 57                	je     80102bf0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102b99:	89 d9                	mov    %ebx,%ecx
80102b9b:	83 e1 40             	and    $0x40,%ecx
80102b9e:	84 c0                	test   %al,%al
80102ba0:	78 5e                	js     80102c00 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102ba2:	85 c9                	test   %ecx,%ecx
80102ba4:	74 09                	je     80102baf <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ba6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102ba9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102bac:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102baf:	0f b6 8a c0 79 10 80 	movzbl -0x7fef8640(%edx),%ecx
  shift ^= togglecode[data];
80102bb6:	0f b6 82 c0 78 10 80 	movzbl -0x7fef8740(%edx),%eax
  shift |= shiftcode[data];
80102bbd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102bbf:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bc1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102bc3:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102bc9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102bcc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bcf:	8b 04 85 a0 78 10 80 	mov    -0x7fef8760(,%eax,4),%eax
80102bd6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102bda:	74 0b                	je     80102be7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102bdc:	8d 50 9f             	lea    -0x61(%eax),%edx
80102bdf:	83 fa 19             	cmp    $0x19,%edx
80102be2:	77 44                	ja     80102c28 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102be4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102be7:	5b                   	pop    %ebx
80102be8:	5d                   	pop    %ebp
80102be9:	c3                   	ret    
80102bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102bf0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102bf3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102bf5:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
80102bfb:	5b                   	pop    %ebx
80102bfc:	5d                   	pop    %ebp
80102bfd:	c3                   	ret    
80102bfe:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102c00:	83 e0 7f             	and    $0x7f,%eax
80102c03:	85 c9                	test   %ecx,%ecx
80102c05:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102c08:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102c0a:	0f b6 8a c0 79 10 80 	movzbl -0x7fef8640(%edx),%ecx
80102c11:	83 c9 40             	or     $0x40,%ecx
80102c14:	0f b6 c9             	movzbl %cl,%ecx
80102c17:	f7 d1                	not    %ecx
80102c19:	21 d9                	and    %ebx,%ecx
}
80102c1b:	5b                   	pop    %ebx
80102c1c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102c1d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102c23:	c3                   	ret    
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102c28:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102c2b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102c2e:	5b                   	pop    %ebx
80102c2f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102c30:	83 f9 1a             	cmp    $0x1a,%ecx
80102c33:	0f 42 c2             	cmovb  %edx,%eax
}
80102c36:	c3                   	ret    
80102c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c3e:	66 90                	xchg   %ax,%ax
    return -1;
80102c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102c45:	c3                   	ret    
80102c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c4d:	8d 76 00             	lea    0x0(%esi),%esi

80102c50 <kbdintr>:

void
kbdintr(void)
{
80102c50:	f3 0f 1e fb          	endbr32 
80102c54:	55                   	push   %ebp
80102c55:	89 e5                	mov    %esp,%ebp
80102c57:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102c5a:	68 70 2b 10 80       	push   $0x80102b70
80102c5f:	e8 ec dd ff ff       	call   80100a50 <consoleintr>
}
80102c64:	83 c4 10             	add    $0x10,%esp
80102c67:	c9                   	leave  
80102c68:	c3                   	ret    
80102c69:	66 90                	xchg   %ax,%ax
80102c6b:	66 90                	xchg   %ax,%ax
80102c6d:	66 90                	xchg   %ax,%ax
80102c6f:	90                   	nop

80102c70 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102c70:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102c74:	a1 1c 2c 11 80       	mov    0x80112c1c,%eax
80102c79:	85 c0                	test   %eax,%eax
80102c7b:	0f 84 c7 00 00 00    	je     80102d48 <lapicinit+0xd8>
  lapic[index] = value;
80102c81:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102c88:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c8b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c8e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102c95:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c98:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c9b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102ca2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102ca5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ca8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102caf:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102cb2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cb5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102cbc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cbf:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cc2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102cc9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ccc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ccf:	8b 50 30             	mov    0x30(%eax),%edx
80102cd2:	c1 ea 10             	shr    $0x10,%edx
80102cd5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102cdb:	75 73                	jne    80102d50 <lapicinit+0xe0>
  lapic[index] = value;
80102cdd:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102ce4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cea:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102cf1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cf4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cf7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102cfe:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d01:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d04:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d0b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d0e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d11:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d18:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d1b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d1e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102d25:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102d28:	8b 50 20             	mov    0x20(%eax),%edx
80102d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d2f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102d30:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102d36:	80 e6 10             	and    $0x10,%dh
80102d39:	75 f5                	jne    80102d30 <lapicinit+0xc0>
  lapic[index] = value;
80102d3b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102d42:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d45:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102d48:	c3                   	ret    
80102d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102d50:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102d57:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d5a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102d5d:	e9 7b ff ff ff       	jmp    80102cdd <lapicinit+0x6d>
80102d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <lapicid>:

int
lapicid(void)
{
80102d70:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102d74:	a1 1c 2c 11 80       	mov    0x80112c1c,%eax
80102d79:	85 c0                	test   %eax,%eax
80102d7b:	74 0b                	je     80102d88 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102d7d:	8b 40 20             	mov    0x20(%eax),%eax
80102d80:	c1 e8 18             	shr    $0x18,%eax
80102d83:	c3                   	ret    
80102d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102d88:	31 c0                	xor    %eax,%eax
}
80102d8a:	c3                   	ret    
80102d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d8f:	90                   	nop

80102d90 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102d90:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102d94:	a1 1c 2c 11 80       	mov    0x80112c1c,%eax
80102d99:	85 c0                	test   %eax,%eax
80102d9b:	74 0d                	je     80102daa <lapiceoi+0x1a>
  lapic[index] = value;
80102d9d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102da4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102da7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102daa:	c3                   	ret    
80102dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102daf:	90                   	nop

80102db0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102db0:	f3 0f 1e fb          	endbr32 
}
80102db4:	c3                   	ret    
80102db5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102dc0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102dc0:	f3 0f 1e fb          	endbr32 
80102dc4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc5:	b8 0f 00 00 00       	mov    $0xf,%eax
80102dca:	ba 70 00 00 00       	mov    $0x70,%edx
80102dcf:	89 e5                	mov    %esp,%ebp
80102dd1:	53                   	push   %ebx
80102dd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102dd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102dd8:	ee                   	out    %al,(%dx)
80102dd9:	b8 0a 00 00 00       	mov    $0xa,%eax
80102dde:	ba 71 00 00 00       	mov    $0x71,%edx
80102de3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102de4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102de6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102de9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102def:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102df1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102df4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102df6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102df9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102dfc:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102e02:	a1 1c 2c 11 80       	mov    0x80112c1c,%eax
80102e07:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e0d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e10:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e17:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e1a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e1d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102e24:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e27:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e2a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e30:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e33:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e39:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e3c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e42:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e45:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102e4b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102e4c:	8b 40 20             	mov    0x20(%eax),%eax
}
80102e4f:	5d                   	pop    %ebp
80102e50:	c3                   	ret    
80102e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e5f:	90                   	nop

80102e60 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102e60:	f3 0f 1e fb          	endbr32 
80102e64:	55                   	push   %ebp
80102e65:	b8 0b 00 00 00       	mov    $0xb,%eax
80102e6a:	ba 70 00 00 00       	mov    $0x70,%edx
80102e6f:	89 e5                	mov    %esp,%ebp
80102e71:	57                   	push   %edi
80102e72:	56                   	push   %esi
80102e73:	53                   	push   %ebx
80102e74:	83 ec 4c             	sub    $0x4c,%esp
80102e77:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e78:	ba 71 00 00 00       	mov    $0x71,%edx
80102e7d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102e7e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e81:	bb 70 00 00 00       	mov    $0x70,%ebx
80102e86:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e90:	31 c0                	xor    %eax,%eax
80102e92:	89 da                	mov    %ebx,%edx
80102e94:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e95:	b9 71 00 00 00       	mov    $0x71,%ecx
80102e9a:	89 ca                	mov    %ecx,%edx
80102e9c:	ec                   	in     (%dx),%al
80102e9d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ea0:	89 da                	mov    %ebx,%edx
80102ea2:	b8 02 00 00 00       	mov    $0x2,%eax
80102ea7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ea8:	89 ca                	mov    %ecx,%edx
80102eaa:	ec                   	in     (%dx),%al
80102eab:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eae:	89 da                	mov    %ebx,%edx
80102eb0:	b8 04 00 00 00       	mov    $0x4,%eax
80102eb5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eb6:	89 ca                	mov    %ecx,%edx
80102eb8:	ec                   	in     (%dx),%al
80102eb9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ebc:	89 da                	mov    %ebx,%edx
80102ebe:	b8 07 00 00 00       	mov    $0x7,%eax
80102ec3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ec4:	89 ca                	mov    %ecx,%edx
80102ec6:	ec                   	in     (%dx),%al
80102ec7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eca:	89 da                	mov    %ebx,%edx
80102ecc:	b8 08 00 00 00       	mov    $0x8,%eax
80102ed1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ed2:	89 ca                	mov    %ecx,%edx
80102ed4:	ec                   	in     (%dx),%al
80102ed5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ed7:	89 da                	mov    %ebx,%edx
80102ed9:	b8 09 00 00 00       	mov    $0x9,%eax
80102ede:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102edf:	89 ca                	mov    %ecx,%edx
80102ee1:	ec                   	in     (%dx),%al
80102ee2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ee4:	89 da                	mov    %ebx,%edx
80102ee6:	b8 0a 00 00 00       	mov    $0xa,%eax
80102eeb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eec:	89 ca                	mov    %ecx,%edx
80102eee:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102eef:	84 c0                	test   %al,%al
80102ef1:	78 9d                	js     80102e90 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102ef3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102ef7:	89 fa                	mov    %edi,%edx
80102ef9:	0f b6 fa             	movzbl %dl,%edi
80102efc:	89 f2                	mov    %esi,%edx
80102efe:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102f01:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102f05:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f08:	89 da                	mov    %ebx,%edx
80102f0a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102f0d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102f10:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102f14:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102f17:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102f1a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102f1e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102f21:	31 c0                	xor    %eax,%eax
80102f23:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f24:	89 ca                	mov    %ecx,%edx
80102f26:	ec                   	in     (%dx),%al
80102f27:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f2a:	89 da                	mov    %ebx,%edx
80102f2c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102f2f:	b8 02 00 00 00       	mov    $0x2,%eax
80102f34:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f35:	89 ca                	mov    %ecx,%edx
80102f37:	ec                   	in     (%dx),%al
80102f38:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f3b:	89 da                	mov    %ebx,%edx
80102f3d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102f40:	b8 04 00 00 00       	mov    $0x4,%eax
80102f45:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f46:	89 ca                	mov    %ecx,%edx
80102f48:	ec                   	in     (%dx),%al
80102f49:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f4c:	89 da                	mov    %ebx,%edx
80102f4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102f51:	b8 07 00 00 00       	mov    $0x7,%eax
80102f56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f57:	89 ca                	mov    %ecx,%edx
80102f59:	ec                   	in     (%dx),%al
80102f5a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f5d:	89 da                	mov    %ebx,%edx
80102f5f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f62:	b8 08 00 00 00       	mov    $0x8,%eax
80102f67:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f68:	89 ca                	mov    %ecx,%edx
80102f6a:	ec                   	in     (%dx),%al
80102f6b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f6e:	89 da                	mov    %ebx,%edx
80102f70:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102f73:	b8 09 00 00 00       	mov    $0x9,%eax
80102f78:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f79:	89 ca                	mov    %ecx,%edx
80102f7b:	ec                   	in     (%dx),%al
80102f7c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f7f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102f82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f85:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102f88:	6a 18                	push   $0x18
80102f8a:	50                   	push   %eax
80102f8b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102f8e:	50                   	push   %eax
80102f8f:	e8 fc 1b 00 00       	call   80104b90 <memcmp>
80102f94:	83 c4 10             	add    $0x10,%esp
80102f97:	85 c0                	test   %eax,%eax
80102f99:	0f 85 f1 fe ff ff    	jne    80102e90 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102f9f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102fa3:	75 78                	jne    8010301d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102fa5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102fa8:	89 c2                	mov    %eax,%edx
80102faa:	83 e0 0f             	and    $0xf,%eax
80102fad:	c1 ea 04             	shr    $0x4,%edx
80102fb0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fb3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fb6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102fb9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102fbc:	89 c2                	mov    %eax,%edx
80102fbe:	83 e0 0f             	and    $0xf,%eax
80102fc1:	c1 ea 04             	shr    $0x4,%edx
80102fc4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fc7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fca:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102fcd:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102fd0:	89 c2                	mov    %eax,%edx
80102fd2:	83 e0 0f             	and    $0xf,%eax
80102fd5:	c1 ea 04             	shr    $0x4,%edx
80102fd8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fdb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fde:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102fe1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102fe4:	89 c2                	mov    %eax,%edx
80102fe6:	83 e0 0f             	and    $0xf,%eax
80102fe9:	c1 ea 04             	shr    $0x4,%edx
80102fec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fef:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ff2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102ff5:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ff8:	89 c2                	mov    %eax,%edx
80102ffa:	83 e0 0f             	and    $0xf,%eax
80102ffd:	c1 ea 04             	shr    $0x4,%edx
80103000:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103003:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103006:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103009:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010300c:	89 c2                	mov    %eax,%edx
8010300e:	83 e0 0f             	and    $0xf,%eax
80103011:	c1 ea 04             	shr    $0x4,%edx
80103014:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103017:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010301a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010301d:	8b 75 08             	mov    0x8(%ebp),%esi
80103020:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103023:	89 06                	mov    %eax,(%esi)
80103025:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103028:	89 46 04             	mov    %eax,0x4(%esi)
8010302b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010302e:	89 46 08             	mov    %eax,0x8(%esi)
80103031:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103034:	89 46 0c             	mov    %eax,0xc(%esi)
80103037:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010303a:	89 46 10             	mov    %eax,0x10(%esi)
8010303d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103040:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103043:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010304a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010304d:	5b                   	pop    %ebx
8010304e:	5e                   	pop    %esi
8010304f:	5f                   	pop    %edi
80103050:	5d                   	pop    %ebp
80103051:	c3                   	ret    
80103052:	66 90                	xchg   %ax,%ax
80103054:	66 90                	xchg   %ax,%ax
80103056:	66 90                	xchg   %ax,%ax
80103058:	66 90                	xchg   %ax,%ax
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103060:	8b 0d 68 2c 11 80    	mov    0x80112c68,%ecx
80103066:	85 c9                	test   %ecx,%ecx
80103068:	0f 8e 8a 00 00 00    	jle    801030f8 <install_trans+0x98>
{
8010306e:	55                   	push   %ebp
8010306f:	89 e5                	mov    %esp,%ebp
80103071:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103072:	31 ff                	xor    %edi,%edi
{
80103074:	56                   	push   %esi
80103075:	53                   	push   %ebx
80103076:	83 ec 0c             	sub    $0xc,%esp
80103079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103080:	a1 54 2c 11 80       	mov    0x80112c54,%eax
80103085:	83 ec 08             	sub    $0x8,%esp
80103088:	01 f8                	add    %edi,%eax
8010308a:	83 c0 01             	add    $0x1,%eax
8010308d:	50                   	push   %eax
8010308e:	ff 35 64 2c 11 80    	pushl  0x80112c64
80103094:	e8 37 d0 ff ff       	call   801000d0 <bread>
80103099:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010309b:	58                   	pop    %eax
8010309c:	5a                   	pop    %edx
8010309d:	ff 34 bd 6c 2c 11 80 	pushl  -0x7feed394(,%edi,4)
801030a4:	ff 35 64 2c 11 80    	pushl  0x80112c64
  for (tail = 0; tail < log.lh.n; tail++) {
801030aa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030ad:	e8 1e d0 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030b2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030b5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030b7:	8d 46 5c             	lea    0x5c(%esi),%eax
801030ba:	68 00 02 00 00       	push   $0x200
801030bf:	50                   	push   %eax
801030c0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801030c3:	50                   	push   %eax
801030c4:	e8 17 1b 00 00       	call   80104be0 <memmove>
    bwrite(dbuf);  // write dst to disk
801030c9:	89 1c 24             	mov    %ebx,(%esp)
801030cc:	e8 df d0 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801030d1:	89 34 24             	mov    %esi,(%esp)
801030d4:	e8 17 d1 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801030d9:	89 1c 24             	mov    %ebx,(%esp)
801030dc:	e8 0f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030e1:	83 c4 10             	add    $0x10,%esp
801030e4:	39 3d 68 2c 11 80    	cmp    %edi,0x80112c68
801030ea:	7f 94                	jg     80103080 <install_trans+0x20>
  }
}
801030ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030ef:	5b                   	pop    %ebx
801030f0:	5e                   	pop    %esi
801030f1:	5f                   	pop    %edi
801030f2:	5d                   	pop    %ebp
801030f3:	c3                   	ret    
801030f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030f8:	c3                   	ret    
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103100 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103100:	55                   	push   %ebp
80103101:	89 e5                	mov    %esp,%ebp
80103103:	53                   	push   %ebx
80103104:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103107:	ff 35 54 2c 11 80    	pushl  0x80112c54
8010310d:	ff 35 64 2c 11 80    	pushl  0x80112c64
80103113:	e8 b8 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103118:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010311b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010311d:	a1 68 2c 11 80       	mov    0x80112c68,%eax
80103122:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103125:	85 c0                	test   %eax,%eax
80103127:	7e 19                	jle    80103142 <write_head+0x42>
80103129:	31 d2                	xor    %edx,%edx
8010312b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010312f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103130:	8b 0c 95 6c 2c 11 80 	mov    -0x7feed394(,%edx,4),%ecx
80103137:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010313b:	83 c2 01             	add    $0x1,%edx
8010313e:	39 d0                	cmp    %edx,%eax
80103140:	75 ee                	jne    80103130 <write_head+0x30>
  }
  bwrite(buf);
80103142:	83 ec 0c             	sub    $0xc,%esp
80103145:	53                   	push   %ebx
80103146:	e8 65 d0 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010314b:	89 1c 24             	mov    %ebx,(%esp)
8010314e:	e8 9d d0 ff ff       	call   801001f0 <brelse>
}
80103153:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	c9                   	leave  
8010315a:	c3                   	ret    
8010315b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010315f:	90                   	nop

80103160 <initlog>:
{
80103160:	f3 0f 1e fb          	endbr32 
80103164:	55                   	push   %ebp
80103165:	89 e5                	mov    %esp,%ebp
80103167:	53                   	push   %ebx
80103168:	83 ec 2c             	sub    $0x2c,%esp
8010316b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010316e:	68 c0 7a 10 80       	push   $0x80107ac0
80103173:	68 20 2c 11 80       	push   $0x80112c20
80103178:	e8 33 17 00 00       	call   801048b0 <initlock>
  readsb(dev, &sb);
8010317d:	58                   	pop    %eax
8010317e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103181:	5a                   	pop    %edx
80103182:	50                   	push   %eax
80103183:	53                   	push   %ebx
80103184:	e8 47 e8 ff ff       	call   801019d0 <readsb>
  log.start = sb.logstart;
80103189:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010318c:	59                   	pop    %ecx
  log.dev = dev;
8010318d:	89 1d 64 2c 11 80    	mov    %ebx,0x80112c64
  log.size = sb.nlog;
80103193:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103196:	a3 54 2c 11 80       	mov    %eax,0x80112c54
  log.size = sb.nlog;
8010319b:	89 15 58 2c 11 80    	mov    %edx,0x80112c58
  struct buf *buf = bread(log.dev, log.start);
801031a1:	5a                   	pop    %edx
801031a2:	50                   	push   %eax
801031a3:	53                   	push   %ebx
801031a4:	e8 27 cf ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801031a9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801031ac:	8b 48 5c             	mov    0x5c(%eax),%ecx
801031af:	89 0d 68 2c 11 80    	mov    %ecx,0x80112c68
  for (i = 0; i < log.lh.n; i++) {
801031b5:	85 c9                	test   %ecx,%ecx
801031b7:	7e 19                	jle    801031d2 <initlog+0x72>
801031b9:	31 d2                	xor    %edx,%edx
801031bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031bf:	90                   	nop
    log.lh.block[i] = lh->block[i];
801031c0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
801031c4:	89 1c 95 6c 2c 11 80 	mov    %ebx,-0x7feed394(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801031cb:	83 c2 01             	add    $0x1,%edx
801031ce:	39 d1                	cmp    %edx,%ecx
801031d0:	75 ee                	jne    801031c0 <initlog+0x60>
  brelse(buf);
801031d2:	83 ec 0c             	sub    $0xc,%esp
801031d5:	50                   	push   %eax
801031d6:	e8 15 d0 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801031db:	e8 80 fe ff ff       	call   80103060 <install_trans>
  log.lh.n = 0;
801031e0:	c7 05 68 2c 11 80 00 	movl   $0x0,0x80112c68
801031e7:	00 00 00 
  write_head(); // clear the log
801031ea:	e8 11 ff ff ff       	call   80103100 <write_head>
}
801031ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031f2:	83 c4 10             	add    $0x10,%esp
801031f5:	c9                   	leave  
801031f6:	c3                   	ret    
801031f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031fe:	66 90                	xchg   %ax,%ax

80103200 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103200:	f3 0f 1e fb          	endbr32 
80103204:	55                   	push   %ebp
80103205:	89 e5                	mov    %esp,%ebp
80103207:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010320a:	68 20 2c 11 80       	push   $0x80112c20
8010320f:	e8 1c 18 00 00       	call   80104a30 <acquire>
80103214:	83 c4 10             	add    $0x10,%esp
80103217:	eb 1c                	jmp    80103235 <begin_op+0x35>
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103220:	83 ec 08             	sub    $0x8,%esp
80103223:	68 20 2c 11 80       	push   $0x80112c20
80103228:	68 20 2c 11 80       	push   $0x80112c20
8010322d:	e8 be 11 00 00       	call   801043f0 <sleep>
80103232:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103235:	a1 60 2c 11 80       	mov    0x80112c60,%eax
8010323a:	85 c0                	test   %eax,%eax
8010323c:	75 e2                	jne    80103220 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010323e:	a1 5c 2c 11 80       	mov    0x80112c5c,%eax
80103243:	8b 15 68 2c 11 80    	mov    0x80112c68,%edx
80103249:	83 c0 01             	add    $0x1,%eax
8010324c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010324f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103252:	83 fa 1e             	cmp    $0x1e,%edx
80103255:	7f c9                	jg     80103220 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103257:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010325a:	a3 5c 2c 11 80       	mov    %eax,0x80112c5c
      release(&log.lock);
8010325f:	68 20 2c 11 80       	push   $0x80112c20
80103264:	e8 87 18 00 00       	call   80104af0 <release>
      break;
    }
  }
}
80103269:	83 c4 10             	add    $0x10,%esp
8010326c:	c9                   	leave  
8010326d:	c3                   	ret    
8010326e:	66 90                	xchg   %ax,%ax

80103270 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103270:	f3 0f 1e fb          	endbr32 
80103274:	55                   	push   %ebp
80103275:	89 e5                	mov    %esp,%ebp
80103277:	57                   	push   %edi
80103278:	56                   	push   %esi
80103279:	53                   	push   %ebx
8010327a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010327d:	68 20 2c 11 80       	push   $0x80112c20
80103282:	e8 a9 17 00 00       	call   80104a30 <acquire>
  log.outstanding -= 1;
80103287:	a1 5c 2c 11 80       	mov    0x80112c5c,%eax
  if(log.committing)
8010328c:	8b 35 60 2c 11 80    	mov    0x80112c60,%esi
80103292:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103295:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103298:	89 1d 5c 2c 11 80    	mov    %ebx,0x80112c5c
  if(log.committing)
8010329e:	85 f6                	test   %esi,%esi
801032a0:	0f 85 1e 01 00 00    	jne    801033c4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801032a6:	85 db                	test   %ebx,%ebx
801032a8:	0f 85 f2 00 00 00    	jne    801033a0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801032ae:	c7 05 60 2c 11 80 01 	movl   $0x1,0x80112c60
801032b5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801032b8:	83 ec 0c             	sub    $0xc,%esp
801032bb:	68 20 2c 11 80       	push   $0x80112c20
801032c0:	e8 2b 18 00 00       	call   80104af0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801032c5:	8b 0d 68 2c 11 80    	mov    0x80112c68,%ecx
801032cb:	83 c4 10             	add    $0x10,%esp
801032ce:	85 c9                	test   %ecx,%ecx
801032d0:	7f 3e                	jg     80103310 <end_op+0xa0>
    acquire(&log.lock);
801032d2:	83 ec 0c             	sub    $0xc,%esp
801032d5:	68 20 2c 11 80       	push   $0x80112c20
801032da:	e8 51 17 00 00       	call   80104a30 <acquire>
    wakeup(&log);
801032df:	c7 04 24 20 2c 11 80 	movl   $0x80112c20,(%esp)
    log.committing = 0;
801032e6:	c7 05 60 2c 11 80 00 	movl   $0x0,0x80112c60
801032ed:	00 00 00 
    wakeup(&log);
801032f0:	e8 bb 12 00 00       	call   801045b0 <wakeup>
    release(&log.lock);
801032f5:	c7 04 24 20 2c 11 80 	movl   $0x80112c20,(%esp)
801032fc:	e8 ef 17 00 00       	call   80104af0 <release>
80103301:	83 c4 10             	add    $0x10,%esp
}
80103304:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103307:	5b                   	pop    %ebx
80103308:	5e                   	pop    %esi
80103309:	5f                   	pop    %edi
8010330a:	5d                   	pop    %ebp
8010330b:	c3                   	ret    
8010330c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103310:	a1 54 2c 11 80       	mov    0x80112c54,%eax
80103315:	83 ec 08             	sub    $0x8,%esp
80103318:	01 d8                	add    %ebx,%eax
8010331a:	83 c0 01             	add    $0x1,%eax
8010331d:	50                   	push   %eax
8010331e:	ff 35 64 2c 11 80    	pushl  0x80112c64
80103324:	e8 a7 cd ff ff       	call   801000d0 <bread>
80103329:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010332b:	58                   	pop    %eax
8010332c:	5a                   	pop    %edx
8010332d:	ff 34 9d 6c 2c 11 80 	pushl  -0x7feed394(,%ebx,4)
80103334:	ff 35 64 2c 11 80    	pushl  0x80112c64
  for (tail = 0; tail < log.lh.n; tail++) {
8010333a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010333d:	e8 8e cd ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103342:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103345:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103347:	8d 40 5c             	lea    0x5c(%eax),%eax
8010334a:	68 00 02 00 00       	push   $0x200
8010334f:	50                   	push   %eax
80103350:	8d 46 5c             	lea    0x5c(%esi),%eax
80103353:	50                   	push   %eax
80103354:	e8 87 18 00 00       	call   80104be0 <memmove>
    bwrite(to);  // write the log
80103359:	89 34 24             	mov    %esi,(%esp)
8010335c:	e8 4f ce ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103361:	89 3c 24             	mov    %edi,(%esp)
80103364:	e8 87 ce ff ff       	call   801001f0 <brelse>
    brelse(to);
80103369:	89 34 24             	mov    %esi,(%esp)
8010336c:	e8 7f ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103371:	83 c4 10             	add    $0x10,%esp
80103374:	3b 1d 68 2c 11 80    	cmp    0x80112c68,%ebx
8010337a:	7c 94                	jl     80103310 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010337c:	e8 7f fd ff ff       	call   80103100 <write_head>
    install_trans(); // Now install writes to home locations
80103381:	e8 da fc ff ff       	call   80103060 <install_trans>
    log.lh.n = 0;
80103386:	c7 05 68 2c 11 80 00 	movl   $0x0,0x80112c68
8010338d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103390:	e8 6b fd ff ff       	call   80103100 <write_head>
80103395:	e9 38 ff ff ff       	jmp    801032d2 <end_op+0x62>
8010339a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801033a0:	83 ec 0c             	sub    $0xc,%esp
801033a3:	68 20 2c 11 80       	push   $0x80112c20
801033a8:	e8 03 12 00 00       	call   801045b0 <wakeup>
  release(&log.lock);
801033ad:	c7 04 24 20 2c 11 80 	movl   $0x80112c20,(%esp)
801033b4:	e8 37 17 00 00       	call   80104af0 <release>
801033b9:	83 c4 10             	add    $0x10,%esp
}
801033bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033bf:	5b                   	pop    %ebx
801033c0:	5e                   	pop    %esi
801033c1:	5f                   	pop    %edi
801033c2:	5d                   	pop    %ebp
801033c3:	c3                   	ret    
    panic("log.committing");
801033c4:	83 ec 0c             	sub    $0xc,%esp
801033c7:	68 c4 7a 10 80       	push   $0x80107ac4
801033cc:	e8 bf cf ff ff       	call   80100390 <panic>
801033d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033df:	90                   	nop

801033e0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801033e0:	f3 0f 1e fb          	endbr32 
801033e4:	55                   	push   %ebp
801033e5:	89 e5                	mov    %esp,%ebp
801033e7:	53                   	push   %ebx
801033e8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033eb:	8b 15 68 2c 11 80    	mov    0x80112c68,%edx
{
801033f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033f4:	83 fa 1d             	cmp    $0x1d,%edx
801033f7:	0f 8f 91 00 00 00    	jg     8010348e <log_write+0xae>
801033fd:	a1 58 2c 11 80       	mov    0x80112c58,%eax
80103402:	83 e8 01             	sub    $0x1,%eax
80103405:	39 c2                	cmp    %eax,%edx
80103407:	0f 8d 81 00 00 00    	jge    8010348e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010340d:	a1 5c 2c 11 80       	mov    0x80112c5c,%eax
80103412:	85 c0                	test   %eax,%eax
80103414:	0f 8e 81 00 00 00    	jle    8010349b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010341a:	83 ec 0c             	sub    $0xc,%esp
8010341d:	68 20 2c 11 80       	push   $0x80112c20
80103422:	e8 09 16 00 00       	call   80104a30 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103427:	8b 15 68 2c 11 80    	mov    0x80112c68,%edx
8010342d:	83 c4 10             	add    $0x10,%esp
80103430:	85 d2                	test   %edx,%edx
80103432:	7e 4e                	jle    80103482 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103434:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103437:	31 c0                	xor    %eax,%eax
80103439:	eb 0c                	jmp    80103447 <log_write+0x67>
8010343b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010343f:	90                   	nop
80103440:	83 c0 01             	add    $0x1,%eax
80103443:	39 c2                	cmp    %eax,%edx
80103445:	74 29                	je     80103470 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103447:	39 0c 85 6c 2c 11 80 	cmp    %ecx,-0x7feed394(,%eax,4)
8010344e:	75 f0                	jne    80103440 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103450:	89 0c 85 6c 2c 11 80 	mov    %ecx,-0x7feed394(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103457:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010345a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010345d:	c7 45 08 20 2c 11 80 	movl   $0x80112c20,0x8(%ebp)
}
80103464:	c9                   	leave  
  release(&log.lock);
80103465:	e9 86 16 00 00       	jmp    80104af0 <release>
8010346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103470:	89 0c 95 6c 2c 11 80 	mov    %ecx,-0x7feed394(,%edx,4)
    log.lh.n++;
80103477:	83 c2 01             	add    $0x1,%edx
8010347a:	89 15 68 2c 11 80    	mov    %edx,0x80112c68
80103480:	eb d5                	jmp    80103457 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103482:	8b 43 08             	mov    0x8(%ebx),%eax
80103485:	a3 6c 2c 11 80       	mov    %eax,0x80112c6c
  if (i == log.lh.n)
8010348a:	75 cb                	jne    80103457 <log_write+0x77>
8010348c:	eb e9                	jmp    80103477 <log_write+0x97>
    panic("too big a transaction");
8010348e:	83 ec 0c             	sub    $0xc,%esp
80103491:	68 d3 7a 10 80       	push   $0x80107ad3
80103496:	e8 f5 ce ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010349b:	83 ec 0c             	sub    $0xc,%esp
8010349e:	68 e9 7a 10 80       	push   $0x80107ae9
801034a3:	e8 e8 ce ff ff       	call   80100390 <panic>
801034a8:	66 90                	xchg   %ax,%ax
801034aa:	66 90                	xchg   %ax,%ax
801034ac:	66 90                	xchg   %ax,%ax
801034ae:	66 90                	xchg   %ax,%ax

801034b0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	53                   	push   %ebx
801034b4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801034b7:	e8 54 09 00 00       	call   80103e10 <cpuid>
801034bc:	89 c3                	mov    %eax,%ebx
801034be:	e8 4d 09 00 00       	call   80103e10 <cpuid>
801034c3:	83 ec 04             	sub    $0x4,%esp
801034c6:	53                   	push   %ebx
801034c7:	50                   	push   %eax
801034c8:	68 04 7b 10 80       	push   $0x80107b04
801034cd:	e8 ce d3 ff ff       	call   801008a0 <cprintf>
  idtinit();       // load idt register
801034d2:	e8 19 29 00 00       	call   80105df0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801034d7:	e8 c4 08 00 00       	call   80103da0 <mycpu>
801034dc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801034de:	b8 01 00 00 00       	mov    $0x1,%eax
801034e3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801034ea:	e8 11 0c 00 00       	call   80104100 <scheduler>
801034ef:	90                   	nop

801034f0 <mpenter>:
{
801034f0:	f3 0f 1e fb          	endbr32 
801034f4:	55                   	push   %ebp
801034f5:	89 e5                	mov    %esp,%ebp
801034f7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801034fa:	e8 c1 39 00 00       	call   80106ec0 <switchkvm>
  seginit();
801034ff:	e8 2c 39 00 00       	call   80106e30 <seginit>
  lapicinit();
80103504:	e8 67 f7 ff ff       	call   80102c70 <lapicinit>
  mpmain();
80103509:	e8 a2 ff ff ff       	call   801034b0 <mpmain>
8010350e:	66 90                	xchg   %ax,%ax

80103510 <main>:
{
80103510:	f3 0f 1e fb          	endbr32 
80103514:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103518:	83 e4 f0             	and    $0xfffffff0,%esp
8010351b:	ff 71 fc             	pushl  -0x4(%ecx)
8010351e:	55                   	push   %ebp
8010351f:	89 e5                	mov    %esp,%ebp
80103521:	53                   	push   %ebx
80103522:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103523:	83 ec 08             	sub    $0x8,%esp
80103526:	68 00 00 40 80       	push   $0x80400000
8010352b:	68 48 5a 11 80       	push   $0x80115a48
80103530:	e8 fb f4 ff ff       	call   80102a30 <kinit1>
  kvmalloc();      // kernel page table
80103535:	e8 66 3e 00 00       	call   801073a0 <kvmalloc>
  mpinit();        // detect other processors
8010353a:	e8 81 01 00 00       	call   801036c0 <mpinit>
  lapicinit();     // interrupt controller
8010353f:	e8 2c f7 ff ff       	call   80102c70 <lapicinit>
  seginit();       // segment descriptors
80103544:	e8 e7 38 00 00       	call   80106e30 <seginit>
  picinit();       // disable pic
80103549:	e8 52 03 00 00       	call   801038a0 <picinit>
  ioapicinit();    // another interrupt controller
8010354e:	e8 fd f2 ff ff       	call   80102850 <ioapicinit>
  consoleinit();   // console hardware
80103553:	e8 a8 d9 ff ff       	call   80100f00 <consoleinit>
  uartinit();      // serial port
80103558:	e8 93 2b 00 00       	call   801060f0 <uartinit>
  pinit();         // process table
8010355d:	e8 1e 08 00 00       	call   80103d80 <pinit>
  tvinit();        // trap vectors
80103562:	e8 09 28 00 00       	call   80105d70 <tvinit>
  binit();         // buffer cache
80103567:	e8 d4 ca ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010356c:	e8 3f dd ff ff       	call   801012b0 <fileinit>
  ideinit();       // disk 
80103571:	e8 aa f0 ff ff       	call   80102620 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103576:	83 c4 0c             	add    $0xc,%esp
80103579:	68 8a 00 00 00       	push   $0x8a
8010357e:	68 8c a4 10 80       	push   $0x8010a48c
80103583:	68 00 70 00 80       	push   $0x80007000
80103588:	e8 53 16 00 00       	call   80104be0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010358d:	83 c4 10             	add    $0x10,%esp
80103590:	69 05 a0 32 11 80 b0 	imul   $0xb0,0x801132a0,%eax
80103597:	00 00 00 
8010359a:	05 20 2d 11 80       	add    $0x80112d20,%eax
8010359f:	3d 20 2d 11 80       	cmp    $0x80112d20,%eax
801035a4:	76 7a                	jbe    80103620 <main+0x110>
801035a6:	bb 20 2d 11 80       	mov    $0x80112d20,%ebx
801035ab:	eb 1c                	jmp    801035c9 <main+0xb9>
801035ad:	8d 76 00             	lea    0x0(%esi),%esi
801035b0:	69 05 a0 32 11 80 b0 	imul   $0xb0,0x801132a0,%eax
801035b7:	00 00 00 
801035ba:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801035c0:	05 20 2d 11 80       	add    $0x80112d20,%eax
801035c5:	39 c3                	cmp    %eax,%ebx
801035c7:	73 57                	jae    80103620 <main+0x110>
    if(c == mycpu())  // We've started already.
801035c9:	e8 d2 07 00 00       	call   80103da0 <mycpu>
801035ce:	39 c3                	cmp    %eax,%ebx
801035d0:	74 de                	je     801035b0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801035d2:	e8 29 f5 ff ff       	call   80102b00 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801035d7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801035da:	c7 05 f8 6f 00 80 f0 	movl   $0x801034f0,0x80006ff8
801035e1:	34 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801035e4:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801035eb:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801035ee:	05 00 10 00 00       	add    $0x1000,%eax
801035f3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801035f8:	0f b6 03             	movzbl (%ebx),%eax
801035fb:	68 00 70 00 00       	push   $0x7000
80103600:	50                   	push   %eax
80103601:	e8 ba f7 ff ff       	call   80102dc0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103606:	83 c4 10             	add    $0x10,%esp
80103609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103610:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103616:	85 c0                	test   %eax,%eax
80103618:	74 f6                	je     80103610 <main+0x100>
8010361a:	eb 94                	jmp    801035b0 <main+0xa0>
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103620:	83 ec 08             	sub    $0x8,%esp
80103623:	68 00 00 00 8e       	push   $0x8e000000
80103628:	68 00 00 40 80       	push   $0x80400000
8010362d:	e8 6e f4 ff ff       	call   80102aa0 <kinit2>
  userinit();      // first user process
80103632:	e8 29 08 00 00       	call   80103e60 <userinit>
  mpmain();        // finish this processor's setup
80103637:	e8 74 fe ff ff       	call   801034b0 <mpmain>
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	57                   	push   %edi
80103644:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103645:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010364b:	53                   	push   %ebx
  e = addr+len;
8010364c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010364f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103652:	39 de                	cmp    %ebx,%esi
80103654:	72 10                	jb     80103666 <mpsearch1+0x26>
80103656:	eb 50                	jmp    801036a8 <mpsearch1+0x68>
80103658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010365f:	90                   	nop
80103660:	89 fe                	mov    %edi,%esi
80103662:	39 fb                	cmp    %edi,%ebx
80103664:	76 42                	jbe    801036a8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103666:	83 ec 04             	sub    $0x4,%esp
80103669:	8d 7e 10             	lea    0x10(%esi),%edi
8010366c:	6a 04                	push   $0x4
8010366e:	68 18 7b 10 80       	push   $0x80107b18
80103673:	56                   	push   %esi
80103674:	e8 17 15 00 00       	call   80104b90 <memcmp>
80103679:	83 c4 10             	add    $0x10,%esp
8010367c:	85 c0                	test   %eax,%eax
8010367e:	75 e0                	jne    80103660 <mpsearch1+0x20>
80103680:	89 f2                	mov    %esi,%edx
80103682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103688:	0f b6 0a             	movzbl (%edx),%ecx
8010368b:	83 c2 01             	add    $0x1,%edx
8010368e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103690:	39 fa                	cmp    %edi,%edx
80103692:	75 f4                	jne    80103688 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103694:	84 c0                	test   %al,%al
80103696:	75 c8                	jne    80103660 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103698:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010369b:	89 f0                	mov    %esi,%eax
8010369d:	5b                   	pop    %ebx
8010369e:	5e                   	pop    %esi
8010369f:	5f                   	pop    %edi
801036a0:	5d                   	pop    %ebp
801036a1:	c3                   	ret    
801036a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036ab:	31 f6                	xor    %esi,%esi
}
801036ad:	5b                   	pop    %ebx
801036ae:	89 f0                	mov    %esi,%eax
801036b0:	5e                   	pop    %esi
801036b1:	5f                   	pop    %edi
801036b2:	5d                   	pop    %ebp
801036b3:	c3                   	ret    
801036b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036bf:	90                   	nop

801036c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801036c0:	f3 0f 1e fb          	endbr32 
801036c4:	55                   	push   %ebp
801036c5:	89 e5                	mov    %esp,%ebp
801036c7:	57                   	push   %edi
801036c8:	56                   	push   %esi
801036c9:	53                   	push   %ebx
801036ca:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801036cd:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801036d4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801036db:	c1 e0 08             	shl    $0x8,%eax
801036de:	09 d0                	or     %edx,%eax
801036e0:	c1 e0 04             	shl    $0x4,%eax
801036e3:	75 1b                	jne    80103700 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801036e5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801036ec:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801036f3:	c1 e0 08             	shl    $0x8,%eax
801036f6:	09 d0                	or     %edx,%eax
801036f8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801036fb:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103700:	ba 00 04 00 00       	mov    $0x400,%edx
80103705:	e8 36 ff ff ff       	call   80103640 <mpsearch1>
8010370a:	89 c6                	mov    %eax,%esi
8010370c:	85 c0                	test   %eax,%eax
8010370e:	0f 84 4c 01 00 00    	je     80103860 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103714:	8b 5e 04             	mov    0x4(%esi),%ebx
80103717:	85 db                	test   %ebx,%ebx
80103719:	0f 84 61 01 00 00    	je     80103880 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010371f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103722:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103728:	6a 04                	push   $0x4
8010372a:	68 1d 7b 10 80       	push   $0x80107b1d
8010372f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103730:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103733:	e8 58 14 00 00       	call   80104b90 <memcmp>
80103738:	83 c4 10             	add    $0x10,%esp
8010373b:	85 c0                	test   %eax,%eax
8010373d:	0f 85 3d 01 00 00    	jne    80103880 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103743:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010374a:	3c 01                	cmp    $0x1,%al
8010374c:	74 08                	je     80103756 <mpinit+0x96>
8010374e:	3c 04                	cmp    $0x4,%al
80103750:	0f 85 2a 01 00 00    	jne    80103880 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103756:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010375d:	66 85 d2             	test   %dx,%dx
80103760:	74 26                	je     80103788 <mpinit+0xc8>
80103762:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103765:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103767:	31 d2                	xor    %edx,%edx
80103769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103770:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103777:	83 c0 01             	add    $0x1,%eax
8010377a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010377c:	39 f8                	cmp    %edi,%eax
8010377e:	75 f0                	jne    80103770 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103780:	84 d2                	test   %dl,%dl
80103782:	0f 85 f8 00 00 00    	jne    80103880 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103788:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010378e:	a3 1c 2c 11 80       	mov    %eax,0x80112c1c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103793:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103799:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801037a0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037a5:	03 55 e4             	add    -0x1c(%ebp),%edx
801037a8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801037ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037af:	90                   	nop
801037b0:	39 c2                	cmp    %eax,%edx
801037b2:	76 15                	jbe    801037c9 <mpinit+0x109>
    switch(*p){
801037b4:	0f b6 08             	movzbl (%eax),%ecx
801037b7:	80 f9 02             	cmp    $0x2,%cl
801037ba:	74 5c                	je     80103818 <mpinit+0x158>
801037bc:	77 42                	ja     80103800 <mpinit+0x140>
801037be:	84 c9                	test   %cl,%cl
801037c0:	74 6e                	je     80103830 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801037c2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037c5:	39 c2                	cmp    %eax,%edx
801037c7:	77 eb                	ja     801037b4 <mpinit+0xf4>
801037c9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801037cc:	85 db                	test   %ebx,%ebx
801037ce:	0f 84 b9 00 00 00    	je     8010388d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801037d4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
801037d8:	74 15                	je     801037ef <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037da:	b8 70 00 00 00       	mov    $0x70,%eax
801037df:	ba 22 00 00 00       	mov    $0x22,%edx
801037e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037e5:	ba 23 00 00 00       	mov    $0x23,%edx
801037ea:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801037eb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037ee:	ee                   	out    %al,(%dx)
  }
}
801037ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037f2:	5b                   	pop    %ebx
801037f3:	5e                   	pop    %esi
801037f4:	5f                   	pop    %edi
801037f5:	5d                   	pop    %ebp
801037f6:	c3                   	ret    
801037f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037fe:	66 90                	xchg   %ax,%ax
    switch(*p){
80103800:	83 e9 03             	sub    $0x3,%ecx
80103803:	80 f9 01             	cmp    $0x1,%cl
80103806:	76 ba                	jbe    801037c2 <mpinit+0x102>
80103808:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010380f:	eb 9f                	jmp    801037b0 <mpinit+0xf0>
80103811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103818:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010381c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010381f:	88 0d 00 2d 11 80    	mov    %cl,0x80112d00
      continue;
80103825:	eb 89                	jmp    801037b0 <mpinit+0xf0>
80103827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010382e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103830:	8b 0d a0 32 11 80    	mov    0x801132a0,%ecx
80103836:	83 f9 07             	cmp    $0x7,%ecx
80103839:	7f 19                	jg     80103854 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010383b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103841:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103845:	83 c1 01             	add    $0x1,%ecx
80103848:	89 0d a0 32 11 80    	mov    %ecx,0x801132a0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010384e:	88 9f 20 2d 11 80    	mov    %bl,-0x7feed2e0(%edi)
      p += sizeof(struct mpproc);
80103854:	83 c0 14             	add    $0x14,%eax
      continue;
80103857:	e9 54 ff ff ff       	jmp    801037b0 <mpinit+0xf0>
8010385c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103860:	ba 00 00 01 00       	mov    $0x10000,%edx
80103865:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010386a:	e8 d1 fd ff ff       	call   80103640 <mpsearch1>
8010386f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103871:	85 c0                	test   %eax,%eax
80103873:	0f 85 9b fe ff ff    	jne    80103714 <mpinit+0x54>
80103879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103880:	83 ec 0c             	sub    $0xc,%esp
80103883:	68 22 7b 10 80       	push   $0x80107b22
80103888:	e8 03 cb ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010388d:	83 ec 0c             	sub    $0xc,%esp
80103890:	68 3c 7b 10 80       	push   $0x80107b3c
80103895:	e8 f6 ca ff ff       	call   80100390 <panic>
8010389a:	66 90                	xchg   %ax,%ax
8010389c:	66 90                	xchg   %ax,%ax
8010389e:	66 90                	xchg   %ax,%ax

801038a0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801038a0:	f3 0f 1e fb          	endbr32 
801038a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038a9:	ba 21 00 00 00       	mov    $0x21,%edx
801038ae:	ee                   	out    %al,(%dx)
801038af:	ba a1 00 00 00       	mov    $0xa1,%edx
801038b4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801038b5:	c3                   	ret    
801038b6:	66 90                	xchg   %ax,%ax
801038b8:	66 90                	xchg   %ax,%ax
801038ba:	66 90                	xchg   %ax,%ax
801038bc:	66 90                	xchg   %ax,%ax
801038be:	66 90                	xchg   %ax,%ax

801038c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801038c0:	f3 0f 1e fb          	endbr32 
801038c4:	55                   	push   %ebp
801038c5:	89 e5                	mov    %esp,%ebp
801038c7:	57                   	push   %edi
801038c8:	56                   	push   %esi
801038c9:	53                   	push   %ebx
801038ca:	83 ec 0c             	sub    $0xc,%esp
801038cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
801038d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801038d3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801038d9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801038df:	e8 ec d9 ff ff       	call   801012d0 <filealloc>
801038e4:	89 03                	mov    %eax,(%ebx)
801038e6:	85 c0                	test   %eax,%eax
801038e8:	0f 84 ac 00 00 00    	je     8010399a <pipealloc+0xda>
801038ee:	e8 dd d9 ff ff       	call   801012d0 <filealloc>
801038f3:	89 06                	mov    %eax,(%esi)
801038f5:	85 c0                	test   %eax,%eax
801038f7:	0f 84 8b 00 00 00    	je     80103988 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801038fd:	e8 fe f1 ff ff       	call   80102b00 <kalloc>
80103902:	89 c7                	mov    %eax,%edi
80103904:	85 c0                	test   %eax,%eax
80103906:	0f 84 b4 00 00 00    	je     801039c0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010390c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103913:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103916:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103919:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103920:	00 00 00 
  p->nwrite = 0;
80103923:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010392a:	00 00 00 
  p->nread = 0;
8010392d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103934:	00 00 00 
  initlock(&p->lock, "pipe");
80103937:	68 5b 7b 10 80       	push   $0x80107b5b
8010393c:	50                   	push   %eax
8010393d:	e8 6e 0f 00 00       	call   801048b0 <initlock>
  (*f0)->type = FD_PIPE;
80103942:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103944:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103947:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010394d:	8b 03                	mov    (%ebx),%eax
8010394f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103953:	8b 03                	mov    (%ebx),%eax
80103955:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103959:	8b 03                	mov    (%ebx),%eax
8010395b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010395e:	8b 06                	mov    (%esi),%eax
80103960:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103966:	8b 06                	mov    (%esi),%eax
80103968:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010396c:	8b 06                	mov    (%esi),%eax
8010396e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103972:	8b 06                	mov    (%esi),%eax
80103974:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103977:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010397a:	31 c0                	xor    %eax,%eax
}
8010397c:	5b                   	pop    %ebx
8010397d:	5e                   	pop    %esi
8010397e:	5f                   	pop    %edi
8010397f:	5d                   	pop    %ebp
80103980:	c3                   	ret    
80103981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103988:	8b 03                	mov    (%ebx),%eax
8010398a:	85 c0                	test   %eax,%eax
8010398c:	74 1e                	je     801039ac <pipealloc+0xec>
    fileclose(*f0);
8010398e:	83 ec 0c             	sub    $0xc,%esp
80103991:	50                   	push   %eax
80103992:	e8 f9 d9 ff ff       	call   80101390 <fileclose>
80103997:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010399a:	8b 06                	mov    (%esi),%eax
8010399c:	85 c0                	test   %eax,%eax
8010399e:	74 0c                	je     801039ac <pipealloc+0xec>
    fileclose(*f1);
801039a0:	83 ec 0c             	sub    $0xc,%esp
801039a3:	50                   	push   %eax
801039a4:	e8 e7 d9 ff ff       	call   80101390 <fileclose>
801039a9:	83 c4 10             	add    $0x10,%esp
}
801039ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801039af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801039b4:	5b                   	pop    %ebx
801039b5:	5e                   	pop    %esi
801039b6:	5f                   	pop    %edi
801039b7:	5d                   	pop    %ebp
801039b8:	c3                   	ret    
801039b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801039c0:	8b 03                	mov    (%ebx),%eax
801039c2:	85 c0                	test   %eax,%eax
801039c4:	75 c8                	jne    8010398e <pipealloc+0xce>
801039c6:	eb d2                	jmp    8010399a <pipealloc+0xda>
801039c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039cf:	90                   	nop

801039d0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801039d0:	f3 0f 1e fb          	endbr32 
801039d4:	55                   	push   %ebp
801039d5:	89 e5                	mov    %esp,%ebp
801039d7:	56                   	push   %esi
801039d8:	53                   	push   %ebx
801039d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801039dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801039df:	83 ec 0c             	sub    $0xc,%esp
801039e2:	53                   	push   %ebx
801039e3:	e8 48 10 00 00       	call   80104a30 <acquire>
  if(writable){
801039e8:	83 c4 10             	add    $0x10,%esp
801039eb:	85 f6                	test   %esi,%esi
801039ed:	74 41                	je     80103a30 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801039ef:	83 ec 0c             	sub    $0xc,%esp
801039f2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801039f8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801039ff:	00 00 00 
    wakeup(&p->nread);
80103a02:	50                   	push   %eax
80103a03:	e8 a8 0b 00 00       	call   801045b0 <wakeup>
80103a08:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103a0b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103a11:	85 d2                	test   %edx,%edx
80103a13:	75 0a                	jne    80103a1f <pipeclose+0x4f>
80103a15:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103a1b:	85 c0                	test   %eax,%eax
80103a1d:	74 31                	je     80103a50 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103a1f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103a22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a25:	5b                   	pop    %ebx
80103a26:	5e                   	pop    %esi
80103a27:	5d                   	pop    %ebp
    release(&p->lock);
80103a28:	e9 c3 10 00 00       	jmp    80104af0 <release>
80103a2d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103a30:	83 ec 0c             	sub    $0xc,%esp
80103a33:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103a39:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103a40:	00 00 00 
    wakeup(&p->nwrite);
80103a43:	50                   	push   %eax
80103a44:	e8 67 0b 00 00       	call   801045b0 <wakeup>
80103a49:	83 c4 10             	add    $0x10,%esp
80103a4c:	eb bd                	jmp    80103a0b <pipeclose+0x3b>
80103a4e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	53                   	push   %ebx
80103a54:	e8 97 10 00 00       	call   80104af0 <release>
    kfree((char*)p);
80103a59:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103a5c:	83 c4 10             	add    $0x10,%esp
}
80103a5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a62:	5b                   	pop    %ebx
80103a63:	5e                   	pop    %esi
80103a64:	5d                   	pop    %ebp
    kfree((char*)p);
80103a65:	e9 d6 ee ff ff       	jmp    80102940 <kfree>
80103a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a70 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103a70:	f3 0f 1e fb          	endbr32 
80103a74:	55                   	push   %ebp
80103a75:	89 e5                	mov    %esp,%ebp
80103a77:	57                   	push   %edi
80103a78:	56                   	push   %esi
80103a79:	53                   	push   %ebx
80103a7a:	83 ec 28             	sub    $0x28,%esp
80103a7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103a80:	53                   	push   %ebx
80103a81:	e8 aa 0f 00 00       	call   80104a30 <acquire>
  for(i = 0; i < n; i++){
80103a86:	8b 45 10             	mov    0x10(%ebp),%eax
80103a89:	83 c4 10             	add    $0x10,%esp
80103a8c:	85 c0                	test   %eax,%eax
80103a8e:	0f 8e bc 00 00 00    	jle    80103b50 <pipewrite+0xe0>
80103a94:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a97:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103a9d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103aa3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103aa6:	03 45 10             	add    0x10(%ebp),%eax
80103aa9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103aac:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ab2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ab8:	89 ca                	mov    %ecx,%edx
80103aba:	05 00 02 00 00       	add    $0x200,%eax
80103abf:	39 c1                	cmp    %eax,%ecx
80103ac1:	74 3b                	je     80103afe <pipewrite+0x8e>
80103ac3:	eb 63                	jmp    80103b28 <pipewrite+0xb8>
80103ac5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103ac8:	e8 63 03 00 00       	call   80103e30 <myproc>
80103acd:	8b 48 24             	mov    0x24(%eax),%ecx
80103ad0:	85 c9                	test   %ecx,%ecx
80103ad2:	75 34                	jne    80103b08 <pipewrite+0x98>
      wakeup(&p->nread);
80103ad4:	83 ec 0c             	sub    $0xc,%esp
80103ad7:	57                   	push   %edi
80103ad8:	e8 d3 0a 00 00       	call   801045b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103add:	58                   	pop    %eax
80103ade:	5a                   	pop    %edx
80103adf:	53                   	push   %ebx
80103ae0:	56                   	push   %esi
80103ae1:	e8 0a 09 00 00       	call   801043f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ae6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103aec:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103af2:	83 c4 10             	add    $0x10,%esp
80103af5:	05 00 02 00 00       	add    $0x200,%eax
80103afa:	39 c2                	cmp    %eax,%edx
80103afc:	75 2a                	jne    80103b28 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103afe:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103b04:	85 c0                	test   %eax,%eax
80103b06:	75 c0                	jne    80103ac8 <pipewrite+0x58>
        release(&p->lock);
80103b08:	83 ec 0c             	sub    $0xc,%esp
80103b0b:	53                   	push   %ebx
80103b0c:	e8 df 0f 00 00       	call   80104af0 <release>
        return -1;
80103b11:	83 c4 10             	add    $0x10,%esp
80103b14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103b19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b1c:	5b                   	pop    %ebx
80103b1d:	5e                   	pop    %esi
80103b1e:	5f                   	pop    %edi
80103b1f:	5d                   	pop    %ebp
80103b20:	c3                   	ret    
80103b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b28:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103b2b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103b2e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103b34:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103b3a:	0f b6 06             	movzbl (%esi),%eax
80103b3d:	83 c6 01             	add    $0x1,%esi
80103b40:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103b43:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103b47:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103b4a:	0f 85 5c ff ff ff    	jne    80103aac <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103b50:	83 ec 0c             	sub    $0xc,%esp
80103b53:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103b59:	50                   	push   %eax
80103b5a:	e8 51 0a 00 00       	call   801045b0 <wakeup>
  release(&p->lock);
80103b5f:	89 1c 24             	mov    %ebx,(%esp)
80103b62:	e8 89 0f 00 00       	call   80104af0 <release>
  return n;
80103b67:	8b 45 10             	mov    0x10(%ebp),%eax
80103b6a:	83 c4 10             	add    $0x10,%esp
80103b6d:	eb aa                	jmp    80103b19 <pipewrite+0xa9>
80103b6f:	90                   	nop

80103b70 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103b70:	f3 0f 1e fb          	endbr32 
80103b74:	55                   	push   %ebp
80103b75:	89 e5                	mov    %esp,%ebp
80103b77:	57                   	push   %edi
80103b78:	56                   	push   %esi
80103b79:	53                   	push   %ebx
80103b7a:	83 ec 18             	sub    $0x18,%esp
80103b7d:	8b 75 08             	mov    0x8(%ebp),%esi
80103b80:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103b83:	56                   	push   %esi
80103b84:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103b8a:	e8 a1 0e 00 00       	call   80104a30 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b8f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103b95:	83 c4 10             	add    $0x10,%esp
80103b98:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103b9e:	74 33                	je     80103bd3 <piperead+0x63>
80103ba0:	eb 3b                	jmp    80103bdd <piperead+0x6d>
80103ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103ba8:	e8 83 02 00 00       	call   80103e30 <myproc>
80103bad:	8b 48 24             	mov    0x24(%eax),%ecx
80103bb0:	85 c9                	test   %ecx,%ecx
80103bb2:	0f 85 88 00 00 00    	jne    80103c40 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103bb8:	83 ec 08             	sub    $0x8,%esp
80103bbb:	56                   	push   %esi
80103bbc:	53                   	push   %ebx
80103bbd:	e8 2e 08 00 00       	call   801043f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103bc2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103bc8:	83 c4 10             	add    $0x10,%esp
80103bcb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103bd1:	75 0a                	jne    80103bdd <piperead+0x6d>
80103bd3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103bd9:	85 c0                	test   %eax,%eax
80103bdb:	75 cb                	jne    80103ba8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103bdd:	8b 55 10             	mov    0x10(%ebp),%edx
80103be0:	31 db                	xor    %ebx,%ebx
80103be2:	85 d2                	test   %edx,%edx
80103be4:	7f 28                	jg     80103c0e <piperead+0x9e>
80103be6:	eb 34                	jmp    80103c1c <piperead+0xac>
80103be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bef:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103bf0:	8d 48 01             	lea    0x1(%eax),%ecx
80103bf3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103bf8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103bfe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103c03:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c06:	83 c3 01             	add    $0x1,%ebx
80103c09:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103c0c:	74 0e                	je     80103c1c <piperead+0xac>
    if(p->nread == p->nwrite)
80103c0e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103c14:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103c1a:	75 d4                	jne    80103bf0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103c1c:	83 ec 0c             	sub    $0xc,%esp
80103c1f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103c25:	50                   	push   %eax
80103c26:	e8 85 09 00 00       	call   801045b0 <wakeup>
  release(&p->lock);
80103c2b:	89 34 24             	mov    %esi,(%esp)
80103c2e:	e8 bd 0e 00 00       	call   80104af0 <release>
  return i;
80103c33:	83 c4 10             	add    $0x10,%esp
}
80103c36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c39:	89 d8                	mov    %ebx,%eax
80103c3b:	5b                   	pop    %ebx
80103c3c:	5e                   	pop    %esi
80103c3d:	5f                   	pop    %edi
80103c3e:	5d                   	pop    %ebp
80103c3f:	c3                   	ret    
      release(&p->lock);
80103c40:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103c43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103c48:	56                   	push   %esi
80103c49:	e8 a2 0e 00 00       	call   80104af0 <release>
      return -1;
80103c4e:	83 c4 10             	add    $0x10,%esp
}
80103c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c54:	89 d8                	mov    %ebx,%eax
80103c56:	5b                   	pop    %ebx
80103c57:	5e                   	pop    %esi
80103c58:	5f                   	pop    %edi
80103c59:	5d                   	pop    %ebp
80103c5a:	c3                   	ret    
80103c5b:	66 90                	xchg   %ax,%ax
80103c5d:	66 90                	xchg   %ax,%ax
80103c5f:	90                   	nop

80103c60 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c64:	bb f4 32 11 80       	mov    $0x801132f4,%ebx
{
80103c69:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103c6c:	68 c0 32 11 80       	push   $0x801132c0
80103c71:	e8 ba 0d 00 00       	call   80104a30 <acquire>
80103c76:	83 c4 10             	add    $0x10,%esp
80103c79:	eb 10                	jmp    80103c8b <allocproc+0x2b>
80103c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c7f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c80:	83 c3 7c             	add    $0x7c,%ebx
80103c83:	81 fb f4 51 11 80    	cmp    $0x801151f4,%ebx
80103c89:	74 75                	je     80103d00 <allocproc+0xa0>
    if(p->state == UNUSED)
80103c8b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103c8e:	85 c0                	test   %eax,%eax
80103c90:	75 ee                	jne    80103c80 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103c92:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103c97:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103c9a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103ca1:	89 43 10             	mov    %eax,0x10(%ebx)
80103ca4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103ca7:	68 c0 32 11 80       	push   $0x801132c0
  p->pid = nextpid++;
80103cac:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103cb2:	e8 39 0e 00 00       	call   80104af0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103cb7:	e8 44 ee ff ff       	call   80102b00 <kalloc>
80103cbc:	83 c4 10             	add    $0x10,%esp
80103cbf:	89 43 08             	mov    %eax,0x8(%ebx)
80103cc2:	85 c0                	test   %eax,%eax
80103cc4:	74 53                	je     80103d19 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103cc6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103ccc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103ccf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103cd4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103cd7:	c7 40 14 56 5d 10 80 	movl   $0x80105d56,0x14(%eax)
  p->context = (struct context*)sp;
80103cde:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103ce1:	6a 14                	push   $0x14
80103ce3:	6a 00                	push   $0x0
80103ce5:	50                   	push   %eax
80103ce6:	e8 55 0e 00 00       	call   80104b40 <memset>
  p->context->eip = (uint)forkret;
80103ceb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103cee:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103cf1:	c7 40 10 30 3d 10 80 	movl   $0x80103d30,0x10(%eax)
}
80103cf8:	89 d8                	mov    %ebx,%eax
80103cfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cfd:	c9                   	leave  
80103cfe:	c3                   	ret    
80103cff:	90                   	nop
  release(&ptable.lock);
80103d00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103d03:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103d05:	68 c0 32 11 80       	push   $0x801132c0
80103d0a:	e8 e1 0d 00 00       	call   80104af0 <release>
}
80103d0f:	89 d8                	mov    %ebx,%eax
  return 0;
80103d11:	83 c4 10             	add    $0x10,%esp
}
80103d14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d17:	c9                   	leave  
80103d18:	c3                   	ret    
    p->state = UNUSED;
80103d19:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103d20:	31 db                	xor    %ebx,%ebx
}
80103d22:	89 d8                	mov    %ebx,%eax
80103d24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d27:	c9                   	leave  
80103d28:	c3                   	ret    
80103d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d30 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103d30:	f3 0f 1e fb          	endbr32 
80103d34:	55                   	push   %ebp
80103d35:	89 e5                	mov    %esp,%ebp
80103d37:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103d3a:	68 c0 32 11 80       	push   $0x801132c0
80103d3f:	e8 ac 0d 00 00       	call   80104af0 <release>

  if (first) {
80103d44:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103d49:	83 c4 10             	add    $0x10,%esp
80103d4c:	85 c0                	test   %eax,%eax
80103d4e:	75 08                	jne    80103d58 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103d50:	c9                   	leave  
80103d51:	c3                   	ret    
80103d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103d58:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103d5f:	00 00 00 
    iinit(ROOTDEV);
80103d62:	83 ec 0c             	sub    $0xc,%esp
80103d65:	6a 01                	push   $0x1
80103d67:	e8 a4 dc ff ff       	call   80101a10 <iinit>
    initlog(ROOTDEV);
80103d6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103d73:	e8 e8 f3 ff ff       	call   80103160 <initlog>
}
80103d78:	83 c4 10             	add    $0x10,%esp
80103d7b:	c9                   	leave  
80103d7c:	c3                   	ret    
80103d7d:	8d 76 00             	lea    0x0(%esi),%esi

80103d80 <pinit>:
{
80103d80:	f3 0f 1e fb          	endbr32 
80103d84:	55                   	push   %ebp
80103d85:	89 e5                	mov    %esp,%ebp
80103d87:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103d8a:	68 60 7b 10 80       	push   $0x80107b60
80103d8f:	68 c0 32 11 80       	push   $0x801132c0
80103d94:	e8 17 0b 00 00       	call   801048b0 <initlock>
}
80103d99:	83 c4 10             	add    $0x10,%esp
80103d9c:	c9                   	leave  
80103d9d:	c3                   	ret    
80103d9e:	66 90                	xchg   %ax,%ax

80103da0 <mycpu>:
{
80103da0:	f3 0f 1e fb          	endbr32 
80103da4:	55                   	push   %ebp
80103da5:	89 e5                	mov    %esp,%ebp
80103da7:	56                   	push   %esi
80103da8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103da9:	9c                   	pushf  
80103daa:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103dab:	f6 c4 02             	test   $0x2,%ah
80103dae:	75 4a                	jne    80103dfa <mycpu+0x5a>
  apicid = lapicid();
80103db0:	e8 bb ef ff ff       	call   80102d70 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103db5:	8b 35 a0 32 11 80    	mov    0x801132a0,%esi
  apicid = lapicid();
80103dbb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103dbd:	85 f6                	test   %esi,%esi
80103dbf:	7e 2c                	jle    80103ded <mycpu+0x4d>
80103dc1:	31 d2                	xor    %edx,%edx
80103dc3:	eb 0a                	jmp    80103dcf <mycpu+0x2f>
80103dc5:	8d 76 00             	lea    0x0(%esi),%esi
80103dc8:	83 c2 01             	add    $0x1,%edx
80103dcb:	39 f2                	cmp    %esi,%edx
80103dcd:	74 1e                	je     80103ded <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103dcf:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103dd5:	0f b6 81 20 2d 11 80 	movzbl -0x7feed2e0(%ecx),%eax
80103ddc:	39 d8                	cmp    %ebx,%eax
80103dde:	75 e8                	jne    80103dc8 <mycpu+0x28>
}
80103de0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103de3:	8d 81 20 2d 11 80    	lea    -0x7feed2e0(%ecx),%eax
}
80103de9:	5b                   	pop    %ebx
80103dea:	5e                   	pop    %esi
80103deb:	5d                   	pop    %ebp
80103dec:	c3                   	ret    
  panic("unknown apicid\n");
80103ded:	83 ec 0c             	sub    $0xc,%esp
80103df0:	68 67 7b 10 80       	push   $0x80107b67
80103df5:	e8 96 c5 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103dfa:	83 ec 0c             	sub    $0xc,%esp
80103dfd:	68 44 7c 10 80       	push   $0x80107c44
80103e02:	e8 89 c5 ff ff       	call   80100390 <panic>
80103e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e0e:	66 90                	xchg   %ax,%ax

80103e10 <cpuid>:
cpuid() {
80103e10:	f3 0f 1e fb          	endbr32 
80103e14:	55                   	push   %ebp
80103e15:	89 e5                	mov    %esp,%ebp
80103e17:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103e1a:	e8 81 ff ff ff       	call   80103da0 <mycpu>
}
80103e1f:	c9                   	leave  
  return mycpu()-cpus;
80103e20:	2d 20 2d 11 80       	sub    $0x80112d20,%eax
80103e25:	c1 f8 04             	sar    $0x4,%eax
80103e28:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103e2e:	c3                   	ret    
80103e2f:	90                   	nop

80103e30 <myproc>:
myproc(void) {
80103e30:	f3 0f 1e fb          	endbr32 
80103e34:	55                   	push   %ebp
80103e35:	89 e5                	mov    %esp,%ebp
80103e37:	53                   	push   %ebx
80103e38:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103e3b:	e8 f0 0a 00 00       	call   80104930 <pushcli>
  c = mycpu();
80103e40:	e8 5b ff ff ff       	call   80103da0 <mycpu>
  p = c->proc;
80103e45:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e4b:	e8 30 0b 00 00       	call   80104980 <popcli>
}
80103e50:	83 c4 04             	add    $0x4,%esp
80103e53:	89 d8                	mov    %ebx,%eax
80103e55:	5b                   	pop    %ebx
80103e56:	5d                   	pop    %ebp
80103e57:	c3                   	ret    
80103e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e5f:	90                   	nop

80103e60 <userinit>:
{
80103e60:	f3 0f 1e fb          	endbr32 
80103e64:	55                   	push   %ebp
80103e65:	89 e5                	mov    %esp,%ebp
80103e67:	53                   	push   %ebx
80103e68:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103e6b:	e8 f0 fd ff ff       	call   80103c60 <allocproc>
80103e70:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103e72:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103e77:	e8 a4 34 00 00       	call   80107320 <setupkvm>
80103e7c:	89 43 04             	mov    %eax,0x4(%ebx)
80103e7f:	85 c0                	test   %eax,%eax
80103e81:	0f 84 bd 00 00 00    	je     80103f44 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103e87:	83 ec 04             	sub    $0x4,%esp
80103e8a:	68 2c 00 00 00       	push   $0x2c
80103e8f:	68 60 a4 10 80       	push   $0x8010a460
80103e94:	50                   	push   %eax
80103e95:	e8 56 31 00 00       	call   80106ff0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103e9a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103e9d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103ea3:	6a 4c                	push   $0x4c
80103ea5:	6a 00                	push   $0x0
80103ea7:	ff 73 18             	pushl  0x18(%ebx)
80103eaa:	e8 91 0c 00 00       	call   80104b40 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103eaf:	8b 43 18             	mov    0x18(%ebx),%eax
80103eb2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103eb7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103eba:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ebf:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ec3:	8b 43 18             	mov    0x18(%ebx),%eax
80103ec6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103eca:	8b 43 18             	mov    0x18(%ebx),%eax
80103ecd:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ed1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ed5:	8b 43 18             	mov    0x18(%ebx),%eax
80103ed8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103edc:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103ee0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ee3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103eea:	8b 43 18             	mov    0x18(%ebx),%eax
80103eed:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ef4:	8b 43 18             	mov    0x18(%ebx),%eax
80103ef7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103efe:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103f01:	6a 10                	push   $0x10
80103f03:	68 90 7b 10 80       	push   $0x80107b90
80103f08:	50                   	push   %eax
80103f09:	e8 f2 0d 00 00       	call   80104d00 <safestrcpy>
  p->cwd = namei("/");
80103f0e:	c7 04 24 99 7b 10 80 	movl   $0x80107b99,(%esp)
80103f15:	e8 e6 e5 ff ff       	call   80102500 <namei>
80103f1a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103f1d:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
80103f24:	e8 07 0b 00 00       	call   80104a30 <acquire>
  p->state = RUNNABLE;
80103f29:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103f30:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
80103f37:	e8 b4 0b 00 00       	call   80104af0 <release>
}
80103f3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f3f:	83 c4 10             	add    $0x10,%esp
80103f42:	c9                   	leave  
80103f43:	c3                   	ret    
    panic("userinit: out of memory?");
80103f44:	83 ec 0c             	sub    $0xc,%esp
80103f47:	68 77 7b 10 80       	push   $0x80107b77
80103f4c:	e8 3f c4 ff ff       	call   80100390 <panic>
80103f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f5f:	90                   	nop

80103f60 <growproc>:
{
80103f60:	f3 0f 1e fb          	endbr32 
80103f64:	55                   	push   %ebp
80103f65:	89 e5                	mov    %esp,%ebp
80103f67:	56                   	push   %esi
80103f68:	53                   	push   %ebx
80103f69:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103f6c:	e8 bf 09 00 00       	call   80104930 <pushcli>
  c = mycpu();
80103f71:	e8 2a fe ff ff       	call   80103da0 <mycpu>
  p = c->proc;
80103f76:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f7c:	e8 ff 09 00 00       	call   80104980 <popcli>
  sz = curproc->sz;
80103f81:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103f83:	85 f6                	test   %esi,%esi
80103f85:	7f 19                	jg     80103fa0 <growproc+0x40>
  } else if(n < 0){
80103f87:	75 37                	jne    80103fc0 <growproc+0x60>
  switchuvm(curproc);
80103f89:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f8c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f8e:	53                   	push   %ebx
80103f8f:	e8 4c 2f 00 00       	call   80106ee0 <switchuvm>
  return 0;
80103f94:	83 c4 10             	add    $0x10,%esp
80103f97:	31 c0                	xor    %eax,%eax
}
80103f99:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f9c:	5b                   	pop    %ebx
80103f9d:	5e                   	pop    %esi
80103f9e:	5d                   	pop    %ebp
80103f9f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fa0:	83 ec 04             	sub    $0x4,%esp
80103fa3:	01 c6                	add    %eax,%esi
80103fa5:	56                   	push   %esi
80103fa6:	50                   	push   %eax
80103fa7:	ff 73 04             	pushl  0x4(%ebx)
80103faa:	e8 91 31 00 00       	call   80107140 <allocuvm>
80103faf:	83 c4 10             	add    $0x10,%esp
80103fb2:	85 c0                	test   %eax,%eax
80103fb4:	75 d3                	jne    80103f89 <growproc+0x29>
      return -1;
80103fb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fbb:	eb dc                	jmp    80103f99 <growproc+0x39>
80103fbd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fc0:	83 ec 04             	sub    $0x4,%esp
80103fc3:	01 c6                	add    %eax,%esi
80103fc5:	56                   	push   %esi
80103fc6:	50                   	push   %eax
80103fc7:	ff 73 04             	pushl  0x4(%ebx)
80103fca:	e8 a1 32 00 00       	call   80107270 <deallocuvm>
80103fcf:	83 c4 10             	add    $0x10,%esp
80103fd2:	85 c0                	test   %eax,%eax
80103fd4:	75 b3                	jne    80103f89 <growproc+0x29>
80103fd6:	eb de                	jmp    80103fb6 <growproc+0x56>
80103fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fdf:	90                   	nop

80103fe0 <fork>:
{
80103fe0:	f3 0f 1e fb          	endbr32 
80103fe4:	55                   	push   %ebp
80103fe5:	89 e5                	mov    %esp,%ebp
80103fe7:	57                   	push   %edi
80103fe8:	56                   	push   %esi
80103fe9:	53                   	push   %ebx
80103fea:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103fed:	e8 3e 09 00 00       	call   80104930 <pushcli>
  c = mycpu();
80103ff2:	e8 a9 fd ff ff       	call   80103da0 <mycpu>
  p = c->proc;
80103ff7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ffd:	e8 7e 09 00 00       	call   80104980 <popcli>
  if((np = allocproc()) == 0){
80104002:	e8 59 fc ff ff       	call   80103c60 <allocproc>
80104007:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010400a:	85 c0                	test   %eax,%eax
8010400c:	0f 84 bb 00 00 00    	je     801040cd <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104012:	83 ec 08             	sub    $0x8,%esp
80104015:	ff 33                	pushl  (%ebx)
80104017:	89 c7                	mov    %eax,%edi
80104019:	ff 73 04             	pushl  0x4(%ebx)
8010401c:	e8 cf 33 00 00       	call   801073f0 <copyuvm>
80104021:	83 c4 10             	add    $0x10,%esp
80104024:	89 47 04             	mov    %eax,0x4(%edi)
80104027:	85 c0                	test   %eax,%eax
80104029:	0f 84 a5 00 00 00    	je     801040d4 <fork+0xf4>
  np->sz = curproc->sz;
8010402f:	8b 03                	mov    (%ebx),%eax
80104031:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104034:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104036:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104039:	89 c8                	mov    %ecx,%eax
8010403b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010403e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104043:	8b 73 18             	mov    0x18(%ebx),%esi
80104046:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104048:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010404a:	8b 40 18             	mov    0x18(%eax),%eax
8010404d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104058:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010405c:	85 c0                	test   %eax,%eax
8010405e:	74 13                	je     80104073 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104060:	83 ec 0c             	sub    $0xc,%esp
80104063:	50                   	push   %eax
80104064:	e8 d7 d2 ff ff       	call   80101340 <filedup>
80104069:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010406c:	83 c4 10             	add    $0x10,%esp
8010406f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104073:	83 c6 01             	add    $0x1,%esi
80104076:	83 fe 10             	cmp    $0x10,%esi
80104079:	75 dd                	jne    80104058 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010407b:	83 ec 0c             	sub    $0xc,%esp
8010407e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104081:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104084:	e8 77 db ff ff       	call   80101c00 <idup>
80104089:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010408c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010408f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104092:	8d 47 6c             	lea    0x6c(%edi),%eax
80104095:	6a 10                	push   $0x10
80104097:	53                   	push   %ebx
80104098:	50                   	push   %eax
80104099:	e8 62 0c 00 00       	call   80104d00 <safestrcpy>
  pid = np->pid;
8010409e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801040a1:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
801040a8:	e8 83 09 00 00       	call   80104a30 <acquire>
  np->state = RUNNABLE;
801040ad:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801040b4:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
801040bb:	e8 30 0a 00 00       	call   80104af0 <release>
  return pid;
801040c0:	83 c4 10             	add    $0x10,%esp
}
801040c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040c6:	89 d8                	mov    %ebx,%eax
801040c8:	5b                   	pop    %ebx
801040c9:	5e                   	pop    %esi
801040ca:	5f                   	pop    %edi
801040cb:	5d                   	pop    %ebp
801040cc:	c3                   	ret    
    return -1;
801040cd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801040d2:	eb ef                	jmp    801040c3 <fork+0xe3>
    kfree(np->kstack);
801040d4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801040d7:	83 ec 0c             	sub    $0xc,%esp
801040da:	ff 73 08             	pushl  0x8(%ebx)
801040dd:	e8 5e e8 ff ff       	call   80102940 <kfree>
    np->kstack = 0;
801040e2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801040e9:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801040ec:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801040f3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801040f8:	eb c9                	jmp    801040c3 <fork+0xe3>
801040fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104100 <scheduler>:
{
80104100:	f3 0f 1e fb          	endbr32 
80104104:	55                   	push   %ebp
80104105:	89 e5                	mov    %esp,%ebp
80104107:	57                   	push   %edi
80104108:	56                   	push   %esi
80104109:	53                   	push   %ebx
8010410a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010410d:	e8 8e fc ff ff       	call   80103da0 <mycpu>
  c->proc = 0;
80104112:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104119:	00 00 00 
  struct cpu *c = mycpu();
8010411c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010411e:	8d 78 04             	lea    0x4(%eax),%edi
80104121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104128:	fb                   	sti    
    acquire(&ptable.lock);
80104129:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010412c:	bb f4 32 11 80       	mov    $0x801132f4,%ebx
    acquire(&ptable.lock);
80104131:	68 c0 32 11 80       	push   $0x801132c0
80104136:	e8 f5 08 00 00       	call   80104a30 <acquire>
8010413b:	83 c4 10             	add    $0x10,%esp
8010413e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104140:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104144:	75 33                	jne    80104179 <scheduler+0x79>
      switchuvm(p);
80104146:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104149:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010414f:	53                   	push   %ebx
80104150:	e8 8b 2d 00 00       	call   80106ee0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104155:	58                   	pop    %eax
80104156:	5a                   	pop    %edx
80104157:	ff 73 1c             	pushl  0x1c(%ebx)
8010415a:	57                   	push   %edi
      p->state = RUNNING;
8010415b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104162:	e8 fc 0b 00 00       	call   80104d63 <swtch>
      switchkvm();
80104167:	e8 54 2d 00 00       	call   80106ec0 <switchkvm>
      c->proc = 0;
8010416c:	83 c4 10             	add    $0x10,%esp
8010416f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104176:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104179:	83 c3 7c             	add    $0x7c,%ebx
8010417c:	81 fb f4 51 11 80    	cmp    $0x801151f4,%ebx
80104182:	75 bc                	jne    80104140 <scheduler+0x40>
    release(&ptable.lock);
80104184:	83 ec 0c             	sub    $0xc,%esp
80104187:	68 c0 32 11 80       	push   $0x801132c0
8010418c:	e8 5f 09 00 00       	call   80104af0 <release>
    sti();
80104191:	83 c4 10             	add    $0x10,%esp
80104194:	eb 92                	jmp    80104128 <scheduler+0x28>
80104196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010419d:	8d 76 00             	lea    0x0(%esi),%esi

801041a0 <sched>:
{
801041a0:	f3 0f 1e fb          	endbr32 
801041a4:	55                   	push   %ebp
801041a5:	89 e5                	mov    %esp,%ebp
801041a7:	56                   	push   %esi
801041a8:	53                   	push   %ebx
  pushcli();
801041a9:	e8 82 07 00 00       	call   80104930 <pushcli>
  c = mycpu();
801041ae:	e8 ed fb ff ff       	call   80103da0 <mycpu>
  p = c->proc;
801041b3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041b9:	e8 c2 07 00 00       	call   80104980 <popcli>
  if(!holding(&ptable.lock))
801041be:	83 ec 0c             	sub    $0xc,%esp
801041c1:	68 c0 32 11 80       	push   $0x801132c0
801041c6:	e8 15 08 00 00       	call   801049e0 <holding>
801041cb:	83 c4 10             	add    $0x10,%esp
801041ce:	85 c0                	test   %eax,%eax
801041d0:	74 4f                	je     80104221 <sched+0x81>
  if(mycpu()->ncli != 1)
801041d2:	e8 c9 fb ff ff       	call   80103da0 <mycpu>
801041d7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801041de:	75 68                	jne    80104248 <sched+0xa8>
  if(p->state == RUNNING)
801041e0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801041e4:	74 55                	je     8010423b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041e6:	9c                   	pushf  
801041e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041e8:	f6 c4 02             	test   $0x2,%ah
801041eb:	75 41                	jne    8010422e <sched+0x8e>
  intena = mycpu()->intena;
801041ed:	e8 ae fb ff ff       	call   80103da0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801041f2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801041f5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801041fb:	e8 a0 fb ff ff       	call   80103da0 <mycpu>
80104200:	83 ec 08             	sub    $0x8,%esp
80104203:	ff 70 04             	pushl  0x4(%eax)
80104206:	53                   	push   %ebx
80104207:	e8 57 0b 00 00       	call   80104d63 <swtch>
  mycpu()->intena = intena;
8010420c:	e8 8f fb ff ff       	call   80103da0 <mycpu>
}
80104211:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104214:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010421a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010421d:	5b                   	pop    %ebx
8010421e:	5e                   	pop    %esi
8010421f:	5d                   	pop    %ebp
80104220:	c3                   	ret    
    panic("sched ptable.lock");
80104221:	83 ec 0c             	sub    $0xc,%esp
80104224:	68 9b 7b 10 80       	push   $0x80107b9b
80104229:	e8 62 c1 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010422e:	83 ec 0c             	sub    $0xc,%esp
80104231:	68 c7 7b 10 80       	push   $0x80107bc7
80104236:	e8 55 c1 ff ff       	call   80100390 <panic>
    panic("sched running");
8010423b:	83 ec 0c             	sub    $0xc,%esp
8010423e:	68 b9 7b 10 80       	push   $0x80107bb9
80104243:	e8 48 c1 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104248:	83 ec 0c             	sub    $0xc,%esp
8010424b:	68 ad 7b 10 80       	push   $0x80107bad
80104250:	e8 3b c1 ff ff       	call   80100390 <panic>
80104255:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010425c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104260 <exit>:
{
80104260:	f3 0f 1e fb          	endbr32 
80104264:	55                   	push   %ebp
80104265:	89 e5                	mov    %esp,%ebp
80104267:	57                   	push   %edi
80104268:	56                   	push   %esi
80104269:	53                   	push   %ebx
8010426a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010426d:	e8 be 06 00 00       	call   80104930 <pushcli>
  c = mycpu();
80104272:	e8 29 fb ff ff       	call   80103da0 <mycpu>
  p = c->proc;
80104277:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010427d:	e8 fe 06 00 00       	call   80104980 <popcli>
  if(curproc == initproc)
80104282:	8d 5e 28             	lea    0x28(%esi),%ebx
80104285:	8d 7e 68             	lea    0x68(%esi),%edi
80104288:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
8010428e:	0f 84 f3 00 00 00    	je     80104387 <exit+0x127>
80104294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104298:	8b 03                	mov    (%ebx),%eax
8010429a:	85 c0                	test   %eax,%eax
8010429c:	74 12                	je     801042b0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010429e:	83 ec 0c             	sub    $0xc,%esp
801042a1:	50                   	push   %eax
801042a2:	e8 e9 d0 ff ff       	call   80101390 <fileclose>
      curproc->ofile[fd] = 0;
801042a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801042ad:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801042b0:	83 c3 04             	add    $0x4,%ebx
801042b3:	39 df                	cmp    %ebx,%edi
801042b5:	75 e1                	jne    80104298 <exit+0x38>
  begin_op();
801042b7:	e8 44 ef ff ff       	call   80103200 <begin_op>
  iput(curproc->cwd);
801042bc:	83 ec 0c             	sub    $0xc,%esp
801042bf:	ff 76 68             	pushl  0x68(%esi)
801042c2:	e8 99 da ff ff       	call   80101d60 <iput>
  end_op();
801042c7:	e8 a4 ef ff ff       	call   80103270 <end_op>
  curproc->cwd = 0;
801042cc:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801042d3:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
801042da:	e8 51 07 00 00       	call   80104a30 <acquire>
  wakeup1(curproc->parent);
801042df:	8b 56 14             	mov    0x14(%esi),%edx
801042e2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042e5:	b8 f4 32 11 80       	mov    $0x801132f4,%eax
801042ea:	eb 0e                	jmp    801042fa <exit+0x9a>
801042ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042f0:	83 c0 7c             	add    $0x7c,%eax
801042f3:	3d f4 51 11 80       	cmp    $0x801151f4,%eax
801042f8:	74 1c                	je     80104316 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
801042fa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042fe:	75 f0                	jne    801042f0 <exit+0x90>
80104300:	3b 50 20             	cmp    0x20(%eax),%edx
80104303:	75 eb                	jne    801042f0 <exit+0x90>
      p->state = RUNNABLE;
80104305:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010430c:	83 c0 7c             	add    $0x7c,%eax
8010430f:	3d f4 51 11 80       	cmp    $0x801151f4,%eax
80104314:	75 e4                	jne    801042fa <exit+0x9a>
      p->parent = initproc;
80104316:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010431c:	ba f4 32 11 80       	mov    $0x801132f4,%edx
80104321:	eb 10                	jmp    80104333 <exit+0xd3>
80104323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104327:	90                   	nop
80104328:	83 c2 7c             	add    $0x7c,%edx
8010432b:	81 fa f4 51 11 80    	cmp    $0x801151f4,%edx
80104331:	74 3b                	je     8010436e <exit+0x10e>
    if(p->parent == curproc){
80104333:	39 72 14             	cmp    %esi,0x14(%edx)
80104336:	75 f0                	jne    80104328 <exit+0xc8>
      if(p->state == ZOMBIE)
80104338:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010433c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010433f:	75 e7                	jne    80104328 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104341:	b8 f4 32 11 80       	mov    $0x801132f4,%eax
80104346:	eb 12                	jmp    8010435a <exit+0xfa>
80104348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010434f:	90                   	nop
80104350:	83 c0 7c             	add    $0x7c,%eax
80104353:	3d f4 51 11 80       	cmp    $0x801151f4,%eax
80104358:	74 ce                	je     80104328 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
8010435a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010435e:	75 f0                	jne    80104350 <exit+0xf0>
80104360:	3b 48 20             	cmp    0x20(%eax),%ecx
80104363:	75 eb                	jne    80104350 <exit+0xf0>
      p->state = RUNNABLE;
80104365:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010436c:	eb e2                	jmp    80104350 <exit+0xf0>
  curproc->state = ZOMBIE;
8010436e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104375:	e8 26 fe ff ff       	call   801041a0 <sched>
  panic("zombie exit");
8010437a:	83 ec 0c             	sub    $0xc,%esp
8010437d:	68 e8 7b 10 80       	push   $0x80107be8
80104382:	e8 09 c0 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104387:	83 ec 0c             	sub    $0xc,%esp
8010438a:	68 db 7b 10 80       	push   $0x80107bdb
8010438f:	e8 fc bf ff ff       	call   80100390 <panic>
80104394:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010439b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010439f:	90                   	nop

801043a0 <yield>:
{
801043a0:	f3 0f 1e fb          	endbr32 
801043a4:	55                   	push   %ebp
801043a5:	89 e5                	mov    %esp,%ebp
801043a7:	53                   	push   %ebx
801043a8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801043ab:	68 c0 32 11 80       	push   $0x801132c0
801043b0:	e8 7b 06 00 00       	call   80104a30 <acquire>
  pushcli();
801043b5:	e8 76 05 00 00       	call   80104930 <pushcli>
  c = mycpu();
801043ba:	e8 e1 f9 ff ff       	call   80103da0 <mycpu>
  p = c->proc;
801043bf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043c5:	e8 b6 05 00 00       	call   80104980 <popcli>
  myproc()->state = RUNNABLE;
801043ca:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801043d1:	e8 ca fd ff ff       	call   801041a0 <sched>
  release(&ptable.lock);
801043d6:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
801043dd:	e8 0e 07 00 00       	call   80104af0 <release>
}
801043e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043e5:	83 c4 10             	add    $0x10,%esp
801043e8:	c9                   	leave  
801043e9:	c3                   	ret    
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043f0 <sleep>:
{
801043f0:	f3 0f 1e fb          	endbr32 
801043f4:	55                   	push   %ebp
801043f5:	89 e5                	mov    %esp,%ebp
801043f7:	57                   	push   %edi
801043f8:	56                   	push   %esi
801043f9:	53                   	push   %ebx
801043fa:	83 ec 0c             	sub    $0xc,%esp
801043fd:	8b 7d 08             	mov    0x8(%ebp),%edi
80104400:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104403:	e8 28 05 00 00       	call   80104930 <pushcli>
  c = mycpu();
80104408:	e8 93 f9 ff ff       	call   80103da0 <mycpu>
  p = c->proc;
8010440d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104413:	e8 68 05 00 00       	call   80104980 <popcli>
  if(p == 0)
80104418:	85 db                	test   %ebx,%ebx
8010441a:	0f 84 83 00 00 00    	je     801044a3 <sleep+0xb3>
  if(lk == 0)
80104420:	85 f6                	test   %esi,%esi
80104422:	74 72                	je     80104496 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104424:	81 fe c0 32 11 80    	cmp    $0x801132c0,%esi
8010442a:	74 4c                	je     80104478 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010442c:	83 ec 0c             	sub    $0xc,%esp
8010442f:	68 c0 32 11 80       	push   $0x801132c0
80104434:	e8 f7 05 00 00       	call   80104a30 <acquire>
    release(lk);
80104439:	89 34 24             	mov    %esi,(%esp)
8010443c:	e8 af 06 00 00       	call   80104af0 <release>
  p->chan = chan;
80104441:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104444:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010444b:	e8 50 fd ff ff       	call   801041a0 <sched>
  p->chan = 0;
80104450:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104457:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
8010445e:	e8 8d 06 00 00       	call   80104af0 <release>
    acquire(lk);
80104463:	89 75 08             	mov    %esi,0x8(%ebp)
80104466:	83 c4 10             	add    $0x10,%esp
}
80104469:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010446c:	5b                   	pop    %ebx
8010446d:	5e                   	pop    %esi
8010446e:	5f                   	pop    %edi
8010446f:	5d                   	pop    %ebp
    acquire(lk);
80104470:	e9 bb 05 00 00       	jmp    80104a30 <acquire>
80104475:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104478:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010447b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104482:	e8 19 fd ff ff       	call   801041a0 <sched>
  p->chan = 0;
80104487:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010448e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104491:	5b                   	pop    %ebx
80104492:	5e                   	pop    %esi
80104493:	5f                   	pop    %edi
80104494:	5d                   	pop    %ebp
80104495:	c3                   	ret    
    panic("sleep without lk");
80104496:	83 ec 0c             	sub    $0xc,%esp
80104499:	68 fa 7b 10 80       	push   $0x80107bfa
8010449e:	e8 ed be ff ff       	call   80100390 <panic>
    panic("sleep");
801044a3:	83 ec 0c             	sub    $0xc,%esp
801044a6:	68 f4 7b 10 80       	push   $0x80107bf4
801044ab:	e8 e0 be ff ff       	call   80100390 <panic>

801044b0 <wait>:
{
801044b0:	f3 0f 1e fb          	endbr32 
801044b4:	55                   	push   %ebp
801044b5:	89 e5                	mov    %esp,%ebp
801044b7:	56                   	push   %esi
801044b8:	53                   	push   %ebx
  pushcli();
801044b9:	e8 72 04 00 00       	call   80104930 <pushcli>
  c = mycpu();
801044be:	e8 dd f8 ff ff       	call   80103da0 <mycpu>
  p = c->proc;
801044c3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801044c9:	e8 b2 04 00 00       	call   80104980 <popcli>
  acquire(&ptable.lock);
801044ce:	83 ec 0c             	sub    $0xc,%esp
801044d1:	68 c0 32 11 80       	push   $0x801132c0
801044d6:	e8 55 05 00 00       	call   80104a30 <acquire>
801044db:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801044de:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044e0:	bb f4 32 11 80       	mov    $0x801132f4,%ebx
801044e5:	eb 14                	jmp    801044fb <wait+0x4b>
801044e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ee:	66 90                	xchg   %ax,%ax
801044f0:	83 c3 7c             	add    $0x7c,%ebx
801044f3:	81 fb f4 51 11 80    	cmp    $0x801151f4,%ebx
801044f9:	74 1b                	je     80104516 <wait+0x66>
      if(p->parent != curproc)
801044fb:	39 73 14             	cmp    %esi,0x14(%ebx)
801044fe:	75 f0                	jne    801044f0 <wait+0x40>
      if(p->state == ZOMBIE){
80104500:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104504:	74 32                	je     80104538 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104506:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104509:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010450e:	81 fb f4 51 11 80    	cmp    $0x801151f4,%ebx
80104514:	75 e5                	jne    801044fb <wait+0x4b>
    if(!havekids || curproc->killed){
80104516:	85 c0                	test   %eax,%eax
80104518:	74 74                	je     8010458e <wait+0xde>
8010451a:	8b 46 24             	mov    0x24(%esi),%eax
8010451d:	85 c0                	test   %eax,%eax
8010451f:	75 6d                	jne    8010458e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104521:	83 ec 08             	sub    $0x8,%esp
80104524:	68 c0 32 11 80       	push   $0x801132c0
80104529:	56                   	push   %esi
8010452a:	e8 c1 fe ff ff       	call   801043f0 <sleep>
    havekids = 0;
8010452f:	83 c4 10             	add    $0x10,%esp
80104532:	eb aa                	jmp    801044de <wait+0x2e>
80104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104538:	83 ec 0c             	sub    $0xc,%esp
8010453b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010453e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104541:	e8 fa e3 ff ff       	call   80102940 <kfree>
        freevm(p->pgdir);
80104546:	5a                   	pop    %edx
80104547:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010454a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104551:	e8 4a 2d 00 00       	call   801072a0 <freevm>
        release(&ptable.lock);
80104556:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
        p->pid = 0;
8010455d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104564:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010456b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010456f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104576:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010457d:	e8 6e 05 00 00       	call   80104af0 <release>
        return pid;
80104582:	83 c4 10             	add    $0x10,%esp
}
80104585:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104588:	89 f0                	mov    %esi,%eax
8010458a:	5b                   	pop    %ebx
8010458b:	5e                   	pop    %esi
8010458c:	5d                   	pop    %ebp
8010458d:	c3                   	ret    
      release(&ptable.lock);
8010458e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104591:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104596:	68 c0 32 11 80       	push   $0x801132c0
8010459b:	e8 50 05 00 00       	call   80104af0 <release>
      return -1;
801045a0:	83 c4 10             	add    $0x10,%esp
801045a3:	eb e0                	jmp    80104585 <wait+0xd5>
801045a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801045b0:	f3 0f 1e fb          	endbr32 
801045b4:	55                   	push   %ebp
801045b5:	89 e5                	mov    %esp,%ebp
801045b7:	53                   	push   %ebx
801045b8:	83 ec 10             	sub    $0x10,%esp
801045bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801045be:	68 c0 32 11 80       	push   $0x801132c0
801045c3:	e8 68 04 00 00       	call   80104a30 <acquire>
801045c8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045cb:	b8 f4 32 11 80       	mov    $0x801132f4,%eax
801045d0:	eb 10                	jmp    801045e2 <wakeup+0x32>
801045d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045d8:	83 c0 7c             	add    $0x7c,%eax
801045db:	3d f4 51 11 80       	cmp    $0x801151f4,%eax
801045e0:	74 1c                	je     801045fe <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
801045e2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045e6:	75 f0                	jne    801045d8 <wakeup+0x28>
801045e8:	3b 58 20             	cmp    0x20(%eax),%ebx
801045eb:	75 eb                	jne    801045d8 <wakeup+0x28>
      p->state = RUNNABLE;
801045ed:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045f4:	83 c0 7c             	add    $0x7c,%eax
801045f7:	3d f4 51 11 80       	cmp    $0x801151f4,%eax
801045fc:	75 e4                	jne    801045e2 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
801045fe:	c7 45 08 c0 32 11 80 	movl   $0x801132c0,0x8(%ebp)
}
80104605:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104608:	c9                   	leave  
  release(&ptable.lock);
80104609:	e9 e2 04 00 00       	jmp    80104af0 <release>
8010460e:	66 90                	xchg   %ax,%ax

80104610 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104610:	f3 0f 1e fb          	endbr32 
80104614:	55                   	push   %ebp
80104615:	89 e5                	mov    %esp,%ebp
80104617:	53                   	push   %ebx
80104618:	83 ec 10             	sub    $0x10,%esp
8010461b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010461e:	68 c0 32 11 80       	push   $0x801132c0
80104623:	e8 08 04 00 00       	call   80104a30 <acquire>
80104628:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010462b:	b8 f4 32 11 80       	mov    $0x801132f4,%eax
80104630:	eb 10                	jmp    80104642 <kill+0x32>
80104632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104638:	83 c0 7c             	add    $0x7c,%eax
8010463b:	3d f4 51 11 80       	cmp    $0x801151f4,%eax
80104640:	74 36                	je     80104678 <kill+0x68>
    if(p->pid == pid){
80104642:	39 58 10             	cmp    %ebx,0x10(%eax)
80104645:	75 f1                	jne    80104638 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104647:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010464b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104652:	75 07                	jne    8010465b <kill+0x4b>
        p->state = RUNNABLE;
80104654:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010465b:	83 ec 0c             	sub    $0xc,%esp
8010465e:	68 c0 32 11 80       	push   $0x801132c0
80104663:	e8 88 04 00 00       	call   80104af0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104668:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010466b:	83 c4 10             	add    $0x10,%esp
8010466e:	31 c0                	xor    %eax,%eax
}
80104670:	c9                   	leave  
80104671:	c3                   	ret    
80104672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104678:	83 ec 0c             	sub    $0xc,%esp
8010467b:	68 c0 32 11 80       	push   $0x801132c0
80104680:	e8 6b 04 00 00       	call   80104af0 <release>
}
80104685:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104688:	83 c4 10             	add    $0x10,%esp
8010468b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104690:	c9                   	leave  
80104691:	c3                   	ret    
80104692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801046a0:	f3 0f 1e fb          	endbr32 
801046a4:	55                   	push   %ebp
801046a5:	89 e5                	mov    %esp,%ebp
801046a7:	57                   	push   %edi
801046a8:	56                   	push   %esi
801046a9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801046ac:	53                   	push   %ebx
801046ad:	bb 60 33 11 80       	mov    $0x80113360,%ebx
801046b2:	83 ec 3c             	sub    $0x3c,%esp
801046b5:	eb 28                	jmp    801046df <procdump+0x3f>
801046b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046be:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801046c0:	83 ec 0c             	sub    $0xc,%esp
801046c3:	68 77 7f 10 80       	push   $0x80107f77
801046c8:	e8 d3 c1 ff ff       	call   801008a0 <cprintf>
801046cd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046d0:	83 c3 7c             	add    $0x7c,%ebx
801046d3:	81 fb 60 52 11 80    	cmp    $0x80115260,%ebx
801046d9:	0f 84 81 00 00 00    	je     80104760 <procdump+0xc0>
    if(p->state == UNUSED)
801046df:	8b 43 a0             	mov    -0x60(%ebx),%eax
801046e2:	85 c0                	test   %eax,%eax
801046e4:	74 ea                	je     801046d0 <procdump+0x30>
      state = "???";
801046e6:	ba 0b 7c 10 80       	mov    $0x80107c0b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046eb:	83 f8 05             	cmp    $0x5,%eax
801046ee:	77 11                	ja     80104701 <procdump+0x61>
801046f0:	8b 14 85 6c 7c 10 80 	mov    -0x7fef8394(,%eax,4),%edx
      state = "???";
801046f7:	b8 0b 7c 10 80       	mov    $0x80107c0b,%eax
801046fc:	85 d2                	test   %edx,%edx
801046fe:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104701:	53                   	push   %ebx
80104702:	52                   	push   %edx
80104703:	ff 73 a4             	pushl  -0x5c(%ebx)
80104706:	68 0f 7c 10 80       	push   $0x80107c0f
8010470b:	e8 90 c1 ff ff       	call   801008a0 <cprintf>
    if(p->state == SLEEPING){
80104710:	83 c4 10             	add    $0x10,%esp
80104713:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104717:	75 a7                	jne    801046c0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104719:	83 ec 08             	sub    $0x8,%esp
8010471c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010471f:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104722:	50                   	push   %eax
80104723:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104726:	8b 40 0c             	mov    0xc(%eax),%eax
80104729:	83 c0 08             	add    $0x8,%eax
8010472c:	50                   	push   %eax
8010472d:	e8 9e 01 00 00       	call   801048d0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104732:	83 c4 10             	add    $0x10,%esp
80104735:	8d 76 00             	lea    0x0(%esi),%esi
80104738:	8b 17                	mov    (%edi),%edx
8010473a:	85 d2                	test   %edx,%edx
8010473c:	74 82                	je     801046c0 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010473e:	83 ec 08             	sub    $0x8,%esp
80104741:	83 c7 04             	add    $0x4,%edi
80104744:	52                   	push   %edx
80104745:	68 01 76 10 80       	push   $0x80107601
8010474a:	e8 51 c1 ff ff       	call   801008a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010474f:	83 c4 10             	add    $0x10,%esp
80104752:	39 fe                	cmp    %edi,%esi
80104754:	75 e2                	jne    80104738 <procdump+0x98>
80104756:	e9 65 ff ff ff       	jmp    801046c0 <procdump+0x20>
8010475b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010475f:	90                   	nop
  }
}
80104760:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104763:	5b                   	pop    %ebx
80104764:	5e                   	pop    %esi
80104765:	5f                   	pop    %edi
80104766:	5d                   	pop    %ebp
80104767:	c3                   	ret    
80104768:	66 90                	xchg   %ax,%ax
8010476a:	66 90                	xchg   %ax,%ax
8010476c:	66 90                	xchg   %ax,%ax
8010476e:	66 90                	xchg   %ax,%ax

80104770 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104770:	f3 0f 1e fb          	endbr32 
80104774:	55                   	push   %ebp
80104775:	89 e5                	mov    %esp,%ebp
80104777:	53                   	push   %ebx
80104778:	83 ec 0c             	sub    $0xc,%esp
8010477b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010477e:	68 84 7c 10 80       	push   $0x80107c84
80104783:	8d 43 04             	lea    0x4(%ebx),%eax
80104786:	50                   	push   %eax
80104787:	e8 24 01 00 00       	call   801048b0 <initlock>
  lk->name = name;
8010478c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010478f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104795:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104798:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010479f:	89 43 38             	mov    %eax,0x38(%ebx)
}
801047a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047a5:	c9                   	leave  
801047a6:	c3                   	ret    
801047a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ae:	66 90                	xchg   %ax,%ax

801047b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801047b0:	f3 0f 1e fb          	endbr32 
801047b4:	55                   	push   %ebp
801047b5:	89 e5                	mov    %esp,%ebp
801047b7:	56                   	push   %esi
801047b8:	53                   	push   %ebx
801047b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047bc:	8d 73 04             	lea    0x4(%ebx),%esi
801047bf:	83 ec 0c             	sub    $0xc,%esp
801047c2:	56                   	push   %esi
801047c3:	e8 68 02 00 00       	call   80104a30 <acquire>
  while (lk->locked) {
801047c8:	8b 13                	mov    (%ebx),%edx
801047ca:	83 c4 10             	add    $0x10,%esp
801047cd:	85 d2                	test   %edx,%edx
801047cf:	74 1a                	je     801047eb <acquiresleep+0x3b>
801047d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801047d8:	83 ec 08             	sub    $0x8,%esp
801047db:	56                   	push   %esi
801047dc:	53                   	push   %ebx
801047dd:	e8 0e fc ff ff       	call   801043f0 <sleep>
  while (lk->locked) {
801047e2:	8b 03                	mov    (%ebx),%eax
801047e4:	83 c4 10             	add    $0x10,%esp
801047e7:	85 c0                	test   %eax,%eax
801047e9:	75 ed                	jne    801047d8 <acquiresleep+0x28>
  }
  lk->locked = 1;
801047eb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801047f1:	e8 3a f6 ff ff       	call   80103e30 <myproc>
801047f6:	8b 40 10             	mov    0x10(%eax),%eax
801047f9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801047fc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801047ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104802:	5b                   	pop    %ebx
80104803:	5e                   	pop    %esi
80104804:	5d                   	pop    %ebp
  release(&lk->lk);
80104805:	e9 e6 02 00 00       	jmp    80104af0 <release>
8010480a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104810 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104810:	f3 0f 1e fb          	endbr32 
80104814:	55                   	push   %ebp
80104815:	89 e5                	mov    %esp,%ebp
80104817:	56                   	push   %esi
80104818:	53                   	push   %ebx
80104819:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010481c:	8d 73 04             	lea    0x4(%ebx),%esi
8010481f:	83 ec 0c             	sub    $0xc,%esp
80104822:	56                   	push   %esi
80104823:	e8 08 02 00 00       	call   80104a30 <acquire>
  lk->locked = 0;
80104828:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010482e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104835:	89 1c 24             	mov    %ebx,(%esp)
80104838:	e8 73 fd ff ff       	call   801045b0 <wakeup>
  release(&lk->lk);
8010483d:	89 75 08             	mov    %esi,0x8(%ebp)
80104840:	83 c4 10             	add    $0x10,%esp
}
80104843:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104846:	5b                   	pop    %ebx
80104847:	5e                   	pop    %esi
80104848:	5d                   	pop    %ebp
  release(&lk->lk);
80104849:	e9 a2 02 00 00       	jmp    80104af0 <release>
8010484e:	66 90                	xchg   %ax,%ax

80104850 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104850:	f3 0f 1e fb          	endbr32 
80104854:	55                   	push   %ebp
80104855:	89 e5                	mov    %esp,%ebp
80104857:	57                   	push   %edi
80104858:	31 ff                	xor    %edi,%edi
8010485a:	56                   	push   %esi
8010485b:	53                   	push   %ebx
8010485c:	83 ec 18             	sub    $0x18,%esp
8010485f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104862:	8d 73 04             	lea    0x4(%ebx),%esi
80104865:	56                   	push   %esi
80104866:	e8 c5 01 00 00       	call   80104a30 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010486b:	8b 03                	mov    (%ebx),%eax
8010486d:	83 c4 10             	add    $0x10,%esp
80104870:	85 c0                	test   %eax,%eax
80104872:	75 1c                	jne    80104890 <holdingsleep+0x40>
  release(&lk->lk);
80104874:	83 ec 0c             	sub    $0xc,%esp
80104877:	56                   	push   %esi
80104878:	e8 73 02 00 00       	call   80104af0 <release>
  return r;
}
8010487d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104880:	89 f8                	mov    %edi,%eax
80104882:	5b                   	pop    %ebx
80104883:	5e                   	pop    %esi
80104884:	5f                   	pop    %edi
80104885:	5d                   	pop    %ebp
80104886:	c3                   	ret    
80104887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104890:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104893:	e8 98 f5 ff ff       	call   80103e30 <myproc>
80104898:	39 58 10             	cmp    %ebx,0x10(%eax)
8010489b:	0f 94 c0             	sete   %al
8010489e:	0f b6 c0             	movzbl %al,%eax
801048a1:	89 c7                	mov    %eax,%edi
801048a3:	eb cf                	jmp    80104874 <holdingsleep+0x24>
801048a5:	66 90                	xchg   %ax,%ax
801048a7:	66 90                	xchg   %ax,%ax
801048a9:	66 90                	xchg   %ax,%ax
801048ab:	66 90                	xchg   %ax,%ax
801048ad:	66 90                	xchg   %ax,%ax
801048af:	90                   	nop

801048b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801048b0:	f3 0f 1e fb          	endbr32 
801048b4:	55                   	push   %ebp
801048b5:	89 e5                	mov    %esp,%ebp
801048b7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801048ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801048bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801048c3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801048c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801048cd:	5d                   	pop    %ebp
801048ce:	c3                   	ret    
801048cf:	90                   	nop

801048d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801048d0:	f3 0f 1e fb          	endbr32 
801048d4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801048d5:	31 d2                	xor    %edx,%edx
{
801048d7:	89 e5                	mov    %esp,%ebp
801048d9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801048da:	8b 45 08             	mov    0x8(%ebp),%eax
{
801048dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801048e0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801048e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048e7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048e8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801048ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048f4:	77 1a                	ja     80104910 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
801048f6:	8b 58 04             	mov    0x4(%eax),%ebx
801048f9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801048fc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801048ff:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104901:	83 fa 0a             	cmp    $0xa,%edx
80104904:	75 e2                	jne    801048e8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104906:	5b                   	pop    %ebx
80104907:	5d                   	pop    %ebp
80104908:	c3                   	ret    
80104909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104910:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104913:	8d 51 28             	lea    0x28(%ecx),%edx
80104916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010491d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104926:	83 c0 04             	add    $0x4,%eax
80104929:	39 d0                	cmp    %edx,%eax
8010492b:	75 f3                	jne    80104920 <getcallerpcs+0x50>
}
8010492d:	5b                   	pop    %ebx
8010492e:	5d                   	pop    %ebp
8010492f:	c3                   	ret    

80104930 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104930:	f3 0f 1e fb          	endbr32 
80104934:	55                   	push   %ebp
80104935:	89 e5                	mov    %esp,%ebp
80104937:	53                   	push   %ebx
80104938:	83 ec 04             	sub    $0x4,%esp
8010493b:	9c                   	pushf  
8010493c:	5b                   	pop    %ebx
  asm volatile("cli");
8010493d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010493e:	e8 5d f4 ff ff       	call   80103da0 <mycpu>
80104943:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104949:	85 c0                	test   %eax,%eax
8010494b:	74 13                	je     80104960 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010494d:	e8 4e f4 ff ff       	call   80103da0 <mycpu>
80104952:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104959:	83 c4 04             	add    $0x4,%esp
8010495c:	5b                   	pop    %ebx
8010495d:	5d                   	pop    %ebp
8010495e:	c3                   	ret    
8010495f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104960:	e8 3b f4 ff ff       	call   80103da0 <mycpu>
80104965:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010496b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104971:	eb da                	jmp    8010494d <pushcli+0x1d>
80104973:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104980 <popcli>:

void
popcli(void)
{
80104980:	f3 0f 1e fb          	endbr32 
80104984:	55                   	push   %ebp
80104985:	89 e5                	mov    %esp,%ebp
80104987:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010498a:	9c                   	pushf  
8010498b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010498c:	f6 c4 02             	test   $0x2,%ah
8010498f:	75 31                	jne    801049c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104991:	e8 0a f4 ff ff       	call   80103da0 <mycpu>
80104996:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010499d:	78 30                	js     801049cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010499f:	e8 fc f3 ff ff       	call   80103da0 <mycpu>
801049a4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801049aa:	85 d2                	test   %edx,%edx
801049ac:	74 02                	je     801049b0 <popcli+0x30>
    sti();
}
801049ae:	c9                   	leave  
801049af:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049b0:	e8 eb f3 ff ff       	call   80103da0 <mycpu>
801049b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049bb:	85 c0                	test   %eax,%eax
801049bd:	74 ef                	je     801049ae <popcli+0x2e>
  asm volatile("sti");
801049bf:	fb                   	sti    
}
801049c0:	c9                   	leave  
801049c1:	c3                   	ret    
    panic("popcli - interruptible");
801049c2:	83 ec 0c             	sub    $0xc,%esp
801049c5:	68 8f 7c 10 80       	push   $0x80107c8f
801049ca:	e8 c1 b9 ff ff       	call   80100390 <panic>
    panic("popcli");
801049cf:	83 ec 0c             	sub    $0xc,%esp
801049d2:	68 a6 7c 10 80       	push   $0x80107ca6
801049d7:	e8 b4 b9 ff ff       	call   80100390 <panic>
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049e0 <holding>:
{
801049e0:	f3 0f 1e fb          	endbr32 
801049e4:	55                   	push   %ebp
801049e5:	89 e5                	mov    %esp,%ebp
801049e7:	56                   	push   %esi
801049e8:	53                   	push   %ebx
801049e9:	8b 75 08             	mov    0x8(%ebp),%esi
801049ec:	31 db                	xor    %ebx,%ebx
  pushcli();
801049ee:	e8 3d ff ff ff       	call   80104930 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801049f3:	8b 06                	mov    (%esi),%eax
801049f5:	85 c0                	test   %eax,%eax
801049f7:	75 0f                	jne    80104a08 <holding+0x28>
  popcli();
801049f9:	e8 82 ff ff ff       	call   80104980 <popcli>
}
801049fe:	89 d8                	mov    %ebx,%eax
80104a00:	5b                   	pop    %ebx
80104a01:	5e                   	pop    %esi
80104a02:	5d                   	pop    %ebp
80104a03:	c3                   	ret    
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104a08:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a0b:	e8 90 f3 ff ff       	call   80103da0 <mycpu>
80104a10:	39 c3                	cmp    %eax,%ebx
80104a12:	0f 94 c3             	sete   %bl
  popcli();
80104a15:	e8 66 ff ff ff       	call   80104980 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104a1a:	0f b6 db             	movzbl %bl,%ebx
}
80104a1d:	89 d8                	mov    %ebx,%eax
80104a1f:	5b                   	pop    %ebx
80104a20:	5e                   	pop    %esi
80104a21:	5d                   	pop    %ebp
80104a22:	c3                   	ret    
80104a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a30 <acquire>:
{
80104a30:	f3 0f 1e fb          	endbr32 
80104a34:	55                   	push   %ebp
80104a35:	89 e5                	mov    %esp,%ebp
80104a37:	56                   	push   %esi
80104a38:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104a39:	e8 f2 fe ff ff       	call   80104930 <pushcli>
  if(holding(lk))
80104a3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a41:	83 ec 0c             	sub    $0xc,%esp
80104a44:	53                   	push   %ebx
80104a45:	e8 96 ff ff ff       	call   801049e0 <holding>
80104a4a:	83 c4 10             	add    $0x10,%esp
80104a4d:	85 c0                	test   %eax,%eax
80104a4f:	0f 85 7f 00 00 00    	jne    80104ad4 <acquire+0xa4>
80104a55:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104a57:	ba 01 00 00 00       	mov    $0x1,%edx
80104a5c:	eb 05                	jmp    80104a63 <acquire+0x33>
80104a5e:	66 90                	xchg   %ax,%ax
80104a60:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a63:	89 d0                	mov    %edx,%eax
80104a65:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104a68:	85 c0                	test   %eax,%eax
80104a6a:	75 f4                	jne    80104a60 <acquire+0x30>
  __sync_synchronize();
80104a6c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104a71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a74:	e8 27 f3 ff ff       	call   80103da0 <mycpu>
80104a79:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104a7c:	89 e8                	mov    %ebp,%eax
80104a7e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a80:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104a86:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104a8c:	77 22                	ja     80104ab0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104a8e:	8b 50 04             	mov    0x4(%eax),%edx
80104a91:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104a95:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104a98:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a9a:	83 fe 0a             	cmp    $0xa,%esi
80104a9d:	75 e1                	jne    80104a80 <acquire+0x50>
}
80104a9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104aa2:	5b                   	pop    %ebx
80104aa3:	5e                   	pop    %esi
80104aa4:	5d                   	pop    %ebp
80104aa5:	c3                   	ret    
80104aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aad:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104ab0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104ab4:	83 c3 34             	add    $0x34,%ebx
80104ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ac0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ac6:	83 c0 04             	add    $0x4,%eax
80104ac9:	39 d8                	cmp    %ebx,%eax
80104acb:	75 f3                	jne    80104ac0 <acquire+0x90>
}
80104acd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ad0:	5b                   	pop    %ebx
80104ad1:	5e                   	pop    %esi
80104ad2:	5d                   	pop    %ebp
80104ad3:	c3                   	ret    
    panic("acquire");
80104ad4:	83 ec 0c             	sub    $0xc,%esp
80104ad7:	68 ad 7c 10 80       	push   $0x80107cad
80104adc:	e8 af b8 ff ff       	call   80100390 <panic>
80104ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aef:	90                   	nop

80104af0 <release>:
{
80104af0:	f3 0f 1e fb          	endbr32 
80104af4:	55                   	push   %ebp
80104af5:	89 e5                	mov    %esp,%ebp
80104af7:	53                   	push   %ebx
80104af8:	83 ec 10             	sub    $0x10,%esp
80104afb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104afe:	53                   	push   %ebx
80104aff:	e8 dc fe ff ff       	call   801049e0 <holding>
80104b04:	83 c4 10             	add    $0x10,%esp
80104b07:	85 c0                	test   %eax,%eax
80104b09:	74 22                	je     80104b2d <release+0x3d>
  lk->pcs[0] = 0;
80104b0b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104b12:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104b19:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104b1e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104b24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b27:	c9                   	leave  
  popcli();
80104b28:	e9 53 fe ff ff       	jmp    80104980 <popcli>
    panic("release");
80104b2d:	83 ec 0c             	sub    $0xc,%esp
80104b30:	68 b5 7c 10 80       	push   $0x80107cb5
80104b35:	e8 56 b8 ff ff       	call   80100390 <panic>
80104b3a:	66 90                	xchg   %ax,%ax
80104b3c:	66 90                	xchg   %ax,%ax
80104b3e:	66 90                	xchg   %ax,%ax

80104b40 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b40:	f3 0f 1e fb          	endbr32 
80104b44:	55                   	push   %ebp
80104b45:	89 e5                	mov    %esp,%ebp
80104b47:	57                   	push   %edi
80104b48:	8b 55 08             	mov    0x8(%ebp),%edx
80104b4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b4e:	53                   	push   %ebx
80104b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104b52:	89 d7                	mov    %edx,%edi
80104b54:	09 cf                	or     %ecx,%edi
80104b56:	83 e7 03             	and    $0x3,%edi
80104b59:	75 25                	jne    80104b80 <memset+0x40>
    c &= 0xFF;
80104b5b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104b5e:	c1 e0 18             	shl    $0x18,%eax
80104b61:	89 fb                	mov    %edi,%ebx
80104b63:	c1 e9 02             	shr    $0x2,%ecx
80104b66:	c1 e3 10             	shl    $0x10,%ebx
80104b69:	09 d8                	or     %ebx,%eax
80104b6b:	09 f8                	or     %edi,%eax
80104b6d:	c1 e7 08             	shl    $0x8,%edi
80104b70:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104b72:	89 d7                	mov    %edx,%edi
80104b74:	fc                   	cld    
80104b75:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104b77:	5b                   	pop    %ebx
80104b78:	89 d0                	mov    %edx,%eax
80104b7a:	5f                   	pop    %edi
80104b7b:	5d                   	pop    %ebp
80104b7c:	c3                   	ret    
80104b7d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104b80:	89 d7                	mov    %edx,%edi
80104b82:	fc                   	cld    
80104b83:	f3 aa                	rep stos %al,%es:(%edi)
80104b85:	5b                   	pop    %ebx
80104b86:	89 d0                	mov    %edx,%eax
80104b88:	5f                   	pop    %edi
80104b89:	5d                   	pop    %ebp
80104b8a:	c3                   	ret    
80104b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b8f:	90                   	nop

80104b90 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104b90:	f3 0f 1e fb          	endbr32 
80104b94:	55                   	push   %ebp
80104b95:	89 e5                	mov    %esp,%ebp
80104b97:	56                   	push   %esi
80104b98:	8b 75 10             	mov    0x10(%ebp),%esi
80104b9b:	8b 55 08             	mov    0x8(%ebp),%edx
80104b9e:	53                   	push   %ebx
80104b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104ba2:	85 f6                	test   %esi,%esi
80104ba4:	74 2a                	je     80104bd0 <memcmp+0x40>
80104ba6:	01 c6                	add    %eax,%esi
80104ba8:	eb 10                	jmp    80104bba <memcmp+0x2a>
80104baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104bb0:	83 c0 01             	add    $0x1,%eax
80104bb3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104bb6:	39 f0                	cmp    %esi,%eax
80104bb8:	74 16                	je     80104bd0 <memcmp+0x40>
    if(*s1 != *s2)
80104bba:	0f b6 0a             	movzbl (%edx),%ecx
80104bbd:	0f b6 18             	movzbl (%eax),%ebx
80104bc0:	38 d9                	cmp    %bl,%cl
80104bc2:	74 ec                	je     80104bb0 <memcmp+0x20>
      return *s1 - *s2;
80104bc4:	0f b6 c1             	movzbl %cl,%eax
80104bc7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104bc9:	5b                   	pop    %ebx
80104bca:	5e                   	pop    %esi
80104bcb:	5d                   	pop    %ebp
80104bcc:	c3                   	ret    
80104bcd:	8d 76 00             	lea    0x0(%esi),%esi
80104bd0:	5b                   	pop    %ebx
  return 0;
80104bd1:	31 c0                	xor    %eax,%eax
}
80104bd3:	5e                   	pop    %esi
80104bd4:	5d                   	pop    %ebp
80104bd5:	c3                   	ret    
80104bd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bdd:	8d 76 00             	lea    0x0(%esi),%esi

80104be0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104be0:	f3 0f 1e fb          	endbr32 
80104be4:	55                   	push   %ebp
80104be5:	89 e5                	mov    %esp,%ebp
80104be7:	57                   	push   %edi
80104be8:	8b 55 08             	mov    0x8(%ebp),%edx
80104beb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104bee:	56                   	push   %esi
80104bef:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104bf2:	39 d6                	cmp    %edx,%esi
80104bf4:	73 2a                	jae    80104c20 <memmove+0x40>
80104bf6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104bf9:	39 fa                	cmp    %edi,%edx
80104bfb:	73 23                	jae    80104c20 <memmove+0x40>
80104bfd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104c00:	85 c9                	test   %ecx,%ecx
80104c02:	74 13                	je     80104c17 <memmove+0x37>
80104c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104c08:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104c0c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104c0f:	83 e8 01             	sub    $0x1,%eax
80104c12:	83 f8 ff             	cmp    $0xffffffff,%eax
80104c15:	75 f1                	jne    80104c08 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104c17:	5e                   	pop    %esi
80104c18:	89 d0                	mov    %edx,%eax
80104c1a:	5f                   	pop    %edi
80104c1b:	5d                   	pop    %ebp
80104c1c:	c3                   	ret    
80104c1d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104c20:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104c23:	89 d7                	mov    %edx,%edi
80104c25:	85 c9                	test   %ecx,%ecx
80104c27:	74 ee                	je     80104c17 <memmove+0x37>
80104c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104c30:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104c31:	39 f0                	cmp    %esi,%eax
80104c33:	75 fb                	jne    80104c30 <memmove+0x50>
}
80104c35:	5e                   	pop    %esi
80104c36:	89 d0                	mov    %edx,%eax
80104c38:	5f                   	pop    %edi
80104c39:	5d                   	pop    %ebp
80104c3a:	c3                   	ret    
80104c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c3f:	90                   	nop

80104c40 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104c40:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104c44:	eb 9a                	jmp    80104be0 <memmove>
80104c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c4d:	8d 76 00             	lea    0x0(%esi),%esi

80104c50 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104c50:	f3 0f 1e fb          	endbr32 
80104c54:	55                   	push   %ebp
80104c55:	89 e5                	mov    %esp,%ebp
80104c57:	56                   	push   %esi
80104c58:	8b 75 10             	mov    0x10(%ebp),%esi
80104c5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c5e:	53                   	push   %ebx
80104c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104c62:	85 f6                	test   %esi,%esi
80104c64:	74 32                	je     80104c98 <strncmp+0x48>
80104c66:	01 c6                	add    %eax,%esi
80104c68:	eb 14                	jmp    80104c7e <strncmp+0x2e>
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c70:	38 da                	cmp    %bl,%dl
80104c72:	75 14                	jne    80104c88 <strncmp+0x38>
    n--, p++, q++;
80104c74:	83 c0 01             	add    $0x1,%eax
80104c77:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104c7a:	39 f0                	cmp    %esi,%eax
80104c7c:	74 1a                	je     80104c98 <strncmp+0x48>
80104c7e:	0f b6 11             	movzbl (%ecx),%edx
80104c81:	0f b6 18             	movzbl (%eax),%ebx
80104c84:	84 d2                	test   %dl,%dl
80104c86:	75 e8                	jne    80104c70 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104c88:	0f b6 c2             	movzbl %dl,%eax
80104c8b:	29 d8                	sub    %ebx,%eax
}
80104c8d:	5b                   	pop    %ebx
80104c8e:	5e                   	pop    %esi
80104c8f:	5d                   	pop    %ebp
80104c90:	c3                   	ret    
80104c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c98:	5b                   	pop    %ebx
    return 0;
80104c99:	31 c0                	xor    %eax,%eax
}
80104c9b:	5e                   	pop    %esi
80104c9c:	5d                   	pop    %ebp
80104c9d:	c3                   	ret    
80104c9e:	66 90                	xchg   %ax,%ax

80104ca0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ca0:	f3 0f 1e fb          	endbr32 
80104ca4:	55                   	push   %ebp
80104ca5:	89 e5                	mov    %esp,%ebp
80104ca7:	57                   	push   %edi
80104ca8:	56                   	push   %esi
80104ca9:	8b 75 08             	mov    0x8(%ebp),%esi
80104cac:	53                   	push   %ebx
80104cad:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104cb0:	89 f2                	mov    %esi,%edx
80104cb2:	eb 1b                	jmp    80104ccf <strncpy+0x2f>
80104cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cb8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104cbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104cbf:	83 c2 01             	add    $0x1,%edx
80104cc2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104cc6:	89 f9                	mov    %edi,%ecx
80104cc8:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ccb:	84 c9                	test   %cl,%cl
80104ccd:	74 09                	je     80104cd8 <strncpy+0x38>
80104ccf:	89 c3                	mov    %eax,%ebx
80104cd1:	83 e8 01             	sub    $0x1,%eax
80104cd4:	85 db                	test   %ebx,%ebx
80104cd6:	7f e0                	jg     80104cb8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104cd8:	89 d1                	mov    %edx,%ecx
80104cda:	85 c0                	test   %eax,%eax
80104cdc:	7e 15                	jle    80104cf3 <strncpy+0x53>
80104cde:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104ce0:	83 c1 01             	add    $0x1,%ecx
80104ce3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104ce7:	89 c8                	mov    %ecx,%eax
80104ce9:	f7 d0                	not    %eax
80104ceb:	01 d0                	add    %edx,%eax
80104ced:	01 d8                	add    %ebx,%eax
80104cef:	85 c0                	test   %eax,%eax
80104cf1:	7f ed                	jg     80104ce0 <strncpy+0x40>
  return os;
}
80104cf3:	5b                   	pop    %ebx
80104cf4:	89 f0                	mov    %esi,%eax
80104cf6:	5e                   	pop    %esi
80104cf7:	5f                   	pop    %edi
80104cf8:	5d                   	pop    %ebp
80104cf9:	c3                   	ret    
80104cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d00:	f3 0f 1e fb          	endbr32 
80104d04:	55                   	push   %ebp
80104d05:	89 e5                	mov    %esp,%ebp
80104d07:	56                   	push   %esi
80104d08:	8b 55 10             	mov    0x10(%ebp),%edx
80104d0b:	8b 75 08             	mov    0x8(%ebp),%esi
80104d0e:	53                   	push   %ebx
80104d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104d12:	85 d2                	test   %edx,%edx
80104d14:	7e 21                	jle    80104d37 <safestrcpy+0x37>
80104d16:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104d1a:	89 f2                	mov    %esi,%edx
80104d1c:	eb 12                	jmp    80104d30 <safestrcpy+0x30>
80104d1e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d20:	0f b6 08             	movzbl (%eax),%ecx
80104d23:	83 c0 01             	add    $0x1,%eax
80104d26:	83 c2 01             	add    $0x1,%edx
80104d29:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d2c:	84 c9                	test   %cl,%cl
80104d2e:	74 04                	je     80104d34 <safestrcpy+0x34>
80104d30:	39 d8                	cmp    %ebx,%eax
80104d32:	75 ec                	jne    80104d20 <safestrcpy+0x20>
    ;
  *s = 0;
80104d34:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104d37:	89 f0                	mov    %esi,%eax
80104d39:	5b                   	pop    %ebx
80104d3a:	5e                   	pop    %esi
80104d3b:	5d                   	pop    %ebp
80104d3c:	c3                   	ret    
80104d3d:	8d 76 00             	lea    0x0(%esi),%esi

80104d40 <strlen>:

int
strlen(const char *s)
{
80104d40:	f3 0f 1e fb          	endbr32 
80104d44:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d45:	31 c0                	xor    %eax,%eax
{
80104d47:	89 e5                	mov    %esp,%ebp
80104d49:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104d4c:	80 3a 00             	cmpb   $0x0,(%edx)
80104d4f:	74 10                	je     80104d61 <strlen+0x21>
80104d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d58:	83 c0 01             	add    $0x1,%eax
80104d5b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d5f:	75 f7                	jne    80104d58 <strlen+0x18>
    ;
  return n;
}
80104d61:	5d                   	pop    %ebp
80104d62:	c3                   	ret    

80104d63 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d63:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d67:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104d6b:	55                   	push   %ebp
  pushl %ebx
80104d6c:	53                   	push   %ebx
  pushl %esi
80104d6d:	56                   	push   %esi
  pushl %edi
80104d6e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104d6f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104d71:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104d73:	5f                   	pop    %edi
  popl %esi
80104d74:	5e                   	pop    %esi
  popl %ebx
80104d75:	5b                   	pop    %ebx
  popl %ebp
80104d76:	5d                   	pop    %ebp
  ret
80104d77:	c3                   	ret    
80104d78:	66 90                	xchg   %ax,%ax
80104d7a:	66 90                	xchg   %ax,%ax
80104d7c:	66 90                	xchg   %ax,%ax
80104d7e:	66 90                	xchg   %ax,%ax

80104d80 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104d80:	f3 0f 1e fb          	endbr32 
80104d84:	55                   	push   %ebp
80104d85:	89 e5                	mov    %esp,%ebp
80104d87:	53                   	push   %ebx
80104d88:	83 ec 04             	sub    $0x4,%esp
80104d8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104d8e:	e8 9d f0 ff ff       	call   80103e30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d93:	8b 00                	mov    (%eax),%eax
80104d95:	39 d8                	cmp    %ebx,%eax
80104d97:	76 17                	jbe    80104db0 <fetchint+0x30>
80104d99:	8d 53 04             	lea    0x4(%ebx),%edx
80104d9c:	39 d0                	cmp    %edx,%eax
80104d9e:	72 10                	jb     80104db0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104da0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104da3:	8b 13                	mov    (%ebx),%edx
80104da5:	89 10                	mov    %edx,(%eax)
  return 0;
80104da7:	31 c0                	xor    %eax,%eax
}
80104da9:	83 c4 04             	add    $0x4,%esp
80104dac:	5b                   	pop    %ebx
80104dad:	5d                   	pop    %ebp
80104dae:	c3                   	ret    
80104daf:	90                   	nop
    return -1;
80104db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104db5:	eb f2                	jmp    80104da9 <fetchint+0x29>
80104db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dbe:	66 90                	xchg   %ax,%ax

80104dc0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104dc0:	f3 0f 1e fb          	endbr32 
80104dc4:	55                   	push   %ebp
80104dc5:	89 e5                	mov    %esp,%ebp
80104dc7:	53                   	push   %ebx
80104dc8:	83 ec 04             	sub    $0x4,%esp
80104dcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104dce:	e8 5d f0 ff ff       	call   80103e30 <myproc>

  if(addr >= curproc->sz)
80104dd3:	39 18                	cmp    %ebx,(%eax)
80104dd5:	76 31                	jbe    80104e08 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dda:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ddc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104dde:	39 d3                	cmp    %edx,%ebx
80104de0:	73 26                	jae    80104e08 <fetchstr+0x48>
80104de2:	89 d8                	mov    %ebx,%eax
80104de4:	eb 11                	jmp    80104df7 <fetchstr+0x37>
80104de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ded:	8d 76 00             	lea    0x0(%esi),%esi
80104df0:	83 c0 01             	add    $0x1,%eax
80104df3:	39 c2                	cmp    %eax,%edx
80104df5:	76 11                	jbe    80104e08 <fetchstr+0x48>
    if(*s == 0)
80104df7:	80 38 00             	cmpb   $0x0,(%eax)
80104dfa:	75 f4                	jne    80104df0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104dfc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104dff:	29 d8                	sub    %ebx,%eax
}
80104e01:	5b                   	pop    %ebx
80104e02:	5d                   	pop    %ebp
80104e03:	c3                   	ret    
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e08:	83 c4 04             	add    $0x4,%esp
    return -1;
80104e0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e10:	5b                   	pop    %ebx
80104e11:	5d                   	pop    %ebp
80104e12:	c3                   	ret    
80104e13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e20:	f3 0f 1e fb          	endbr32 
80104e24:	55                   	push   %ebp
80104e25:	89 e5                	mov    %esp,%ebp
80104e27:	56                   	push   %esi
80104e28:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e29:	e8 02 f0 ff ff       	call   80103e30 <myproc>
80104e2e:	8b 55 08             	mov    0x8(%ebp),%edx
80104e31:	8b 40 18             	mov    0x18(%eax),%eax
80104e34:	8b 40 44             	mov    0x44(%eax),%eax
80104e37:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104e3a:	e8 f1 ef ff ff       	call   80103e30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e3f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e42:	8b 00                	mov    (%eax),%eax
80104e44:	39 c6                	cmp    %eax,%esi
80104e46:	73 18                	jae    80104e60 <argint+0x40>
80104e48:	8d 53 08             	lea    0x8(%ebx),%edx
80104e4b:	39 d0                	cmp    %edx,%eax
80104e4d:	72 11                	jb     80104e60 <argint+0x40>
  *ip = *(int*)(addr);
80104e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e52:	8b 53 04             	mov    0x4(%ebx),%edx
80104e55:	89 10                	mov    %edx,(%eax)
  return 0;
80104e57:	31 c0                	xor    %eax,%eax
}
80104e59:	5b                   	pop    %ebx
80104e5a:	5e                   	pop    %esi
80104e5b:	5d                   	pop    %ebp
80104e5c:	c3                   	ret    
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e65:	eb f2                	jmp    80104e59 <argint+0x39>
80104e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6e:	66 90                	xchg   %ax,%ax

80104e70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e70:	f3 0f 1e fb          	endbr32 
80104e74:	55                   	push   %ebp
80104e75:	89 e5                	mov    %esp,%ebp
80104e77:	56                   	push   %esi
80104e78:	53                   	push   %ebx
80104e79:	83 ec 10             	sub    $0x10,%esp
80104e7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104e7f:	e8 ac ef ff ff       	call   80103e30 <myproc>
 
  if(argint(n, &i) < 0)
80104e84:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104e87:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104e89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e8c:	50                   	push   %eax
80104e8d:	ff 75 08             	pushl  0x8(%ebp)
80104e90:	e8 8b ff ff ff       	call   80104e20 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104e95:	83 c4 10             	add    $0x10,%esp
80104e98:	85 c0                	test   %eax,%eax
80104e9a:	78 24                	js     80104ec0 <argptr+0x50>
80104e9c:	85 db                	test   %ebx,%ebx
80104e9e:	78 20                	js     80104ec0 <argptr+0x50>
80104ea0:	8b 16                	mov    (%esi),%edx
80104ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea5:	39 c2                	cmp    %eax,%edx
80104ea7:	76 17                	jbe    80104ec0 <argptr+0x50>
80104ea9:	01 c3                	add    %eax,%ebx
80104eab:	39 da                	cmp    %ebx,%edx
80104ead:	72 11                	jb     80104ec0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104eaf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104eb2:	89 02                	mov    %eax,(%edx)
  return 0;
80104eb4:	31 c0                	xor    %eax,%eax
}
80104eb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eb9:	5b                   	pop    %ebx
80104eba:	5e                   	pop    %esi
80104ebb:	5d                   	pop    %ebp
80104ebc:	c3                   	ret    
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ec5:	eb ef                	jmp    80104eb6 <argptr+0x46>
80104ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ece:	66 90                	xchg   %ax,%ax

80104ed0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ed0:	f3 0f 1e fb          	endbr32 
80104ed4:	55                   	push   %ebp
80104ed5:	89 e5                	mov    %esp,%ebp
80104ed7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104eda:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104edd:	50                   	push   %eax
80104ede:	ff 75 08             	pushl  0x8(%ebp)
80104ee1:	e8 3a ff ff ff       	call   80104e20 <argint>
80104ee6:	83 c4 10             	add    $0x10,%esp
80104ee9:	85 c0                	test   %eax,%eax
80104eeb:	78 13                	js     80104f00 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104eed:	83 ec 08             	sub    $0x8,%esp
80104ef0:	ff 75 0c             	pushl  0xc(%ebp)
80104ef3:	ff 75 f4             	pushl  -0xc(%ebp)
80104ef6:	e8 c5 fe ff ff       	call   80104dc0 <fetchstr>
80104efb:	83 c4 10             	add    $0x10,%esp
}
80104efe:	c9                   	leave  
80104eff:	c3                   	ret    
80104f00:	c9                   	leave  
    return -1;
80104f01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f06:	c3                   	ret    
80104f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0e:	66 90                	xchg   %ax,%ax

80104f10 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104f10:	f3 0f 1e fb          	endbr32 
80104f14:	55                   	push   %ebp
80104f15:	89 e5                	mov    %esp,%ebp
80104f17:	53                   	push   %ebx
80104f18:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104f1b:	e8 10 ef ff ff       	call   80103e30 <myproc>
80104f20:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f22:	8b 40 18             	mov    0x18(%eax),%eax
80104f25:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f28:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f2b:	83 fa 14             	cmp    $0x14,%edx
80104f2e:	77 20                	ja     80104f50 <syscall+0x40>
80104f30:	8b 14 85 e0 7c 10 80 	mov    -0x7fef8320(,%eax,4),%edx
80104f37:	85 d2                	test   %edx,%edx
80104f39:	74 15                	je     80104f50 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104f3b:	ff d2                	call   *%edx
80104f3d:	89 c2                	mov    %eax,%edx
80104f3f:	8b 43 18             	mov    0x18(%ebx),%eax
80104f42:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f48:	c9                   	leave  
80104f49:	c3                   	ret    
80104f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104f50:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104f51:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104f54:	50                   	push   %eax
80104f55:	ff 73 10             	pushl  0x10(%ebx)
80104f58:	68 bd 7c 10 80       	push   $0x80107cbd
80104f5d:	e8 3e b9 ff ff       	call   801008a0 <cprintf>
    curproc->tf->eax = -1;
80104f62:	8b 43 18             	mov    0x18(%ebx),%eax
80104f65:	83 c4 10             	add    $0x10,%esp
80104f68:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104f6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f72:	c9                   	leave  
80104f73:	c3                   	ret    
80104f74:	66 90                	xchg   %ax,%ax
80104f76:	66 90                	xchg   %ax,%ax
80104f78:	66 90                	xchg   %ax,%ax
80104f7a:	66 90                	xchg   %ax,%ax
80104f7c:	66 90                	xchg   %ax,%ax
80104f7e:	66 90                	xchg   %ax,%ax

80104f80 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	57                   	push   %edi
80104f84:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104f85:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104f88:	53                   	push   %ebx
80104f89:	83 ec 34             	sub    $0x34,%esp
80104f8c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104f8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104f92:	57                   	push   %edi
80104f93:	50                   	push   %eax
{
80104f94:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104f97:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104f9a:	e8 81 d5 ff ff       	call   80102520 <nameiparent>
80104f9f:	83 c4 10             	add    $0x10,%esp
80104fa2:	85 c0                	test   %eax,%eax
80104fa4:	0f 84 46 01 00 00    	je     801050f0 <create+0x170>
    return 0;
  ilock(dp);
80104faa:	83 ec 0c             	sub    $0xc,%esp
80104fad:	89 c3                	mov    %eax,%ebx
80104faf:	50                   	push   %eax
80104fb0:	e8 7b cc ff ff       	call   80101c30 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104fb5:	83 c4 0c             	add    $0xc,%esp
80104fb8:	6a 00                	push   $0x0
80104fba:	57                   	push   %edi
80104fbb:	53                   	push   %ebx
80104fbc:	e8 bf d1 ff ff       	call   80102180 <dirlookup>
80104fc1:	83 c4 10             	add    $0x10,%esp
80104fc4:	89 c6                	mov    %eax,%esi
80104fc6:	85 c0                	test   %eax,%eax
80104fc8:	74 56                	je     80105020 <create+0xa0>
    iunlockput(dp);
80104fca:	83 ec 0c             	sub    $0xc,%esp
80104fcd:	53                   	push   %ebx
80104fce:	e8 fd ce ff ff       	call   80101ed0 <iunlockput>
    ilock(ip);
80104fd3:	89 34 24             	mov    %esi,(%esp)
80104fd6:	e8 55 cc ff ff       	call   80101c30 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104fdb:	83 c4 10             	add    $0x10,%esp
80104fde:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104fe3:	75 1b                	jne    80105000 <create+0x80>
80104fe5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104fea:	75 14                	jne    80105000 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104fec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fef:	89 f0                	mov    %esi,%eax
80104ff1:	5b                   	pop    %ebx
80104ff2:	5e                   	pop    %esi
80104ff3:	5f                   	pop    %edi
80104ff4:	5d                   	pop    %ebp
80104ff5:	c3                   	ret    
80104ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105000:	83 ec 0c             	sub    $0xc,%esp
80105003:	56                   	push   %esi
    return 0;
80105004:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105006:	e8 c5 ce ff ff       	call   80101ed0 <iunlockput>
    return 0;
8010500b:	83 c4 10             	add    $0x10,%esp
}
8010500e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105011:	89 f0                	mov    %esi,%eax
80105013:	5b                   	pop    %ebx
80105014:	5e                   	pop    %esi
80105015:	5f                   	pop    %edi
80105016:	5d                   	pop    %ebp
80105017:	c3                   	ret    
80105018:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105020:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105024:	83 ec 08             	sub    $0x8,%esp
80105027:	50                   	push   %eax
80105028:	ff 33                	pushl  (%ebx)
8010502a:	e8 81 ca ff ff       	call   80101ab0 <ialloc>
8010502f:	83 c4 10             	add    $0x10,%esp
80105032:	89 c6                	mov    %eax,%esi
80105034:	85 c0                	test   %eax,%eax
80105036:	0f 84 cd 00 00 00    	je     80105109 <create+0x189>
  ilock(ip);
8010503c:	83 ec 0c             	sub    $0xc,%esp
8010503f:	50                   	push   %eax
80105040:	e8 eb cb ff ff       	call   80101c30 <ilock>
  ip->major = major;
80105045:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105049:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010504d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105051:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105055:	b8 01 00 00 00       	mov    $0x1,%eax
8010505a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010505e:	89 34 24             	mov    %esi,(%esp)
80105061:	e8 0a cb ff ff       	call   80101b70 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105066:	83 c4 10             	add    $0x10,%esp
80105069:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010506e:	74 30                	je     801050a0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105070:	83 ec 04             	sub    $0x4,%esp
80105073:	ff 76 04             	pushl  0x4(%esi)
80105076:	57                   	push   %edi
80105077:	53                   	push   %ebx
80105078:	e8 c3 d3 ff ff       	call   80102440 <dirlink>
8010507d:	83 c4 10             	add    $0x10,%esp
80105080:	85 c0                	test   %eax,%eax
80105082:	78 78                	js     801050fc <create+0x17c>
  iunlockput(dp);
80105084:	83 ec 0c             	sub    $0xc,%esp
80105087:	53                   	push   %ebx
80105088:	e8 43 ce ff ff       	call   80101ed0 <iunlockput>
  return ip;
8010508d:	83 c4 10             	add    $0x10,%esp
}
80105090:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105093:	89 f0                	mov    %esi,%eax
80105095:	5b                   	pop    %ebx
80105096:	5e                   	pop    %esi
80105097:	5f                   	pop    %edi
80105098:	5d                   	pop    %ebp
80105099:	c3                   	ret    
8010509a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801050a0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801050a3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801050a8:	53                   	push   %ebx
801050a9:	e8 c2 ca ff ff       	call   80101b70 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801050ae:	83 c4 0c             	add    $0xc,%esp
801050b1:	ff 76 04             	pushl  0x4(%esi)
801050b4:	68 54 7d 10 80       	push   $0x80107d54
801050b9:	56                   	push   %esi
801050ba:	e8 81 d3 ff ff       	call   80102440 <dirlink>
801050bf:	83 c4 10             	add    $0x10,%esp
801050c2:	85 c0                	test   %eax,%eax
801050c4:	78 18                	js     801050de <create+0x15e>
801050c6:	83 ec 04             	sub    $0x4,%esp
801050c9:	ff 73 04             	pushl  0x4(%ebx)
801050cc:	68 53 7d 10 80       	push   $0x80107d53
801050d1:	56                   	push   %esi
801050d2:	e8 69 d3 ff ff       	call   80102440 <dirlink>
801050d7:	83 c4 10             	add    $0x10,%esp
801050da:	85 c0                	test   %eax,%eax
801050dc:	79 92                	jns    80105070 <create+0xf0>
      panic("create dots");
801050de:	83 ec 0c             	sub    $0xc,%esp
801050e1:	68 47 7d 10 80       	push   $0x80107d47
801050e6:	e8 a5 b2 ff ff       	call   80100390 <panic>
801050eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050ef:	90                   	nop
}
801050f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801050f3:	31 f6                	xor    %esi,%esi
}
801050f5:	5b                   	pop    %ebx
801050f6:	89 f0                	mov    %esi,%eax
801050f8:	5e                   	pop    %esi
801050f9:	5f                   	pop    %edi
801050fa:	5d                   	pop    %ebp
801050fb:	c3                   	ret    
    panic("create: dirlink");
801050fc:	83 ec 0c             	sub    $0xc,%esp
801050ff:	68 56 7d 10 80       	push   $0x80107d56
80105104:	e8 87 b2 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105109:	83 ec 0c             	sub    $0xc,%esp
8010510c:	68 38 7d 10 80       	push   $0x80107d38
80105111:	e8 7a b2 ff ff       	call   80100390 <panic>
80105116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511d:	8d 76 00             	lea    0x0(%esi),%esi

80105120 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	89 d6                	mov    %edx,%esi
80105126:	53                   	push   %ebx
80105127:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105129:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010512c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010512f:	50                   	push   %eax
80105130:	6a 00                	push   $0x0
80105132:	e8 e9 fc ff ff       	call   80104e20 <argint>
80105137:	83 c4 10             	add    $0x10,%esp
8010513a:	85 c0                	test   %eax,%eax
8010513c:	78 2a                	js     80105168 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010513e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105142:	77 24                	ja     80105168 <argfd.constprop.0+0x48>
80105144:	e8 e7 ec ff ff       	call   80103e30 <myproc>
80105149:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010514c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105150:	85 c0                	test   %eax,%eax
80105152:	74 14                	je     80105168 <argfd.constprop.0+0x48>
  if(pfd)
80105154:	85 db                	test   %ebx,%ebx
80105156:	74 02                	je     8010515a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105158:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010515a:	89 06                	mov    %eax,(%esi)
  return 0;
8010515c:	31 c0                	xor    %eax,%eax
}
8010515e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105161:	5b                   	pop    %ebx
80105162:	5e                   	pop    %esi
80105163:	5d                   	pop    %ebp
80105164:	c3                   	ret    
80105165:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010516d:	eb ef                	jmp    8010515e <argfd.constprop.0+0x3e>
8010516f:	90                   	nop

80105170 <sys_dup>:
{
80105170:	f3 0f 1e fb          	endbr32 
80105174:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105175:	31 c0                	xor    %eax,%eax
{
80105177:	89 e5                	mov    %esp,%ebp
80105179:	56                   	push   %esi
8010517a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010517b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010517e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105181:	e8 9a ff ff ff       	call   80105120 <argfd.constprop.0>
80105186:	85 c0                	test   %eax,%eax
80105188:	78 1e                	js     801051a8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010518a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010518d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010518f:	e8 9c ec ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105198:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010519c:	85 d2                	test   %edx,%edx
8010519e:	74 20                	je     801051c0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801051a0:	83 c3 01             	add    $0x1,%ebx
801051a3:	83 fb 10             	cmp    $0x10,%ebx
801051a6:	75 f0                	jne    80105198 <sys_dup+0x28>
}
801051a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801051ab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801051b0:	89 d8                	mov    %ebx,%eax
801051b2:	5b                   	pop    %ebx
801051b3:	5e                   	pop    %esi
801051b4:	5d                   	pop    %ebp
801051b5:	c3                   	ret    
801051b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051bd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801051c0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801051c4:	83 ec 0c             	sub    $0xc,%esp
801051c7:	ff 75 f4             	pushl  -0xc(%ebp)
801051ca:	e8 71 c1 ff ff       	call   80101340 <filedup>
  return fd;
801051cf:	83 c4 10             	add    $0x10,%esp
}
801051d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051d5:	89 d8                	mov    %ebx,%eax
801051d7:	5b                   	pop    %ebx
801051d8:	5e                   	pop    %esi
801051d9:	5d                   	pop    %ebp
801051da:	c3                   	ret    
801051db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051df:	90                   	nop

801051e0 <sys_read>:
{
801051e0:	f3 0f 1e fb          	endbr32 
801051e4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051e5:	31 c0                	xor    %eax,%eax
{
801051e7:	89 e5                	mov    %esp,%ebp
801051e9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051ec:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051ef:	e8 2c ff ff ff       	call   80105120 <argfd.constprop.0>
801051f4:	85 c0                	test   %eax,%eax
801051f6:	78 48                	js     80105240 <sys_read+0x60>
801051f8:	83 ec 08             	sub    $0x8,%esp
801051fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051fe:	50                   	push   %eax
801051ff:	6a 02                	push   $0x2
80105201:	e8 1a fc ff ff       	call   80104e20 <argint>
80105206:	83 c4 10             	add    $0x10,%esp
80105209:	85 c0                	test   %eax,%eax
8010520b:	78 33                	js     80105240 <sys_read+0x60>
8010520d:	83 ec 04             	sub    $0x4,%esp
80105210:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105213:	ff 75 f0             	pushl  -0x10(%ebp)
80105216:	50                   	push   %eax
80105217:	6a 01                	push   $0x1
80105219:	e8 52 fc ff ff       	call   80104e70 <argptr>
8010521e:	83 c4 10             	add    $0x10,%esp
80105221:	85 c0                	test   %eax,%eax
80105223:	78 1b                	js     80105240 <sys_read+0x60>
  return fileread(f, p, n);
80105225:	83 ec 04             	sub    $0x4,%esp
80105228:	ff 75 f0             	pushl  -0x10(%ebp)
8010522b:	ff 75 f4             	pushl  -0xc(%ebp)
8010522e:	ff 75 ec             	pushl  -0x14(%ebp)
80105231:	e8 8a c2 ff ff       	call   801014c0 <fileread>
80105236:	83 c4 10             	add    $0x10,%esp
}
80105239:	c9                   	leave  
8010523a:	c3                   	ret    
8010523b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010523f:	90                   	nop
80105240:	c9                   	leave  
    return -1;
80105241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105246:	c3                   	ret    
80105247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524e:	66 90                	xchg   %ax,%ax

80105250 <sys_write>:
{
80105250:	f3 0f 1e fb          	endbr32 
80105254:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105255:	31 c0                	xor    %eax,%eax
{
80105257:	89 e5                	mov    %esp,%ebp
80105259:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010525c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010525f:	e8 bc fe ff ff       	call   80105120 <argfd.constprop.0>
80105264:	85 c0                	test   %eax,%eax
80105266:	78 48                	js     801052b0 <sys_write+0x60>
80105268:	83 ec 08             	sub    $0x8,%esp
8010526b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010526e:	50                   	push   %eax
8010526f:	6a 02                	push   $0x2
80105271:	e8 aa fb ff ff       	call   80104e20 <argint>
80105276:	83 c4 10             	add    $0x10,%esp
80105279:	85 c0                	test   %eax,%eax
8010527b:	78 33                	js     801052b0 <sys_write+0x60>
8010527d:	83 ec 04             	sub    $0x4,%esp
80105280:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105283:	ff 75 f0             	pushl  -0x10(%ebp)
80105286:	50                   	push   %eax
80105287:	6a 01                	push   $0x1
80105289:	e8 e2 fb ff ff       	call   80104e70 <argptr>
8010528e:	83 c4 10             	add    $0x10,%esp
80105291:	85 c0                	test   %eax,%eax
80105293:	78 1b                	js     801052b0 <sys_write+0x60>
  return filewrite(f, p, n);
80105295:	83 ec 04             	sub    $0x4,%esp
80105298:	ff 75 f0             	pushl  -0x10(%ebp)
8010529b:	ff 75 f4             	pushl  -0xc(%ebp)
8010529e:	ff 75 ec             	pushl  -0x14(%ebp)
801052a1:	e8 ba c2 ff ff       	call   80101560 <filewrite>
801052a6:	83 c4 10             	add    $0x10,%esp
}
801052a9:	c9                   	leave  
801052aa:	c3                   	ret    
801052ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052af:	90                   	nop
801052b0:	c9                   	leave  
    return -1;
801052b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052b6:	c3                   	ret    
801052b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052be:	66 90                	xchg   %ax,%ax

801052c0 <sys_close>:
{
801052c0:	f3 0f 1e fb          	endbr32 
801052c4:	55                   	push   %ebp
801052c5:	89 e5                	mov    %esp,%ebp
801052c7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801052ca:	8d 55 f4             	lea    -0xc(%ebp),%edx
801052cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052d0:	e8 4b fe ff ff       	call   80105120 <argfd.constprop.0>
801052d5:	85 c0                	test   %eax,%eax
801052d7:	78 27                	js     80105300 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801052d9:	e8 52 eb ff ff       	call   80103e30 <myproc>
801052de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801052e1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801052e4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801052eb:	00 
  fileclose(f);
801052ec:	ff 75 f4             	pushl  -0xc(%ebp)
801052ef:	e8 9c c0 ff ff       	call   80101390 <fileclose>
  return 0;
801052f4:	83 c4 10             	add    $0x10,%esp
801052f7:	31 c0                	xor    %eax,%eax
}
801052f9:	c9                   	leave  
801052fa:	c3                   	ret    
801052fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052ff:	90                   	nop
80105300:	c9                   	leave  
    return -1;
80105301:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105306:	c3                   	ret    
80105307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010530e:	66 90                	xchg   %ax,%ax

80105310 <sys_fstat>:
{
80105310:	f3 0f 1e fb          	endbr32 
80105314:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105315:	31 c0                	xor    %eax,%eax
{
80105317:	89 e5                	mov    %esp,%ebp
80105319:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010531c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010531f:	e8 fc fd ff ff       	call   80105120 <argfd.constprop.0>
80105324:	85 c0                	test   %eax,%eax
80105326:	78 30                	js     80105358 <sys_fstat+0x48>
80105328:	83 ec 04             	sub    $0x4,%esp
8010532b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010532e:	6a 14                	push   $0x14
80105330:	50                   	push   %eax
80105331:	6a 01                	push   $0x1
80105333:	e8 38 fb ff ff       	call   80104e70 <argptr>
80105338:	83 c4 10             	add    $0x10,%esp
8010533b:	85 c0                	test   %eax,%eax
8010533d:	78 19                	js     80105358 <sys_fstat+0x48>
  return filestat(f, st);
8010533f:	83 ec 08             	sub    $0x8,%esp
80105342:	ff 75 f4             	pushl  -0xc(%ebp)
80105345:	ff 75 f0             	pushl  -0x10(%ebp)
80105348:	e8 23 c1 ff ff       	call   80101470 <filestat>
8010534d:	83 c4 10             	add    $0x10,%esp
}
80105350:	c9                   	leave  
80105351:	c3                   	ret    
80105352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105358:	c9                   	leave  
    return -1;
80105359:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010535e:	c3                   	ret    
8010535f:	90                   	nop

80105360 <sys_link>:
{
80105360:	f3 0f 1e fb          	endbr32 
80105364:	55                   	push   %ebp
80105365:	89 e5                	mov    %esp,%ebp
80105367:	57                   	push   %edi
80105368:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105369:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010536c:	53                   	push   %ebx
8010536d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105370:	50                   	push   %eax
80105371:	6a 00                	push   $0x0
80105373:	e8 58 fb ff ff       	call   80104ed0 <argstr>
80105378:	83 c4 10             	add    $0x10,%esp
8010537b:	85 c0                	test   %eax,%eax
8010537d:	0f 88 ff 00 00 00    	js     80105482 <sys_link+0x122>
80105383:	83 ec 08             	sub    $0x8,%esp
80105386:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105389:	50                   	push   %eax
8010538a:	6a 01                	push   $0x1
8010538c:	e8 3f fb ff ff       	call   80104ed0 <argstr>
80105391:	83 c4 10             	add    $0x10,%esp
80105394:	85 c0                	test   %eax,%eax
80105396:	0f 88 e6 00 00 00    	js     80105482 <sys_link+0x122>
  begin_op();
8010539c:	e8 5f de ff ff       	call   80103200 <begin_op>
  if((ip = namei(old)) == 0){
801053a1:	83 ec 0c             	sub    $0xc,%esp
801053a4:	ff 75 d4             	pushl  -0x2c(%ebp)
801053a7:	e8 54 d1 ff ff       	call   80102500 <namei>
801053ac:	83 c4 10             	add    $0x10,%esp
801053af:	89 c3                	mov    %eax,%ebx
801053b1:	85 c0                	test   %eax,%eax
801053b3:	0f 84 e8 00 00 00    	je     801054a1 <sys_link+0x141>
  ilock(ip);
801053b9:	83 ec 0c             	sub    $0xc,%esp
801053bc:	50                   	push   %eax
801053bd:	e8 6e c8 ff ff       	call   80101c30 <ilock>
  if(ip->type == T_DIR){
801053c2:	83 c4 10             	add    $0x10,%esp
801053c5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053ca:	0f 84 b9 00 00 00    	je     80105489 <sys_link+0x129>
  iupdate(ip);
801053d0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801053d3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801053d8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801053db:	53                   	push   %ebx
801053dc:	e8 8f c7 ff ff       	call   80101b70 <iupdate>
  iunlock(ip);
801053e1:	89 1c 24             	mov    %ebx,(%esp)
801053e4:	e8 27 c9 ff ff       	call   80101d10 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801053e9:	58                   	pop    %eax
801053ea:	5a                   	pop    %edx
801053eb:	57                   	push   %edi
801053ec:	ff 75 d0             	pushl  -0x30(%ebp)
801053ef:	e8 2c d1 ff ff       	call   80102520 <nameiparent>
801053f4:	83 c4 10             	add    $0x10,%esp
801053f7:	89 c6                	mov    %eax,%esi
801053f9:	85 c0                	test   %eax,%eax
801053fb:	74 5f                	je     8010545c <sys_link+0xfc>
  ilock(dp);
801053fd:	83 ec 0c             	sub    $0xc,%esp
80105400:	50                   	push   %eax
80105401:	e8 2a c8 ff ff       	call   80101c30 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105406:	8b 03                	mov    (%ebx),%eax
80105408:	83 c4 10             	add    $0x10,%esp
8010540b:	39 06                	cmp    %eax,(%esi)
8010540d:	75 41                	jne    80105450 <sys_link+0xf0>
8010540f:	83 ec 04             	sub    $0x4,%esp
80105412:	ff 73 04             	pushl  0x4(%ebx)
80105415:	57                   	push   %edi
80105416:	56                   	push   %esi
80105417:	e8 24 d0 ff ff       	call   80102440 <dirlink>
8010541c:	83 c4 10             	add    $0x10,%esp
8010541f:	85 c0                	test   %eax,%eax
80105421:	78 2d                	js     80105450 <sys_link+0xf0>
  iunlockput(dp);
80105423:	83 ec 0c             	sub    $0xc,%esp
80105426:	56                   	push   %esi
80105427:	e8 a4 ca ff ff       	call   80101ed0 <iunlockput>
  iput(ip);
8010542c:	89 1c 24             	mov    %ebx,(%esp)
8010542f:	e8 2c c9 ff ff       	call   80101d60 <iput>
  end_op();
80105434:	e8 37 de ff ff       	call   80103270 <end_op>
  return 0;
80105439:	83 c4 10             	add    $0x10,%esp
8010543c:	31 c0                	xor    %eax,%eax
}
8010543e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105441:	5b                   	pop    %ebx
80105442:	5e                   	pop    %esi
80105443:	5f                   	pop    %edi
80105444:	5d                   	pop    %ebp
80105445:	c3                   	ret    
80105446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010544d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105450:	83 ec 0c             	sub    $0xc,%esp
80105453:	56                   	push   %esi
80105454:	e8 77 ca ff ff       	call   80101ed0 <iunlockput>
    goto bad;
80105459:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010545c:	83 ec 0c             	sub    $0xc,%esp
8010545f:	53                   	push   %ebx
80105460:	e8 cb c7 ff ff       	call   80101c30 <ilock>
  ip->nlink--;
80105465:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010546a:	89 1c 24             	mov    %ebx,(%esp)
8010546d:	e8 fe c6 ff ff       	call   80101b70 <iupdate>
  iunlockput(ip);
80105472:	89 1c 24             	mov    %ebx,(%esp)
80105475:	e8 56 ca ff ff       	call   80101ed0 <iunlockput>
  end_op();
8010547a:	e8 f1 dd ff ff       	call   80103270 <end_op>
  return -1;
8010547f:	83 c4 10             	add    $0x10,%esp
80105482:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105487:	eb b5                	jmp    8010543e <sys_link+0xde>
    iunlockput(ip);
80105489:	83 ec 0c             	sub    $0xc,%esp
8010548c:	53                   	push   %ebx
8010548d:	e8 3e ca ff ff       	call   80101ed0 <iunlockput>
    end_op();
80105492:	e8 d9 dd ff ff       	call   80103270 <end_op>
    return -1;
80105497:	83 c4 10             	add    $0x10,%esp
8010549a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549f:	eb 9d                	jmp    8010543e <sys_link+0xde>
    end_op();
801054a1:	e8 ca dd ff ff       	call   80103270 <end_op>
    return -1;
801054a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ab:	eb 91                	jmp    8010543e <sys_link+0xde>
801054ad:	8d 76 00             	lea    0x0(%esi),%esi

801054b0 <sys_unlink>:
{
801054b0:	f3 0f 1e fb          	endbr32 
801054b4:	55                   	push   %ebp
801054b5:	89 e5                	mov    %esp,%ebp
801054b7:	57                   	push   %edi
801054b8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801054b9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801054bc:	53                   	push   %ebx
801054bd:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801054c0:	50                   	push   %eax
801054c1:	6a 00                	push   $0x0
801054c3:	e8 08 fa ff ff       	call   80104ed0 <argstr>
801054c8:	83 c4 10             	add    $0x10,%esp
801054cb:	85 c0                	test   %eax,%eax
801054cd:	0f 88 7d 01 00 00    	js     80105650 <sys_unlink+0x1a0>
  begin_op();
801054d3:	e8 28 dd ff ff       	call   80103200 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801054d8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801054db:	83 ec 08             	sub    $0x8,%esp
801054de:	53                   	push   %ebx
801054df:	ff 75 c0             	pushl  -0x40(%ebp)
801054e2:	e8 39 d0 ff ff       	call   80102520 <nameiparent>
801054e7:	83 c4 10             	add    $0x10,%esp
801054ea:	89 c6                	mov    %eax,%esi
801054ec:	85 c0                	test   %eax,%eax
801054ee:	0f 84 66 01 00 00    	je     8010565a <sys_unlink+0x1aa>
  ilock(dp);
801054f4:	83 ec 0c             	sub    $0xc,%esp
801054f7:	50                   	push   %eax
801054f8:	e8 33 c7 ff ff       	call   80101c30 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801054fd:	58                   	pop    %eax
801054fe:	5a                   	pop    %edx
801054ff:	68 54 7d 10 80       	push   $0x80107d54
80105504:	53                   	push   %ebx
80105505:	e8 56 cc ff ff       	call   80102160 <namecmp>
8010550a:	83 c4 10             	add    $0x10,%esp
8010550d:	85 c0                	test   %eax,%eax
8010550f:	0f 84 03 01 00 00    	je     80105618 <sys_unlink+0x168>
80105515:	83 ec 08             	sub    $0x8,%esp
80105518:	68 53 7d 10 80       	push   $0x80107d53
8010551d:	53                   	push   %ebx
8010551e:	e8 3d cc ff ff       	call   80102160 <namecmp>
80105523:	83 c4 10             	add    $0x10,%esp
80105526:	85 c0                	test   %eax,%eax
80105528:	0f 84 ea 00 00 00    	je     80105618 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010552e:	83 ec 04             	sub    $0x4,%esp
80105531:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105534:	50                   	push   %eax
80105535:	53                   	push   %ebx
80105536:	56                   	push   %esi
80105537:	e8 44 cc ff ff       	call   80102180 <dirlookup>
8010553c:	83 c4 10             	add    $0x10,%esp
8010553f:	89 c3                	mov    %eax,%ebx
80105541:	85 c0                	test   %eax,%eax
80105543:	0f 84 cf 00 00 00    	je     80105618 <sys_unlink+0x168>
  ilock(ip);
80105549:	83 ec 0c             	sub    $0xc,%esp
8010554c:	50                   	push   %eax
8010554d:	e8 de c6 ff ff       	call   80101c30 <ilock>
  if(ip->nlink < 1)
80105552:	83 c4 10             	add    $0x10,%esp
80105555:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010555a:	0f 8e 23 01 00 00    	jle    80105683 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105560:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105565:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105568:	74 66                	je     801055d0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010556a:	83 ec 04             	sub    $0x4,%esp
8010556d:	6a 10                	push   $0x10
8010556f:	6a 00                	push   $0x0
80105571:	57                   	push   %edi
80105572:	e8 c9 f5 ff ff       	call   80104b40 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105577:	6a 10                	push   $0x10
80105579:	ff 75 c4             	pushl  -0x3c(%ebp)
8010557c:	57                   	push   %edi
8010557d:	56                   	push   %esi
8010557e:	e8 ad ca ff ff       	call   80102030 <writei>
80105583:	83 c4 20             	add    $0x20,%esp
80105586:	83 f8 10             	cmp    $0x10,%eax
80105589:	0f 85 e7 00 00 00    	jne    80105676 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010558f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105594:	0f 84 96 00 00 00    	je     80105630 <sys_unlink+0x180>
  iunlockput(dp);
8010559a:	83 ec 0c             	sub    $0xc,%esp
8010559d:	56                   	push   %esi
8010559e:	e8 2d c9 ff ff       	call   80101ed0 <iunlockput>
  ip->nlink--;
801055a3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055a8:	89 1c 24             	mov    %ebx,(%esp)
801055ab:	e8 c0 c5 ff ff       	call   80101b70 <iupdate>
  iunlockput(ip);
801055b0:	89 1c 24             	mov    %ebx,(%esp)
801055b3:	e8 18 c9 ff ff       	call   80101ed0 <iunlockput>
  end_op();
801055b8:	e8 b3 dc ff ff       	call   80103270 <end_op>
  return 0;
801055bd:	83 c4 10             	add    $0x10,%esp
801055c0:	31 c0                	xor    %eax,%eax
}
801055c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055c5:	5b                   	pop    %ebx
801055c6:	5e                   	pop    %esi
801055c7:	5f                   	pop    %edi
801055c8:	5d                   	pop    %ebp
801055c9:	c3                   	ret    
801055ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801055d0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801055d4:	76 94                	jbe    8010556a <sys_unlink+0xba>
801055d6:	ba 20 00 00 00       	mov    $0x20,%edx
801055db:	eb 0b                	jmp    801055e8 <sys_unlink+0x138>
801055dd:	8d 76 00             	lea    0x0(%esi),%esi
801055e0:	83 c2 10             	add    $0x10,%edx
801055e3:	39 53 58             	cmp    %edx,0x58(%ebx)
801055e6:	76 82                	jbe    8010556a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055e8:	6a 10                	push   $0x10
801055ea:	52                   	push   %edx
801055eb:	57                   	push   %edi
801055ec:	53                   	push   %ebx
801055ed:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801055f0:	e8 3b c9 ff ff       	call   80101f30 <readi>
801055f5:	83 c4 10             	add    $0x10,%esp
801055f8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801055fb:	83 f8 10             	cmp    $0x10,%eax
801055fe:	75 69                	jne    80105669 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105600:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105605:	74 d9                	je     801055e0 <sys_unlink+0x130>
    iunlockput(ip);
80105607:	83 ec 0c             	sub    $0xc,%esp
8010560a:	53                   	push   %ebx
8010560b:	e8 c0 c8 ff ff       	call   80101ed0 <iunlockput>
    goto bad;
80105610:	83 c4 10             	add    $0x10,%esp
80105613:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105617:	90                   	nop
  iunlockput(dp);
80105618:	83 ec 0c             	sub    $0xc,%esp
8010561b:	56                   	push   %esi
8010561c:	e8 af c8 ff ff       	call   80101ed0 <iunlockput>
  end_op();
80105621:	e8 4a dc ff ff       	call   80103270 <end_op>
  return -1;
80105626:	83 c4 10             	add    $0x10,%esp
80105629:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010562e:	eb 92                	jmp    801055c2 <sys_unlink+0x112>
    iupdate(dp);
80105630:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105633:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105638:	56                   	push   %esi
80105639:	e8 32 c5 ff ff       	call   80101b70 <iupdate>
8010563e:	83 c4 10             	add    $0x10,%esp
80105641:	e9 54 ff ff ff       	jmp    8010559a <sys_unlink+0xea>
80105646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010564d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105655:	e9 68 ff ff ff       	jmp    801055c2 <sys_unlink+0x112>
    end_op();
8010565a:	e8 11 dc ff ff       	call   80103270 <end_op>
    return -1;
8010565f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105664:	e9 59 ff ff ff       	jmp    801055c2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105669:	83 ec 0c             	sub    $0xc,%esp
8010566c:	68 78 7d 10 80       	push   $0x80107d78
80105671:	e8 1a ad ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105676:	83 ec 0c             	sub    $0xc,%esp
80105679:	68 8a 7d 10 80       	push   $0x80107d8a
8010567e:	e8 0d ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105683:	83 ec 0c             	sub    $0xc,%esp
80105686:	68 66 7d 10 80       	push   $0x80107d66
8010568b:	e8 00 ad ff ff       	call   80100390 <panic>

80105690 <sys_open>:

int
sys_open(void)
{
80105690:	f3 0f 1e fb          	endbr32 
80105694:	55                   	push   %ebp
80105695:	89 e5                	mov    %esp,%ebp
80105697:	57                   	push   %edi
80105698:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105699:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010569c:	53                   	push   %ebx
8010569d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056a0:	50                   	push   %eax
801056a1:	6a 00                	push   $0x0
801056a3:	e8 28 f8 ff ff       	call   80104ed0 <argstr>
801056a8:	83 c4 10             	add    $0x10,%esp
801056ab:	85 c0                	test   %eax,%eax
801056ad:	0f 88 8a 00 00 00    	js     8010573d <sys_open+0xad>
801056b3:	83 ec 08             	sub    $0x8,%esp
801056b6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056b9:	50                   	push   %eax
801056ba:	6a 01                	push   $0x1
801056bc:	e8 5f f7 ff ff       	call   80104e20 <argint>
801056c1:	83 c4 10             	add    $0x10,%esp
801056c4:	85 c0                	test   %eax,%eax
801056c6:	78 75                	js     8010573d <sys_open+0xad>
    return -1;

  begin_op();
801056c8:	e8 33 db ff ff       	call   80103200 <begin_op>

  if(omode & O_CREATE){
801056cd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801056d1:	75 75                	jne    80105748 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801056d3:	83 ec 0c             	sub    $0xc,%esp
801056d6:	ff 75 e0             	pushl  -0x20(%ebp)
801056d9:	e8 22 ce ff ff       	call   80102500 <namei>
801056de:	83 c4 10             	add    $0x10,%esp
801056e1:	89 c6                	mov    %eax,%esi
801056e3:	85 c0                	test   %eax,%eax
801056e5:	74 7e                	je     80105765 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801056e7:	83 ec 0c             	sub    $0xc,%esp
801056ea:	50                   	push   %eax
801056eb:	e8 40 c5 ff ff       	call   80101c30 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801056f0:	83 c4 10             	add    $0x10,%esp
801056f3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801056f8:	0f 84 c2 00 00 00    	je     801057c0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801056fe:	e8 cd bb ff ff       	call   801012d0 <filealloc>
80105703:	89 c7                	mov    %eax,%edi
80105705:	85 c0                	test   %eax,%eax
80105707:	74 23                	je     8010572c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105709:	e8 22 e7 ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010570e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105710:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105714:	85 d2                	test   %edx,%edx
80105716:	74 60                	je     80105778 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105718:	83 c3 01             	add    $0x1,%ebx
8010571b:	83 fb 10             	cmp    $0x10,%ebx
8010571e:	75 f0                	jne    80105710 <sys_open+0x80>
    if(f)
      fileclose(f);
80105720:	83 ec 0c             	sub    $0xc,%esp
80105723:	57                   	push   %edi
80105724:	e8 67 bc ff ff       	call   80101390 <fileclose>
80105729:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010572c:	83 ec 0c             	sub    $0xc,%esp
8010572f:	56                   	push   %esi
80105730:	e8 9b c7 ff ff       	call   80101ed0 <iunlockput>
    end_op();
80105735:	e8 36 db ff ff       	call   80103270 <end_op>
    return -1;
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105742:	eb 6d                	jmp    801057b1 <sys_open+0x121>
80105744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105748:	83 ec 0c             	sub    $0xc,%esp
8010574b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010574e:	31 c9                	xor    %ecx,%ecx
80105750:	ba 02 00 00 00       	mov    $0x2,%edx
80105755:	6a 00                	push   $0x0
80105757:	e8 24 f8 ff ff       	call   80104f80 <create>
    if(ip == 0){
8010575c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010575f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105761:	85 c0                	test   %eax,%eax
80105763:	75 99                	jne    801056fe <sys_open+0x6e>
      end_op();
80105765:	e8 06 db ff ff       	call   80103270 <end_op>
      return -1;
8010576a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010576f:	eb 40                	jmp    801057b1 <sys_open+0x121>
80105771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105778:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010577b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010577f:	56                   	push   %esi
80105780:	e8 8b c5 ff ff       	call   80101d10 <iunlock>
  end_op();
80105785:	e8 e6 da ff ff       	call   80103270 <end_op>

  f->type = FD_INODE;
8010578a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105790:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105793:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105796:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105799:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010579b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801057a2:	f7 d0                	not    %eax
801057a4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057a7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801057aa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057ad:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801057b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b4:	89 d8                	mov    %ebx,%eax
801057b6:	5b                   	pop    %ebx
801057b7:	5e                   	pop    %esi
801057b8:	5f                   	pop    %edi
801057b9:	5d                   	pop    %ebp
801057ba:	c3                   	ret    
801057bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057bf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801057c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801057c3:	85 c9                	test   %ecx,%ecx
801057c5:	0f 84 33 ff ff ff    	je     801056fe <sys_open+0x6e>
801057cb:	e9 5c ff ff ff       	jmp    8010572c <sys_open+0x9c>

801057d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801057d0:	f3 0f 1e fb          	endbr32 
801057d4:	55                   	push   %ebp
801057d5:	89 e5                	mov    %esp,%ebp
801057d7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801057da:	e8 21 da ff ff       	call   80103200 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801057df:	83 ec 08             	sub    $0x8,%esp
801057e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057e5:	50                   	push   %eax
801057e6:	6a 00                	push   $0x0
801057e8:	e8 e3 f6 ff ff       	call   80104ed0 <argstr>
801057ed:	83 c4 10             	add    $0x10,%esp
801057f0:	85 c0                	test   %eax,%eax
801057f2:	78 34                	js     80105828 <sys_mkdir+0x58>
801057f4:	83 ec 0c             	sub    $0xc,%esp
801057f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057fa:	31 c9                	xor    %ecx,%ecx
801057fc:	ba 01 00 00 00       	mov    $0x1,%edx
80105801:	6a 00                	push   $0x0
80105803:	e8 78 f7 ff ff       	call   80104f80 <create>
80105808:	83 c4 10             	add    $0x10,%esp
8010580b:	85 c0                	test   %eax,%eax
8010580d:	74 19                	je     80105828 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010580f:	83 ec 0c             	sub    $0xc,%esp
80105812:	50                   	push   %eax
80105813:	e8 b8 c6 ff ff       	call   80101ed0 <iunlockput>
  end_op();
80105818:	e8 53 da ff ff       	call   80103270 <end_op>
  return 0;
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	31 c0                	xor    %eax,%eax
}
80105822:	c9                   	leave  
80105823:	c3                   	ret    
80105824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105828:	e8 43 da ff ff       	call   80103270 <end_op>
    return -1;
8010582d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105832:	c9                   	leave  
80105833:	c3                   	ret    
80105834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010583f:	90                   	nop

80105840 <sys_mknod>:

int
sys_mknod(void)
{
80105840:	f3 0f 1e fb          	endbr32 
80105844:	55                   	push   %ebp
80105845:	89 e5                	mov    %esp,%ebp
80105847:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010584a:	e8 b1 d9 ff ff       	call   80103200 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010584f:	83 ec 08             	sub    $0x8,%esp
80105852:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105855:	50                   	push   %eax
80105856:	6a 00                	push   $0x0
80105858:	e8 73 f6 ff ff       	call   80104ed0 <argstr>
8010585d:	83 c4 10             	add    $0x10,%esp
80105860:	85 c0                	test   %eax,%eax
80105862:	78 64                	js     801058c8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105864:	83 ec 08             	sub    $0x8,%esp
80105867:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010586a:	50                   	push   %eax
8010586b:	6a 01                	push   $0x1
8010586d:	e8 ae f5 ff ff       	call   80104e20 <argint>
  if((argstr(0, &path)) < 0 ||
80105872:	83 c4 10             	add    $0x10,%esp
80105875:	85 c0                	test   %eax,%eax
80105877:	78 4f                	js     801058c8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105879:	83 ec 08             	sub    $0x8,%esp
8010587c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010587f:	50                   	push   %eax
80105880:	6a 02                	push   $0x2
80105882:	e8 99 f5 ff ff       	call   80104e20 <argint>
     argint(1, &major) < 0 ||
80105887:	83 c4 10             	add    $0x10,%esp
8010588a:	85 c0                	test   %eax,%eax
8010588c:	78 3a                	js     801058c8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010588e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105892:	83 ec 0c             	sub    $0xc,%esp
80105895:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105899:	ba 03 00 00 00       	mov    $0x3,%edx
8010589e:	50                   	push   %eax
8010589f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801058a2:	e8 d9 f6 ff ff       	call   80104f80 <create>
     argint(2, &minor) < 0 ||
801058a7:	83 c4 10             	add    $0x10,%esp
801058aa:	85 c0                	test   %eax,%eax
801058ac:	74 1a                	je     801058c8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
801058ae:	83 ec 0c             	sub    $0xc,%esp
801058b1:	50                   	push   %eax
801058b2:	e8 19 c6 ff ff       	call   80101ed0 <iunlockput>
  end_op();
801058b7:	e8 b4 d9 ff ff       	call   80103270 <end_op>
  return 0;
801058bc:	83 c4 10             	add    $0x10,%esp
801058bf:	31 c0                	xor    %eax,%eax
}
801058c1:	c9                   	leave  
801058c2:	c3                   	ret    
801058c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058c7:	90                   	nop
    end_op();
801058c8:	e8 a3 d9 ff ff       	call   80103270 <end_op>
    return -1;
801058cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058d2:	c9                   	leave  
801058d3:	c3                   	ret    
801058d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058df:	90                   	nop

801058e0 <sys_chdir>:

int
sys_chdir(void)
{
801058e0:	f3 0f 1e fb          	endbr32 
801058e4:	55                   	push   %ebp
801058e5:	89 e5                	mov    %esp,%ebp
801058e7:	56                   	push   %esi
801058e8:	53                   	push   %ebx
801058e9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801058ec:	e8 3f e5 ff ff       	call   80103e30 <myproc>
801058f1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801058f3:	e8 08 d9 ff ff       	call   80103200 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801058f8:	83 ec 08             	sub    $0x8,%esp
801058fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058fe:	50                   	push   %eax
801058ff:	6a 00                	push   $0x0
80105901:	e8 ca f5 ff ff       	call   80104ed0 <argstr>
80105906:	83 c4 10             	add    $0x10,%esp
80105909:	85 c0                	test   %eax,%eax
8010590b:	78 73                	js     80105980 <sys_chdir+0xa0>
8010590d:	83 ec 0c             	sub    $0xc,%esp
80105910:	ff 75 f4             	pushl  -0xc(%ebp)
80105913:	e8 e8 cb ff ff       	call   80102500 <namei>
80105918:	83 c4 10             	add    $0x10,%esp
8010591b:	89 c3                	mov    %eax,%ebx
8010591d:	85 c0                	test   %eax,%eax
8010591f:	74 5f                	je     80105980 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105921:	83 ec 0c             	sub    $0xc,%esp
80105924:	50                   	push   %eax
80105925:	e8 06 c3 ff ff       	call   80101c30 <ilock>
  if(ip->type != T_DIR){
8010592a:	83 c4 10             	add    $0x10,%esp
8010592d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105932:	75 2c                	jne    80105960 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105934:	83 ec 0c             	sub    $0xc,%esp
80105937:	53                   	push   %ebx
80105938:	e8 d3 c3 ff ff       	call   80101d10 <iunlock>
  iput(curproc->cwd);
8010593d:	58                   	pop    %eax
8010593e:	ff 76 68             	pushl  0x68(%esi)
80105941:	e8 1a c4 ff ff       	call   80101d60 <iput>
  end_op();
80105946:	e8 25 d9 ff ff       	call   80103270 <end_op>
  curproc->cwd = ip;
8010594b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010594e:	83 c4 10             	add    $0x10,%esp
80105951:	31 c0                	xor    %eax,%eax
}
80105953:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105956:	5b                   	pop    %ebx
80105957:	5e                   	pop    %esi
80105958:	5d                   	pop    %ebp
80105959:	c3                   	ret    
8010595a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	53                   	push   %ebx
80105964:	e8 67 c5 ff ff       	call   80101ed0 <iunlockput>
    end_op();
80105969:	e8 02 d9 ff ff       	call   80103270 <end_op>
    return -1;
8010596e:	83 c4 10             	add    $0x10,%esp
80105971:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105976:	eb db                	jmp    80105953 <sys_chdir+0x73>
80105978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010597f:	90                   	nop
    end_op();
80105980:	e8 eb d8 ff ff       	call   80103270 <end_op>
    return -1;
80105985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010598a:	eb c7                	jmp    80105953 <sys_chdir+0x73>
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105990 <sys_exec>:

int
sys_exec(void)
{
80105990:	f3 0f 1e fb          	endbr32 
80105994:	55                   	push   %ebp
80105995:	89 e5                	mov    %esp,%ebp
80105997:	57                   	push   %edi
80105998:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105999:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010599f:	53                   	push   %ebx
801059a0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059a6:	50                   	push   %eax
801059a7:	6a 00                	push   $0x0
801059a9:	e8 22 f5 ff ff       	call   80104ed0 <argstr>
801059ae:	83 c4 10             	add    $0x10,%esp
801059b1:	85 c0                	test   %eax,%eax
801059b3:	0f 88 8b 00 00 00    	js     80105a44 <sys_exec+0xb4>
801059b9:	83 ec 08             	sub    $0x8,%esp
801059bc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801059c2:	50                   	push   %eax
801059c3:	6a 01                	push   $0x1
801059c5:	e8 56 f4 ff ff       	call   80104e20 <argint>
801059ca:	83 c4 10             	add    $0x10,%esp
801059cd:	85 c0                	test   %eax,%eax
801059cf:	78 73                	js     80105a44 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801059d1:	83 ec 04             	sub    $0x4,%esp
801059d4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801059da:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801059dc:	68 80 00 00 00       	push   $0x80
801059e1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801059e7:	6a 00                	push   $0x0
801059e9:	50                   	push   %eax
801059ea:	e8 51 f1 ff ff       	call   80104b40 <memset>
801059ef:	83 c4 10             	add    $0x10,%esp
801059f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801059f8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801059fe:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105a05:	83 ec 08             	sub    $0x8,%esp
80105a08:	57                   	push   %edi
80105a09:	01 f0                	add    %esi,%eax
80105a0b:	50                   	push   %eax
80105a0c:	e8 6f f3 ff ff       	call   80104d80 <fetchint>
80105a11:	83 c4 10             	add    $0x10,%esp
80105a14:	85 c0                	test   %eax,%eax
80105a16:	78 2c                	js     80105a44 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105a18:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a1e:	85 c0                	test   %eax,%eax
80105a20:	74 36                	je     80105a58 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a22:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105a28:	83 ec 08             	sub    $0x8,%esp
80105a2b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105a2e:	52                   	push   %edx
80105a2f:	50                   	push   %eax
80105a30:	e8 8b f3 ff ff       	call   80104dc0 <fetchstr>
80105a35:	83 c4 10             	add    $0x10,%esp
80105a38:	85 c0                	test   %eax,%eax
80105a3a:	78 08                	js     80105a44 <sys_exec+0xb4>
  for(i=0;; i++){
80105a3c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105a3f:	83 fb 20             	cmp    $0x20,%ebx
80105a42:	75 b4                	jne    801059f8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105a44:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105a47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a4c:	5b                   	pop    %ebx
80105a4d:	5e                   	pop    %esi
80105a4e:	5f                   	pop    %edi
80105a4f:	5d                   	pop    %ebp
80105a50:	c3                   	ret    
80105a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105a58:	83 ec 08             	sub    $0x8,%esp
80105a5b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105a61:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105a68:	00 00 00 00 
  return exec(path, argv);
80105a6c:	50                   	push   %eax
80105a6d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105a73:	e8 d8 b4 ff ff       	call   80100f50 <exec>
80105a78:	83 c4 10             	add    $0x10,%esp
}
80105a7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a7e:	5b                   	pop    %ebx
80105a7f:	5e                   	pop    %esi
80105a80:	5f                   	pop    %edi
80105a81:	5d                   	pop    %ebp
80105a82:	c3                   	ret    
80105a83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a90 <sys_pipe>:

int
sys_pipe(void)
{
80105a90:	f3 0f 1e fb          	endbr32 
80105a94:	55                   	push   %ebp
80105a95:	89 e5                	mov    %esp,%ebp
80105a97:	57                   	push   %edi
80105a98:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a99:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105a9c:	53                   	push   %ebx
80105a9d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105aa0:	6a 08                	push   $0x8
80105aa2:	50                   	push   %eax
80105aa3:	6a 00                	push   $0x0
80105aa5:	e8 c6 f3 ff ff       	call   80104e70 <argptr>
80105aaa:	83 c4 10             	add    $0x10,%esp
80105aad:	85 c0                	test   %eax,%eax
80105aaf:	78 4e                	js     80105aff <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ab1:	83 ec 08             	sub    $0x8,%esp
80105ab4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ab7:	50                   	push   %eax
80105ab8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105abb:	50                   	push   %eax
80105abc:	e8 ff dd ff ff       	call   801038c0 <pipealloc>
80105ac1:	83 c4 10             	add    $0x10,%esp
80105ac4:	85 c0                	test   %eax,%eax
80105ac6:	78 37                	js     80105aff <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ac8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105acb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105acd:	e8 5e e3 ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105ad8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105adc:	85 f6                	test   %esi,%esi
80105ade:	74 30                	je     80105b10 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105ae0:	83 c3 01             	add    $0x1,%ebx
80105ae3:	83 fb 10             	cmp    $0x10,%ebx
80105ae6:	75 f0                	jne    80105ad8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105ae8:	83 ec 0c             	sub    $0xc,%esp
80105aeb:	ff 75 e0             	pushl  -0x20(%ebp)
80105aee:	e8 9d b8 ff ff       	call   80101390 <fileclose>
    fileclose(wf);
80105af3:	58                   	pop    %eax
80105af4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105af7:	e8 94 b8 ff ff       	call   80101390 <fileclose>
    return -1;
80105afc:	83 c4 10             	add    $0x10,%esp
80105aff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b04:	eb 5b                	jmp    80105b61 <sys_pipe+0xd1>
80105b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105b10:	8d 73 08             	lea    0x8(%ebx),%esi
80105b13:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105b1a:	e8 11 e3 ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b1f:	31 d2                	xor    %edx,%edx
80105b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105b28:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105b2c:	85 c9                	test   %ecx,%ecx
80105b2e:	74 20                	je     80105b50 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105b30:	83 c2 01             	add    $0x1,%edx
80105b33:	83 fa 10             	cmp    $0x10,%edx
80105b36:	75 f0                	jne    80105b28 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105b38:	e8 f3 e2 ff ff       	call   80103e30 <myproc>
80105b3d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105b44:	00 
80105b45:	eb a1                	jmp    80105ae8 <sys_pipe+0x58>
80105b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b4e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105b50:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105b54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b57:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105b59:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b5c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105b5f:	31 c0                	xor    %eax,%eax
}
80105b61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b64:	5b                   	pop    %ebx
80105b65:	5e                   	pop    %esi
80105b66:	5f                   	pop    %edi
80105b67:	5d                   	pop    %ebp
80105b68:	c3                   	ret    
80105b69:	66 90                	xchg   %ax,%ax
80105b6b:	66 90                	xchg   %ax,%ax
80105b6d:	66 90                	xchg   %ax,%ax
80105b6f:	90                   	nop

80105b70 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105b70:	f3 0f 1e fb          	endbr32 
  return fork();
80105b74:	e9 67 e4 ff ff       	jmp    80103fe0 <fork>
80105b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b80 <sys_exit>:
}

int
sys_exit(void)
{
80105b80:	f3 0f 1e fb          	endbr32 
80105b84:	55                   	push   %ebp
80105b85:	89 e5                	mov    %esp,%ebp
80105b87:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b8a:	e8 d1 e6 ff ff       	call   80104260 <exit>
  return 0;  // not reached
}
80105b8f:	31 c0                	xor    %eax,%eax
80105b91:	c9                   	leave  
80105b92:	c3                   	ret    
80105b93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ba0 <sys_wait>:

int
sys_wait(void)
{
80105ba0:	f3 0f 1e fb          	endbr32 
  return wait();
80105ba4:	e9 07 e9 ff ff       	jmp    801044b0 <wait>
80105ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bb0 <sys_kill>:
}

int
sys_kill(void)
{
80105bb0:	f3 0f 1e fb          	endbr32 
80105bb4:	55                   	push   %ebp
80105bb5:	89 e5                	mov    %esp,%ebp
80105bb7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105bba:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bbd:	50                   	push   %eax
80105bbe:	6a 00                	push   $0x0
80105bc0:	e8 5b f2 ff ff       	call   80104e20 <argint>
80105bc5:	83 c4 10             	add    $0x10,%esp
80105bc8:	85 c0                	test   %eax,%eax
80105bca:	78 14                	js     80105be0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105bcc:	83 ec 0c             	sub    $0xc,%esp
80105bcf:	ff 75 f4             	pushl  -0xc(%ebp)
80105bd2:	e8 39 ea ff ff       	call   80104610 <kill>
80105bd7:	83 c4 10             	add    $0x10,%esp
}
80105bda:	c9                   	leave  
80105bdb:	c3                   	ret    
80105bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105be0:	c9                   	leave  
    return -1;
80105be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105be6:	c3                   	ret    
80105be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bee:	66 90                	xchg   %ax,%ax

80105bf0 <sys_getpid>:

int
sys_getpid(void)
{
80105bf0:	f3 0f 1e fb          	endbr32 
80105bf4:	55                   	push   %ebp
80105bf5:	89 e5                	mov    %esp,%ebp
80105bf7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105bfa:	e8 31 e2 ff ff       	call   80103e30 <myproc>
80105bff:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c02:	c9                   	leave  
80105c03:	c3                   	ret    
80105c04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c0f:	90                   	nop

80105c10 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c10:	f3 0f 1e fb          	endbr32 
80105c14:	55                   	push   %ebp
80105c15:	89 e5                	mov    %esp,%ebp
80105c17:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c18:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c1b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c1e:	50                   	push   %eax
80105c1f:	6a 00                	push   $0x0
80105c21:	e8 fa f1 ff ff       	call   80104e20 <argint>
80105c26:	83 c4 10             	add    $0x10,%esp
80105c29:	85 c0                	test   %eax,%eax
80105c2b:	78 23                	js     80105c50 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c2d:	e8 fe e1 ff ff       	call   80103e30 <myproc>
  if(growproc(n) < 0)
80105c32:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105c35:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c37:	ff 75 f4             	pushl  -0xc(%ebp)
80105c3a:	e8 21 e3 ff ff       	call   80103f60 <growproc>
80105c3f:	83 c4 10             	add    $0x10,%esp
80105c42:	85 c0                	test   %eax,%eax
80105c44:	78 0a                	js     80105c50 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105c46:	89 d8                	mov    %ebx,%eax
80105c48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c4b:	c9                   	leave  
80105c4c:	c3                   	ret    
80105c4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c50:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c55:	eb ef                	jmp    80105c46 <sys_sbrk+0x36>
80105c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c5e:	66 90                	xchg   %ax,%ax

80105c60 <sys_sleep>:

int
sys_sleep(void)
{
80105c60:	f3 0f 1e fb          	endbr32 
80105c64:	55                   	push   %ebp
80105c65:	89 e5                	mov    %esp,%ebp
80105c67:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c68:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c6b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c6e:	50                   	push   %eax
80105c6f:	6a 00                	push   $0x0
80105c71:	e8 aa f1 ff ff       	call   80104e20 <argint>
80105c76:	83 c4 10             	add    $0x10,%esp
80105c79:	85 c0                	test   %eax,%eax
80105c7b:	0f 88 86 00 00 00    	js     80105d07 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105c81:	83 ec 0c             	sub    $0xc,%esp
80105c84:	68 00 52 11 80       	push   $0x80115200
80105c89:	e8 a2 ed ff ff       	call   80104a30 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105c91:	8b 1d 40 5a 11 80    	mov    0x80115a40,%ebx
  while(ticks - ticks0 < n){
80105c97:	83 c4 10             	add    $0x10,%esp
80105c9a:	85 d2                	test   %edx,%edx
80105c9c:	75 23                	jne    80105cc1 <sys_sleep+0x61>
80105c9e:	eb 50                	jmp    80105cf0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ca0:	83 ec 08             	sub    $0x8,%esp
80105ca3:	68 00 52 11 80       	push   $0x80115200
80105ca8:	68 40 5a 11 80       	push   $0x80115a40
80105cad:	e8 3e e7 ff ff       	call   801043f0 <sleep>
  while(ticks - ticks0 < n){
80105cb2:	a1 40 5a 11 80       	mov    0x80115a40,%eax
80105cb7:	83 c4 10             	add    $0x10,%esp
80105cba:	29 d8                	sub    %ebx,%eax
80105cbc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105cbf:	73 2f                	jae    80105cf0 <sys_sleep+0x90>
    if(myproc()->killed){
80105cc1:	e8 6a e1 ff ff       	call   80103e30 <myproc>
80105cc6:	8b 40 24             	mov    0x24(%eax),%eax
80105cc9:	85 c0                	test   %eax,%eax
80105ccb:	74 d3                	je     80105ca0 <sys_sleep+0x40>
      release(&tickslock);
80105ccd:	83 ec 0c             	sub    $0xc,%esp
80105cd0:	68 00 52 11 80       	push   $0x80115200
80105cd5:	e8 16 ee ff ff       	call   80104af0 <release>
  }
  release(&tickslock);
  return 0;
}
80105cda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105cdd:	83 c4 10             	add    $0x10,%esp
80105ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ce5:	c9                   	leave  
80105ce6:	c3                   	ret    
80105ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cee:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105cf0:	83 ec 0c             	sub    $0xc,%esp
80105cf3:	68 00 52 11 80       	push   $0x80115200
80105cf8:	e8 f3 ed ff ff       	call   80104af0 <release>
  return 0;
80105cfd:	83 c4 10             	add    $0x10,%esp
80105d00:	31 c0                	xor    %eax,%eax
}
80105d02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d05:	c9                   	leave  
80105d06:	c3                   	ret    
    return -1;
80105d07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0c:	eb f4                	jmp    80105d02 <sys_sleep+0xa2>
80105d0e:	66 90                	xchg   %ax,%ax

80105d10 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d10:	f3 0f 1e fb          	endbr32 
80105d14:	55                   	push   %ebp
80105d15:	89 e5                	mov    %esp,%ebp
80105d17:	53                   	push   %ebx
80105d18:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d1b:	68 00 52 11 80       	push   $0x80115200
80105d20:	e8 0b ed ff ff       	call   80104a30 <acquire>
  xticks = ticks;
80105d25:	8b 1d 40 5a 11 80    	mov    0x80115a40,%ebx
  release(&tickslock);
80105d2b:	c7 04 24 00 52 11 80 	movl   $0x80115200,(%esp)
80105d32:	e8 b9 ed ff ff       	call   80104af0 <release>
  return xticks;
}
80105d37:	89 d8                	mov    %ebx,%eax
80105d39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d3c:	c9                   	leave  
80105d3d:	c3                   	ret    

80105d3e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d3e:	1e                   	push   %ds
  pushl %es
80105d3f:	06                   	push   %es
  pushl %fs
80105d40:	0f a0                	push   %fs
  pushl %gs
80105d42:	0f a8                	push   %gs
  pushal
80105d44:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d45:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d49:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d4b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d4d:	54                   	push   %esp
  call trap
80105d4e:	e8 cd 00 00 00       	call   80105e20 <trap>
  addl $4, %esp
80105d53:	83 c4 04             	add    $0x4,%esp

80105d56 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d56:	61                   	popa   
  popl %gs
80105d57:	0f a9                	pop    %gs
  popl %fs
80105d59:	0f a1                	pop    %fs
  popl %es
80105d5b:	07                   	pop    %es
  popl %ds
80105d5c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d5d:	83 c4 08             	add    $0x8,%esp
  iret
80105d60:	cf                   	iret   
80105d61:	66 90                	xchg   %ax,%ax
80105d63:	66 90                	xchg   %ax,%ax
80105d65:	66 90                	xchg   %ax,%ax
80105d67:	66 90                	xchg   %ax,%ax
80105d69:	66 90                	xchg   %ax,%ax
80105d6b:	66 90                	xchg   %ax,%ax
80105d6d:	66 90                	xchg   %ax,%ax
80105d6f:	90                   	nop

80105d70 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d70:	f3 0f 1e fb          	endbr32 
80105d74:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d75:	31 c0                	xor    %eax,%eax
{
80105d77:	89 e5                	mov    %esp,%ebp
80105d79:	83 ec 08             	sub    $0x8,%esp
80105d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d80:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105d87:	c7 04 c5 42 52 11 80 	movl   $0x8e000008,-0x7feeadbe(,%eax,8)
80105d8e:	08 00 00 8e 
80105d92:	66 89 14 c5 40 52 11 	mov    %dx,-0x7feeadc0(,%eax,8)
80105d99:	80 
80105d9a:	c1 ea 10             	shr    $0x10,%edx
80105d9d:	66 89 14 c5 46 52 11 	mov    %dx,-0x7feeadba(,%eax,8)
80105da4:	80 
  for(i = 0; i < 256; i++)
80105da5:	83 c0 01             	add    $0x1,%eax
80105da8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105dad:	75 d1                	jne    80105d80 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105daf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105db2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105db7:	c7 05 42 54 11 80 08 	movl   $0xef000008,0x80115442
80105dbe:	00 00 ef 
  initlock(&tickslock, "time");
80105dc1:	68 99 7d 10 80       	push   $0x80107d99
80105dc6:	68 00 52 11 80       	push   $0x80115200
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105dcb:	66 a3 40 54 11 80    	mov    %ax,0x80115440
80105dd1:	c1 e8 10             	shr    $0x10,%eax
80105dd4:	66 a3 46 54 11 80    	mov    %ax,0x80115446
  initlock(&tickslock, "time");
80105dda:	e8 d1 ea ff ff       	call   801048b0 <initlock>
}
80105ddf:	83 c4 10             	add    $0x10,%esp
80105de2:	c9                   	leave  
80105de3:	c3                   	ret    
80105de4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105def:	90                   	nop

80105df0 <idtinit>:

void
idtinit(void)
{
80105df0:	f3 0f 1e fb          	endbr32 
80105df4:	55                   	push   %ebp
  pd[0] = size-1;
80105df5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105dfa:	89 e5                	mov    %esp,%ebp
80105dfc:	83 ec 10             	sub    $0x10,%esp
80105dff:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e03:	b8 40 52 11 80       	mov    $0x80115240,%eax
80105e08:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e0c:	c1 e8 10             	shr    $0x10,%eax
80105e0f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105e13:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e16:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105e19:	c9                   	leave  
80105e1a:	c3                   	ret    
80105e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e1f:	90                   	nop

80105e20 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105e20:	f3 0f 1e fb          	endbr32 
80105e24:	55                   	push   %ebp
80105e25:	89 e5                	mov    %esp,%ebp
80105e27:	57                   	push   %edi
80105e28:	56                   	push   %esi
80105e29:	53                   	push   %ebx
80105e2a:	83 ec 1c             	sub    $0x1c,%esp
80105e2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105e30:	8b 43 30             	mov    0x30(%ebx),%eax
80105e33:	83 f8 40             	cmp    $0x40,%eax
80105e36:	0f 84 bc 01 00 00    	je     80105ff8 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e3c:	83 e8 20             	sub    $0x20,%eax
80105e3f:	83 f8 1f             	cmp    $0x1f,%eax
80105e42:	77 08                	ja     80105e4c <trap+0x2c>
80105e44:	3e ff 24 85 40 7e 10 	notrack jmp *-0x7fef81c0(,%eax,4)
80105e4b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e4c:	e8 df df ff ff       	call   80103e30 <myproc>
80105e51:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e54:	85 c0                	test   %eax,%eax
80105e56:	0f 84 eb 01 00 00    	je     80106047 <trap+0x227>
80105e5c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105e60:	0f 84 e1 01 00 00    	je     80106047 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e66:	0f 20 d1             	mov    %cr2,%ecx
80105e69:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e6c:	e8 9f df ff ff       	call   80103e10 <cpuid>
80105e71:	8b 73 30             	mov    0x30(%ebx),%esi
80105e74:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e77:	8b 43 34             	mov    0x34(%ebx),%eax
80105e7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105e7d:	e8 ae df ff ff       	call   80103e30 <myproc>
80105e82:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105e85:	e8 a6 df ff ff       	call   80103e30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e8a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e90:	51                   	push   %ecx
80105e91:	57                   	push   %edi
80105e92:	52                   	push   %edx
80105e93:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e96:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105e97:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105e9a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e9d:	56                   	push   %esi
80105e9e:	ff 70 10             	pushl  0x10(%eax)
80105ea1:	68 fc 7d 10 80       	push   $0x80107dfc
80105ea6:	e8 f5 a9 ff ff       	call   801008a0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105eab:	83 c4 20             	add    $0x20,%esp
80105eae:	e8 7d df ff ff       	call   80103e30 <myproc>
80105eb3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eba:	e8 71 df ff ff       	call   80103e30 <myproc>
80105ebf:	85 c0                	test   %eax,%eax
80105ec1:	74 1d                	je     80105ee0 <trap+0xc0>
80105ec3:	e8 68 df ff ff       	call   80103e30 <myproc>
80105ec8:	8b 50 24             	mov    0x24(%eax),%edx
80105ecb:	85 d2                	test   %edx,%edx
80105ecd:	74 11                	je     80105ee0 <trap+0xc0>
80105ecf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ed3:	83 e0 03             	and    $0x3,%eax
80105ed6:	66 83 f8 03          	cmp    $0x3,%ax
80105eda:	0f 84 50 01 00 00    	je     80106030 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ee0:	e8 4b df ff ff       	call   80103e30 <myproc>
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	74 0f                	je     80105ef8 <trap+0xd8>
80105ee9:	e8 42 df ff ff       	call   80103e30 <myproc>
80105eee:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ef2:	0f 84 e8 00 00 00    	je     80105fe0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ef8:	e8 33 df ff ff       	call   80103e30 <myproc>
80105efd:	85 c0                	test   %eax,%eax
80105eff:	74 1d                	je     80105f1e <trap+0xfe>
80105f01:	e8 2a df ff ff       	call   80103e30 <myproc>
80105f06:	8b 40 24             	mov    0x24(%eax),%eax
80105f09:	85 c0                	test   %eax,%eax
80105f0b:	74 11                	je     80105f1e <trap+0xfe>
80105f0d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105f11:	83 e0 03             	and    $0x3,%eax
80105f14:	66 83 f8 03          	cmp    $0x3,%ax
80105f18:	0f 84 03 01 00 00    	je     80106021 <trap+0x201>
    exit();
}
80105f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f21:	5b                   	pop    %ebx
80105f22:	5e                   	pop    %esi
80105f23:	5f                   	pop    %edi
80105f24:	5d                   	pop    %ebp
80105f25:	c3                   	ret    
    ideintr();
80105f26:	e8 85 c7 ff ff       	call   801026b0 <ideintr>
    lapiceoi();
80105f2b:	e8 60 ce ff ff       	call   80102d90 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f30:	e8 fb de ff ff       	call   80103e30 <myproc>
80105f35:	85 c0                	test   %eax,%eax
80105f37:	75 8a                	jne    80105ec3 <trap+0xa3>
80105f39:	eb a5                	jmp    80105ee0 <trap+0xc0>
    if(cpuid() == 0){
80105f3b:	e8 d0 de ff ff       	call   80103e10 <cpuid>
80105f40:	85 c0                	test   %eax,%eax
80105f42:	75 e7                	jne    80105f2b <trap+0x10b>
      acquire(&tickslock);
80105f44:	83 ec 0c             	sub    $0xc,%esp
80105f47:	68 00 52 11 80       	push   $0x80115200
80105f4c:	e8 df ea ff ff       	call   80104a30 <acquire>
      wakeup(&ticks);
80105f51:	c7 04 24 40 5a 11 80 	movl   $0x80115a40,(%esp)
      ticks++;
80105f58:	83 05 40 5a 11 80 01 	addl   $0x1,0x80115a40
      wakeup(&ticks);
80105f5f:	e8 4c e6 ff ff       	call   801045b0 <wakeup>
      release(&tickslock);
80105f64:	c7 04 24 00 52 11 80 	movl   $0x80115200,(%esp)
80105f6b:	e8 80 eb ff ff       	call   80104af0 <release>
80105f70:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105f73:	eb b6                	jmp    80105f2b <trap+0x10b>
    kbdintr();
80105f75:	e8 d6 cc ff ff       	call   80102c50 <kbdintr>
    lapiceoi();
80105f7a:	e8 11 ce ff ff       	call   80102d90 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f7f:	e8 ac de ff ff       	call   80103e30 <myproc>
80105f84:	85 c0                	test   %eax,%eax
80105f86:	0f 85 37 ff ff ff    	jne    80105ec3 <trap+0xa3>
80105f8c:	e9 4f ff ff ff       	jmp    80105ee0 <trap+0xc0>
    uartintr();
80105f91:	e8 4a 02 00 00       	call   801061e0 <uartintr>
    lapiceoi();
80105f96:	e8 f5 cd ff ff       	call   80102d90 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f9b:	e8 90 de ff ff       	call   80103e30 <myproc>
80105fa0:	85 c0                	test   %eax,%eax
80105fa2:	0f 85 1b ff ff ff    	jne    80105ec3 <trap+0xa3>
80105fa8:	e9 33 ff ff ff       	jmp    80105ee0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105fad:	8b 7b 38             	mov    0x38(%ebx),%edi
80105fb0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105fb4:	e8 57 de ff ff       	call   80103e10 <cpuid>
80105fb9:	57                   	push   %edi
80105fba:	56                   	push   %esi
80105fbb:	50                   	push   %eax
80105fbc:	68 a4 7d 10 80       	push   $0x80107da4
80105fc1:	e8 da a8 ff ff       	call   801008a0 <cprintf>
    lapiceoi();
80105fc6:	e8 c5 cd ff ff       	call   80102d90 <lapiceoi>
    break;
80105fcb:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fce:	e8 5d de ff ff       	call   80103e30 <myproc>
80105fd3:	85 c0                	test   %eax,%eax
80105fd5:	0f 85 e8 fe ff ff    	jne    80105ec3 <trap+0xa3>
80105fdb:	e9 00 ff ff ff       	jmp    80105ee0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80105fe0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105fe4:	0f 85 0e ff ff ff    	jne    80105ef8 <trap+0xd8>
    yield();
80105fea:	e8 b1 e3 ff ff       	call   801043a0 <yield>
80105fef:	e9 04 ff ff ff       	jmp    80105ef8 <trap+0xd8>
80105ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105ff8:	e8 33 de ff ff       	call   80103e30 <myproc>
80105ffd:	8b 70 24             	mov    0x24(%eax),%esi
80106000:	85 f6                	test   %esi,%esi
80106002:	75 3c                	jne    80106040 <trap+0x220>
    myproc()->tf = tf;
80106004:	e8 27 de ff ff       	call   80103e30 <myproc>
80106009:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010600c:	e8 ff ee ff ff       	call   80104f10 <syscall>
    if(myproc()->killed)
80106011:	e8 1a de ff ff       	call   80103e30 <myproc>
80106016:	8b 48 24             	mov    0x24(%eax),%ecx
80106019:	85 c9                	test   %ecx,%ecx
8010601b:	0f 84 fd fe ff ff    	je     80105f1e <trap+0xfe>
}
80106021:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106024:	5b                   	pop    %ebx
80106025:	5e                   	pop    %esi
80106026:	5f                   	pop    %edi
80106027:	5d                   	pop    %ebp
      exit();
80106028:	e9 33 e2 ff ff       	jmp    80104260 <exit>
8010602d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106030:	e8 2b e2 ff ff       	call   80104260 <exit>
80106035:	e9 a6 fe ff ff       	jmp    80105ee0 <trap+0xc0>
8010603a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106040:	e8 1b e2 ff ff       	call   80104260 <exit>
80106045:	eb bd                	jmp    80106004 <trap+0x1e4>
80106047:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010604a:	e8 c1 dd ff ff       	call   80103e10 <cpuid>
8010604f:	83 ec 0c             	sub    $0xc,%esp
80106052:	56                   	push   %esi
80106053:	57                   	push   %edi
80106054:	50                   	push   %eax
80106055:	ff 73 30             	pushl  0x30(%ebx)
80106058:	68 c8 7d 10 80       	push   $0x80107dc8
8010605d:	e8 3e a8 ff ff       	call   801008a0 <cprintf>
      panic("trap");
80106062:	83 c4 14             	add    $0x14,%esp
80106065:	68 9e 7d 10 80       	push   $0x80107d9e
8010606a:	e8 21 a3 ff ff       	call   80100390 <panic>
8010606f:	90                   	nop

80106070 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106070:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106074:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80106079:	85 c0                	test   %eax,%eax
8010607b:	74 1b                	je     80106098 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010607d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106082:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106083:	a8 01                	test   $0x1,%al
80106085:	74 11                	je     80106098 <uartgetc+0x28>
80106087:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010608c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010608d:	0f b6 c0             	movzbl %al,%eax
80106090:	c3                   	ret    
80106091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010609d:	c3                   	ret    
8010609e:	66 90                	xchg   %ax,%ax

801060a0 <uartputc.part.0>:
uartputc(int c)
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	57                   	push   %edi
801060a4:	89 c7                	mov    %eax,%edi
801060a6:	56                   	push   %esi
801060a7:	be fd 03 00 00       	mov    $0x3fd,%esi
801060ac:	53                   	push   %ebx
801060ad:	bb 80 00 00 00       	mov    $0x80,%ebx
801060b2:	83 ec 0c             	sub    $0xc,%esp
801060b5:	eb 1b                	jmp    801060d2 <uartputc.part.0+0x32>
801060b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060be:	66 90                	xchg   %ax,%ax
    microdelay(10);
801060c0:	83 ec 0c             	sub    $0xc,%esp
801060c3:	6a 0a                	push   $0xa
801060c5:	e8 e6 cc ff ff       	call   80102db0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060ca:	83 c4 10             	add    $0x10,%esp
801060cd:	83 eb 01             	sub    $0x1,%ebx
801060d0:	74 07                	je     801060d9 <uartputc.part.0+0x39>
801060d2:	89 f2                	mov    %esi,%edx
801060d4:	ec                   	in     (%dx),%al
801060d5:	a8 20                	test   $0x20,%al
801060d7:	74 e7                	je     801060c0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060d9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060de:	89 f8                	mov    %edi,%eax
801060e0:	ee                   	out    %al,(%dx)
}
801060e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060e4:	5b                   	pop    %ebx
801060e5:	5e                   	pop    %esi
801060e6:	5f                   	pop    %edi
801060e7:	5d                   	pop    %ebp
801060e8:	c3                   	ret    
801060e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060f0 <uartinit>:
{
801060f0:	f3 0f 1e fb          	endbr32 
801060f4:	55                   	push   %ebp
801060f5:	31 c9                	xor    %ecx,%ecx
801060f7:	89 c8                	mov    %ecx,%eax
801060f9:	89 e5                	mov    %esp,%ebp
801060fb:	57                   	push   %edi
801060fc:	56                   	push   %esi
801060fd:	53                   	push   %ebx
801060fe:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106103:	89 da                	mov    %ebx,%edx
80106105:	83 ec 0c             	sub    $0xc,%esp
80106108:	ee                   	out    %al,(%dx)
80106109:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010610e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106113:	89 fa                	mov    %edi,%edx
80106115:	ee                   	out    %al,(%dx)
80106116:	b8 0c 00 00 00       	mov    $0xc,%eax
8010611b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106120:	ee                   	out    %al,(%dx)
80106121:	be f9 03 00 00       	mov    $0x3f9,%esi
80106126:	89 c8                	mov    %ecx,%eax
80106128:	89 f2                	mov    %esi,%edx
8010612a:	ee                   	out    %al,(%dx)
8010612b:	b8 03 00 00 00       	mov    $0x3,%eax
80106130:	89 fa                	mov    %edi,%edx
80106132:	ee                   	out    %al,(%dx)
80106133:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106138:	89 c8                	mov    %ecx,%eax
8010613a:	ee                   	out    %al,(%dx)
8010613b:	b8 01 00 00 00       	mov    $0x1,%eax
80106140:	89 f2                	mov    %esi,%edx
80106142:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106143:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106148:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106149:	3c ff                	cmp    $0xff,%al
8010614b:	74 52                	je     8010619f <uartinit+0xaf>
  uart = 1;
8010614d:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80106154:	00 00 00 
80106157:	89 da                	mov    %ebx,%edx
80106159:	ec                   	in     (%dx),%al
8010615a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010615f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106160:	83 ec 08             	sub    $0x8,%esp
80106163:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106168:	bb c0 7e 10 80       	mov    $0x80107ec0,%ebx
  ioapicenable(IRQ_COM1, 0);
8010616d:	6a 00                	push   $0x0
8010616f:	6a 04                	push   $0x4
80106171:	e8 8a c7 ff ff       	call   80102900 <ioapicenable>
80106176:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106179:	b8 78 00 00 00       	mov    $0x78,%eax
8010617e:	eb 04                	jmp    80106184 <uartinit+0x94>
80106180:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106184:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
8010618a:	85 d2                	test   %edx,%edx
8010618c:	74 08                	je     80106196 <uartinit+0xa6>
    uartputc(*p);
8010618e:	0f be c0             	movsbl %al,%eax
80106191:	e8 0a ff ff ff       	call   801060a0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106196:	89 f0                	mov    %esi,%eax
80106198:	83 c3 01             	add    $0x1,%ebx
8010619b:	84 c0                	test   %al,%al
8010619d:	75 e1                	jne    80106180 <uartinit+0x90>
}
8010619f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061a2:	5b                   	pop    %ebx
801061a3:	5e                   	pop    %esi
801061a4:	5f                   	pop    %edi
801061a5:	5d                   	pop    %ebp
801061a6:	c3                   	ret    
801061a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ae:	66 90                	xchg   %ax,%ax

801061b0 <uartputc>:
{
801061b0:	f3 0f 1e fb          	endbr32 
801061b4:	55                   	push   %ebp
  if(!uart)
801061b5:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
801061bb:	89 e5                	mov    %esp,%ebp
801061bd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801061c0:	85 d2                	test   %edx,%edx
801061c2:	74 0c                	je     801061d0 <uartputc+0x20>
}
801061c4:	5d                   	pop    %ebp
801061c5:	e9 d6 fe ff ff       	jmp    801060a0 <uartputc.part.0>
801061ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801061d0:	5d                   	pop    %ebp
801061d1:	c3                   	ret    
801061d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061e0 <uartintr>:

void
uartintr(void)
{
801061e0:	f3 0f 1e fb          	endbr32 
801061e4:	55                   	push   %ebp
801061e5:	89 e5                	mov    %esp,%ebp
801061e7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801061ea:	68 70 60 10 80       	push   $0x80106070
801061ef:	e8 5c a8 ff ff       	call   80100a50 <consoleintr>
}
801061f4:	83 c4 10             	add    $0x10,%esp
801061f7:	c9                   	leave  
801061f8:	c3                   	ret    

801061f9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $0
801061fb:	6a 00                	push   $0x0
  jmp alltraps
801061fd:	e9 3c fb ff ff       	jmp    80105d3e <alltraps>

80106202 <vector1>:
.globl vector1
vector1:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $1
80106204:	6a 01                	push   $0x1
  jmp alltraps
80106206:	e9 33 fb ff ff       	jmp    80105d3e <alltraps>

8010620b <vector2>:
.globl vector2
vector2:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $2
8010620d:	6a 02                	push   $0x2
  jmp alltraps
8010620f:	e9 2a fb ff ff       	jmp    80105d3e <alltraps>

80106214 <vector3>:
.globl vector3
vector3:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $3
80106216:	6a 03                	push   $0x3
  jmp alltraps
80106218:	e9 21 fb ff ff       	jmp    80105d3e <alltraps>

8010621d <vector4>:
.globl vector4
vector4:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $4
8010621f:	6a 04                	push   $0x4
  jmp alltraps
80106221:	e9 18 fb ff ff       	jmp    80105d3e <alltraps>

80106226 <vector5>:
.globl vector5
vector5:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $5
80106228:	6a 05                	push   $0x5
  jmp alltraps
8010622a:	e9 0f fb ff ff       	jmp    80105d3e <alltraps>

8010622f <vector6>:
.globl vector6
vector6:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $6
80106231:	6a 06                	push   $0x6
  jmp alltraps
80106233:	e9 06 fb ff ff       	jmp    80105d3e <alltraps>

80106238 <vector7>:
.globl vector7
vector7:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $7
8010623a:	6a 07                	push   $0x7
  jmp alltraps
8010623c:	e9 fd fa ff ff       	jmp    80105d3e <alltraps>

80106241 <vector8>:
.globl vector8
vector8:
  pushl $8
80106241:	6a 08                	push   $0x8
  jmp alltraps
80106243:	e9 f6 fa ff ff       	jmp    80105d3e <alltraps>

80106248 <vector9>:
.globl vector9
vector9:
  pushl $0
80106248:	6a 00                	push   $0x0
  pushl $9
8010624a:	6a 09                	push   $0x9
  jmp alltraps
8010624c:	e9 ed fa ff ff       	jmp    80105d3e <alltraps>

80106251 <vector10>:
.globl vector10
vector10:
  pushl $10
80106251:	6a 0a                	push   $0xa
  jmp alltraps
80106253:	e9 e6 fa ff ff       	jmp    80105d3e <alltraps>

80106258 <vector11>:
.globl vector11
vector11:
  pushl $11
80106258:	6a 0b                	push   $0xb
  jmp alltraps
8010625a:	e9 df fa ff ff       	jmp    80105d3e <alltraps>

8010625f <vector12>:
.globl vector12
vector12:
  pushl $12
8010625f:	6a 0c                	push   $0xc
  jmp alltraps
80106261:	e9 d8 fa ff ff       	jmp    80105d3e <alltraps>

80106266 <vector13>:
.globl vector13
vector13:
  pushl $13
80106266:	6a 0d                	push   $0xd
  jmp alltraps
80106268:	e9 d1 fa ff ff       	jmp    80105d3e <alltraps>

8010626d <vector14>:
.globl vector14
vector14:
  pushl $14
8010626d:	6a 0e                	push   $0xe
  jmp alltraps
8010626f:	e9 ca fa ff ff       	jmp    80105d3e <alltraps>

80106274 <vector15>:
.globl vector15
vector15:
  pushl $0
80106274:	6a 00                	push   $0x0
  pushl $15
80106276:	6a 0f                	push   $0xf
  jmp alltraps
80106278:	e9 c1 fa ff ff       	jmp    80105d3e <alltraps>

8010627d <vector16>:
.globl vector16
vector16:
  pushl $0
8010627d:	6a 00                	push   $0x0
  pushl $16
8010627f:	6a 10                	push   $0x10
  jmp alltraps
80106281:	e9 b8 fa ff ff       	jmp    80105d3e <alltraps>

80106286 <vector17>:
.globl vector17
vector17:
  pushl $17
80106286:	6a 11                	push   $0x11
  jmp alltraps
80106288:	e9 b1 fa ff ff       	jmp    80105d3e <alltraps>

8010628d <vector18>:
.globl vector18
vector18:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $18
8010628f:	6a 12                	push   $0x12
  jmp alltraps
80106291:	e9 a8 fa ff ff       	jmp    80105d3e <alltraps>

80106296 <vector19>:
.globl vector19
vector19:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $19
80106298:	6a 13                	push   $0x13
  jmp alltraps
8010629a:	e9 9f fa ff ff       	jmp    80105d3e <alltraps>

8010629f <vector20>:
.globl vector20
vector20:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $20
801062a1:	6a 14                	push   $0x14
  jmp alltraps
801062a3:	e9 96 fa ff ff       	jmp    80105d3e <alltraps>

801062a8 <vector21>:
.globl vector21
vector21:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $21
801062aa:	6a 15                	push   $0x15
  jmp alltraps
801062ac:	e9 8d fa ff ff       	jmp    80105d3e <alltraps>

801062b1 <vector22>:
.globl vector22
vector22:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $22
801062b3:	6a 16                	push   $0x16
  jmp alltraps
801062b5:	e9 84 fa ff ff       	jmp    80105d3e <alltraps>

801062ba <vector23>:
.globl vector23
vector23:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $23
801062bc:	6a 17                	push   $0x17
  jmp alltraps
801062be:	e9 7b fa ff ff       	jmp    80105d3e <alltraps>

801062c3 <vector24>:
.globl vector24
vector24:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $24
801062c5:	6a 18                	push   $0x18
  jmp alltraps
801062c7:	e9 72 fa ff ff       	jmp    80105d3e <alltraps>

801062cc <vector25>:
.globl vector25
vector25:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $25
801062ce:	6a 19                	push   $0x19
  jmp alltraps
801062d0:	e9 69 fa ff ff       	jmp    80105d3e <alltraps>

801062d5 <vector26>:
.globl vector26
vector26:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $26
801062d7:	6a 1a                	push   $0x1a
  jmp alltraps
801062d9:	e9 60 fa ff ff       	jmp    80105d3e <alltraps>

801062de <vector27>:
.globl vector27
vector27:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $27
801062e0:	6a 1b                	push   $0x1b
  jmp alltraps
801062e2:	e9 57 fa ff ff       	jmp    80105d3e <alltraps>

801062e7 <vector28>:
.globl vector28
vector28:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $28
801062e9:	6a 1c                	push   $0x1c
  jmp alltraps
801062eb:	e9 4e fa ff ff       	jmp    80105d3e <alltraps>

801062f0 <vector29>:
.globl vector29
vector29:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $29
801062f2:	6a 1d                	push   $0x1d
  jmp alltraps
801062f4:	e9 45 fa ff ff       	jmp    80105d3e <alltraps>

801062f9 <vector30>:
.globl vector30
vector30:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $30
801062fb:	6a 1e                	push   $0x1e
  jmp alltraps
801062fd:	e9 3c fa ff ff       	jmp    80105d3e <alltraps>

80106302 <vector31>:
.globl vector31
vector31:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $31
80106304:	6a 1f                	push   $0x1f
  jmp alltraps
80106306:	e9 33 fa ff ff       	jmp    80105d3e <alltraps>

8010630b <vector32>:
.globl vector32
vector32:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $32
8010630d:	6a 20                	push   $0x20
  jmp alltraps
8010630f:	e9 2a fa ff ff       	jmp    80105d3e <alltraps>

80106314 <vector33>:
.globl vector33
vector33:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $33
80106316:	6a 21                	push   $0x21
  jmp alltraps
80106318:	e9 21 fa ff ff       	jmp    80105d3e <alltraps>

8010631d <vector34>:
.globl vector34
vector34:
  pushl $0
8010631d:	6a 00                	push   $0x0
  pushl $34
8010631f:	6a 22                	push   $0x22
  jmp alltraps
80106321:	e9 18 fa ff ff       	jmp    80105d3e <alltraps>

80106326 <vector35>:
.globl vector35
vector35:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $35
80106328:	6a 23                	push   $0x23
  jmp alltraps
8010632a:	e9 0f fa ff ff       	jmp    80105d3e <alltraps>

8010632f <vector36>:
.globl vector36
vector36:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $36
80106331:	6a 24                	push   $0x24
  jmp alltraps
80106333:	e9 06 fa ff ff       	jmp    80105d3e <alltraps>

80106338 <vector37>:
.globl vector37
vector37:
  pushl $0
80106338:	6a 00                	push   $0x0
  pushl $37
8010633a:	6a 25                	push   $0x25
  jmp alltraps
8010633c:	e9 fd f9 ff ff       	jmp    80105d3e <alltraps>

80106341 <vector38>:
.globl vector38
vector38:
  pushl $0
80106341:	6a 00                	push   $0x0
  pushl $38
80106343:	6a 26                	push   $0x26
  jmp alltraps
80106345:	e9 f4 f9 ff ff       	jmp    80105d3e <alltraps>

8010634a <vector39>:
.globl vector39
vector39:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $39
8010634c:	6a 27                	push   $0x27
  jmp alltraps
8010634e:	e9 eb f9 ff ff       	jmp    80105d3e <alltraps>

80106353 <vector40>:
.globl vector40
vector40:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $40
80106355:	6a 28                	push   $0x28
  jmp alltraps
80106357:	e9 e2 f9 ff ff       	jmp    80105d3e <alltraps>

8010635c <vector41>:
.globl vector41
vector41:
  pushl $0
8010635c:	6a 00                	push   $0x0
  pushl $41
8010635e:	6a 29                	push   $0x29
  jmp alltraps
80106360:	e9 d9 f9 ff ff       	jmp    80105d3e <alltraps>

80106365 <vector42>:
.globl vector42
vector42:
  pushl $0
80106365:	6a 00                	push   $0x0
  pushl $42
80106367:	6a 2a                	push   $0x2a
  jmp alltraps
80106369:	e9 d0 f9 ff ff       	jmp    80105d3e <alltraps>

8010636e <vector43>:
.globl vector43
vector43:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $43
80106370:	6a 2b                	push   $0x2b
  jmp alltraps
80106372:	e9 c7 f9 ff ff       	jmp    80105d3e <alltraps>

80106377 <vector44>:
.globl vector44
vector44:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $44
80106379:	6a 2c                	push   $0x2c
  jmp alltraps
8010637b:	e9 be f9 ff ff       	jmp    80105d3e <alltraps>

80106380 <vector45>:
.globl vector45
vector45:
  pushl $0
80106380:	6a 00                	push   $0x0
  pushl $45
80106382:	6a 2d                	push   $0x2d
  jmp alltraps
80106384:	e9 b5 f9 ff ff       	jmp    80105d3e <alltraps>

80106389 <vector46>:
.globl vector46
vector46:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $46
8010638b:	6a 2e                	push   $0x2e
  jmp alltraps
8010638d:	e9 ac f9 ff ff       	jmp    80105d3e <alltraps>

80106392 <vector47>:
.globl vector47
vector47:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $47
80106394:	6a 2f                	push   $0x2f
  jmp alltraps
80106396:	e9 a3 f9 ff ff       	jmp    80105d3e <alltraps>

8010639b <vector48>:
.globl vector48
vector48:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $48
8010639d:	6a 30                	push   $0x30
  jmp alltraps
8010639f:	e9 9a f9 ff ff       	jmp    80105d3e <alltraps>

801063a4 <vector49>:
.globl vector49
vector49:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $49
801063a6:	6a 31                	push   $0x31
  jmp alltraps
801063a8:	e9 91 f9 ff ff       	jmp    80105d3e <alltraps>

801063ad <vector50>:
.globl vector50
vector50:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $50
801063af:	6a 32                	push   $0x32
  jmp alltraps
801063b1:	e9 88 f9 ff ff       	jmp    80105d3e <alltraps>

801063b6 <vector51>:
.globl vector51
vector51:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $51
801063b8:	6a 33                	push   $0x33
  jmp alltraps
801063ba:	e9 7f f9 ff ff       	jmp    80105d3e <alltraps>

801063bf <vector52>:
.globl vector52
vector52:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $52
801063c1:	6a 34                	push   $0x34
  jmp alltraps
801063c3:	e9 76 f9 ff ff       	jmp    80105d3e <alltraps>

801063c8 <vector53>:
.globl vector53
vector53:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $53
801063ca:	6a 35                	push   $0x35
  jmp alltraps
801063cc:	e9 6d f9 ff ff       	jmp    80105d3e <alltraps>

801063d1 <vector54>:
.globl vector54
vector54:
  pushl $0
801063d1:	6a 00                	push   $0x0
  pushl $54
801063d3:	6a 36                	push   $0x36
  jmp alltraps
801063d5:	e9 64 f9 ff ff       	jmp    80105d3e <alltraps>

801063da <vector55>:
.globl vector55
vector55:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $55
801063dc:	6a 37                	push   $0x37
  jmp alltraps
801063de:	e9 5b f9 ff ff       	jmp    80105d3e <alltraps>

801063e3 <vector56>:
.globl vector56
vector56:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $56
801063e5:	6a 38                	push   $0x38
  jmp alltraps
801063e7:	e9 52 f9 ff ff       	jmp    80105d3e <alltraps>

801063ec <vector57>:
.globl vector57
vector57:
  pushl $0
801063ec:	6a 00                	push   $0x0
  pushl $57
801063ee:	6a 39                	push   $0x39
  jmp alltraps
801063f0:	e9 49 f9 ff ff       	jmp    80105d3e <alltraps>

801063f5 <vector58>:
.globl vector58
vector58:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $58
801063f7:	6a 3a                	push   $0x3a
  jmp alltraps
801063f9:	e9 40 f9 ff ff       	jmp    80105d3e <alltraps>

801063fe <vector59>:
.globl vector59
vector59:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $59
80106400:	6a 3b                	push   $0x3b
  jmp alltraps
80106402:	e9 37 f9 ff ff       	jmp    80105d3e <alltraps>

80106407 <vector60>:
.globl vector60
vector60:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $60
80106409:	6a 3c                	push   $0x3c
  jmp alltraps
8010640b:	e9 2e f9 ff ff       	jmp    80105d3e <alltraps>

80106410 <vector61>:
.globl vector61
vector61:
  pushl $0
80106410:	6a 00                	push   $0x0
  pushl $61
80106412:	6a 3d                	push   $0x3d
  jmp alltraps
80106414:	e9 25 f9 ff ff       	jmp    80105d3e <alltraps>

80106419 <vector62>:
.globl vector62
vector62:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $62
8010641b:	6a 3e                	push   $0x3e
  jmp alltraps
8010641d:	e9 1c f9 ff ff       	jmp    80105d3e <alltraps>

80106422 <vector63>:
.globl vector63
vector63:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $63
80106424:	6a 3f                	push   $0x3f
  jmp alltraps
80106426:	e9 13 f9 ff ff       	jmp    80105d3e <alltraps>

8010642b <vector64>:
.globl vector64
vector64:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $64
8010642d:	6a 40                	push   $0x40
  jmp alltraps
8010642f:	e9 0a f9 ff ff       	jmp    80105d3e <alltraps>

80106434 <vector65>:
.globl vector65
vector65:
  pushl $0
80106434:	6a 00                	push   $0x0
  pushl $65
80106436:	6a 41                	push   $0x41
  jmp alltraps
80106438:	e9 01 f9 ff ff       	jmp    80105d3e <alltraps>

8010643d <vector66>:
.globl vector66
vector66:
  pushl $0
8010643d:	6a 00                	push   $0x0
  pushl $66
8010643f:	6a 42                	push   $0x42
  jmp alltraps
80106441:	e9 f8 f8 ff ff       	jmp    80105d3e <alltraps>

80106446 <vector67>:
.globl vector67
vector67:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $67
80106448:	6a 43                	push   $0x43
  jmp alltraps
8010644a:	e9 ef f8 ff ff       	jmp    80105d3e <alltraps>

8010644f <vector68>:
.globl vector68
vector68:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $68
80106451:	6a 44                	push   $0x44
  jmp alltraps
80106453:	e9 e6 f8 ff ff       	jmp    80105d3e <alltraps>

80106458 <vector69>:
.globl vector69
vector69:
  pushl $0
80106458:	6a 00                	push   $0x0
  pushl $69
8010645a:	6a 45                	push   $0x45
  jmp alltraps
8010645c:	e9 dd f8 ff ff       	jmp    80105d3e <alltraps>

80106461 <vector70>:
.globl vector70
vector70:
  pushl $0
80106461:	6a 00                	push   $0x0
  pushl $70
80106463:	6a 46                	push   $0x46
  jmp alltraps
80106465:	e9 d4 f8 ff ff       	jmp    80105d3e <alltraps>

8010646a <vector71>:
.globl vector71
vector71:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $71
8010646c:	6a 47                	push   $0x47
  jmp alltraps
8010646e:	e9 cb f8 ff ff       	jmp    80105d3e <alltraps>

80106473 <vector72>:
.globl vector72
vector72:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $72
80106475:	6a 48                	push   $0x48
  jmp alltraps
80106477:	e9 c2 f8 ff ff       	jmp    80105d3e <alltraps>

8010647c <vector73>:
.globl vector73
vector73:
  pushl $0
8010647c:	6a 00                	push   $0x0
  pushl $73
8010647e:	6a 49                	push   $0x49
  jmp alltraps
80106480:	e9 b9 f8 ff ff       	jmp    80105d3e <alltraps>

80106485 <vector74>:
.globl vector74
vector74:
  pushl $0
80106485:	6a 00                	push   $0x0
  pushl $74
80106487:	6a 4a                	push   $0x4a
  jmp alltraps
80106489:	e9 b0 f8 ff ff       	jmp    80105d3e <alltraps>

8010648e <vector75>:
.globl vector75
vector75:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $75
80106490:	6a 4b                	push   $0x4b
  jmp alltraps
80106492:	e9 a7 f8 ff ff       	jmp    80105d3e <alltraps>

80106497 <vector76>:
.globl vector76
vector76:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $76
80106499:	6a 4c                	push   $0x4c
  jmp alltraps
8010649b:	e9 9e f8 ff ff       	jmp    80105d3e <alltraps>

801064a0 <vector77>:
.globl vector77
vector77:
  pushl $0
801064a0:	6a 00                	push   $0x0
  pushl $77
801064a2:	6a 4d                	push   $0x4d
  jmp alltraps
801064a4:	e9 95 f8 ff ff       	jmp    80105d3e <alltraps>

801064a9 <vector78>:
.globl vector78
vector78:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $78
801064ab:	6a 4e                	push   $0x4e
  jmp alltraps
801064ad:	e9 8c f8 ff ff       	jmp    80105d3e <alltraps>

801064b2 <vector79>:
.globl vector79
vector79:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $79
801064b4:	6a 4f                	push   $0x4f
  jmp alltraps
801064b6:	e9 83 f8 ff ff       	jmp    80105d3e <alltraps>

801064bb <vector80>:
.globl vector80
vector80:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $80
801064bd:	6a 50                	push   $0x50
  jmp alltraps
801064bf:	e9 7a f8 ff ff       	jmp    80105d3e <alltraps>

801064c4 <vector81>:
.globl vector81
vector81:
  pushl $0
801064c4:	6a 00                	push   $0x0
  pushl $81
801064c6:	6a 51                	push   $0x51
  jmp alltraps
801064c8:	e9 71 f8 ff ff       	jmp    80105d3e <alltraps>

801064cd <vector82>:
.globl vector82
vector82:
  pushl $0
801064cd:	6a 00                	push   $0x0
  pushl $82
801064cf:	6a 52                	push   $0x52
  jmp alltraps
801064d1:	e9 68 f8 ff ff       	jmp    80105d3e <alltraps>

801064d6 <vector83>:
.globl vector83
vector83:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $83
801064d8:	6a 53                	push   $0x53
  jmp alltraps
801064da:	e9 5f f8 ff ff       	jmp    80105d3e <alltraps>

801064df <vector84>:
.globl vector84
vector84:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $84
801064e1:	6a 54                	push   $0x54
  jmp alltraps
801064e3:	e9 56 f8 ff ff       	jmp    80105d3e <alltraps>

801064e8 <vector85>:
.globl vector85
vector85:
  pushl $0
801064e8:	6a 00                	push   $0x0
  pushl $85
801064ea:	6a 55                	push   $0x55
  jmp alltraps
801064ec:	e9 4d f8 ff ff       	jmp    80105d3e <alltraps>

801064f1 <vector86>:
.globl vector86
vector86:
  pushl $0
801064f1:	6a 00                	push   $0x0
  pushl $86
801064f3:	6a 56                	push   $0x56
  jmp alltraps
801064f5:	e9 44 f8 ff ff       	jmp    80105d3e <alltraps>

801064fa <vector87>:
.globl vector87
vector87:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $87
801064fc:	6a 57                	push   $0x57
  jmp alltraps
801064fe:	e9 3b f8 ff ff       	jmp    80105d3e <alltraps>

80106503 <vector88>:
.globl vector88
vector88:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $88
80106505:	6a 58                	push   $0x58
  jmp alltraps
80106507:	e9 32 f8 ff ff       	jmp    80105d3e <alltraps>

8010650c <vector89>:
.globl vector89
vector89:
  pushl $0
8010650c:	6a 00                	push   $0x0
  pushl $89
8010650e:	6a 59                	push   $0x59
  jmp alltraps
80106510:	e9 29 f8 ff ff       	jmp    80105d3e <alltraps>

80106515 <vector90>:
.globl vector90
vector90:
  pushl $0
80106515:	6a 00                	push   $0x0
  pushl $90
80106517:	6a 5a                	push   $0x5a
  jmp alltraps
80106519:	e9 20 f8 ff ff       	jmp    80105d3e <alltraps>

8010651e <vector91>:
.globl vector91
vector91:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $91
80106520:	6a 5b                	push   $0x5b
  jmp alltraps
80106522:	e9 17 f8 ff ff       	jmp    80105d3e <alltraps>

80106527 <vector92>:
.globl vector92
vector92:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $92
80106529:	6a 5c                	push   $0x5c
  jmp alltraps
8010652b:	e9 0e f8 ff ff       	jmp    80105d3e <alltraps>

80106530 <vector93>:
.globl vector93
vector93:
  pushl $0
80106530:	6a 00                	push   $0x0
  pushl $93
80106532:	6a 5d                	push   $0x5d
  jmp alltraps
80106534:	e9 05 f8 ff ff       	jmp    80105d3e <alltraps>

80106539 <vector94>:
.globl vector94
vector94:
  pushl $0
80106539:	6a 00                	push   $0x0
  pushl $94
8010653b:	6a 5e                	push   $0x5e
  jmp alltraps
8010653d:	e9 fc f7 ff ff       	jmp    80105d3e <alltraps>

80106542 <vector95>:
.globl vector95
vector95:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $95
80106544:	6a 5f                	push   $0x5f
  jmp alltraps
80106546:	e9 f3 f7 ff ff       	jmp    80105d3e <alltraps>

8010654b <vector96>:
.globl vector96
vector96:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $96
8010654d:	6a 60                	push   $0x60
  jmp alltraps
8010654f:	e9 ea f7 ff ff       	jmp    80105d3e <alltraps>

80106554 <vector97>:
.globl vector97
vector97:
  pushl $0
80106554:	6a 00                	push   $0x0
  pushl $97
80106556:	6a 61                	push   $0x61
  jmp alltraps
80106558:	e9 e1 f7 ff ff       	jmp    80105d3e <alltraps>

8010655d <vector98>:
.globl vector98
vector98:
  pushl $0
8010655d:	6a 00                	push   $0x0
  pushl $98
8010655f:	6a 62                	push   $0x62
  jmp alltraps
80106561:	e9 d8 f7 ff ff       	jmp    80105d3e <alltraps>

80106566 <vector99>:
.globl vector99
vector99:
  pushl $0
80106566:	6a 00                	push   $0x0
  pushl $99
80106568:	6a 63                	push   $0x63
  jmp alltraps
8010656a:	e9 cf f7 ff ff       	jmp    80105d3e <alltraps>

8010656f <vector100>:
.globl vector100
vector100:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $100
80106571:	6a 64                	push   $0x64
  jmp alltraps
80106573:	e9 c6 f7 ff ff       	jmp    80105d3e <alltraps>

80106578 <vector101>:
.globl vector101
vector101:
  pushl $0
80106578:	6a 00                	push   $0x0
  pushl $101
8010657a:	6a 65                	push   $0x65
  jmp alltraps
8010657c:	e9 bd f7 ff ff       	jmp    80105d3e <alltraps>

80106581 <vector102>:
.globl vector102
vector102:
  pushl $0
80106581:	6a 00                	push   $0x0
  pushl $102
80106583:	6a 66                	push   $0x66
  jmp alltraps
80106585:	e9 b4 f7 ff ff       	jmp    80105d3e <alltraps>

8010658a <vector103>:
.globl vector103
vector103:
  pushl $0
8010658a:	6a 00                	push   $0x0
  pushl $103
8010658c:	6a 67                	push   $0x67
  jmp alltraps
8010658e:	e9 ab f7 ff ff       	jmp    80105d3e <alltraps>

80106593 <vector104>:
.globl vector104
vector104:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $104
80106595:	6a 68                	push   $0x68
  jmp alltraps
80106597:	e9 a2 f7 ff ff       	jmp    80105d3e <alltraps>

8010659c <vector105>:
.globl vector105
vector105:
  pushl $0
8010659c:	6a 00                	push   $0x0
  pushl $105
8010659e:	6a 69                	push   $0x69
  jmp alltraps
801065a0:	e9 99 f7 ff ff       	jmp    80105d3e <alltraps>

801065a5 <vector106>:
.globl vector106
vector106:
  pushl $0
801065a5:	6a 00                	push   $0x0
  pushl $106
801065a7:	6a 6a                	push   $0x6a
  jmp alltraps
801065a9:	e9 90 f7 ff ff       	jmp    80105d3e <alltraps>

801065ae <vector107>:
.globl vector107
vector107:
  pushl $0
801065ae:	6a 00                	push   $0x0
  pushl $107
801065b0:	6a 6b                	push   $0x6b
  jmp alltraps
801065b2:	e9 87 f7 ff ff       	jmp    80105d3e <alltraps>

801065b7 <vector108>:
.globl vector108
vector108:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $108
801065b9:	6a 6c                	push   $0x6c
  jmp alltraps
801065bb:	e9 7e f7 ff ff       	jmp    80105d3e <alltraps>

801065c0 <vector109>:
.globl vector109
vector109:
  pushl $0
801065c0:	6a 00                	push   $0x0
  pushl $109
801065c2:	6a 6d                	push   $0x6d
  jmp alltraps
801065c4:	e9 75 f7 ff ff       	jmp    80105d3e <alltraps>

801065c9 <vector110>:
.globl vector110
vector110:
  pushl $0
801065c9:	6a 00                	push   $0x0
  pushl $110
801065cb:	6a 6e                	push   $0x6e
  jmp alltraps
801065cd:	e9 6c f7 ff ff       	jmp    80105d3e <alltraps>

801065d2 <vector111>:
.globl vector111
vector111:
  pushl $0
801065d2:	6a 00                	push   $0x0
  pushl $111
801065d4:	6a 6f                	push   $0x6f
  jmp alltraps
801065d6:	e9 63 f7 ff ff       	jmp    80105d3e <alltraps>

801065db <vector112>:
.globl vector112
vector112:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $112
801065dd:	6a 70                	push   $0x70
  jmp alltraps
801065df:	e9 5a f7 ff ff       	jmp    80105d3e <alltraps>

801065e4 <vector113>:
.globl vector113
vector113:
  pushl $0
801065e4:	6a 00                	push   $0x0
  pushl $113
801065e6:	6a 71                	push   $0x71
  jmp alltraps
801065e8:	e9 51 f7 ff ff       	jmp    80105d3e <alltraps>

801065ed <vector114>:
.globl vector114
vector114:
  pushl $0
801065ed:	6a 00                	push   $0x0
  pushl $114
801065ef:	6a 72                	push   $0x72
  jmp alltraps
801065f1:	e9 48 f7 ff ff       	jmp    80105d3e <alltraps>

801065f6 <vector115>:
.globl vector115
vector115:
  pushl $0
801065f6:	6a 00                	push   $0x0
  pushl $115
801065f8:	6a 73                	push   $0x73
  jmp alltraps
801065fa:	e9 3f f7 ff ff       	jmp    80105d3e <alltraps>

801065ff <vector116>:
.globl vector116
vector116:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $116
80106601:	6a 74                	push   $0x74
  jmp alltraps
80106603:	e9 36 f7 ff ff       	jmp    80105d3e <alltraps>

80106608 <vector117>:
.globl vector117
vector117:
  pushl $0
80106608:	6a 00                	push   $0x0
  pushl $117
8010660a:	6a 75                	push   $0x75
  jmp alltraps
8010660c:	e9 2d f7 ff ff       	jmp    80105d3e <alltraps>

80106611 <vector118>:
.globl vector118
vector118:
  pushl $0
80106611:	6a 00                	push   $0x0
  pushl $118
80106613:	6a 76                	push   $0x76
  jmp alltraps
80106615:	e9 24 f7 ff ff       	jmp    80105d3e <alltraps>

8010661a <vector119>:
.globl vector119
vector119:
  pushl $0
8010661a:	6a 00                	push   $0x0
  pushl $119
8010661c:	6a 77                	push   $0x77
  jmp alltraps
8010661e:	e9 1b f7 ff ff       	jmp    80105d3e <alltraps>

80106623 <vector120>:
.globl vector120
vector120:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $120
80106625:	6a 78                	push   $0x78
  jmp alltraps
80106627:	e9 12 f7 ff ff       	jmp    80105d3e <alltraps>

8010662c <vector121>:
.globl vector121
vector121:
  pushl $0
8010662c:	6a 00                	push   $0x0
  pushl $121
8010662e:	6a 79                	push   $0x79
  jmp alltraps
80106630:	e9 09 f7 ff ff       	jmp    80105d3e <alltraps>

80106635 <vector122>:
.globl vector122
vector122:
  pushl $0
80106635:	6a 00                	push   $0x0
  pushl $122
80106637:	6a 7a                	push   $0x7a
  jmp alltraps
80106639:	e9 00 f7 ff ff       	jmp    80105d3e <alltraps>

8010663e <vector123>:
.globl vector123
vector123:
  pushl $0
8010663e:	6a 00                	push   $0x0
  pushl $123
80106640:	6a 7b                	push   $0x7b
  jmp alltraps
80106642:	e9 f7 f6 ff ff       	jmp    80105d3e <alltraps>

80106647 <vector124>:
.globl vector124
vector124:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $124
80106649:	6a 7c                	push   $0x7c
  jmp alltraps
8010664b:	e9 ee f6 ff ff       	jmp    80105d3e <alltraps>

80106650 <vector125>:
.globl vector125
vector125:
  pushl $0
80106650:	6a 00                	push   $0x0
  pushl $125
80106652:	6a 7d                	push   $0x7d
  jmp alltraps
80106654:	e9 e5 f6 ff ff       	jmp    80105d3e <alltraps>

80106659 <vector126>:
.globl vector126
vector126:
  pushl $0
80106659:	6a 00                	push   $0x0
  pushl $126
8010665b:	6a 7e                	push   $0x7e
  jmp alltraps
8010665d:	e9 dc f6 ff ff       	jmp    80105d3e <alltraps>

80106662 <vector127>:
.globl vector127
vector127:
  pushl $0
80106662:	6a 00                	push   $0x0
  pushl $127
80106664:	6a 7f                	push   $0x7f
  jmp alltraps
80106666:	e9 d3 f6 ff ff       	jmp    80105d3e <alltraps>

8010666b <vector128>:
.globl vector128
vector128:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $128
8010666d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106672:	e9 c7 f6 ff ff       	jmp    80105d3e <alltraps>

80106677 <vector129>:
.globl vector129
vector129:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $129
80106679:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010667e:	e9 bb f6 ff ff       	jmp    80105d3e <alltraps>

80106683 <vector130>:
.globl vector130
vector130:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $130
80106685:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010668a:	e9 af f6 ff ff       	jmp    80105d3e <alltraps>

8010668f <vector131>:
.globl vector131
vector131:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $131
80106691:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106696:	e9 a3 f6 ff ff       	jmp    80105d3e <alltraps>

8010669b <vector132>:
.globl vector132
vector132:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $132
8010669d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801066a2:	e9 97 f6 ff ff       	jmp    80105d3e <alltraps>

801066a7 <vector133>:
.globl vector133
vector133:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $133
801066a9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801066ae:	e9 8b f6 ff ff       	jmp    80105d3e <alltraps>

801066b3 <vector134>:
.globl vector134
vector134:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $134
801066b5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801066ba:	e9 7f f6 ff ff       	jmp    80105d3e <alltraps>

801066bf <vector135>:
.globl vector135
vector135:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $135
801066c1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801066c6:	e9 73 f6 ff ff       	jmp    80105d3e <alltraps>

801066cb <vector136>:
.globl vector136
vector136:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $136
801066cd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801066d2:	e9 67 f6 ff ff       	jmp    80105d3e <alltraps>

801066d7 <vector137>:
.globl vector137
vector137:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $137
801066d9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801066de:	e9 5b f6 ff ff       	jmp    80105d3e <alltraps>

801066e3 <vector138>:
.globl vector138
vector138:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $138
801066e5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801066ea:	e9 4f f6 ff ff       	jmp    80105d3e <alltraps>

801066ef <vector139>:
.globl vector139
vector139:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $139
801066f1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801066f6:	e9 43 f6 ff ff       	jmp    80105d3e <alltraps>

801066fb <vector140>:
.globl vector140
vector140:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $140
801066fd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106702:	e9 37 f6 ff ff       	jmp    80105d3e <alltraps>

80106707 <vector141>:
.globl vector141
vector141:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $141
80106709:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010670e:	e9 2b f6 ff ff       	jmp    80105d3e <alltraps>

80106713 <vector142>:
.globl vector142
vector142:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $142
80106715:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010671a:	e9 1f f6 ff ff       	jmp    80105d3e <alltraps>

8010671f <vector143>:
.globl vector143
vector143:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $143
80106721:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106726:	e9 13 f6 ff ff       	jmp    80105d3e <alltraps>

8010672b <vector144>:
.globl vector144
vector144:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $144
8010672d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106732:	e9 07 f6 ff ff       	jmp    80105d3e <alltraps>

80106737 <vector145>:
.globl vector145
vector145:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $145
80106739:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010673e:	e9 fb f5 ff ff       	jmp    80105d3e <alltraps>

80106743 <vector146>:
.globl vector146
vector146:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $146
80106745:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010674a:	e9 ef f5 ff ff       	jmp    80105d3e <alltraps>

8010674f <vector147>:
.globl vector147
vector147:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $147
80106751:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106756:	e9 e3 f5 ff ff       	jmp    80105d3e <alltraps>

8010675b <vector148>:
.globl vector148
vector148:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $148
8010675d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106762:	e9 d7 f5 ff ff       	jmp    80105d3e <alltraps>

80106767 <vector149>:
.globl vector149
vector149:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $149
80106769:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010676e:	e9 cb f5 ff ff       	jmp    80105d3e <alltraps>

80106773 <vector150>:
.globl vector150
vector150:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $150
80106775:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010677a:	e9 bf f5 ff ff       	jmp    80105d3e <alltraps>

8010677f <vector151>:
.globl vector151
vector151:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $151
80106781:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106786:	e9 b3 f5 ff ff       	jmp    80105d3e <alltraps>

8010678b <vector152>:
.globl vector152
vector152:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $152
8010678d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106792:	e9 a7 f5 ff ff       	jmp    80105d3e <alltraps>

80106797 <vector153>:
.globl vector153
vector153:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $153
80106799:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010679e:	e9 9b f5 ff ff       	jmp    80105d3e <alltraps>

801067a3 <vector154>:
.globl vector154
vector154:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $154
801067a5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801067aa:	e9 8f f5 ff ff       	jmp    80105d3e <alltraps>

801067af <vector155>:
.globl vector155
vector155:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $155
801067b1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801067b6:	e9 83 f5 ff ff       	jmp    80105d3e <alltraps>

801067bb <vector156>:
.globl vector156
vector156:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $156
801067bd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801067c2:	e9 77 f5 ff ff       	jmp    80105d3e <alltraps>

801067c7 <vector157>:
.globl vector157
vector157:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $157
801067c9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801067ce:	e9 6b f5 ff ff       	jmp    80105d3e <alltraps>

801067d3 <vector158>:
.globl vector158
vector158:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $158
801067d5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801067da:	e9 5f f5 ff ff       	jmp    80105d3e <alltraps>

801067df <vector159>:
.globl vector159
vector159:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $159
801067e1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801067e6:	e9 53 f5 ff ff       	jmp    80105d3e <alltraps>

801067eb <vector160>:
.globl vector160
vector160:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $160
801067ed:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801067f2:	e9 47 f5 ff ff       	jmp    80105d3e <alltraps>

801067f7 <vector161>:
.globl vector161
vector161:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $161
801067f9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801067fe:	e9 3b f5 ff ff       	jmp    80105d3e <alltraps>

80106803 <vector162>:
.globl vector162
vector162:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $162
80106805:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010680a:	e9 2f f5 ff ff       	jmp    80105d3e <alltraps>

8010680f <vector163>:
.globl vector163
vector163:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $163
80106811:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106816:	e9 23 f5 ff ff       	jmp    80105d3e <alltraps>

8010681b <vector164>:
.globl vector164
vector164:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $164
8010681d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106822:	e9 17 f5 ff ff       	jmp    80105d3e <alltraps>

80106827 <vector165>:
.globl vector165
vector165:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $165
80106829:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010682e:	e9 0b f5 ff ff       	jmp    80105d3e <alltraps>

80106833 <vector166>:
.globl vector166
vector166:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $166
80106835:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010683a:	e9 ff f4 ff ff       	jmp    80105d3e <alltraps>

8010683f <vector167>:
.globl vector167
vector167:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $167
80106841:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106846:	e9 f3 f4 ff ff       	jmp    80105d3e <alltraps>

8010684b <vector168>:
.globl vector168
vector168:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $168
8010684d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106852:	e9 e7 f4 ff ff       	jmp    80105d3e <alltraps>

80106857 <vector169>:
.globl vector169
vector169:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $169
80106859:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010685e:	e9 db f4 ff ff       	jmp    80105d3e <alltraps>

80106863 <vector170>:
.globl vector170
vector170:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $170
80106865:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010686a:	e9 cf f4 ff ff       	jmp    80105d3e <alltraps>

8010686f <vector171>:
.globl vector171
vector171:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $171
80106871:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106876:	e9 c3 f4 ff ff       	jmp    80105d3e <alltraps>

8010687b <vector172>:
.globl vector172
vector172:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $172
8010687d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106882:	e9 b7 f4 ff ff       	jmp    80105d3e <alltraps>

80106887 <vector173>:
.globl vector173
vector173:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $173
80106889:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010688e:	e9 ab f4 ff ff       	jmp    80105d3e <alltraps>

80106893 <vector174>:
.globl vector174
vector174:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $174
80106895:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010689a:	e9 9f f4 ff ff       	jmp    80105d3e <alltraps>

8010689f <vector175>:
.globl vector175
vector175:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $175
801068a1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801068a6:	e9 93 f4 ff ff       	jmp    80105d3e <alltraps>

801068ab <vector176>:
.globl vector176
vector176:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $176
801068ad:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801068b2:	e9 87 f4 ff ff       	jmp    80105d3e <alltraps>

801068b7 <vector177>:
.globl vector177
vector177:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $177
801068b9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801068be:	e9 7b f4 ff ff       	jmp    80105d3e <alltraps>

801068c3 <vector178>:
.globl vector178
vector178:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $178
801068c5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801068ca:	e9 6f f4 ff ff       	jmp    80105d3e <alltraps>

801068cf <vector179>:
.globl vector179
vector179:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $179
801068d1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801068d6:	e9 63 f4 ff ff       	jmp    80105d3e <alltraps>

801068db <vector180>:
.globl vector180
vector180:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $180
801068dd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801068e2:	e9 57 f4 ff ff       	jmp    80105d3e <alltraps>

801068e7 <vector181>:
.globl vector181
vector181:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $181
801068e9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801068ee:	e9 4b f4 ff ff       	jmp    80105d3e <alltraps>

801068f3 <vector182>:
.globl vector182
vector182:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $182
801068f5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801068fa:	e9 3f f4 ff ff       	jmp    80105d3e <alltraps>

801068ff <vector183>:
.globl vector183
vector183:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $183
80106901:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106906:	e9 33 f4 ff ff       	jmp    80105d3e <alltraps>

8010690b <vector184>:
.globl vector184
vector184:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $184
8010690d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106912:	e9 27 f4 ff ff       	jmp    80105d3e <alltraps>

80106917 <vector185>:
.globl vector185
vector185:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $185
80106919:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010691e:	e9 1b f4 ff ff       	jmp    80105d3e <alltraps>

80106923 <vector186>:
.globl vector186
vector186:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $186
80106925:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010692a:	e9 0f f4 ff ff       	jmp    80105d3e <alltraps>

8010692f <vector187>:
.globl vector187
vector187:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $187
80106931:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106936:	e9 03 f4 ff ff       	jmp    80105d3e <alltraps>

8010693b <vector188>:
.globl vector188
vector188:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $188
8010693d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106942:	e9 f7 f3 ff ff       	jmp    80105d3e <alltraps>

80106947 <vector189>:
.globl vector189
vector189:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $189
80106949:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010694e:	e9 eb f3 ff ff       	jmp    80105d3e <alltraps>

80106953 <vector190>:
.globl vector190
vector190:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $190
80106955:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010695a:	e9 df f3 ff ff       	jmp    80105d3e <alltraps>

8010695f <vector191>:
.globl vector191
vector191:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $191
80106961:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106966:	e9 d3 f3 ff ff       	jmp    80105d3e <alltraps>

8010696b <vector192>:
.globl vector192
vector192:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $192
8010696d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106972:	e9 c7 f3 ff ff       	jmp    80105d3e <alltraps>

80106977 <vector193>:
.globl vector193
vector193:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $193
80106979:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010697e:	e9 bb f3 ff ff       	jmp    80105d3e <alltraps>

80106983 <vector194>:
.globl vector194
vector194:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $194
80106985:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010698a:	e9 af f3 ff ff       	jmp    80105d3e <alltraps>

8010698f <vector195>:
.globl vector195
vector195:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $195
80106991:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106996:	e9 a3 f3 ff ff       	jmp    80105d3e <alltraps>

8010699b <vector196>:
.globl vector196
vector196:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $196
8010699d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801069a2:	e9 97 f3 ff ff       	jmp    80105d3e <alltraps>

801069a7 <vector197>:
.globl vector197
vector197:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $197
801069a9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801069ae:	e9 8b f3 ff ff       	jmp    80105d3e <alltraps>

801069b3 <vector198>:
.globl vector198
vector198:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $198
801069b5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801069ba:	e9 7f f3 ff ff       	jmp    80105d3e <alltraps>

801069bf <vector199>:
.globl vector199
vector199:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $199
801069c1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801069c6:	e9 73 f3 ff ff       	jmp    80105d3e <alltraps>

801069cb <vector200>:
.globl vector200
vector200:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $200
801069cd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801069d2:	e9 67 f3 ff ff       	jmp    80105d3e <alltraps>

801069d7 <vector201>:
.globl vector201
vector201:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $201
801069d9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801069de:	e9 5b f3 ff ff       	jmp    80105d3e <alltraps>

801069e3 <vector202>:
.globl vector202
vector202:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $202
801069e5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801069ea:	e9 4f f3 ff ff       	jmp    80105d3e <alltraps>

801069ef <vector203>:
.globl vector203
vector203:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $203
801069f1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801069f6:	e9 43 f3 ff ff       	jmp    80105d3e <alltraps>

801069fb <vector204>:
.globl vector204
vector204:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $204
801069fd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a02:	e9 37 f3 ff ff       	jmp    80105d3e <alltraps>

80106a07 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $205
80106a09:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a0e:	e9 2b f3 ff ff       	jmp    80105d3e <alltraps>

80106a13 <vector206>:
.globl vector206
vector206:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $206
80106a15:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a1a:	e9 1f f3 ff ff       	jmp    80105d3e <alltraps>

80106a1f <vector207>:
.globl vector207
vector207:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $207
80106a21:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a26:	e9 13 f3 ff ff       	jmp    80105d3e <alltraps>

80106a2b <vector208>:
.globl vector208
vector208:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $208
80106a2d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a32:	e9 07 f3 ff ff       	jmp    80105d3e <alltraps>

80106a37 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $209
80106a39:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a3e:	e9 fb f2 ff ff       	jmp    80105d3e <alltraps>

80106a43 <vector210>:
.globl vector210
vector210:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $210
80106a45:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a4a:	e9 ef f2 ff ff       	jmp    80105d3e <alltraps>

80106a4f <vector211>:
.globl vector211
vector211:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $211
80106a51:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a56:	e9 e3 f2 ff ff       	jmp    80105d3e <alltraps>

80106a5b <vector212>:
.globl vector212
vector212:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $212
80106a5d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a62:	e9 d7 f2 ff ff       	jmp    80105d3e <alltraps>

80106a67 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $213
80106a69:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a6e:	e9 cb f2 ff ff       	jmp    80105d3e <alltraps>

80106a73 <vector214>:
.globl vector214
vector214:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $214
80106a75:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a7a:	e9 bf f2 ff ff       	jmp    80105d3e <alltraps>

80106a7f <vector215>:
.globl vector215
vector215:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $215
80106a81:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a86:	e9 b3 f2 ff ff       	jmp    80105d3e <alltraps>

80106a8b <vector216>:
.globl vector216
vector216:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $216
80106a8d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a92:	e9 a7 f2 ff ff       	jmp    80105d3e <alltraps>

80106a97 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $217
80106a99:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a9e:	e9 9b f2 ff ff       	jmp    80105d3e <alltraps>

80106aa3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $218
80106aa5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106aaa:	e9 8f f2 ff ff       	jmp    80105d3e <alltraps>

80106aaf <vector219>:
.globl vector219
vector219:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $219
80106ab1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ab6:	e9 83 f2 ff ff       	jmp    80105d3e <alltraps>

80106abb <vector220>:
.globl vector220
vector220:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $220
80106abd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ac2:	e9 77 f2 ff ff       	jmp    80105d3e <alltraps>

80106ac7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $221
80106ac9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106ace:	e9 6b f2 ff ff       	jmp    80105d3e <alltraps>

80106ad3 <vector222>:
.globl vector222
vector222:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $222
80106ad5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ada:	e9 5f f2 ff ff       	jmp    80105d3e <alltraps>

80106adf <vector223>:
.globl vector223
vector223:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $223
80106ae1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ae6:	e9 53 f2 ff ff       	jmp    80105d3e <alltraps>

80106aeb <vector224>:
.globl vector224
vector224:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $224
80106aed:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106af2:	e9 47 f2 ff ff       	jmp    80105d3e <alltraps>

80106af7 <vector225>:
.globl vector225
vector225:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $225
80106af9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106afe:	e9 3b f2 ff ff       	jmp    80105d3e <alltraps>

80106b03 <vector226>:
.globl vector226
vector226:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $226
80106b05:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b0a:	e9 2f f2 ff ff       	jmp    80105d3e <alltraps>

80106b0f <vector227>:
.globl vector227
vector227:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $227
80106b11:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b16:	e9 23 f2 ff ff       	jmp    80105d3e <alltraps>

80106b1b <vector228>:
.globl vector228
vector228:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $228
80106b1d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b22:	e9 17 f2 ff ff       	jmp    80105d3e <alltraps>

80106b27 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $229
80106b29:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b2e:	e9 0b f2 ff ff       	jmp    80105d3e <alltraps>

80106b33 <vector230>:
.globl vector230
vector230:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $230
80106b35:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b3a:	e9 ff f1 ff ff       	jmp    80105d3e <alltraps>

80106b3f <vector231>:
.globl vector231
vector231:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $231
80106b41:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b46:	e9 f3 f1 ff ff       	jmp    80105d3e <alltraps>

80106b4b <vector232>:
.globl vector232
vector232:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $232
80106b4d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b52:	e9 e7 f1 ff ff       	jmp    80105d3e <alltraps>

80106b57 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $233
80106b59:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b5e:	e9 db f1 ff ff       	jmp    80105d3e <alltraps>

80106b63 <vector234>:
.globl vector234
vector234:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $234
80106b65:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b6a:	e9 cf f1 ff ff       	jmp    80105d3e <alltraps>

80106b6f <vector235>:
.globl vector235
vector235:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $235
80106b71:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b76:	e9 c3 f1 ff ff       	jmp    80105d3e <alltraps>

80106b7b <vector236>:
.globl vector236
vector236:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $236
80106b7d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b82:	e9 b7 f1 ff ff       	jmp    80105d3e <alltraps>

80106b87 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $237
80106b89:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b8e:	e9 ab f1 ff ff       	jmp    80105d3e <alltraps>

80106b93 <vector238>:
.globl vector238
vector238:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $238
80106b95:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b9a:	e9 9f f1 ff ff       	jmp    80105d3e <alltraps>

80106b9f <vector239>:
.globl vector239
vector239:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $239
80106ba1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ba6:	e9 93 f1 ff ff       	jmp    80105d3e <alltraps>

80106bab <vector240>:
.globl vector240
vector240:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $240
80106bad:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106bb2:	e9 87 f1 ff ff       	jmp    80105d3e <alltraps>

80106bb7 <vector241>:
.globl vector241
vector241:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $241
80106bb9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106bbe:	e9 7b f1 ff ff       	jmp    80105d3e <alltraps>

80106bc3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $242
80106bc5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106bca:	e9 6f f1 ff ff       	jmp    80105d3e <alltraps>

80106bcf <vector243>:
.globl vector243
vector243:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $243
80106bd1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106bd6:	e9 63 f1 ff ff       	jmp    80105d3e <alltraps>

80106bdb <vector244>:
.globl vector244
vector244:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $244
80106bdd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106be2:	e9 57 f1 ff ff       	jmp    80105d3e <alltraps>

80106be7 <vector245>:
.globl vector245
vector245:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $245
80106be9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106bee:	e9 4b f1 ff ff       	jmp    80105d3e <alltraps>

80106bf3 <vector246>:
.globl vector246
vector246:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $246
80106bf5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106bfa:	e9 3f f1 ff ff       	jmp    80105d3e <alltraps>

80106bff <vector247>:
.globl vector247
vector247:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $247
80106c01:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c06:	e9 33 f1 ff ff       	jmp    80105d3e <alltraps>

80106c0b <vector248>:
.globl vector248
vector248:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $248
80106c0d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c12:	e9 27 f1 ff ff       	jmp    80105d3e <alltraps>

80106c17 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $249
80106c19:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c1e:	e9 1b f1 ff ff       	jmp    80105d3e <alltraps>

80106c23 <vector250>:
.globl vector250
vector250:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $250
80106c25:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c2a:	e9 0f f1 ff ff       	jmp    80105d3e <alltraps>

80106c2f <vector251>:
.globl vector251
vector251:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $251
80106c31:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c36:	e9 03 f1 ff ff       	jmp    80105d3e <alltraps>

80106c3b <vector252>:
.globl vector252
vector252:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $252
80106c3d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c42:	e9 f7 f0 ff ff       	jmp    80105d3e <alltraps>

80106c47 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $253
80106c49:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c4e:	e9 eb f0 ff ff       	jmp    80105d3e <alltraps>

80106c53 <vector254>:
.globl vector254
vector254:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $254
80106c55:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c5a:	e9 df f0 ff ff       	jmp    80105d3e <alltraps>

80106c5f <vector255>:
.globl vector255
vector255:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $255
80106c61:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c66:	e9 d3 f0 ff ff       	jmp    80105d3e <alltraps>
80106c6b:	66 90                	xchg   %ax,%ax
80106c6d:	66 90                	xchg   %ax,%ax
80106c6f:	90                   	nop

80106c70 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106c70:	55                   	push   %ebp
80106c71:	89 e5                	mov    %esp,%ebp
80106c73:	57                   	push   %edi
80106c74:	56                   	push   %esi
80106c75:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106c77:	c1 ea 16             	shr    $0x16,%edx
{
80106c7a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106c7b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106c7e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106c81:	8b 1f                	mov    (%edi),%ebx
80106c83:	f6 c3 01             	test   $0x1,%bl
80106c86:	74 28                	je     80106cb0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c88:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106c8e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106c94:	89 f0                	mov    %esi,%eax
}
80106c96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106c99:	c1 e8 0a             	shr    $0xa,%eax
80106c9c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106ca1:	01 d8                	add    %ebx,%eax
}
80106ca3:	5b                   	pop    %ebx
80106ca4:	5e                   	pop    %esi
80106ca5:	5f                   	pop    %edi
80106ca6:	5d                   	pop    %ebp
80106ca7:	c3                   	ret    
80106ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106caf:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106cb0:	85 c9                	test   %ecx,%ecx
80106cb2:	74 2c                	je     80106ce0 <walkpgdir+0x70>
80106cb4:	e8 47 be ff ff       	call   80102b00 <kalloc>
80106cb9:	89 c3                	mov    %eax,%ebx
80106cbb:	85 c0                	test   %eax,%eax
80106cbd:	74 21                	je     80106ce0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106cbf:	83 ec 04             	sub    $0x4,%esp
80106cc2:	68 00 10 00 00       	push   $0x1000
80106cc7:	6a 00                	push   $0x0
80106cc9:	50                   	push   %eax
80106cca:	e8 71 de ff ff       	call   80104b40 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ccf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cd5:	83 c4 10             	add    $0x10,%esp
80106cd8:	83 c8 07             	or     $0x7,%eax
80106cdb:	89 07                	mov    %eax,(%edi)
80106cdd:	eb b5                	jmp    80106c94 <walkpgdir+0x24>
80106cdf:	90                   	nop
}
80106ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ce3:	31 c0                	xor    %eax,%eax
}
80106ce5:	5b                   	pop    %ebx
80106ce6:	5e                   	pop    %esi
80106ce7:	5f                   	pop    %edi
80106ce8:	5d                   	pop    %ebp
80106ce9:	c3                   	ret    
80106cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106cf0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	57                   	push   %edi
80106cf4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106cf6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106cfa:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106cfb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106d00:	89 d6                	mov    %edx,%esi
{
80106d02:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106d03:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106d09:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d0f:	8b 45 08             	mov    0x8(%ebp),%eax
80106d12:	29 f0                	sub    %esi,%eax
80106d14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d17:	eb 1f                	jmp    80106d38 <mappages+0x48>
80106d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106d20:	f6 00 01             	testb  $0x1,(%eax)
80106d23:	75 45                	jne    80106d6a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d25:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106d28:	83 cb 01             	or     $0x1,%ebx
80106d2b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106d2d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106d30:	74 2e                	je     80106d60 <mappages+0x70>
      break;
    a += PGSIZE;
80106d32:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106d38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d3b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106d40:	89 f2                	mov    %esi,%edx
80106d42:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106d45:	89 f8                	mov    %edi,%eax
80106d47:	e8 24 ff ff ff       	call   80106c70 <walkpgdir>
80106d4c:	85 c0                	test   %eax,%eax
80106d4e:	75 d0                	jne    80106d20 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d58:	5b                   	pop    %ebx
80106d59:	5e                   	pop    %esi
80106d5a:	5f                   	pop    %edi
80106d5b:	5d                   	pop    %ebp
80106d5c:	c3                   	ret    
80106d5d:	8d 76 00             	lea    0x0(%esi),%esi
80106d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d63:	31 c0                	xor    %eax,%eax
}
80106d65:	5b                   	pop    %ebx
80106d66:	5e                   	pop    %esi
80106d67:	5f                   	pop    %edi
80106d68:	5d                   	pop    %ebp
80106d69:	c3                   	ret    
      panic("remap");
80106d6a:	83 ec 0c             	sub    $0xc,%esp
80106d6d:	68 c8 7e 10 80       	push   $0x80107ec8
80106d72:	e8 19 96 ff ff       	call   80100390 <panic>
80106d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d7e:	66 90                	xchg   %ax,%ax

80106d80 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	57                   	push   %edi
80106d84:	56                   	push   %esi
80106d85:	89 c6                	mov    %eax,%esi
80106d87:	53                   	push   %ebx
80106d88:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106d8a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106d90:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d96:	83 ec 1c             	sub    $0x1c,%esp
80106d99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d9c:	39 da                	cmp    %ebx,%edx
80106d9e:	73 5b                	jae    80106dfb <deallocuvm.part.0+0x7b>
80106da0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106da3:	89 d7                	mov    %edx,%edi
80106da5:	eb 14                	jmp    80106dbb <deallocuvm.part.0+0x3b>
80106da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dae:	66 90                	xchg   %ax,%ax
80106db0:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106db6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106db9:	76 40                	jbe    80106dfb <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106dbb:	31 c9                	xor    %ecx,%ecx
80106dbd:	89 fa                	mov    %edi,%edx
80106dbf:	89 f0                	mov    %esi,%eax
80106dc1:	e8 aa fe ff ff       	call   80106c70 <walkpgdir>
80106dc6:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106dc8:	85 c0                	test   %eax,%eax
80106dca:	74 44                	je     80106e10 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106dcc:	8b 00                	mov    (%eax),%eax
80106dce:	a8 01                	test   $0x1,%al
80106dd0:	74 de                	je     80106db0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106dd2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dd7:	74 47                	je     80106e20 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106dd9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106ddc:	05 00 00 00 80       	add    $0x80000000,%eax
80106de1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106de7:	50                   	push   %eax
80106de8:	e8 53 bb ff ff       	call   80102940 <kfree>
      *pte = 0;
80106ded:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106df3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106df6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106df9:	77 c0                	ja     80106dbb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80106dfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106dfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e01:	5b                   	pop    %ebx
80106e02:	5e                   	pop    %esi
80106e03:	5f                   	pop    %edi
80106e04:	5d                   	pop    %ebp
80106e05:	c3                   	ret    
80106e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e0d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106e10:	89 fa                	mov    %edi,%edx
80106e12:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106e18:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80106e1e:	eb 96                	jmp    80106db6 <deallocuvm.part.0+0x36>
        panic("kfree");
80106e20:	83 ec 0c             	sub    $0xc,%esp
80106e23:	68 7e 78 10 80       	push   $0x8010787e
80106e28:	e8 63 95 ff ff       	call   80100390 <panic>
80106e2d:	8d 76 00             	lea    0x0(%esi),%esi

80106e30 <seginit>:
{
80106e30:	f3 0f 1e fb          	endbr32 
80106e34:	55                   	push   %ebp
80106e35:	89 e5                	mov    %esp,%ebp
80106e37:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e3a:	e8 d1 cf ff ff       	call   80103e10 <cpuid>
  pd[0] = size-1;
80106e3f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106e44:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106e4a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e4e:	c7 80 98 2d 11 80 ff 	movl   $0xffff,-0x7feed268(%eax)
80106e55:	ff 00 00 
80106e58:	c7 80 9c 2d 11 80 00 	movl   $0xcf9a00,-0x7feed264(%eax)
80106e5f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e62:	c7 80 a0 2d 11 80 ff 	movl   $0xffff,-0x7feed260(%eax)
80106e69:	ff 00 00 
80106e6c:	c7 80 a4 2d 11 80 00 	movl   $0xcf9200,-0x7feed25c(%eax)
80106e73:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e76:	c7 80 a8 2d 11 80 ff 	movl   $0xffff,-0x7feed258(%eax)
80106e7d:	ff 00 00 
80106e80:	c7 80 ac 2d 11 80 00 	movl   $0xcffa00,-0x7feed254(%eax)
80106e87:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e8a:	c7 80 b0 2d 11 80 ff 	movl   $0xffff,-0x7feed250(%eax)
80106e91:	ff 00 00 
80106e94:	c7 80 b4 2d 11 80 00 	movl   $0xcff200,-0x7feed24c(%eax)
80106e9b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106e9e:	05 90 2d 11 80       	add    $0x80112d90,%eax
  pd[1] = (uint)p;
80106ea3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ea7:	c1 e8 10             	shr    $0x10,%eax
80106eaa:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106eae:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106eb1:	0f 01 10             	lgdtl  (%eax)
}
80106eb4:	c9                   	leave  
80106eb5:	c3                   	ret    
80106eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebd:	8d 76 00             	lea    0x0(%esi),%esi

80106ec0 <switchkvm>:
{
80106ec0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ec4:	a1 44 5a 11 80       	mov    0x80115a44,%eax
80106ec9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ece:	0f 22 d8             	mov    %eax,%cr3
}
80106ed1:	c3                   	ret    
80106ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ee0 <switchuvm>:
{
80106ee0:	f3 0f 1e fb          	endbr32 
80106ee4:	55                   	push   %ebp
80106ee5:	89 e5                	mov    %esp,%ebp
80106ee7:	57                   	push   %edi
80106ee8:	56                   	push   %esi
80106ee9:	53                   	push   %ebx
80106eea:	83 ec 1c             	sub    $0x1c,%esp
80106eed:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106ef0:	85 f6                	test   %esi,%esi
80106ef2:	0f 84 cb 00 00 00    	je     80106fc3 <switchuvm+0xe3>
  if(p->kstack == 0)
80106ef8:	8b 46 08             	mov    0x8(%esi),%eax
80106efb:	85 c0                	test   %eax,%eax
80106efd:	0f 84 da 00 00 00    	je     80106fdd <switchuvm+0xfd>
  if(p->pgdir == 0)
80106f03:	8b 46 04             	mov    0x4(%esi),%eax
80106f06:	85 c0                	test   %eax,%eax
80106f08:	0f 84 c2 00 00 00    	je     80106fd0 <switchuvm+0xf0>
  pushcli();
80106f0e:	e8 1d da ff ff       	call   80104930 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f13:	e8 88 ce ff ff       	call   80103da0 <mycpu>
80106f18:	89 c3                	mov    %eax,%ebx
80106f1a:	e8 81 ce ff ff       	call   80103da0 <mycpu>
80106f1f:	89 c7                	mov    %eax,%edi
80106f21:	e8 7a ce ff ff       	call   80103da0 <mycpu>
80106f26:	83 c7 08             	add    $0x8,%edi
80106f29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f2c:	e8 6f ce ff ff       	call   80103da0 <mycpu>
80106f31:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f34:	ba 67 00 00 00       	mov    $0x67,%edx
80106f39:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f40:	83 c0 08             	add    $0x8,%eax
80106f43:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f4a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f4f:	83 c1 08             	add    $0x8,%ecx
80106f52:	c1 e8 18             	shr    $0x18,%eax
80106f55:	c1 e9 10             	shr    $0x10,%ecx
80106f58:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f5e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f64:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f69:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f70:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106f75:	e8 26 ce ff ff       	call   80103da0 <mycpu>
80106f7a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f81:	e8 1a ce ff ff       	call   80103da0 <mycpu>
80106f86:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f8a:	8b 5e 08             	mov    0x8(%esi),%ebx
80106f8d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f93:	e8 08 ce ff ff       	call   80103da0 <mycpu>
80106f98:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f9b:	e8 00 ce ff ff       	call   80103da0 <mycpu>
80106fa0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106fa4:	b8 28 00 00 00       	mov    $0x28,%eax
80106fa9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106fac:	8b 46 04             	mov    0x4(%esi),%eax
80106faf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fb4:	0f 22 d8             	mov    %eax,%cr3
}
80106fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fba:	5b                   	pop    %ebx
80106fbb:	5e                   	pop    %esi
80106fbc:	5f                   	pop    %edi
80106fbd:	5d                   	pop    %ebp
  popcli();
80106fbe:	e9 bd d9 ff ff       	jmp    80104980 <popcli>
    panic("switchuvm: no process");
80106fc3:	83 ec 0c             	sub    $0xc,%esp
80106fc6:	68 ce 7e 10 80       	push   $0x80107ece
80106fcb:	e8 c0 93 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106fd0:	83 ec 0c             	sub    $0xc,%esp
80106fd3:	68 f9 7e 10 80       	push   $0x80107ef9
80106fd8:	e8 b3 93 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106fdd:	83 ec 0c             	sub    $0xc,%esp
80106fe0:	68 e4 7e 10 80       	push   $0x80107ee4
80106fe5:	e8 a6 93 ff ff       	call   80100390 <panic>
80106fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ff0 <inituvm>:
{
80106ff0:	f3 0f 1e fb          	endbr32 
80106ff4:	55                   	push   %ebp
80106ff5:	89 e5                	mov    %esp,%ebp
80106ff7:	57                   	push   %edi
80106ff8:	56                   	push   %esi
80106ff9:	53                   	push   %ebx
80106ffa:	83 ec 1c             	sub    $0x1c,%esp
80106ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107000:	8b 75 10             	mov    0x10(%ebp),%esi
80107003:	8b 7d 08             	mov    0x8(%ebp),%edi
80107006:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107009:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010700f:	77 4b                	ja     8010705c <inituvm+0x6c>
  mem = kalloc();
80107011:	e8 ea ba ff ff       	call   80102b00 <kalloc>
  memset(mem, 0, PGSIZE);
80107016:	83 ec 04             	sub    $0x4,%esp
80107019:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010701e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107020:	6a 00                	push   $0x0
80107022:	50                   	push   %eax
80107023:	e8 18 db ff ff       	call   80104b40 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107028:	58                   	pop    %eax
80107029:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010702f:	5a                   	pop    %edx
80107030:	6a 06                	push   $0x6
80107032:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107037:	31 d2                	xor    %edx,%edx
80107039:	50                   	push   %eax
8010703a:	89 f8                	mov    %edi,%eax
8010703c:	e8 af fc ff ff       	call   80106cf0 <mappages>
  memmove(mem, init, sz);
80107041:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107044:	89 75 10             	mov    %esi,0x10(%ebp)
80107047:	83 c4 10             	add    $0x10,%esp
8010704a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010704d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107050:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107053:	5b                   	pop    %ebx
80107054:	5e                   	pop    %esi
80107055:	5f                   	pop    %edi
80107056:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107057:	e9 84 db ff ff       	jmp    80104be0 <memmove>
    panic("inituvm: more than a page");
8010705c:	83 ec 0c             	sub    $0xc,%esp
8010705f:	68 0d 7f 10 80       	push   $0x80107f0d
80107064:	e8 27 93 ff ff       	call   80100390 <panic>
80107069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107070 <loaduvm>:
{
80107070:	f3 0f 1e fb          	endbr32 
80107074:	55                   	push   %ebp
80107075:	89 e5                	mov    %esp,%ebp
80107077:	57                   	push   %edi
80107078:	56                   	push   %esi
80107079:	53                   	push   %ebx
8010707a:	83 ec 1c             	sub    $0x1c,%esp
8010707d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107080:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107083:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107088:	0f 85 99 00 00 00    	jne    80107127 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010708e:	01 f0                	add    %esi,%eax
80107090:	89 f3                	mov    %esi,%ebx
80107092:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107095:	8b 45 14             	mov    0x14(%ebp),%eax
80107098:	01 f0                	add    %esi,%eax
8010709a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010709d:	85 f6                	test   %esi,%esi
8010709f:	75 15                	jne    801070b6 <loaduvm+0x46>
801070a1:	eb 6d                	jmp    80107110 <loaduvm+0xa0>
801070a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070a7:	90                   	nop
801070a8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801070ae:	89 f0                	mov    %esi,%eax
801070b0:	29 d8                	sub    %ebx,%eax
801070b2:	39 c6                	cmp    %eax,%esi
801070b4:	76 5a                	jbe    80107110 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801070b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801070b9:	8b 45 08             	mov    0x8(%ebp),%eax
801070bc:	31 c9                	xor    %ecx,%ecx
801070be:	29 da                	sub    %ebx,%edx
801070c0:	e8 ab fb ff ff       	call   80106c70 <walkpgdir>
801070c5:	85 c0                	test   %eax,%eax
801070c7:	74 51                	je     8010711a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801070c9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070cb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801070ce:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801070d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801070d8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801070de:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070e1:	29 d9                	sub    %ebx,%ecx
801070e3:	05 00 00 00 80       	add    $0x80000000,%eax
801070e8:	57                   	push   %edi
801070e9:	51                   	push   %ecx
801070ea:	50                   	push   %eax
801070eb:	ff 75 10             	pushl  0x10(%ebp)
801070ee:	e8 3d ae ff ff       	call   80101f30 <readi>
801070f3:	83 c4 10             	add    $0x10,%esp
801070f6:	39 f8                	cmp    %edi,%eax
801070f8:	74 ae                	je     801070a8 <loaduvm+0x38>
}
801070fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107102:	5b                   	pop    %ebx
80107103:	5e                   	pop    %esi
80107104:	5f                   	pop    %edi
80107105:	5d                   	pop    %ebp
80107106:	c3                   	ret    
80107107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010710e:	66 90                	xchg   %ax,%ax
80107110:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107113:	31 c0                	xor    %eax,%eax
}
80107115:	5b                   	pop    %ebx
80107116:	5e                   	pop    %esi
80107117:	5f                   	pop    %edi
80107118:	5d                   	pop    %ebp
80107119:	c3                   	ret    
      panic("loaduvm: address should exist");
8010711a:	83 ec 0c             	sub    $0xc,%esp
8010711d:	68 27 7f 10 80       	push   $0x80107f27
80107122:	e8 69 92 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107127:	83 ec 0c             	sub    $0xc,%esp
8010712a:	68 c8 7f 10 80       	push   $0x80107fc8
8010712f:	e8 5c 92 ff ff       	call   80100390 <panic>
80107134:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010713f:	90                   	nop

80107140 <allocuvm>:
{
80107140:	f3 0f 1e fb          	endbr32 
80107144:	55                   	push   %ebp
80107145:	89 e5                	mov    %esp,%ebp
80107147:	57                   	push   %edi
80107148:	56                   	push   %esi
80107149:	53                   	push   %ebx
8010714a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010714d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107150:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107153:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107156:	85 c0                	test   %eax,%eax
80107158:	0f 88 b2 00 00 00    	js     80107210 <allocuvm+0xd0>
  if(newsz < oldsz)
8010715e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107161:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107164:	0f 82 96 00 00 00    	jb     80107200 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010716a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107170:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107176:	39 75 10             	cmp    %esi,0x10(%ebp)
80107179:	77 40                	ja     801071bb <allocuvm+0x7b>
8010717b:	e9 83 00 00 00       	jmp    80107203 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107180:	83 ec 04             	sub    $0x4,%esp
80107183:	68 00 10 00 00       	push   $0x1000
80107188:	6a 00                	push   $0x0
8010718a:	50                   	push   %eax
8010718b:	e8 b0 d9 ff ff       	call   80104b40 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107190:	58                   	pop    %eax
80107191:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107197:	5a                   	pop    %edx
80107198:	6a 06                	push   $0x6
8010719a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010719f:	89 f2                	mov    %esi,%edx
801071a1:	50                   	push   %eax
801071a2:	89 f8                	mov    %edi,%eax
801071a4:	e8 47 fb ff ff       	call   80106cf0 <mappages>
801071a9:	83 c4 10             	add    $0x10,%esp
801071ac:	85 c0                	test   %eax,%eax
801071ae:	78 78                	js     80107228 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801071b0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801071b6:	39 75 10             	cmp    %esi,0x10(%ebp)
801071b9:	76 48                	jbe    80107203 <allocuvm+0xc3>
    mem = kalloc();
801071bb:	e8 40 b9 ff ff       	call   80102b00 <kalloc>
801071c0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801071c2:	85 c0                	test   %eax,%eax
801071c4:	75 ba                	jne    80107180 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801071c6:	83 ec 0c             	sub    $0xc,%esp
801071c9:	68 45 7f 10 80       	push   $0x80107f45
801071ce:	e8 cd 96 ff ff       	call   801008a0 <cprintf>
  if(newsz >= oldsz)
801071d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801071d6:	83 c4 10             	add    $0x10,%esp
801071d9:	39 45 10             	cmp    %eax,0x10(%ebp)
801071dc:	74 32                	je     80107210 <allocuvm+0xd0>
801071de:	8b 55 10             	mov    0x10(%ebp),%edx
801071e1:	89 c1                	mov    %eax,%ecx
801071e3:	89 f8                	mov    %edi,%eax
801071e5:	e8 96 fb ff ff       	call   80106d80 <deallocuvm.part.0>
      return 0;
801071ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801071f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071f7:	5b                   	pop    %ebx
801071f8:	5e                   	pop    %esi
801071f9:	5f                   	pop    %edi
801071fa:	5d                   	pop    %ebp
801071fb:	c3                   	ret    
801071fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107200:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107206:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107209:	5b                   	pop    %ebx
8010720a:	5e                   	pop    %esi
8010720b:	5f                   	pop    %edi
8010720c:	5d                   	pop    %ebp
8010720d:	c3                   	ret    
8010720e:	66 90                	xchg   %ax,%ax
    return 0;
80107210:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107217:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010721a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010721d:	5b                   	pop    %ebx
8010721e:	5e                   	pop    %esi
8010721f:	5f                   	pop    %edi
80107220:	5d                   	pop    %ebp
80107221:	c3                   	ret    
80107222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107228:	83 ec 0c             	sub    $0xc,%esp
8010722b:	68 5d 7f 10 80       	push   $0x80107f5d
80107230:	e8 6b 96 ff ff       	call   801008a0 <cprintf>
  if(newsz >= oldsz)
80107235:	8b 45 0c             	mov    0xc(%ebp),%eax
80107238:	83 c4 10             	add    $0x10,%esp
8010723b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010723e:	74 0c                	je     8010724c <allocuvm+0x10c>
80107240:	8b 55 10             	mov    0x10(%ebp),%edx
80107243:	89 c1                	mov    %eax,%ecx
80107245:	89 f8                	mov    %edi,%eax
80107247:	e8 34 fb ff ff       	call   80106d80 <deallocuvm.part.0>
      kfree(mem);
8010724c:	83 ec 0c             	sub    $0xc,%esp
8010724f:	53                   	push   %ebx
80107250:	e8 eb b6 ff ff       	call   80102940 <kfree>
      return 0;
80107255:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010725c:	83 c4 10             	add    $0x10,%esp
}
8010725f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107262:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107265:	5b                   	pop    %ebx
80107266:	5e                   	pop    %esi
80107267:	5f                   	pop    %edi
80107268:	5d                   	pop    %ebp
80107269:	c3                   	ret    
8010726a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107270 <deallocuvm>:
{
80107270:	f3 0f 1e fb          	endbr32 
80107274:	55                   	push   %ebp
80107275:	89 e5                	mov    %esp,%ebp
80107277:	8b 55 0c             	mov    0xc(%ebp),%edx
8010727a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010727d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107280:	39 d1                	cmp    %edx,%ecx
80107282:	73 0c                	jae    80107290 <deallocuvm+0x20>
}
80107284:	5d                   	pop    %ebp
80107285:	e9 f6 fa ff ff       	jmp    80106d80 <deallocuvm.part.0>
8010728a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107290:	89 d0                	mov    %edx,%eax
80107292:	5d                   	pop    %ebp
80107293:	c3                   	ret    
80107294:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010729b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010729f:	90                   	nop

801072a0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801072a0:	f3 0f 1e fb          	endbr32 
801072a4:	55                   	push   %ebp
801072a5:	89 e5                	mov    %esp,%ebp
801072a7:	57                   	push   %edi
801072a8:	56                   	push   %esi
801072a9:	53                   	push   %ebx
801072aa:	83 ec 0c             	sub    $0xc,%esp
801072ad:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801072b0:	85 f6                	test   %esi,%esi
801072b2:	74 55                	je     80107309 <freevm+0x69>
  if(newsz >= oldsz)
801072b4:	31 c9                	xor    %ecx,%ecx
801072b6:	ba 00 00 00 80       	mov    $0x80000000,%edx
801072bb:	89 f0                	mov    %esi,%eax
801072bd:	89 f3                	mov    %esi,%ebx
801072bf:	e8 bc fa ff ff       	call   80106d80 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072c4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801072ca:	eb 0b                	jmp    801072d7 <freevm+0x37>
801072cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072d0:	83 c3 04             	add    $0x4,%ebx
801072d3:	39 df                	cmp    %ebx,%edi
801072d5:	74 23                	je     801072fa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072d7:	8b 03                	mov    (%ebx),%eax
801072d9:	a8 01                	test   $0x1,%al
801072db:	74 f3                	je     801072d0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801072e2:	83 ec 0c             	sub    $0xc,%esp
801072e5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072e8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801072ed:	50                   	push   %eax
801072ee:	e8 4d b6 ff ff       	call   80102940 <kfree>
801072f3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072f6:	39 df                	cmp    %ebx,%edi
801072f8:	75 dd                	jne    801072d7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801072fa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801072fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107300:	5b                   	pop    %ebx
80107301:	5e                   	pop    %esi
80107302:	5f                   	pop    %edi
80107303:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107304:	e9 37 b6 ff ff       	jmp    80102940 <kfree>
    panic("freevm: no pgdir");
80107309:	83 ec 0c             	sub    $0xc,%esp
8010730c:	68 79 7f 10 80       	push   $0x80107f79
80107311:	e8 7a 90 ff ff       	call   80100390 <panic>
80107316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010731d:	8d 76 00             	lea    0x0(%esi),%esi

80107320 <setupkvm>:
{
80107320:	f3 0f 1e fb          	endbr32 
80107324:	55                   	push   %ebp
80107325:	89 e5                	mov    %esp,%ebp
80107327:	56                   	push   %esi
80107328:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107329:	e8 d2 b7 ff ff       	call   80102b00 <kalloc>
8010732e:	89 c6                	mov    %eax,%esi
80107330:	85 c0                	test   %eax,%eax
80107332:	74 42                	je     80107376 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107334:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107337:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
8010733c:	68 00 10 00 00       	push   $0x1000
80107341:	6a 00                	push   $0x0
80107343:	50                   	push   %eax
80107344:	e8 f7 d7 ff ff       	call   80104b40 <memset>
80107349:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010734c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010734f:	83 ec 08             	sub    $0x8,%esp
80107352:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107355:	ff 73 0c             	pushl  0xc(%ebx)
80107358:	8b 13                	mov    (%ebx),%edx
8010735a:	50                   	push   %eax
8010735b:	29 c1                	sub    %eax,%ecx
8010735d:	89 f0                	mov    %esi,%eax
8010735f:	e8 8c f9 ff ff       	call   80106cf0 <mappages>
80107364:	83 c4 10             	add    $0x10,%esp
80107367:	85 c0                	test   %eax,%eax
80107369:	78 15                	js     80107380 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010736b:	83 c3 10             	add    $0x10,%ebx
8010736e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107374:	75 d6                	jne    8010734c <setupkvm+0x2c>
}
80107376:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107379:	89 f0                	mov    %esi,%eax
8010737b:	5b                   	pop    %ebx
8010737c:	5e                   	pop    %esi
8010737d:	5d                   	pop    %ebp
8010737e:	c3                   	ret    
8010737f:	90                   	nop
      freevm(pgdir);
80107380:	83 ec 0c             	sub    $0xc,%esp
80107383:	56                   	push   %esi
      return 0;
80107384:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107386:	e8 15 ff ff ff       	call   801072a0 <freevm>
      return 0;
8010738b:	83 c4 10             	add    $0x10,%esp
}
8010738e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107391:	89 f0                	mov    %esi,%eax
80107393:	5b                   	pop    %ebx
80107394:	5e                   	pop    %esi
80107395:	5d                   	pop    %ebp
80107396:	c3                   	ret    
80107397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010739e:	66 90                	xchg   %ax,%ax

801073a0 <kvmalloc>:
{
801073a0:	f3 0f 1e fb          	endbr32 
801073a4:	55                   	push   %ebp
801073a5:	89 e5                	mov    %esp,%ebp
801073a7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801073aa:	e8 71 ff ff ff       	call   80107320 <setupkvm>
801073af:	a3 44 5a 11 80       	mov    %eax,0x80115a44
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073b4:	05 00 00 00 80       	add    $0x80000000,%eax
801073b9:	0f 22 d8             	mov    %eax,%cr3
}
801073bc:	c9                   	leave  
801073bd:	c3                   	ret    
801073be:	66 90                	xchg   %ax,%ax

801073c0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801073c0:	f3 0f 1e fb          	endbr32 
801073c4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801073c5:	31 c9                	xor    %ecx,%ecx
{
801073c7:	89 e5                	mov    %esp,%ebp
801073c9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801073cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801073cf:	8b 45 08             	mov    0x8(%ebp),%eax
801073d2:	e8 99 f8 ff ff       	call   80106c70 <walkpgdir>
  if(pte == 0)
801073d7:	85 c0                	test   %eax,%eax
801073d9:	74 05                	je     801073e0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801073db:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801073de:	c9                   	leave  
801073df:	c3                   	ret    
    panic("clearpteu");
801073e0:	83 ec 0c             	sub    $0xc,%esp
801073e3:	68 8a 7f 10 80       	push   $0x80107f8a
801073e8:	e8 a3 8f ff ff       	call   80100390 <panic>
801073ed:	8d 76 00             	lea    0x0(%esi),%esi

801073f0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801073f0:	f3 0f 1e fb          	endbr32 
801073f4:	55                   	push   %ebp
801073f5:	89 e5                	mov    %esp,%ebp
801073f7:	57                   	push   %edi
801073f8:	56                   	push   %esi
801073f9:	53                   	push   %ebx
801073fa:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801073fd:	e8 1e ff ff ff       	call   80107320 <setupkvm>
80107402:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107405:	85 c0                	test   %eax,%eax
80107407:	0f 84 9b 00 00 00    	je     801074a8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010740d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107410:	85 c9                	test   %ecx,%ecx
80107412:	0f 84 90 00 00 00    	je     801074a8 <copyuvm+0xb8>
80107418:	31 f6                	xor    %esi,%esi
8010741a:	eb 46                	jmp    80107462 <copyuvm+0x72>
8010741c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107420:	83 ec 04             	sub    $0x4,%esp
80107423:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107429:	68 00 10 00 00       	push   $0x1000
8010742e:	57                   	push   %edi
8010742f:	50                   	push   %eax
80107430:	e8 ab d7 ff ff       	call   80104be0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107435:	58                   	pop    %eax
80107436:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010743c:	5a                   	pop    %edx
8010743d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107440:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107445:	89 f2                	mov    %esi,%edx
80107447:	50                   	push   %eax
80107448:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010744b:	e8 a0 f8 ff ff       	call   80106cf0 <mappages>
80107450:	83 c4 10             	add    $0x10,%esp
80107453:	85 c0                	test   %eax,%eax
80107455:	78 61                	js     801074b8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107457:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010745d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107460:	76 46                	jbe    801074a8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107462:	8b 45 08             	mov    0x8(%ebp),%eax
80107465:	31 c9                	xor    %ecx,%ecx
80107467:	89 f2                	mov    %esi,%edx
80107469:	e8 02 f8 ff ff       	call   80106c70 <walkpgdir>
8010746e:	85 c0                	test   %eax,%eax
80107470:	74 61                	je     801074d3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107472:	8b 00                	mov    (%eax),%eax
80107474:	a8 01                	test   $0x1,%al
80107476:	74 4e                	je     801074c6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107478:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010747a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010747f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107482:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107488:	e8 73 b6 ff ff       	call   80102b00 <kalloc>
8010748d:	89 c3                	mov    %eax,%ebx
8010748f:	85 c0                	test   %eax,%eax
80107491:	75 8d                	jne    80107420 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107493:	83 ec 0c             	sub    $0xc,%esp
80107496:	ff 75 e0             	pushl  -0x20(%ebp)
80107499:	e8 02 fe ff ff       	call   801072a0 <freevm>
  return 0;
8010749e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801074a5:	83 c4 10             	add    $0x10,%esp
}
801074a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074ae:	5b                   	pop    %ebx
801074af:	5e                   	pop    %esi
801074b0:	5f                   	pop    %edi
801074b1:	5d                   	pop    %ebp
801074b2:	c3                   	ret    
801074b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074b7:	90                   	nop
      kfree(mem);
801074b8:	83 ec 0c             	sub    $0xc,%esp
801074bb:	53                   	push   %ebx
801074bc:	e8 7f b4 ff ff       	call   80102940 <kfree>
      goto bad;
801074c1:	83 c4 10             	add    $0x10,%esp
801074c4:	eb cd                	jmp    80107493 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801074c6:	83 ec 0c             	sub    $0xc,%esp
801074c9:	68 ae 7f 10 80       	push   $0x80107fae
801074ce:	e8 bd 8e ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801074d3:	83 ec 0c             	sub    $0xc,%esp
801074d6:	68 94 7f 10 80       	push   $0x80107f94
801074db:	e8 b0 8e ff ff       	call   80100390 <panic>

801074e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801074e0:	f3 0f 1e fb          	endbr32 
801074e4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801074e5:	31 c9                	xor    %ecx,%ecx
{
801074e7:	89 e5                	mov    %esp,%ebp
801074e9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801074ec:	8b 55 0c             	mov    0xc(%ebp),%edx
801074ef:	8b 45 08             	mov    0x8(%ebp),%eax
801074f2:	e8 79 f7 ff ff       	call   80106c70 <walkpgdir>
  if((*pte & PTE_P) == 0)
801074f7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801074f9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801074fa:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801074fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107501:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107504:	05 00 00 00 80       	add    $0x80000000,%eax
80107509:	83 fa 05             	cmp    $0x5,%edx
8010750c:	ba 00 00 00 00       	mov    $0x0,%edx
80107511:	0f 45 c2             	cmovne %edx,%eax
}
80107514:	c3                   	ret    
80107515:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010751c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107520 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107520:	f3 0f 1e fb          	endbr32 
80107524:	55                   	push   %ebp
80107525:	89 e5                	mov    %esp,%ebp
80107527:	57                   	push   %edi
80107528:	56                   	push   %esi
80107529:	53                   	push   %ebx
8010752a:	83 ec 0c             	sub    $0xc,%esp
8010752d:	8b 75 14             	mov    0x14(%ebp),%esi
80107530:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107533:	85 f6                	test   %esi,%esi
80107535:	75 3c                	jne    80107573 <copyout+0x53>
80107537:	eb 67                	jmp    801075a0 <copyout+0x80>
80107539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107540:	8b 55 0c             	mov    0xc(%ebp),%edx
80107543:	89 fb                	mov    %edi,%ebx
80107545:	29 d3                	sub    %edx,%ebx
80107547:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010754d:	39 f3                	cmp    %esi,%ebx
8010754f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107552:	29 fa                	sub    %edi,%edx
80107554:	83 ec 04             	sub    $0x4,%esp
80107557:	01 c2                	add    %eax,%edx
80107559:	53                   	push   %ebx
8010755a:	ff 75 10             	pushl  0x10(%ebp)
8010755d:	52                   	push   %edx
8010755e:	e8 7d d6 ff ff       	call   80104be0 <memmove>
    len -= n;
    buf += n;
80107563:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107566:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010756c:	83 c4 10             	add    $0x10,%esp
8010756f:	29 de                	sub    %ebx,%esi
80107571:	74 2d                	je     801075a0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107573:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107575:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107578:	89 55 0c             	mov    %edx,0xc(%ebp)
8010757b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107581:	57                   	push   %edi
80107582:	ff 75 08             	pushl  0x8(%ebp)
80107585:	e8 56 ff ff ff       	call   801074e0 <uva2ka>
    if(pa0 == 0)
8010758a:	83 c4 10             	add    $0x10,%esp
8010758d:	85 c0                	test   %eax,%eax
8010758f:	75 af                	jne    80107540 <copyout+0x20>
  }
  return 0;
}
80107591:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107594:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107599:	5b                   	pop    %ebx
8010759a:	5e                   	pop    %esi
8010759b:	5f                   	pop    %edi
8010759c:	5d                   	pop    %ebp
8010759d:	c3                   	ret    
8010759e:	66 90                	xchg   %ax,%ax
801075a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075a3:	31 c0                	xor    %eax,%eax
}
801075a5:	5b                   	pop    %ebx
801075a6:	5e                   	pop    %esi
801075a7:	5f                   	pop    %edi
801075a8:	5d                   	pop    %ebp
801075a9:	c3                   	ret    
