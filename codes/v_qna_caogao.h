//
//  v_qna_caogao.h
//  tcxly
//
//  Created by Li yi on 13-8-14.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "iPageView.h"

@interface v_qna_caogao : iPageView
{
    UIImageView *canvas;
    CGPoint lastPoint;
    float r,g,b;
    
    int stroke;
}
@end
