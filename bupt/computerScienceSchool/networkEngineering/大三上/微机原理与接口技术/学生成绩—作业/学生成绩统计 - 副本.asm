

;                     *************************************************************************
;                     *                    2010211312  10211480   16    �����                *
;                     *  ��ĿҪ��:   ����ѧ��ѧ�������ͳɼ�                                   *
;                     *              ����ɼ������ս�������                                   *
;                     *              ͳ�Ƹ������ε�����                                       *
;                     *              ����ƽ����                                               *
;                     *************************************************************************



					
data     segment   
   				msg1   db   0dh,0ah,'please input the name:$'                               ;��ʾ����
  				msg2   db   'please input the number:$'   
 				msg3   db   'please input the mark:$'   
  				msg4   db   'another students information to enter?(y/n)$'   
  				namelength           equ   15                                               ;���峤��
 			    numberlength         equ   6   
 				marklength           equ   3   
 				len                  equ   namelength+numberlength+marklength  
  				stunomax             equ   100                                              ;���֧�ֵ�ѧ����   
  				strtemp          	 db    len+3   dup(0)   
 			    firstline            db    0dh,0ah                                          ;���б���   
                           		     db    'name',namelength-4   dup(0)   
                          		     db    'number',numberlength-6   dup(0)   
                         	         db    'mark',0dh,0ah,'$'   
                a1         dw   0  
  			    aa         db   0   
 			    bb         db   0   
 			    no         db   0                                          ;��ѧ����   
 
  				buffer1           db   namelength+1                        ;namebuffer
                         		  db   0   
                        		  db   namelength+1     dup(0)   
  				buffer2           db   numberlength+1                      ;numberbuffer
                         		  db   0   
                         		  db   numberlength+1   dup(0)            
			    buffer3           db   marklength+1                        ;markbuffer
                         		  db   0   
                        		  db   marklength+1     dup(0)   
  				eadd1             db   0                                   ;��Ŵ��Ƚ����ݿ�ָ���ƫַ   
  				eadd2             db   0   
 			    add0              db   0                                   ;��n���������ʼ��ַ   
 		   
 			    buf               db   400   dup(0)   
 			    pbuf              db   stunomax   dup(0)                   ;�ṹ��ָ������   
 			    data              ends   
  				stack             segment   stack   
                                  db   200   dup(0)   
                stack   ends   
                
;***********************************************************************************************

code     segment   
               assume      ds:data,es:data,ss:stack,cs:code   
