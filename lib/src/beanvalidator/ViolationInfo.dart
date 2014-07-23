part of beanvalidator;

class ViolationInfo<T> {
    final _logger = new Logger('beanvalidator.ViolationInfo');

    final String methodName;
    final String message;
    final Object invalidValue;
    final T rootBean;


    ViolationInfo(this.methodName, this.message, this.invalidValue, this.rootBean) {
        Validate.notBlank(methodName);
        Validate.notBlank(message);
        Validate.notNull(rootBean);
    }

//    String getMessage();
//
//    String getMessageTemplate();
//
//    Object getInvalidValue();
//
//    String getMethodName();
//
//    T getRootBean();

    // -- private -------------------------------------------------------------

}
