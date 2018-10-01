function! Hex2addr(hexstr)
	let k=1024.0
	let m=k*1024
	let g=m*1024
	let temp =0
	if a:hexstr <k
	    temp = a:hexstr*1 
	   return a:hexstr*1 . "B"
	elseif a:hexstr <m
	   return  a:hexstr/k . "K"
	elseif a:hexstr <g
	   return  a:hexstr/m . "M"
	else
	   return a:hexstr/g  . "G"
	endif

endfunction

function! Hex2addr2(hexstr)
	let k=1024
	let m=k*1024
	let g=m*1024
	let v_b = a:hexstr %k
	let v_k= a:hexstr %m
	let v_m= a:hexstr %g
	let v_g = a:hexstr /g 
	if v_g >0
	   return v_g ".". v_m . v_k . v_b . "G"
	elseif v_m >0
	   return v_m . "." . v_k . v_b . "M"
	elseif v_k >0
	   return v_k . "." . v_b . "K"
	else
	   return v_b  . "B"
	endif

endfunction

function! Hex2addr3(hexstr)
	let k=1024.0
	let m=k*1024
	let g=m*1024
	let t=g*1024
	let temp =0
	echo temp 
	echo a:hexstr
	if a:hexstr <k
	   let temp = a:hexstr*1 
	   return temp. "B"
	elseif a:hexstr <m
	   let temp=  a:hexstr/k 
	   return  string(temp) . "K"
	elseif a:hexstr <g
	   let temp=  a:hexstr/m 
	   return  string(temp) . "M"
	elseif a:hexstr <t
	   let temp= a:hexstr/g  
	   return string(temp)  . "G"
	else
	   let temp= a:hexstr/t  
	   return string(temp)  . "T"
	endif

endfunction
g/mem\|BRK/s#0x[0-9a-z]\{8,16}#\=printf("%s (%4s)",submatch(0),Hex2addr3(submatch(0)))#gc
