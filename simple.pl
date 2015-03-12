    #!/usr/bin/perl
    
     # Functional style
    use Digest::MD5 qw(md5 md5_hex md5_base64);
    
    
    $search=154;
    
    $p1 = "The strident guy ";
    $p2 = "strode";
    $p3 = " into the bar, and the punctual girl ";
    $p4 = "punched";
    $p5 = " it!";
    
    $len2 = length($p2);
    $len3 = length($p4);
    
    while (1){
       $count++;
       $pos =  int(rand($len2));
       if ($count %2) {
          substr ($p2, $pos, 1) = ucfirst ( substr ($p2, $pos, 1));
       } else {
          substr ($p2, $pos, 1) = lcfirst ( substr ($p2, $pos, 1));
       }
    
       $pos =  int(rand($len3));
       if ($count %2) {
          substr ($p4, $pos, 1) = ucfirst ( substr ($p4, $pos, 1));
       } else {
          substr ($p4, $pos, 1) = lcfirst ( substr ($p4, $pos, 1));
       }
    
       $try = $p1 . $p2 . $p3 . $p4 . $p5;
       $res =  md5_hex($try);
    
       if ($res =~ /$search$/) {
          print "count: $count  $res  - $search - answer: $try\n";
          exit;
       }
    }
    