start:         mov   ax,data   
               mov   ds,ax   
               mov   es,ax   
               cld   
               lea   bx,buf   
    
  l1:          lea   dx,msg1   
               mov   ah,9                                                      ;��ʾ�ַ�   
               int   21h   
               lea   dx,buffer1                                                ;����   
               mov   a1,namelength   
               call  cin                                                      ;��������   
    
               lea   dx,msg2   
               mov   ah,9                                                      ;��ʾ�ַ�   
               int   21h   
               lea   dx,buffer2  
               mov   a1,numberlength   
               call  cin                                                      ;����ѧ��   
    
               lea   dx,msg3   
               mov   ah,9                                                      ;��ʾ�ַ�   
               int   21h   
               lea   dx,buffer3   
               mov   a1,marklength   
               call  cin                                                      ;�������   
    
               mov   ah,9   
               lea   dx,msg4   
               int   21h   
    
  l3:          mov   ah,8                     ;�жϻ�����   
               int   21h   
               cmp   al,'y'   
               jz    l1   
               cmp   al,'y'   
               jz    l1   
               cmp   al,'n'   
               jz    l2   
               cmp   al,'n'   
               jz    l2   
               jmp   l3   
    
 
    
    
  l2:         add   di,marklength          ;��֤$���ַ��������   
              inc   di   
              lea   dx,buf                 ;���ѧ����������no   
              sub   di,dx   
              inc   di   
              inc   di   
              mov   ax,di   
              mov   cl,len   
              div   cl   
              mov   no,al   
    
              lea   dx,firstline           ;������б���   
              mov   ah,9   
              int   21h   
                
  ;��ʼ����************************************************************************************************  
              xor   ax,ax                  ;ָ�������ʼ��   
              lea   si,pbuf   
              mov   cl,no   
              mov   ch,0   
  lc1:        mov   [si],al   
              inc   si   
              inc   al   
              loop   lc1   
    
              lea   bx,buf   
              xor   cl,cl                   ;��cl������   
              mov   add0,cl   
              mov   ch,no   
              cmp   ch,1                    ;ֻ��һ���������ñȽϣ�ֱ�����   
              jnz   lb1   
              xor   dh,dh   
              call  sort   
              jmp   coend   
                
  lb1:        dec   ch                          ;����ch�αȽ�   
  lp2:        push   cx   
              lea   bx,pbuf   
              push   cx   
              and   cx,0fh   
              add   bx,cx   
              pop   cx   
              mov   dh,[bx]   
              mov   eadd1,cl   
  lp1:        inc   bx   
              inc   cl   
              mov   dl,[bx]   
              mov   eadd2,cl   
              call   compare   
              dec   ch   
              jnz   lp1   
              call  sort   
    
              pop   cx   
              push   cx   
              and   cx,0fh   
              lea   di,pbuf   
              add   di,cx   
              pop   cx   
                
              lea   si,pbuf   
              mov   al,eadd1   
              mov   ah,0   
              add   si,ax   
              mov   ah,[si]   
              mov   al,[di]   
              mov   [si],al   
              mov   [di],ah   
    
              inc   cl   
              dec   ch   
              jnz   lp2   
    

                
  ;�����������һ�飨��С�ģ�   
              lea   di,pbuf   
              mov   al,no   
              mov   ah,0   
              add   di,ax   
              mov   dh,-1[di]   
              call   sort   
    
  coend:mov   ah,4ch   
              int   21h   
  ;***********************************************************************************  
  sort   proc                 ;һ����ɣ���������   
              push   si   
              push   ax   
              push   dx   
              push   cx   
              push   di   
    
              lea   si,buf   
              mov   al,len   
              mul   dh   
              add   si,ax   
              lea   di,strtemp   
              mov   cx,len   
              rep   movsb   
              mov   [di],byte   ptr   0dh   
              mov   [di+1],byte   ptr   0ah   
              mov   [di+2],byte   ptr   '$'   
              lea   dx,strtemp   
              mov   ah,9   
              int   21h   
    
              pop   di   
              pop   cx   
              pop   dx   
              pop   ax   
              pop   si   
              ret   
  sort   endp   
  ;*********************************************************************************************  
  cin       proc   
              push   ax   
              mov   ah,10   
              int   21h   
              mov   si,dx   
              inc   si   
    
              mov   cl,[si];�����ַ���   
              push   cx   
              mov   ah,2         ;�س�����   
              mov   dl,0dh   
              int   21h   
              mov   dl,0ah   
              int   21h   
              inc   si   
              mov   di,bx   
              rep   movsb       ;�ַ�������   
              pop   cx             ;�ָ�cxΪ�����ַ���   
                
              add   bx,a1   
              cmp   a1,marklength   
              jnz   l11   
                
  ;"����"�ֶε���   
              mov   ax,marklength  
              dec   di   
              mov   si,di   
              sub   di,cx   
              add   di,marklength   
              std   
              mov   ax,cx   
              rep   movsb   
              mov   cx,marklength   
              sub   cx,ax   
              jz   l13   
  l12:        mov   [di],byte   ptr   0   
              dec   di   
              loop   l12   
  l13:     cld   
  l11:     pop   ax   
              ret   
  cin       endp   
 ;*****************************************************************************   
  compare   proc             ;dh��dl��ָ�Ƚϣ�����ָ������dh   
              push   ax   
              push   bx   
              push   cx   
              push   si   
              push   di   
    
              mov   cx,marklength  
              lea   si,buf   
              lea   di,buf   
                
              mov   al,len   
              mul   dh   
              add   ax,namelength+numberlength   
              add   si,ax   
    
              mov   al,len   
              mul   dl   
              add   ax,namelength+numberlength   
              add   di,ax   
                
  la1:     mov   al,[si]   
              mov   aa,al   
              mov   al,[di]   
              mov   bb,al   
              mov   al,aa   
              cmp   al,bb   
              ja   ll1   
              jb   ll2   
              dec   cx   
              jz   ll1   
              inc   si   
              inc   di   
              jmp   la1   
                
  ll2:     mov   dh,dl   
              mov   al,eadd2   
              mov   eadd1,al   
    
  ll1:     pop   di   
              pop   si   
              pop   cx   
              pop   bx   
              pop   ax   
              ret   
  compare   endp   
 ;*****************************************************************************************   
  code     ends   
              end   start   
