#!/usr/bin/perl -w
use Bio::SeqIO;

my $in = Bio::SeqIO->new(-file => shift @ARGV );

print "\nProduct info of mRNA features\n\nLOCUS TAG\tPRODUCT \n\n";
while(my $seq_object = $in->next_seq) {

 for my $feat_object ($seq_object->get_SeqFeatures) {

   if ($feat_object->primary_tag eq 'mRNA') {

     if ($feat_object->has_tag('product') ) {

           for my $locus_tag ($feat_object->get_tag_values('locus_tag')) {
           for my $product ($feat_object->get_tag_values('product')) {

               print $locus_tag, "\t " , $product, "\n";
           }
        }
      }
    }
  }
}
