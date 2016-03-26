/*****************************************************************************

YASK: Yet Another Stencil Kernel
Copyright (c) 2014-2016, Intel Corporation

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

* The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.

*****************************************************************************/

// Base class for calculating a future stencil value.

#ifndef STENCIL_BASE
#define STENCIL_BASE

using namespace std;

class StencilBase {
protected:
    int _order;         // stencil order (width not including center point).

public:
    StencilBase(int order=2) : _order(order) { }
    
    virtual ~StencilBase() {}

    // Set order.
    // Return true if successful.
    virtual bool setOrder(int order) {
        _order = order;
        return order % 2 == 0;  // support only even orders by default.
    }
    
    // Calculate and return the value of stencil at u(timeWanted, i, j, k)
    // based on values at timeLastKnown or earlier.
    virtual GridValue value(TemporalGrid& u, int timeWanted, int timeLastKnown,
                            int i, int j, int k) const =0;
};

#endif

